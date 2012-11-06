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
        [self addSubview:_calloutView];
        _testButton = [[UIButton alloc]initWithFrame:CGRectMake(235.0, 1, 64, 40)];
        [_testButton setImage:[UIImage imageNamed:@"ButtonSegment3.png"] forState:UIControlStateNormal];
        //[[_calloutView moreButton] setImage:[UIImage imageNamed:@"ButtonSegment3.png"] forState:UIControlStateNormal];

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
                                   initWithTarget:self action:@selector(moreButtonGestured:)];
    _tap.numberOfTapsRequired = 1;
    _tap.delegate = ROOT;
    [self addGestureRecognizer:_tap];
    [[_calloutView moreButton] addGestureRecognizer:_tap];
}

-(void)dataForIndex:(int)index {
    _calloutView.whereLabel.text = _title;
    _calloutView.whoLabel.text = [_kisserArray objectAtIndex:index];
    // 9901
    //_calloutView.whenLabel.text = [_dateArray objectAtIndex:index];
    _calloutView.descLabel.text = [_descriptionArray objectAtIndex:index];
    
    // colorize based on rating
}

-(void)displayCallout {
    
    [self dataForIndex:_index];
    
    if ([_kisserArray count] > 1) {
        [self addSubview:_testButton];
    }
    
    /*
    //NSLog(@"+Co tap x %f",[_tap locationInView:_calloutView].x);
    //NSLog(@"+Co tap y %f",[_tap locationInView:_calloutView].y);
    NSLog(@"+Co tap x %f",[_tap locationInView:[_calloutView superview]].x);
    NSLog(@"+Co tap y %f",[_tap locationInView:[_calloutView superview]].y);
    
    NSLog(@"self %@",self);
     */
    
    _calloutView.hidden = NO;
    //_testButton.hidden = NO;
    

    CGPoint annotationCoordPoint = [[ROOT mainMapView] convertCoordinate:_coordinate toPointToView:[ROOT mainMapView]];
    annotationCoordPoint = CGPointMake(annotationCoordPoint.x+6.0f, annotationCoordPoint.y-155.0f);
    
    [[ROOT mainMapView] setCenterCoordinate:[[ROOT mainMapView] convertPoint:annotationCoordPoint toCoordinateFromView:[ROOT mainMapView]] animated:YES];
}

-(void)dismissCallout {
    /*
    //NSLog(@"-Co tap x %f",[_tap locationInView:_calloutView].x);
    //NSLog(@"-Co tap y %f",[_tap locationInView:_calloutView].y);
    NSLog(@"-Co tap x %f",[_tap locationInView:[_calloutView superview]].x);
    NSLog(@"-Co tap y %f",[_tap locationInView:[_calloutView superview]].y);
    
    NSLog(@"self %@",self);
     */
    
    _calloutView.hidden = YES;
    //_testButton.hidden = YES;
    [[ROOT mainMapView] setCenterCoordinate:_coordinate animated:YES];

    /*
    if (CGRectContainsPoint(_calloutView.frame, [_tap locationInView:_calloutView])) {
        NSLog(@"IN");
        [self moreButtonGestured:_tap];
    } else {
        NSLog(@"OUT");
        _calloutView.hidden = YES;
        _testButton.hidden = YES;
        [[ROOT mainMapView] setCenterCoordinate:_coordinate animated:YES];
    }
     */
}

-(void)moreButtonGestured:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"mBG");
    
    _index++;
    if ((_index - 1) == [_kisserArray count]) {
        _index = 0;
    }
    
    [self dataForIndex:_index];
}



@end
