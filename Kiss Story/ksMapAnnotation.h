//
//  ksMapAnnotation.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/20/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ksColorObject.h"

@interface ksMapAnnotation : NSObject <MKAnnotation> {
}

-(id)init;

@property (nonatomic, readwrite) NSString* title;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) NSArray* IDArray;
@property (nonatomic, retain) NSArray* locationArray;
@property (nonatomic, retain) NSArray* kisserArray;
@property (nonatomic, retain) NSArray* ratingArray;
@property (nonatomic, retain) NSArray* dateArray;
@property (nonatomic, retain) NSArray* descriptionArray;

@property (nonatomic, readwrite) int color;

/*
@property (nonatomic, readwrite) double ID;
@property (nonatomic, retain) NSString* locationName;
@property (nonatomic, retain) NSString* kisserName;
@property (nonatomic, readwrite) int rating;
@property (nonatomic, readwrite) double date;
@property (nonatomic, retain) NSString* kissDescription;
 */

@end
