//
//  ksKissObject.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/26/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ksKissObject : NSObject

// this is going to have a state
// and all the dataholders =for an object
// as well as the delete/edit/add - commit/verify routines.

// I guess also new who/where's as well; validation before adding, &c.

// pictures, sharing, &c. all from here

// activity indicator for saves...

@property (nonatomic, readwrite) int state;
@property (atomic, retain) NSObject* kissWho;
@property (atomic, readwrite) NSDate* kissDate;
@property (atomic, readwrite) int kissRating;
@property (atomic, retain) NSObject* kissWhere;
@property (atomic, retain) NSString* kissDescription;

@end
