//
//  ksKissObject.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/26/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ksCoreData.h"
#import "DCRoundSwitch.h"

#define VALID_DATA 0
#define INVALID_WHO_ENTITY 1
#define INVALID_WHERE_ENTITY 2
#define INVALID_WHO_AND_WHERE_ENTITY 3

@interface ksKissObject : UIView <UITextFieldDelegate>

-(id)initWithConfiguration:(int)configuration;

-(void)validityCheck;
-(BOOL)saveKiss;
-(void)deleteKiss;

@property (nonatomic) int state;
@property (nonatomic, retain) NSMutableDictionary* kissWho;
@property (nonatomic, retain) NSMutableDictionary* kissWhere;
@property (nonatomic, readwrite) NSDate* kissDate;
@property (nonatomic, readwrite) int kissRating;
@property (nonatomic, retain) NSString* kissDescription;
@property (nonatomic, retain) UIImage* kissPicture;
@property (nonatomic) BOOL validWho;
@property (nonatomic) BOOL validWhere;
@property (nonatomic) BOOL validDate;
@property (nonatomic) BOOL validDesc;

@property (nonatomic, retain) ksCoreData* coreData;

// object 0 KissDetailsWarning
@property (nonatomic, retain) IBOutlet UILabel* popOverTitle;
@property (nonatomic, retain) IBOutlet UILabel* popOverText;

// object 1 AddWhoWhere
@property (nonatomic, retain) IBOutlet UILabel* addTitle;
@property (nonatomic, retain) IBOutlet UITextField* addText;
@property (nonatomic, retain) IBOutlet UIButton* addAcceptButton;

// objetc 2 ConfirmAction
@property (nonatomic, retain) IBOutlet UILabel* confirmTitle;
@property (nonatomic, retain) IBOutlet UIButton* confirmAcceptButton;

// object 3 ShareKiss
@property (nonatomic, retain) IBOutlet DCRoundSwitch* facebookSwitch;
@property (nonatomic, retain) IBOutlet DCRoundSwitch* twitterSwitch;
@property (nonatomic, retain) IBOutlet UIButton* shareAcceptButton;







@end
