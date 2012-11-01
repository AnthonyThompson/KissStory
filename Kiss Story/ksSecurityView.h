//
//  ksSecurity.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/14/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEC_CANCEL_KEY 10
#define SEC_BACK_KEY 11

#define SEC_PASSCODE_ENTER 0
#define SEC_PASSCODE_CONFIRM 1

#define SEC_PROCESS_RUNTIMELOGIN 0
#define SEC_PROCESS_SETNEW 1
#define SEC_PROCESS_CONFIRMNEW 2
#define SEC_PROCESS_DISABLE 3

@interface ksSecurityView : UIView

-(id)initForProcess:(int)whichProcess withData:(NSDictionary*)dataDictionary;
-(void)displaySecurityView;

+(BOOL)securityCheck:(NSDictionary*)dataDictionary;

@property (nonatomic, retain) IBOutlet UILabel* passcodeTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel* passcodeStatusLabel;
@property (nonatomic, retain) IBOutlet UIImageView* passcodeImage1;
@property (nonatomic, retain) IBOutlet UIImageView* passcodeImage2;
@property (nonatomic, retain) IBOutlet UIImageView* passcodeImage3;
@property (nonatomic, retain) IBOutlet UIImageView* passcodeImage4;

@property (nonatomic, retain) IBOutlet UIButton* passcodeButton1;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButton2;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButton3;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButton4;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButton5;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButton6;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButton7;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButton8;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButton9;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButton0;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButtonCancel;
@property (nonatomic, retain) IBOutlet UIButton* passcodeButtonBack;

@property (nonatomic, readwrite) int whichProcess;
@property (nonatomic, readwrite) NSString* tempPasscode;
@property (nonatomic, readwrite) BOOL securityEnabled;
@property (nonatomic, readwrite) NSString* passcode;

@property (nonatomic, retain) IBOutlet UIView* loginView;

@end
