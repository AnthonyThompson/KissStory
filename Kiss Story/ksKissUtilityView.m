//
//  ksKissUtilityView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/23/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissUtilityView.h"
#import "ksViewController.h"
#import "ksPickerView.h"

@implementation ksKissUtilityView

@synthesize kissWhoObject = _kissWhoObject;
@synthesize kissDate = _kissDate;
@synthesize kissRating = _kissRating;
@synthesize kissWhereObject = _kissWhereObject;
@synthesize kissDescription = _kissDescription;

#pragma mark - Inits

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ksKissUtilityView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.frame = frame;
    }
    
    return self;
}

-(id)initForState:(int)whichState withData:(NSDictionary*)whichDictionary {
    if ([self initWithFrame:CGRectMake(0.0f, 480.0f, 320.0f, 436.0f)]) {
        _dataDictionary = [[NSDictionary alloc]initWithDictionary:whichDictionary];
        _state = whichState;
        
        switch (_state) {
            case STATE_ADD: {
                _kissWhoObject = [[NSObject alloc]init];
                _kissDate = [NSDate date];
                _kissRating = 0;
                _kissWhereObject = [[NSObject alloc]init];
                _kissDescription = [[NSString alloc]init];
                
                [_ratingSlider addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ratingSliderTapped:)]];
                [_ratingSlider setThumbImage:[UIImage imageNamed:@"Invisible80Pixel.png"] forState:UIControlStateNormal];
            }
        }
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Kisser Action Group

-(IBAction)kisserButtonTapped:(id)sender {
    [sender setEnabled:NO];
    [self addSubview:[[ksPickerView alloc]initForState:KISSER withData:[[(ksViewController*) [[self window] rootViewController] ksCD] fetchedResultsController:KSCD_WHOBYNAME]]];
}

#pragma mark - Date Action Group

-(IBAction)dateButtonTapped:(id)sender {
    [sender setEnabled:NO];
    [self addSubview:[[ksPickerView alloc]initForState:DATE withData:[[(ksViewController*) [[self window] rootViewController] ksCD] fetchedResultsController:DATE]]];
}

#pragma mark - Rating Action Group

-(IBAction)ratingSliderValueChanged:(id)sender {
    if (_ratingSlider.value < 0.5f) {
        _ratingHeart1.image = CCO_HEART_GREY;
        _ratingHeart2.image = CCO_HEART_GREY;
        _ratingHeart3.image = CCO_HEART_GREY;
        _ratingHeart4.image = CCO_HEART_GREY;
        _ratingHeart5.image = CCO_HEART_GREY;
    } else if (_ratingSlider.value < 1.5f) {
        _ratingHeart1.image = CCO_HEART_BLUE;
        _ratingHeart2.image = CCO_HEART_GREY;
        _ratingHeart3.image = CCO_HEART_GREY;
        _ratingHeart4.image = CCO_HEART_GREY;
        _ratingHeart5.image = CCO_HEART_GREY;
    } else if (_ratingSlider.value < 2.5f) {
        _ratingHeart1.image = CCO_HEART_BLUE;
        _ratingHeart2.image = CCO_HEART_GREEN;
        _ratingHeart3.image = CCO_HEART_GREY;
        _ratingHeart4.image = CCO_HEART_GREY;
        _ratingHeart5.image = CCO_HEART_GREY;
    } else if (_ratingSlider.value < 3.5f) {
        _ratingHeart1.image = CCO_HEART_BLUE;
        _ratingHeart2.image = CCO_HEART_GREEN;
        _ratingHeart3.image = CCO_HEART_YELLOW;
        _ratingHeart4.image = CCO_HEART_GREY;
        _ratingHeart5.image = CCO_HEART_GREY;
    } else if (_ratingSlider.value < 4.5f) {
        _ratingHeart1.image = CCO_HEART_BLUE;
        _ratingHeart2.image = CCO_HEART_GREEN;
        _ratingHeart3.image = CCO_HEART_YELLOW;
        _ratingHeart4.image = CCO_HEART_ORANGE;
        _ratingHeart5.image = CCO_HEART_GREY;
    } else {
        _ratingHeart1.image = CCO_HEART_BLUE;
        _ratingHeart2.image = CCO_HEART_GREEN;
        _ratingHeart3.image = CCO_HEART_YELLOW;
        _ratingHeart4.image = CCO_HEART_ORANGE;
        _ratingHeart5.image = CCO_HEART_RED;
    }
}

-(void)ratingSliderTapped:(UITapGestureRecognizer*)sender {
    UISlider* slider = (UISlider*)sender.view;
    CGFloat percent = [sender locationInView:slider].x/slider.bounds.size.width;
    CGFloat delta = percent*(slider.maximumValue - slider.minimumValue);
    CGFloat value = slider.minimumValue + delta;
    [slider setValue:value animated:NO];
    [self ratingSliderValueChanged:_ratingSlider];
}

#pragma mark - Location Action Group

-(IBAction)locationButtonTapped:(id)sender {
    [sender setEnabled:NO];
    [self addSubview:[[ksPickerView alloc]initForState:LOCATION withData:[[(ksViewController*) [[self window] rootViewController] ksCD] fetchedResultsController:KSCD_WHEREBYNAME]]];
}

-(IBAction)locationCenterMapButtonTapped:(id)sender {
    
}

#pragma mark - Description Action Group

-(IBAction)descriptionTextViewTapped:(id)sender {
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
