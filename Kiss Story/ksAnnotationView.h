//
//  ksAnnotationView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/22/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ksKissItemView.h"

#define BASE_BUTTON_FRAME CGRectMake(0.0f, 0.0f, 64.0f, 40.0f)
#define BASE_ANNOTATION_FRAME CGRectMake(0.0f, 0.0f, 37.0f, 39.0f)
#define BASE_PIN_FRAME CGRectMake(0.0f, 0.0f, 37.0f, 39.0f)
#define BASE_CONTENT_FRAME CGRectMake(7.0f, 7.0f, _content.frame.size.width, _content.frame.size.height)
#define BASE_FRAME_FRAME CGRectMake(0.0f, 0.0f, 37.0f, 39.0f)

@interface ksAnnotationView : MKAnnotationView

-(void)displayCallout;
-(void)dismissCallout;

@property (nonatomic, readwrite) NSString* title;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) ksKissItemView* content;
@property (nonatomic, retain) UIImageView* frameImageView;
@property (nonatomic, retain) UIButton* backingButton;
@property (nonatomic, retain) UIButton* moreButton;
@property (nonatomic, retain) UIImageView* pinImageView;
@property (nonatomic, retain) NSArray* kissArray;
@property (nonatomic, readwrite) int index;

@end
