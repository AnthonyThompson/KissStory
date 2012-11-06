//
//  ksAnnotationView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/22/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ksCalloutView.h"

@interface ksAnnotationView : MKAnnotationView

-(void)displayCallout;
-(void)dismissCallout;

@property (nonatomic, retain) ksCalloutView* calloutView;
@property (nonatomic, retain) UITapGestureRecognizer* tap;

@property (nonatomic, readwrite) NSString* title;
@property (nonatomic, readwrite) NSString* reuseIdentifier;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) UIButton* testButton;

@property (nonatomic, retain) NSArray* IDArray;
@property (nonatomic, retain) NSArray* locationArray;
@property (nonatomic, retain) NSArray* kisserArray;
@property (nonatomic, retain) NSArray* ratingArray;
@property (nonatomic, retain) NSArray* dateArray;
@property (nonatomic, retain) NSArray* descriptionArray;

@property (nonatomic, readwrite) int color;
@property (nonatomic, readwrite) int index;


@end
