//
//  ksKissObject.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/26/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ksCoreData.h"
#import "ksPopOverView.h"

#define VALID_DATA 0
#define INVALID_WHO_ENTITY 1
#define INVALID_WHERE_ENTITY 2
#define INVALID_WHO_AND_WHERE_ENTITY 3

@interface ksKissObjectView : UIView

-(BOOL)saveKiss;

@property (nonatomic, readwrite) int state;
//@property (nonatomic, retain) NSManagedObject* kissWho;
//@property (nonatomic, retain) NSManagedObject* kissWhere;
//@property (nonatomic, retain) NSManagedObject* kissKiss;
@property (nonatomic, retain) NSObject* kissWho;
@property (nonatomic, retain) NSObject* kissWhere;
@property (nonatomic, retain) NSObject* kissKiss;
@property (nonatomic, readwrite) NSDate* kissDate;
@property (nonatomic, readwrite) int kissRating;
@property (nonatomic, retain) NSString* kissDescription;

@property (nonatomic, retain) ksCoreData* coreData;

@property (nonatomic, retain) ksPopOverView* popOverView;
@property (nonatomic, retain) IBOutlet UILabel* popOverTitle;
@property (nonatomic, retain) IBOutlet UILabel* popOverText;
@property (nonatomic, retain) IBOutlet UIButton* popOverButton;


@end
