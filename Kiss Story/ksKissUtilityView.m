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
                [_ratingSlider setThumbImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
                [_ratingSlider setMinimumTrackImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
                [_ratingSlider setMaximumTrackImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];

                // dynamically adjust the size of the scolledContainer to fit it's contents... can't use autolayout becuase it frakked up the custom buttons in the buttons header...
                [[_scrollView.subviews objectAtIndex:0] setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f + 5.0f
                                                                            + _whoSection.frame.size.height + 5.0f
                                                                            + _whenSection.frame.size.height + 5.0f
                                                                            + _howSection.frame.size.height + 5.0f
                                                                            + _whereSection.frame.size.height + 5.0f
                                                                            + _whatSection.frame.size.height + 5.0f)];
                
                // needs must set the scrollView content to the frame of it's sole view
                _scrollView.contentSize = CGSizeMake([[_scrollView.subviews objectAtIndex:0]frame].size.width, [[_scrollView.subviews objectAtIndex:0]frame].size.height);
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

#pragma mark - Scroll Section Group

-(IBAction)whoButtonTapped:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0.0f, _whoSection.frame.origin.y - 5.0f) animated:YES];
}

-(IBAction)whenButtonTapped:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0.0f, _whenSection.frame.origin.y - 5.0f) animated:YES];
}

-(IBAction)whatButtonTapped:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0.0f, _whatSection.frame.origin.y - 5.0f) animated:YES];
}

-(IBAction)whereButtonTapped:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0.0f, _whereSection.frame.origin.y - 5.0f) animated:YES];
}

-(IBAction)howButtonTapped:(id)sender {
    [_scrollView setContentOffset:CGPointMake(0.0f, _howSection.frame.origin.y - 5.0f) animated:YES];
}

#pragma mark - UITextView Delegate

-(void)keyboardWillShowNotification:(NSNotification*)notification {
    NSLog(@"kWSN");
    
    /*
    CGSize kbSize = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    double animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGPoint newCenter = self.center;

    newCenter = CGPointMake(newCenter.x, (kbSize.height - self.frame.size.height/2)+125.0f);

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.center = newCenter;
    [UIView commitAnimations];
     */
}

-(void)keyboardWillHideNotification:(NSNotification*)notification {
    NSLog(@"kWHN");
    [_descTextView resignFirstResponder];
}


-(void)displayUtilityView {
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0.0f, 44.0f, 320.0f, 436.0f);
    }];
}

-(void)dismissUtilityView {
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0.0f, 480.0f, 320.0f, 436.0f);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
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
