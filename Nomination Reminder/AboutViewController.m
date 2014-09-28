//
//  AboutViewController.m
//  Nomination Reminder
//
//  Created by YIN HUA on 21/09/2014.
//  Copyright (c) 2014 orange. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UITextView *aboutText;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aboutText.text = @"Copyright 2014 Yin Hua\n\nImmiHelpper Version: 0.3.1   21st Sep 2014\n\nThank you for using ImmiHelper. If you have any question or suggestion, welcome to send me feedback.";
    self.aboutText.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
