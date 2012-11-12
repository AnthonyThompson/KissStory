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

@property (nonatomic, retain) ksKissItemView* content;

@property (nonatomic, retain) UIImageView* frameImageView;
@property (nonatomic, retain) UIButton* moreButton;
@property (nonatomic, retain) UIImageView* pinImageView;

@property (nonatomic, retain) NSArray* kissArray;






//9901 THESE ARE SUSPECT...
@property (nonatomic, readwrite) NSString* title;
@property (nonatomic, readwrite) NSString* reuseIdentifier;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, readwrite) int index;
@property (nonatomic, readwrite) int indexIterations;
@property (nonatomic, readwrite) int frameIterations;

@end
