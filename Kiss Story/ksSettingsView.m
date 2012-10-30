//
//  ksSettingsView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/29/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksSettingsView.h"
#import "ksViewController.h"

@implementation ksSettingsView

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 288.0f, 368.0f)]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksSettingsView" owner:self options:nil] objectAtIndex:0];
        
        _popOverView = [[ksPopOverView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width + 20, self.frame.size.height + 20)];

        _facebookSwitch.on = NO;
        /*
        if ([[_settingsDictionary valueForKey:@"facebookEnabled"] isEqualToString:@"YES"]) {
            _facebookSwitch.on = YES;
        }
         */
        
        _twitterSwitch.on = NO;
        /*
        if ([[_settingsDictionary valueForKey:@"twitterEnabled"] isEqualToString:@"YES"]) {
            _twitterSwitch.on = YES;
        }
         */
        
        //_passcodeSwitch.on = [ksSecurityView securityCheck:_settingsDictionary];

        _bigVersionLabel.text = [[NSString alloc]initWithFormat:@"%@ v%@.%@%@",
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"],
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"],
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey],
#ifdef DEBUG
                                 @"d"
#else
                                 @""
#endif
                                 ];
        _littleVersionLabel.text = [[NSString alloc]initWithFormat:@"%@ logo and app are\n© 2012 Geek Gamer Guy Mobile LLC\nAll rights reserved",
                                    [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"]];


    }
    return self;
}

-(void)displaySettingsView {
    [_popOverView displayPopOverViewWithContent:self withBacking:nil inSuperView:[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
}

-(void)dismissSettingsView {
    [_popOverView dismissPopOverViewInSuperView:[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
}

#pragma mark - Passcode Action Group

-(IBAction)passcodeSwitchSwitched:(id)sender {
    if ([(UISwitch*)sender isOn]) {
        // was off, is now ON, so set a new passcode
        //_securityView = [[ksSecurityView alloc]initForProcess:SEC_PROCESS_SETNEW withData:_settingsDictionary];
    } else {
        // was on, is now OFF, so disable current passcode
        //_securityView = [[ksSecurityView alloc]initForProcess:SEC_PROCESS_DISABLE withData:_settingsDictionary];
    }
}

-(IBAction)dismissButtonTapped:(id)sender {
    [self dismissSettingsView];
}

-(IBAction)emailButtonTapped:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        mailer.subject = @"Question or comment about KissStory";
        NSArray *toRecipients = [NSArray arrayWithObjects:@"ksfeedback@geekgamerguy.com",nil];
        mailer.toRecipients = toRecipients;
        //9901 figure this out: delegate here or in VC?
        /*
        [self presentViewController:mailer
                           animated:YES
                         completion:NULL];
         */
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
