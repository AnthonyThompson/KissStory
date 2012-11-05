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

@synthesize headerView;
@synthesize moreButton;
@synthesize headerLabel;
@synthesize nameLabel;
@synthesize rightLabel;
@synthesize leftLabel;
@synthesize bodyLabel;
@synthesize leftThumb;
@synthesize rightThumb;
@synthesize nameThumb;
@synthesize photoThumb;

@synthesize title = _title;
@synthesize coordinate = _coordinate;
@synthesize reuseIdentifier = _reuseIdentifier;

-(id)initWithAnnotation:(ksAnnotationView*)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:(id)annotation reuseIdentifier:reuseIdentifier]) {
        //self = [[[NSBundle mainBundle] loadNibNamed:@"ksAnnotationView" owner:self options:nil] objectAtIndex:0];
        _coordinate = annotation.coordinate;
        _reuseIdentifier = reuseIdentifier;
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

-(IBAction)moreButtonTapped:(id)sender {
    
}

-(void)displayCallout {
    if (_calloutView == nil) {
        _calloutView = [[[NSBundle mainBundle] loadNibNamed:@"ksAnnotationView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:_calloutView];
    }

    _calloutView.hidden = NO;
    _calloutView.frame = CGRectOffset(_calloutView.frame, -(_calloutView.frame.size.width/2)+19.0f, -(_calloutView.frame.size.height)+39.0f);
    
    CGPoint annotationCoordPoint = [[ROOT mainMapView] convertCoordinate:_coordinate toPointToView:[ROOT mainMapView]];
    annotationCoordPoint = CGPointMake(annotationCoordPoint.x+6.0f, annotationCoordPoint.y-155.0f);
    [[ROOT mainMapView] setCenterCoordinate:[[ROOT mainMapView] convertPoint:annotationCoordPoint toCoordinateFromView:[ROOT mainMapView]] animated:YES];
}

-(void)dismissCallout {
    _calloutView.hidden = YES;
    [[ROOT mainMapView] setCenterCoordinate:_coordinate animated:YES];
}

@end
