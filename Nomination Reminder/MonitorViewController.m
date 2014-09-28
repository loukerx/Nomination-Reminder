//
//  MonitorViewController.m
//  Nomination Reminder
//
//  Created by YIN HUA on 21/09/2014.
//  Copyright (c) 2014 orange. All rights reserved.
//

#import "MonitorViewController.h"

@interface MonitorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *displayLable;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *lightLabel;

@end

@implementation MonitorViewController

//default setting
NSString * originalHTMLString;
unsigned int internalWaitingSeconds = 7;
//get url
NSString * urlString =@"";
BOOL threadStopped = true;
NSString * urlLabel =@"";
//declare AppDelegate
AppDelegate *myAppDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //setting
    self.displayTextView.editable = false;
    self.displayTextView.text = @"Ready";
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)startCheckingWebButton:(UIButton *)sender {
    
    
    NSLog(@"Start scanning and it is using URL: %@", urlString);
    //top label display
    myAppDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    urlString = myAppDelegate.urlText;
    [self changeLabelFromURL:urlString];
    
    
    //run a thread.
    if ([self.startButton.titleLabel.text  isEqual: @"Start"]) {
        [self.startButton setTitle:@"Stop" forState:(UIControlStateNormal)];
        [self.startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.lightLabel.backgroundColor = [UIColor greenColor];
        //start a NSThread
        self.watching = true;
        [NSThread detachNewThreadSelector:@selector(startWatching) toTarget:self withObject:nil];
        
    } else {
        [self.startButton setTitle:@"Start" forState:(UIControlStateNormal)];
        [self.startButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.lightLabel.backgroundColor = [UIColor redColor];
        //stop a NSThread
        self.watching = false;
        self.displayLable.text=@"";
        self.displayTextView.text =@"";
        self.displayLable.backgroundColor = [UIColor lightTextColor];
    }
    
}


- (void)startWatching
{
    NSLog(@"thread starts");
    
    //setting
    //get html soursecode
    myAppDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    urlString = myAppDelegate.urlText;
    
    //put sourse code to original NSstring
    originalHTMLString = [[NSString alloc]
                          initWithContentsOfURL:[NSURL URLWithString: urlString]
                          encoding:NSUTF8StringEncoding
                          error:nil];
    NSUInteger secondStringLength = 0;
    [self appendTextview:@"start" websiteLength:[originalHTMLString length]];
                NSLog(@"First start. It is using URL: %@", urlString);
                NSLog(@"The website length is:%lu\n",[originalHTMLString length]);
    do{
        if ([[NSThread currentThread] isExecuting]) {
            //if it isn't stopped
            urlString = myAppDelegate.urlText;
            //adjust label
            [self changeLabelFromURL:urlString];
            //get source code string again.
            NSString *secondTimeHTMLString = [[NSString alloc]
                                              initWithContentsOfURL:[NSURL URLWithString: urlString]
                                              encoding:NSUTF8StringEncoding
                                              error:nil];
            NSLog(@"After waiting for approximate 10 seconds. It is using URL: %@", urlString);
            secondStringLength = [secondTimeHTMLString length];
            NSLog(@"The website length is:%lu\n",secondStringLength);
            //compare .lenght of both string
            if ([originalHTMLString length] != [secondTimeHTMLString length] && [secondTimeHTMLString length]!= 0) {
                
                originalHTMLString = secondTimeHTMLString;
                
                //display difference on the label
                [self appendTextview:@"updated" websiteLength:secondStringLength];
                [self warningLabel:secondStringLength];
                //viber
                for (int i=0; i<=3; i++) {
                    [NSThread sleepForTimeInterval:1];
                    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                    AudioServicesPlaySystemSound (1007);
                }
                
            }
            else{
                [self appendTextview:@"nothing" websiteLength:secondStringLength];
            }
            //sleep for 10 seconds
            [NSThread sleepForTimeInterval:internalWaitingSeconds];
        }
        
    }
    while (self.watching);
    
    
}


- (void)warningLabel:(NSUInteger)length
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //self.displayLable.text = [NSString stringWithFormat:@"The length of the website: %lu", (unsigned long)length];
        self.displayLable.text = [NSString stringWithFormat:@"%@", urlString];
        self.displayLable.backgroundColor = [UIColor redColor];
    });
}

- (void)changeLabelFromURL:(NSString*) urlString
{
    if ([urlString isEqualToString:@"http://www.theaustralian.com.au"]) {
            self.displayLable.text = @"Test Mode\n";
    }
    else{
        self.displayLable.text = @"NSW Skill Nomination\n";
    }
    self.displayLable.text = [self.displayLable.text stringByAppendingString:[urlString substringToIndex:20]];
    
}

- (void)appendTextview:(NSString *)message websiteLength:(NSUInteger) length;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //current data time
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
        NSString* messageWithNewLine = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
        
        //start scaning
        if ([message isEqualToString:@"start"]){
            self.displayTextView.text =@"Start to scan the website now:\n";
        }
        //website changed
        else if ([message isEqualToString:@"updated"]){
            self.displayTextView.text =[self.displayTextView.text  stringByAppendingString:@"\nWebsite has updated!!\n"];
        }
        //nothing changed
        else {
            self.displayTextView.text =[self.displayTextView.text  stringByAppendingString:@"\nWebsite has NOT updated!!\n"];
        }
        
        if(![message isEqualToString:@"start"]){
        NSString *tempString =[NSString stringWithFormat:@"The time is: %@\n",messageWithNewLine];
        self.displayTextView.text =[self.displayTextView.text  stringByAppendingString:tempString];
        
        //only for testing
        tempString =[NSString stringWithFormat:@"The website length is: %lu\n",(unsigned long)length];
        self.displayTextView.text =[self.displayTextView.text  stringByAppendingString:tempString];
        }
       
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
