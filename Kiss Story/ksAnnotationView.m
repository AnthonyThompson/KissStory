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
        
        self.canShowCallout = NO;
        self.enabled = YES;
        self.frame = CGRectMake(0.0f, 0.0f, 37.0f, 39.0f);
        
        _moreButton = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 64.0f, 40.0f)];
        [_moreButton setImage:[UIImage imageNamed:@"ButtonHeaderAccept.png"] forState:UIControlStateNormal];
        
        _pinImageView = [[UIImageView alloc]initWithFrame:self.frame];
        
        _content = [[ksKissItemView alloc]init];
        _content.autoresizingMask = UIViewContentModeCenter;
        _content.transform = CGAffineTransformMakeScale(0.8f, 0.8f);

        _content.frame = CGRectMake(7.0f, 7.0f, _content.frame.size.width, _content.frame.size.height);
        _content.clipsToBounds = YES;
        
        _frameImageView = [[UIImageView alloc]initWithFrame:self.frame];
        [_frameImageView addSubview:_content];
        [_frameImageView addSubview:_moreButton];
        [self addSubview:_pinImageView];
        [self addSubview:_frameImageView];
        
        [self initDisplay];
    }
    return self;
}

-(void)fullDisplay {
    _pinImageView.image = self.image;
    self.image = [UIImage imageNamed:@"PinInvisible.png"];

    _content.hidden = NO;
    [_content colorizeWithData:[_kissArray objectAtIndex:_index] forType:LOCATION];
    _content.frame = CGRectMake(_content.frame.origin.x,
                                _content.frame.origin.y,
                                _content.frame.size.width,
                                _content.frame.size.height);
    
    _content.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _content.descContainerView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    //_content.layer.borderColor = [[UIColor redColor] CGColor];
    //_content.layer.borderWidth = 1.0f;

    _moreButton.hidden = ([_kissArray count] > 1) ? NO : YES;
    _moreButton.frame = (_moreButton.hidden) ? CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) :
                                               CGRectMake(_content.frame.size.width - _moreButton.frame.size.width,
                                                          _content.frame.size.height + 8.0f,
                                                          _moreButton.frame.size.width,
                                                          _moreButton.frame.size.height);

    _frameImageView.hidden = NO;
    _frameImageView.frame = CGRectMake(0.0f, 0.0f,
                                       _content.frame.size.width + 12.0f,
                                       _content.frame.size.height + 32.0f + _moreButton.frame.size.height);
    _frameImageView.image = [[UIImage imageNamed:@"FrameCallout.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8.0f, 127.0f, 32.0f, 127.0f)];
    _frameImageView.layer.shadowColor = [CCO_BASE_GREY CGColor];
    _frameImageView.layer.shadowOpacity = 0.33f;
    _frameImageView.layer.shadowRadius = 0.0f;
    _frameImageView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    //_frameImageView.layer.borderColor = [[UIColor blueColor] CGColor];
    //_frameImageView.layer.borderWidth = 1.0f;

    _pinImageView.hidden = NO;
    _pinImageView.frame = CGRectMake(_frameImageView.frame.size.width/2 - (_pinImageView.frame.size.width/2/3),
                                     _frameImageView.frame.size.height,
                                     _pinImageView.frame.size.width,
                                     _pinImageView.frame.size.height);
    //_pinImageView.layer.borderColor = [[UIColor greenColor] CGColor];
    //_pinImageView.layer.borderWidth = 1.0f;

    self.frame = CGRectMake(self.frame.origin.x - _pinImageView.frame.origin.x,
                            self.frame.origin.y - _frameImageView.frame.size.height,
                            _frameImageView.frame.size.width,
                            (_frameImageView.frame.size.height + _pinImageView.frame.size.height));
    //self.layer.borderColor = [[UIColor blackColor] CGColor];
    //self.layer.borderWidth = 1.0f;
}

-(int)mapPinColor {
    return ([_kissArray count] > 1) ? CCO_RAINBOW_COLOR : [[[_kissArray objectAtIndex:0] valueForKey:@"score"] intValue];
}

-(void)initDisplay {
    self.frame = CGRectMake(self.frame.origin.x + _pinImageView.frame.origin.x,
                            self.frame.origin.y + _pinImageView.frame.origin.y,
                            37.0f,
                            39.0f);
    
    self.image = [[[ksColorObject imageArray]objectAtIndex:[self mapPinColor]]objectAtIndex:CCO_PIN];

    _content.hidden = YES;
    _frameImageView.hidden = YES;
    _pinImageView.hidden = YES;
    _moreButton.hidden = YES;

    _index = 0;
    _indexIterations = 3;
    _frameIterations = 3;
}

-(void)moreButtonTouched {
    _indexIterations = 3;

    _index = (_index == [_kissArray count]) ? 0 : _index++;
    
    [_content colorizeWithData:[_kissArray objectAtIndex:_index] forType:LOCATION];
}


-(void)displayCallout {
    // centers on pin

    CGPoint annotationCoordPoint = [[ROOT mainMapView] convertCoordinate:_coordinate toPointToView:[ROOT mainMapView]];
    annotationCoordPoint = CGPointMake(annotationCoordPoint.x,
                                     annotationCoordPoint.y - 60.0f);

    [[ROOT mainMapView] setCenterCoordinate:[[ROOT mainMapView] convertPoint:annotationCoordPoint toCoordinateFromView:[ROOT mainMapView]] animated:YES];
    [self fullDisplay];
}

-(void)dismissCallout {
    [self initDisplay];
    return;
    
    _indexIterations = 3;
    _frameIterations = 3;
}
@end
