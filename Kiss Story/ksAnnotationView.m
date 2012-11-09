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

-(int)mapPinColor {
    if ([_ratingArray count] > 1) {
        return CCO_RAINBOW_COLOR;
    }
    return [[_ratingArray objectAtIndex:0]intValue];
}

-(void)initData {
    self.canShowCallout = NO;
    self.enabled = YES;

    _index = 0;
    _indexIterations = 3;
    _frameIterations = 3;

    [self colorizeAnnotationWithColor:[[_ratingArray objectAtIndex:0] intValue] withType:LOCATION];
    
    //[self dataForIndex:_index];
}

-(void)dataForIndex:(int)index {
    _calloutView.locationLabel.text = _title;
    _calloutView.kisserLabel.text = [_kisserArray objectAtIndex:index];
    
    //_calloutView.dateLabel.text = [_dateArray objectAtIndex:index];
    
    _calloutView.descLabel.text = [_descriptionArray objectAtIndex:index];
    _calloutView.photoImage.image = [[UIImage alloc]init];

    if (![[_imageArray objectAtIndex:index] isEqualToData:KSCD_DUMMYIMAGE]) {
        // image exists
        _calloutView.photoImage.image = [UIImage imageWithData:[_imageArray objectAtIndex:index]];
    } else {
        // image does not exist... resize element?
    }
}

-(void)displayCallout {
    // called from mapview delegate in didSelectAnnotationView
    
    //9901 RE-FRAME ANNOTATION HERE?  AND THEN DE-FRAME ON DISMISS?
    
    // RESET AND INIT
    [self initData];
    [self dataForIndex:_index];
    _calloutView.hidden = NO;
    
    _calloutView.indexButton.hidden = YES;
    if ([_kisserArray count] > 1) {
        _calloutView.indexButton.hidden = NO;
    }

    CGPoint annotationCoordPoint = [[ROOT mainMapView] convertCoordinate:_coordinate toPointToView:[ROOT mainMapView]];
    
    // 9901 this is teh offset to make the pin point to teh right place... different for pin vs anootation view?  Use offset here?
    // or is this acrtually controlled at creation???
    annotationCoordPoint = CGPointMake(annotationCoordPoint.x + 6.0f,
                                       annotationCoordPoint.y - 155.0f);
    
    [[ROOT mainMapView] setCenterCoordinate:[[ROOT mainMapView] convertPoint:annotationCoordPoint toCoordinateFromView:[ROOT mainMapView]] animated:YES];
}

-(void)dismissCallout {
    _indexIterations = 3;
    _frameIterations = 3;
    _calloutView.hidden = YES;
    [[ROOT mainMapView] setCenterCoordinate:_coordinate animated:YES];
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    
    // think about this...
    //BOOL jool = [self pointInside:point withEvent:event];
    
    CGRect indexButtonFrame = CGRectMake(94.0f, -55.0f, 64.0f, 30.0f);

    if (CGRectContainsPoint(indexButtonFrame, point) && _calloutView.indexButton.hidden == NO) {
        _indexIterations--;
        if (_indexIterations == 0) {
            [self indexButtonTouched];
        }
        return _calloutView.indexButton;
    }
    
    float x = _calloutView.frame.origin.x + self.frame.origin.x;
    float y = _calloutView.frame.origin.y + self.frame.origin.y;
    
    float px = point.x + self.frame.origin.x;
    float py = point.y + self.frame.origin.y;
    
    CGPoint pp = CGPointMake(px, py);
    
    CGRect annotationFrame = CGRectMake(x, y, _calloutView.frame.size.width, _calloutView.frame.size.height - 78.0f);

    if (CGRectContainsPoint(annotationFrame, pp)) {
        _frameIterations--;
        if (_frameIterations == 0) {
            _frameIterations = 3;
        }

        return _calloutView;
        //9901 NOT RETURN CALLOUTVIEW< but disable touches and launch cell detail or some such
    }

    return _calloutView;
}

//9901 is needed???
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // for testing purposes
    BOOL result = [super pointInside:point withEvent:event];
    NSLog(@"pointInside:RESULT = %i", result);
    
    return YES;
}

-(void)indexButtonTouched {
    _indexIterations = 3;
    _index++;
    if (_index == [_kisserArray count]) {
        _index = 0;
    }
    [self dataForIndex:_index];
}

-(void)colorizeAnnotationWithColor:(int)whichColor withType:(int)whichType {
    
    for (UIView* subV in [_calloutView.headerView subviews]) {
        [subV removeFromSuperview];
    }
    
    // these all need to be re-set before/after use/reuse
    
    _calloutView.headerView.backgroundColor = [[[ksColorObject alloc]initDisplayWithColor:whichColor withType:whichType] lightColor];
    _calloutView.kisserImage.image = [[[ksColorObject alloc]initDisplayWithColor:whichColor withType:whichType] leftThumbnailImage];
    _calloutView.dateImage.image = [[[ksColorObject alloc]initDisplayWithColor:whichColor withType:whichType] rightThumbnailImage];
    _calloutView.heartImage = [[[ksColorObject alloc]initDisplayWithColor:whichColor withType:whichType] heartImage];
    
    _calloutView.photoImage.image = nil;
    _calloutView.descContainer.hidden = NO;
    _calloutView.photoContainer.hidden = NO;
    
    //_bodyLabelContainer.frame = CGRectMake(83.0f, 70.0f, 218.0f, 24.0f);
}


@end
