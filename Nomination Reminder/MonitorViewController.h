//
//  MonitorViewController.h
//  Nomination Reminder
//
//  Created by YIN HUA on 21/09/2014.
//  Copyright (c) 2014 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

@interface MonitorViewController : UIViewController

@property (assign) BOOL watching;
@property (weak, nonatomic) IBOutlet UITextView *displayTextView;

@end
