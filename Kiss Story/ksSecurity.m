//
//  ksSecurity.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/14/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksSecurity.h"
#import "ksViewController.h"
#import "ksColorCell.h"

@implementation ksSecurity

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(BOOL)securityCheck {
    if ([_securityEnabled isEqualToString:@"YES"])
        return YES;
    return NO;
}

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
                case SEC_PROCESS_CONFIRMNEW: {
                    _passcodeSwitch.on = NO;
                }
                    break;
                case SEC_PROCESS_DISABLE: {
                    _passcodeSwitch.on = YES;
                }
                    break;
            }

            [self clearPasscodeWindows];
            _passcodeStatusLabel.textColor = CCO_BASE_CREAM;
            _passcodeStatusLabel.backgroundColor = CCO_BASE_RED;
            _passcodeStatusLabel.text = @"Passcode Cancelled";
            _passcodeStatusLabel.hidden = NO;
            [self hidePasscodeView];
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
                [self hidePasscodeView];
                _securityEnabled = @"YES";
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
                _passcodeStatusLabel.text = @"Passcode Confirmed";
                [self hidePasscodeView];
                _securityEnabled = @"YES";
                [[(ksViewController*) [[self window] rootViewController] ksCD] updateSecurity:_securityEnabled passcode:_tempPasscode];
            }
                break;
            case SEC_PROCESS_DISABLE: {
                [self clearPasscodeWindows];
                _passcodeStatusLabel.text = @"Passcode Disabled";
                [self hidePasscodeView];
                _securityEnabled = @"NO";
                [[(ksViewController*) [[self window] rootViewController] ksCD] updateSecurity:_securityEnabled passcode:@""];
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

-(void)clearPasscodeWindows {
    _tempPasscode = @"";
    _passcodeImage1.hidden = YES;
    _passcodeImage2.hidden = YES;
    _passcodeImage3.hidden = YES;
    _passcodeImage4.hidden = YES;
}

-(void)hidePasscodeView {
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0.0, 480.0, 320.0, 480.0);
    }];
}

-(void)showPasscodeView:(int)thisProcess {
    [self clearPasscodeWindows];
    _whichProcess = thisProcess;
    _passcodeStatusLabel.text = @"";
    _passcodeStatusLabel.backgroundColor = [UIColor clearColor];

    switch(_whichProcess) {
        case SEC_PROCESS_RUNTIMELOGIN: {
            _passcodeTitleLabel.text = @"Enter Passcode";
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
        self.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
    }];
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
