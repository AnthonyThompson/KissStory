//
//  ksKissObject.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/26/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissObject.h"

@implementation ksKissObject

@synthesize state = _state;
@synthesize kissWho = _kissWho;
@synthesize kissDate = _kissDate;
@synthesize kissRating = _kissRating;
@synthesize kissWhere = _kissWhere;
@synthesize kissDescription = _kissDescription;

-(id)init {
    if (self = [super init]) {
        _kissWho = [[NSObject alloc]init];
        _kissDate = [NSDate date];
        _kissRating = 0;
        _kissWhere = [[NSObject alloc]init];
        _kissDescription = [[NSString alloc]init];
    }
    
    return self;
}

@end
