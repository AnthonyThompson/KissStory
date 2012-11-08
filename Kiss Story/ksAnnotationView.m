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
        _index = 0;
        _title = annotation.title;
        _coordinate = annotation.coordinate;

        _IDArray = annotation.IDArray;
        _kisserArray = annotation.kisserArray;
        _dateArray = annotation.dateArray;
        _ratingArray = annotation.ratingArray;
        _descriptionArray = annotation.descriptionArray;
        _imageArray = annotation.imageArray;

        _calloutView = [[ksCalloutView alloc]init];
        _calloutView.frameImage.image = [[UIImage imageNamed:@"FrameCallout.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 304, 304)];
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
    
    _tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(segmentedControlGestured:)];
    _tap.numberOfTapsRequired = 1;
    _tap.delegate = ROOT;
    [self addGestureRecognizer:_tap];
    [_calloutView.segmentedControl addGestureRecognizer:_tap];
}

-(void)dataForIndex:(int)index {
    _calloutView.locationLabel.text = _title;
    _calloutView.kisserLabel.text = [_kisserArray objectAtIndex:index];
    // 9901 MAKE DATE FOR VIEW!
    //_calloutView.dateLabel.text = [_dateArray objectAtIndex:index];
    _calloutView.descLabel.text = [_descriptionArray objectAtIndex:index];
    
    // colorize based on rating
}

-(void)displayCallout {
    
    NSLog(@"kAV +CO");

    [self dataForIndex:_index];
    
    if ([_kisserArray count] > 1) {
        [self addSubview:_testButton];
    }

    _calloutView.hidden = NO;

    CGPoint annotationCoordPoint = [[ROOT mainMapView] convertCoordinate:_coordinate toPointToView:[ROOT mainMapView]];
    
    // 9901 this is teh offset to make the pin point to teh right place... different for pin vs anootation view?  Use offset here?
    // or is this acrtually controlled at creation???
    annotationCoordPoint = CGPointMake(annotationCoordPoint.x + 6.0f,
                                       annotationCoordPoint.y - 155.0f);
    
    [[ROOT mainMapView] setCenterCoordinate:[[ROOT mainMapView] convertPoint:annotationCoordPoint toCoordinateFromView:[ROOT mainMapView]] animated:YES];
}

-(void)dismissCallout {
    _calloutView.hidden = YES;
    [[ROOT mainMapView] setCenterCoordinate:_coordinate animated:YES];
}

-(void)segmentedControlGestured:(UITapGestureRecognizer *)gestureRecognizer {

    _index++;
    if ((_index - 1) == [_kisserArray count]) {
        _index = 0;
    }
    
    [self dataForIndex:_index];
}



@end
