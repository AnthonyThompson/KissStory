//
//  ksSettingsView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/29/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksSettingsView.h"
#import "ksSecurityView.h"
#import "ksViewController.h"

@implementation ksSettingsView

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 288.0f, 368.0f)]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksSettingsView" owner:self options:nil] objectAtIndex:0];

        self.settingsDictionary = [ROOT settingsDictionary];

        /*
        self.facebookSwitch.on = NO;
        if ([[self.settingsDictionary valueForKey:@"facebookEnabled"] isEqualToString:@"YES"]) {
            self.facebookSwitch.on = YES;
        }
         */
        
        self.facebookSwitch.on = ([[self.settingsDictionary valueForKey:@"facebookEnabled"] isEqualToString:@"YES"]) ? YES : NO;
        
        /*
        self.twitterSwitch.on = NO;
        if ([[self.settingsDictionary valueForKey:@"twitterEnabled"] isEqualToString:@"YES"]) {
            self.twitterSwitch.on = YES;
        }
         */
        
        self.twitterSwitch.on = ([[self.settingsDictionary valueForKey:@"twitterEnabled"] isEqualToString:@"YES"]) ? YES : NO;

        self.passcodeSwitch.on = [ksSecurityView securityCheck:self.settingsDictionary];

        self.bigVersionLabel.text = [[NSString alloc]initWithFormat:@"%@ v%@.%@%@",
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"],
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"],
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey],
#ifdef DEBUG
                                 @"d"
#else
                                 @""
#endif
                                 ];
        self.littleVersionLabel.text = [[NSString alloc]initWithFormat:@"%@ logo and app are\n© 2012 Geek Gamer Guy Mobile LLC\nAll rights reserved",
                                    [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"]];


    }
    return self;
}

-(void)displaySettingsView {
    ksPopOverView* popOverView = [[ksPopOverView alloc]initWithFrame:self.frame];
    [popOverView displayPopOverViewWithContent:self withBacking:nil inSuperView:[ROOT view]];
}

-(void)dismissSettingsView {
    [(ksPopOverView*)[self superview] dismissPopOverView];
}

#pragma mark - Passcode Action Group

-(IBAction)passcodeSwitchSwitched:(id)sender {
    ksSecurityView* securityView;
    
    if ([(UISwitch*)sender isOn]) {
        // was off, is now ON, so set a new passcode
        securityView = [[ksSecurityView alloc]initForProcess:SEC_PROCESS_SETNEW withData:_settingsDictionary];
    } else {
        // was on, is now OFF, so disable current passcode
        securityView = [[ksSecurityView alloc]initForProcess:SEC_PROCESS_DISABLE withData:_settingsDictionary];
    }
    
    [securityView displaySecurityView];
}

-(IBAction)dismissButtonTapped:(id)sender {
    [self dismissSettingsView];
}

-(IBAction)emailButtonTapped:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = ROOT;
        mailer.subject = @"Question or comment about KissStory";
        NSArray *toRecipients = [NSArray arrayWithObjects:@"ksfeedback@geekgamerguy.com",nil];
        mailer.toRecipients = toRecipients;
        [ROOT presentViewController:mailer
                           animated:YES
                         completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Disabled"
                                                        message:@"Your device cannot compose a mail message"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)wwwButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://geekgamerguy.com/gggmobile/"]];
}

@end
