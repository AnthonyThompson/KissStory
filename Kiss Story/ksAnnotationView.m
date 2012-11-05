//
//  ksAnnotationView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/22/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksAnnotationView.h"
#import "ksViewController.h"

@implementation ksAnnotationView

@synthesize title = _title;
@synthesize coordinate = _coordinate;

-(id)initWithAnnotation:(ksAnnotationView*)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:(id)annotation reuseIdentifier:reuseIdentifier]) {
        _coordinate = annotation.coordinate;
        _calloutView = [[ksCalloutView alloc]init];
        [self addSubview:_calloutView];
        [self initData];
    }
    return self;
}

-(int)color {
    if ([_ratingArray count] > 1) {
        return CCO_RAINBOW_COLOR;
    }
    return [[_ratingArray objectAtIndex:0]intValue];
}

-(void)initData {
    self.canShowCallout = NO;
    self.enabled = YES;
}

-(void)displayCallout {
    _calloutView.hidden = NO;
    CGPoint annotationCoordPoint = [[ROOT mainMapView] convertCoordinate:_coordinate toPointToView:[ROOT mainMapView]];
    annotationCoordPoint = CGPointMake(annotationCoordPoint.x+6.0f, annotationCoordPoint.y-155.0f);
    [[ROOT mainMapView] setCenterCoordinate:[[ROOT mainMapView] convertPoint:annotationCoordPoint toCoordinateFromView:[ROOT mainMapView]] animated:YES];
}

-(void)dismissCallout {
    _calloutView.hidden = YES;
    [[ROOT mainMapView] setCenterCoordinate:_coordinate animated:YES];
}

@end
