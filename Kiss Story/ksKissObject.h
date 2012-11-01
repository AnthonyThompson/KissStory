//
//  ksKissObject.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/26/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ksCoreData.h"

#define VALID_DATA 0
#define INVALID_WHO_ENTITY 1
#define INVALID_WHERE_ENTITY 2
#define INVALID_WHO_AND_WHERE_ENTITY 3

@interface ksKissObject : UIView

-(BOOL)saveKiss;

@property (nonatomic, readwrite) int state;
@property (nonatomic, retain) NSMutableDictionary* kissWho;
@property (nonatomic, retain) NSMutableDictionary* kissWhere;
@property (nonatomic, readwrite) NSDate* kissDate;
@property (nonatomic, readwrite) int kissRating;
@property (nonatomic, retain) NSString* kissDescription;

@property (nonatomic, retain) ksCoreData* coreData;

@property (nonatomic, retain) IBOutlet UILabel* popOverTitle;
@property (nonatomic, retain) IBOutlet UILabel* popOverText;

@property (nonatomic, retain) IBOutlet UILabel* addTitle;
@property (nonatomic, retain) IBOutlet UITextField* addText;



@end
