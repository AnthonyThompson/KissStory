//
//  ksAppDelegate.m
//  Kiss Story
//
//  Created by Anthony Thompson on 9/22/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksAppDelegate.h"

@implementation ksAppDelegate

//@synthesize kissStoryViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent ();
#endif

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // FB
    FBSessionStateChangedNotification = [NSString stringWithFormat:@"%@.Login:FBSessionStateChangedNotification",[[NSBundle mainBundle] bundleIdentifier]];

    _kissStoryViewController = [[ksViewController alloc]init];

    self.window.rootViewController = _kissStoryViewController;
    [self.window makeKeyAndVisible];

#ifdef DEBUG
    NSLog(@"LAUNCH %f",CFAbsoluteTimeGetCurrent () - startTime);
#endif

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[_kissStoryViewController ksCD] saveContext];
    
    //9901 ???
    //[[[[[kqRVC mainNavCon] viewControllers] lastObject] view] addSubview:[kqRVC privacyView]];
    // set the future security bit
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[_kissStoryViewController ksCD] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSession.activeSession handleDidBecomeActive];
    

    //9901
    /*
     
     Need to check if security check is already in place, so we don't try it twice.
     
    if ([kqRVC securityCheck]) {
        [kqRVC buildView:[kqRVC loginView]];
        [[kqRVC privacyScreen] setHidden:NO];
        [kqRVC incrementStateWithView:[kqRVC loginView] withFunction:LOGIN_10 withSubject:LOGIN_10];
    } else {
        // fade-in
        [[kqRVC privacyView] removeFromSuperview];
        [[[[[kqRVC mainNavCon] viewControllers]lastObject]view] setAlpha:0.0f];
        [UIView animateWithDuration:1.0f animations:^{
            [[[[[kqRVC mainNavCon] viewControllers]lastObject]view] setAlpha:1.0f];
        }];
    }
     */

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [[_kissStoryViewController ksCD] saveContext];
    [FBSession.activeSession close];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Facebook API

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error {
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

-(void)closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

@end
