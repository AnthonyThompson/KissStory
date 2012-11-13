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
        _kissArray = annotation.kissArray;

        [self initData];
        [self resetAnnotationView];
    }
    return self;
}

-(void)initData {
    // these are the once-and-done's
    self.canShowCallout = NO;
    self.enabled = YES;
    self.frame = BASE_ANNOTATION_FRAME;

    _moreButton = [[UIButton alloc]initWithFrame:BASE_BUTTON_FRAME];
    [_moreButton addTarget:self action:@selector(moreButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    _buttonImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ButtonHeaderMore.png"]];
    _buttonLabel = [[UILabel alloc]initWithFrame:_buttonImage.frame];
    _buttonLabel.backgroundColor = [UIColor clearColor];
    _buttonLabel.textColor = CCO_BASE_CREAM;
    _buttonLabel.textAlignment = NSTextAlignmentCenter;
    _buttonLabel.minimumScaleFactor = 0.1f;
    _buttonLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:18.0f];
    _buttonLabel.adjustsFontSizeToFitWidth = YES;

    _pinImageView = [[UIImageView alloc]initWithFrame:BASE_PIN_FRAME];
    
    _content = [[ksKissItemView alloc]initForAnnotation];
    _content.frame = BASE_CONTENT_FRAME;

    _frameImageView = [[UIImageView alloc]initWithFrame:BASE_FRAME_FRAME];
    _frameImageView.image = [[UIImage imageNamed:@"FrameCallout.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8.0f, 127.0f, 32.0f, 127.0f)];
    _frameImageView.layer.shadowColor = [CCO_BASE_GREY CGColor];
    _frameImageView.layer.shadowOpacity = 0.33f;
    _frameImageView.layer.shadowRadius = 0.0f;
    _frameImageView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);

    [_frameImageView addSubview:_content];
    [_frameImageView addSubview:_buttonImage];
    [_frameImageView addSubview:_buttonLabel];

    [self addSubview:_pinImageView];
    [self addSubview:_frameImageView];
    [self addSubview:_moreButton];
}

-(void)resetAnnotationView {
    // reset to factory fresh settings
    _index = 0;
    
    _content.hidden = YES;
    _frameImageView.hidden = YES;
    _frameImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);

    _pinImageView.hidden = YES;
    _moreButton.hidden = YES;
    _buttonImage.hidden = YES;
    _buttonLabel.hidden = YES;

    self.frame = CGRectMake(self.frame.origin.x + _pinImageView.frame.origin.x,
                            self.frame.origin.y + _pinImageView.frame.origin.y,
                            37.0f, 39.0f);
    self.image = [[[ksColorObject imageArray]objectAtIndex:[self mapPinColor]]objectAtIndex:CCO_PIN];
    
    _moreButton.frame = BASE_BUTTON_FRAME;

    _pinImageView.frame = BASE_PIN_FRAME;
    _pinImageView.image = self.image;

    _content.frame = BASE_CONTENT_FRAME;
    _content.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _content.descContainerView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);

    _frameImageView.frame = BASE_FRAME_FRAME;
}

-(int)mapPinColor {
    return ([_kissArray count] > 1) ? CCO_RAINBOW_COLOR : [[[_kissArray objectAtIndex:0] valueForKey:@"score"] intValue];
}

-(void)displayFullAnnotationView {
    _pinImageView.image = self.image;
    self.image = [UIImage imageNamed:@"PinInvisible.png"];
    _content.hidden = NO;
    _frameImageView.hidden = NO;
    _pinImageView.hidden = NO;
    
    [self updateContent];
    
    //_content.layer.borderColor = [[UIColor redColor] CGColor];
    //_content.layer.borderWidth = 1.0f;
    //_content.photoContainerView.layer.borderColor = [[UIColor greenColor] CGColor];
    //_content.photoContainerView.layer.borderWidth = 1.0f;
    //_frameImageView.layer.borderColor = [[UIColor blueColor] CGColor];
    //_frameImageView.layer.borderWidth = 1.0f;
    //_pinImageView.layer.borderColor = [[UIColor greenColor] CGColor];
    //_pinImageView.layer.borderWidth = 1.0f;
    //self.layer.borderColor = [[UIColor blackColor] CGColor];
    //self.layer.borderWidth = 1.0f;
}

-(void)displayCallout {
    
    [self displayFullAnnotationView];
    // centers on pin
    //9901, move this down, or cut-out and call separately to re-size/re-center on new call-outs...
    CGPoint annotationCoordPoint = [[ROOT mainMapView] convertCoordinate:_coordinate toPointToView:[ROOT mainMapView]];
    annotationCoordPoint = CGPointMake(annotationCoordPoint.x,
                                       annotationCoordPoint.y - 60.0f);
    
    [[ROOT mainMapView] setCenterCoordinate:[[ROOT mainMapView] convertPoint:annotationCoordPoint toCoordinateFromView:[ROOT mainMapView]] animated:YES];
    
    _frameImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.1f animations:^{
        _frameImageView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.05f animations:^{
            _frameImageView.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05f animations:^{
                _frameImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            }];
        }];
    }];

    
}

-(void)centerOnCallOut {
    // check size of call-out
    // check closeness to edge of view
    //nudge horizontal
    //check closeness to top - centering button
    // nudge vertical
    //[[ROOT mainMapView] setCenterCoordinate:[[ROOT mainMapView] convertPoint:annotationCoordPoint toCoordinateFromView:[ROOT mainMapView]] animated:YES];
}

-(void)dismissCallout {
    [UIView animateWithDuration:0.075f animations:^{
        _frameImageView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1f animations:^{
            _frameImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL finished) {
            [self resetAnnotationView];
        }];
    }];
    
}

-(void)moreButtonTouched:(id)sender {
    _index++;
    if (_index == [_kissArray count]) _index = 0;

    self.frame = CGRectMake(self.frame.origin.x + _pinImageView.frame.origin.x,
                            self.frame.origin.y + _pinImageView.frame.origin.y,
                            37.0f, 39.0f);
    [self updateContent];
}

-(void)updateContent{
    [_content colorizeWithData:[_kissArray objectAtIndex:_index] forType:LOCATION];

    _moreButton.hidden = ([_kissArray count] > 1) ? NO : YES;
    _moreButton.frame = (_moreButton.hidden) ? CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) :
                                                CGRectMake(_content.frame.size.width - _moreButton.frame.size.width,
                                                           _content.frame.size.height + 8.0f,
                                                           _moreButton.frame.size.width,
                                                           _moreButton.frame.size.height);
    
    _buttonImage.hidden = _moreButton.hidden;
    _buttonImage.frame = _moreButton.frame;
    _buttonLabel.hidden = _moreButton.hidden;
    _buttonLabel.frame = _moreButton.frame;
    _buttonLabel.text = [NSString stringWithFormat:@"%i (%i)",_index+1,[_kissArray count]];

    _frameImageView.frame = CGRectMake(0.0f, 0.0f,
                                       _content.frame.size.width + 12.0f,
                                       _content.frame.size.height + 32.0f + _moreButton.frame.size.height);

    _pinImageView.frame = CGRectMake(_frameImageView.frame.size.width/2 - (_pinImageView.frame.size.width/2/3),
                                     _frameImageView.frame.size.height,
                                     _pinImageView.frame.size.width,
                                     _pinImageView.frame.size.height);
    
    self.frame = CGRectMake(self.frame.origin.x - _pinImageView.frame.origin.x,
                            self.frame.origin.y - _frameImageView.frame.size.height,
                            _frameImageView.frame.size.width,
                            (_frameImageView.frame.size.height + _pinImageView.frame.size.height));
}

@end
