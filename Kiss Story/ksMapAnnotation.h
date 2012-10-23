//
//  ksMapAnnotation.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/20/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ksMapAnnotation : NSObject <MKAnnotation> {
}

-(id)init;
-(id)initWithLocation:(NSArray*)locationArray;

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite) double ID;
@property (nonatomic, retain) NSString* locationName;
@property (nonatomic, retain) NSString* kisserName;
@property (nonatomic, readwrite) int rating;
@property (nonatomic, readwrite) double date;
@property (nonatomic, retain) NSString* kissDescription;

@end
