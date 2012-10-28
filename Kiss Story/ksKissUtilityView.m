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

@synthesize kissObject = _kissObject;
@synthesize locationMapView = _locationMapView;

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
        
        //generic all-cases inits
        _dataDictionary = [[NSDictionary alloc]initWithDictionary:whichDictionary];
        _kissObject = [[ksKissObject alloc] init];
        _state = whichState;
        
        [_ratingSlider addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ratingSliderTapped:)]];
        [_ratingSlider setThumbImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
        [_ratingSlider setMinimumTrackImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
        [_ratingSlider setMaximumTrackImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
        
        _locationMapView.showsUserLocation = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        
        // dynamically adjust the size of the scolledContainer to fit it's contents... can't use autolayout becuase it frakked up the custom buttons in the buttons header...
        [[_scrollView.subviews objectAtIndex:0] setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f + 5.0f
                                                                    + _whoSection.frame.size.height + 5.0f
                                                                    + _whenSection.frame.size.height + 5.0f
                                                                    + _howSection.frame.size.height + 5.0f
                                                                    + _whereSection.frame.size.height + 5.0f
                                                                    + _whatSection.frame.size.height + 5.0f)];
        
        // needs must set the scrollView contentSize to the frame of it's view
        _scrollView.contentSize = CGSizeMake([[_scrollView.subviews objectAtIndex:0]frame].size.width, [[_scrollView.subviews objectAtIndex:0]frame].size.height);

        //9901
        //state-specific inits & adjustments; custom data loading, &c.
        switch (_state) {
            case STATE_ADD: {
            }
        }
    }
    
    [self displayUtilityView];
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Kisser Action Group

-(IBAction)kisserButtonTapped:(id)sender {
    [sender setBackgroundColor:CCO_BASE_GREY];
    [sender setEnabled:NO];
    [self addSubview:[[ksPickerView alloc]initForState:KISSER withData:[[(ksViewController*) [[self window] rootViewController] ksCD] fetchedResultsController:KSCD_WHOBYNAME]]];
}

#pragma mark - Date Action Group

-(IBAction)dateButtonTapped:(id)sender {
    [sender setBackgroundColor:CCO_BASE_GREY];
    [sender setEnabled:NO];
    [self addSubview:[[ksPickerView alloc]initForState:DATE withData:[[(ksViewController*) [[self window] rootViewController] ksCD] fetchedResultsController:DATE]]];
}

#pragma mark - Rating Action Group

-(void)ratingSliderTapped:(UITapGestureRecognizer*)sender {
    UISlider* slider = (UISlider*)sender.view;
    CGFloat percent = [sender locationInView:slider].x/slider.bounds.size.width;
    CGFloat delta = percent*(slider.maximumValue - slider.minimumValue);
    CGFloat value = slider.minimumValue + delta;
    [slider setValue:value animated:NO];
    [self ratingSliderValueChanged:_ratingSlider];
}

-(IBAction)ratingSliderValueChanged:(id)sender {
    if (_ratingSlider.value < 0.5f) {
        _ratingHeart1.image = CCO_HEART_GREY;
        _ratingHeart2.image = CCO_HEART_GREY;
        _ratingHeart3.image = CCO_HEART_GREY;
        _ratingHeart4.image = CCO_HEART_GREY;
        _ratingHeart5.image = CCO_HEART_GREY;
        _kissObject.kissRating = 0;
    } else if (_ratingSlider.value < 1.5f) {
        _ratingHeart1.image = CCO_HEART_BLUE;
        _ratingHeart2.image = CCO_HEART_GREY;
        _ratingHeart3.image = CCO_HEART_GREY;
        _ratingHeart4.image = CCO_HEART_GREY;
        _ratingHeart5.image = CCO_HEART_GREY;
        _kissObject.kissRating = 1;
    } else if (_ratingSlider.value < 2.5f) {
        _ratingHeart1.image = CCO_HEART_BLUE;
        _ratingHeart2.image = CCO_HEART_GREEN;
        _ratingHeart3.image = CCO_HEART_GREY;
        _ratingHeart4.image = CCO_HEART_GREY;
        _ratingHeart5.image = CCO_HEART_GREY;
        _kissObject.kissRating = 2;
    } else if (_ratingSlider.value < 3.5f) {
        _ratingHeart1.image = CCO_HEART_BLUE;
        _ratingHeart2.image = CCO_HEART_GREEN;
        _ratingHeart3.image = CCO_HEART_YELLOW;
        _ratingHeart4.image = CCO_HEART_GREY;
        _ratingHeart5.image = CCO_HEART_GREY;
        _kissObject.kissRating = 3;
    } else if (_ratingSlider.value < 4.5f) {
        _ratingHeart1.image = CCO_HEART_BLUE;
        _ratingHeart2.image = CCO_HEART_GREEN;
        _ratingHeart3.image = CCO_HEART_YELLOW;
        _ratingHeart4.image = CCO_HEART_ORANGE;
        _ratingHeart5.image = CCO_HEART_GREY;
        _kissObject.kissRating = 4;
    } else {
        _ratingHeart1.image = CCO_HEART_BLUE;
        _ratingHeart2.image = CCO_HEART_GREEN;
        _ratingHeart3.image = CCO_HEART_YELLOW;
        _ratingHeart4.image = CCO_HEART_ORANGE;
        _ratingHeart5.image = CCO_HEART_RED;
        _kissObject.kissRating = 5;
    }
}

#pragma mark - Location Action Group

-(IBAction)locationButtonTapped:(id)sender {
    [sender setBackgroundColor:CCO_BASE_GREY];
    [sender setEnabled:NO];
    // 9901 also for map touches somewhere else???
    
    // if it's not completely in view, slam to top
    [_whereButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self addSubview:[[ksPickerView alloc]initForState:LOCATION withData:[[(ksViewController*) [[self window] rootViewController] ksCD] fetchedResultsController:KSCD_WHEREBYNAME]]];
}

-(IBAction)locationCenterMapButtonTapped:(id)sender {
    [_locationMapView setCenterCoordinate:[_locationMapView userLocation].coordinate animated:YES];
}

#pragma mark - Scroll Section Group

-(IBAction)whoButtonTapped:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0.0f, _whoSection.frame.origin.y - 5.0f) animated:YES];
}

-(IBAction)whenButtonTapped:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0.0f, _whenSection.frame.origin.y - 5.0f) animated:YES];
}

-(IBAction)howButtonTapped:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0.0f, _howSection.frame.origin.y - 5.0f) animated:YES];
}

-(IBAction)whereButtonTapped:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0.0f, _whereSection.frame.origin.y - 5.0f) animated:YES];
}

-(IBAction)whatButtonTapped:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0.0f, _whatSection.frame.origin.y - 5.0f) animated:YES];
}

#pragma mark - UITextView Delegate

-(void)keyboardWillShowNotification:(NSNotification*)notification {
    // peg whatSection to top-of-view
    [_whatButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)keyboardWillHideNotification:(NSNotification*)notification {
    [_descTextView resignFirstResponder];
    // slap whatSection to bottom of view
    [_scrollView setContentOffset:CGPointMake(0.0f, _scrollView.frame.size.height - 122.0f) animated:YES];
}

-(void)displayUtilityView {
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0.0f, 44.0f, 320.0f, 436.0f);
    }];
}

-(BOOL)dismissUtilityViewWithSave:(BOOL)save {
    // kissObject validates save and returns BOOL
    // (also screen control, activity indicator, messaging, &c)
    // sets superview state to REFRESH I guess, to reload tables?
    // YES then animate && remove
    // NO do nothing
    
    // if you're NOT trying to save OR you you're trying to save and do, kill-window-routine
    // otherwise you're left at utility view
    if (!save || (save && [_kissObject saveKiss])) {
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = CGRectMake(0.0f, 480.0f, 320.0f, 436.0f);
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
        return YES;
    }
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    /*
     //9901 is this a solid replacement?
     
    if([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
     
     */
    
    // need the length delimiting?
    
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
