//
//  ksSettingsView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/29/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ksPopOverView.h"
#import "ksSecurityView.h"

@interface ksSettingsView : UIView

-(void)displaySettingsView;

@property (nonatomic, retain) ksPopOverView* popOverView;

@property (nonatomic, retain) NSDictionary* settingsDictionary;

@property (nonatomic, retain) ksSecurityView* securityView;

@property (nonatomic, retain) IBOutlet UILabel* bigVersionLabel;
@property (nonatomic, retain) IBOutlet UILabel* littleVersionLabel;
@property (nonatomic, retain) IBOutlet UISwitch* facebookSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* twitterSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* passcodeSwitch;
@property (nonatomic, retain) IBOutlet UIButton* wwwButton;
@property (nonatomic, retain) IBOutlet UIButton* emailButton;
@property (nonatomic, retain) IBOutlet UIButton* dismissButton;

@end
