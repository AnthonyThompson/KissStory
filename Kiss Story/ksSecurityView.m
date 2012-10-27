//
//  ksSecurity.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/14/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksSecurityView.h"
#import "ksViewController.h"
#import "ksColorCell.h"

@implementation ksSecurityView

#pragma mark - Inits

- (id)initForProcess:(int)whichProcess withData:(NSDictionary*)settingsDictionary {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
    if (self) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ksSecurityView" owner:self options:nil];
        self = [nib objectAtIndex:0];

        _whichProcess = whichProcess;
        _passcode = [settingsDictionary valueForKey:@"passcode"];
        _securityEnabled = [ksSecurityView securityCheck:settingsDictionary];

        if (_whichProcess != SEC_PROCESS_RUNTIMELOGIN)
            _privacyView.hidden = YES;
        
        _loginView.frame = CGRectMake(0.0f, 480.0f, 320.0f, 480.0f);
        _shadeView.frame = CGRectMake(0.0f, 480.0f, 320.0f, 480.0f);

        [self displayLoginView];
    }
    return self;
}

#pragma mark - Class Actions

+(BOOL)securityCheck:(NSDictionary*)dataDictionary {
    if ([[dataDictionary valueForKey:@"securityEnabled"] isEqualToString:@"YES"])
        return YES;
    return NO;
}

#pragma mark - Login View

-(void)displayLoginView {
    [self clearPasscodeWindows];
    _passcodeStatusLabel.text = @"";
    _passcodeStatusLabel.backgroundColor = [UIColor clearColor];
    float shadeOffset = 44.0f;
    
    switch(_whichProcess) {
        case SEC_PROCESS_RUNTIMELOGIN: {
            _passcodeTitleLabel.text = @"Enter Passcode";
            shadeOffset = 0.0f;
        }
            break;
        case SEC_PROCESS_SETNEW: {
            _passcodeTitleLabel.text = @"Create Passcode";
        }
            break;
        case SEC_PROCESS_CONFIRMNEW: {
            _passcodeTitleLabel.text = @"Confirm New Passcode";
        }
            break;
        case SEC_PROCESS_DISABLE: {
            _passcodeTitleLabel.text = @"Confirm Passcode";
        }
            break;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        _loginView.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
        _shadeView.frame = CGRectMake(shadeOffset, 0.0, 320.0, (480.0 - shadeOffset));
    }];
}

-(void)dismissLoginView {
    [UIView animateWithDuration:0.5f animations:^{
        _loginView.frame = CGRectMake(0.0f, 480.0f, 320.0f, 480.0f);
        _shadeView.frame = CGRectMake(0.0f, 480.0f, 320.0f, 480.0f);
        [[(ksViewController*) [[self window] rootViewController] wallpaperView] setAlpha:0.0f];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
     }];
}

#pragma mark - IBActions

-(IBAction)passcodeButtonTapped:(id)sender {
    switch ([sender tag]) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9: {
            _tempPasscode = [_tempPasscode stringByAppendingString:[NSString stringWithFormat:@"%i",[sender tag]]];
            [self updatePasscodeDisplay];
        }
            break;
        case SEC_CANCEL_KEY: {
            switch (_whichProcess) {
                case SEC_PROCESS_RUNTIMELOGIN: {
                    exit(EXIT_FAILURE);
                }
                    break;
                case SEC_PROCESS_SETNEW:
                case SEC_PROCESS_CONFIRMNEW:
                case SEC_PROCESS_DISABLE: {
                    [[(ksViewController*) [[self window] rootViewController] passcodeSwitch] setOn:[ksSecurityView securityCheck:[(ksViewController*) [[self window] rootViewController] settingsDictionary]]];
                }
            }

            [self clearPasscodeWindows];
            _passcodeStatusLabel.textColor = CCO_BASE_CREAM;
            _passcodeStatusLabel.backgroundColor = CCO_BASE_RED;
            _passcodeStatusLabel.text = @"Passcode Cancelled";
            _passcodeStatusLabel.hidden = NO;
            [self dismissLoginView];
        }
            break;
        case SEC_BACK_KEY: {
            // trim passcode
            if ([_tempPasscode length] > 0) {
                _tempPasscode = [_tempPasscode substringToIndex:[_tempPasscode length]-1];
            }
        }
            break;
    }
    
    [self updatePasscodeDisplay];
    
    if ([_tempPasscode length] == 4) {
        [self validateTempPasscode];
    }
}

#pragma mark - Passcode Display

-(void)clearPasscodeWindows {
    _tempPasscode = @"";
    _passcodeImage1.hidden = YES;
    _passcodeImage2.hidden = YES;
    _passcodeImage3.hidden = YES;
    _passcodeImage4.hidden = YES;
}

-(void)updatePasscodeDisplay {
    [_passcodeStatusLabel setHidden:YES];
    switch ([_tempPasscode length]) {
        case 0: {
            [_passcodeImage1 setHidden:YES];
        }
            break;
        case 1: {
            [_passcodeImage1 setHidden:NO];
            [_passcodeImage2 setHidden:YES];
        }
            break;
        case 2: {
            [_passcodeImage2 setHidden:NO];
            [_passcodeImage3 setHidden:YES];
        }
            break;
        case 3: {
            [_passcodeImage3 setHidden:NO];
            [_passcodeImage4 setHidden:YES];
        }
            break;
        case 4: {
            [_passcodeImage4 setHidden:NO];
        }
            break;
    }
}

#pragma mark - Passcode Validation

-(void)validateTempPasscode {
    if (_whichProcess == SEC_PROCESS_SETNEW){
        _passcode = _tempPasscode;
    }
    
    if ([_tempPasscode isEqualToString:_passcode]) {
        _passcodeStatusLabel.textColor = CCO_BASE_CREAM;
        _passcodeStatusLabel.backgroundColor = CCO_BASE_GREEN;
        _passcodeStatusLabel.hidden = NO;
        
        switch(_whichProcess) {
            case SEC_PROCESS_RUNTIMELOGIN: {
                _privacyView.hidden = YES;
                _passcodeStatusLabel.text = @"Passcode Correct";
                [self dismissLoginView];
            }
                break;
            case SEC_PROCESS_SETNEW: {
                _passcodeStatusLabel.text = @"Confirm Passcode";
                _passcode = _tempPasscode;
                [self clearPasscodeWindows];
                _whichProcess = SEC_PROCESS_CONFIRMNEW;
            }
                break;
            case SEC_PROCESS_CONFIRMNEW: {
                //9901
                _passcodeStatusLabel.text = @"Passcode Confirmed";
                [[(ksViewController*) [[self window] rootViewController] ksCD] updateSecurity:@"YES" passcode:_tempPasscode];
                [(ksViewController*) [[self window] rootViewController] buildSettingsDictionary];
                [self dismissLoginView];
            }
                break;
            case SEC_PROCESS_DISABLE: {
                [self clearPasscodeWindows];
                _passcodeStatusLabel.text = @"Passcode Disabled";
                [[(ksViewController*) [[self window] rootViewController] ksCD] updateSecurity:@"NO" passcode:@""];
                [(ksViewController*) [[self window] rootViewController] buildSettingsDictionary];
                [self dismissLoginView];
            }
                break;
        }
    } else {
        [self clearPasscodeWindows];
        _passcodeStatusLabel.textColor = CCO_BASE_CREAM;
        _passcodeStatusLabel.backgroundColor = CCO_BASE_RED;
        _passcodeStatusLabel.hidden = NO;

        switch(_whichProcess) {
            case SEC_PROCESS_RUNTIMELOGIN: {
                _passcodeStatusLabel.text = @"Incorrect Passcode";
            }
                break;
            case SEC_PROCESS_SETNEW: {
                _passcodeStatusLabel.text = @"Incorrect Passcode";
            }
                break;
            case SEC_PROCESS_CONFIRMNEW: {
                _passcodeStatusLabel.text = @"Incorrect Passcode";
            }
                break;
            case SEC_PROCESS_DISABLE: {
                _passcodeStatusLabel.text = @"Incorrect Passcode";
            }
                break;
        }
    }
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