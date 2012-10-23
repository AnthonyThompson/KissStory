//
//  ksMapAnnotation.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/20/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksMapAnnotation.h"

@implementation ksMapAnnotation

//@synthesize coordinate;
//@synthesize ID;

-(id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(int)color {
    if ([_ratingArray count] > 1) {
        return CCO_RAINBOW_COLOR;
    }
    
    return [[_ratingArray objectAtIndex:0]intValue];
}

@end
