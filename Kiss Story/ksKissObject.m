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
@synthesize managedObjectContext = _managedObjectContext;

-(id)init {
    if (self = [super init]) {
    }
    
    return self;
}

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {
    if (self = [super init]) {
        _kissDate = [NSDate date];
        _kissRating = 0;
        _kissDescription = [[NSString alloc]init];
        _managedObjectContext = managedObjectContext;
        
        NSEntityDescription* whoEntity = [NSEntityDescription entityForName:@"Who" inManagedObjectContext:_managedObjectContext];
        _kissWho = [[NSManagedObject alloc]initWithEntity:whoEntity insertIntoManagedObjectContext:_managedObjectContext];
        
        NSEntityDescription* whereEntity = [NSEntityDescription entityForName:@"Where" inManagedObjectContext:_managedObjectContext];
        _kissWhere = [[NSManagedObject alloc]initWithEntity:whereEntity insertIntoManagedObjectContext:_managedObjectContext];
    }
    
    return self;
}

-(BOOL)saveKiss {
    return NO;
}

@end
