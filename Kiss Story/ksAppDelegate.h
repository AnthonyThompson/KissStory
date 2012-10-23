//
//  ksAppDelegate.h
//  Kiss Story
//
//  Created by Anthony Thompson on 9/22/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ksViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ksAppDelegate : UIResponder <UIApplicationDelegate> {
    NSString* FBSessionStateChangedNotification;
}

// FB

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet ksViewController* kissStoryViewController;

-(NSURL *)applicationDocumentsDirectory;

// FB
-(BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
-(void)closeSession;

@end
