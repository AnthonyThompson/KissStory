//
//  ksKissUtilityView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/23/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissUtilityView.h"
#import "ksViewController.h"
#import "ksMapAnnotation.h"

@implementation ksKissUtilityView

@synthesize kissObject = _kissObject;
@synthesize locationMapView = _locationMapView;

#pragma mark - Inits

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksKissUtilityView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
    }
    
    return self;
}

-(id)initForState:(int)whichState withData:(NSDictionary*)whichDictionary {
    if ([self initWithFrame:CGRectMake(0.0f, 480.0f, 320.0f, 436.0f)]) {
        
        //generic all-cases inits
        _dataDictionary = [[NSDictionary alloc]initWithDictionary:whichDictionary];
        _kissObject = [[ksKissObject alloc]init];
        
        _state = whichState;
        
        [_ratingSlider setThumbImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
        [_ratingSlider setMinimumTrackImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
        [_ratingSlider setMaximumTrackImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
        
        _locationMapView.delegate = ROOT;
        _locationMapView.showsUserLocation = YES;
        [_locationMapView removeAnnotations:[_locationMapView annotations]];
        [_locationMapView addAnnotations:[ROOT annotationArray]];
        _locationMapView.region = MKCoordinateRegionMake([_locationMapView userLocation].coordinate, MKCoordinateSpanMake(0.0025f, 0.0025f));

        //state-specific inits & adjustments; custom data loading, &c.
        switch (_state) {
            case STATE_ADD: {
                [_ratingSlider addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ratingSliderTapped:)]];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
            }
                break;
            case STATE_EDIT: {
                
                _kisserStatus.image = [UIImage imageNamed:@"StatusKisserYes.png"];
                _dateStatus.image = [UIImage imageNamed:@"StatusDateYes.png"];
                _ratingStatus.image = [UIImage imageNamed:@"StatusRatingYes.png"];
                _locationStatus.image = [UIImage imageNamed:@"StatusLocationYes.png"];
                _descStatus.image = [UIImage imageNamed:@"StatusDescriptionYes.png"];
                
                [self prepareButton:_kisserButton withTitle:[[[_dataDictionary valueForKey:@"editKiss"] valueForKey:@"kissWho"] valueForKey:@"name"]];

                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

                [self prepareButton:_dateButton withTitle:[dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:[[[_dataDictionary valueForKey:@"editKiss"] valueForKey:@"when"] intValue]]]];
                
                _ratingSlider.value = [[[_dataDictionary valueForKey:@"editKiss"] valueForKey:@"score"] floatValue];
                [self ratingSliderValueChanged:_ratingSlider];
                _ratingSlider.enabled = NO;
                
                [self prepareButton:_locationButton withTitle:[[[_dataDictionary valueForKey:@"editKiss"] valueForKey:@"kissWhere"] valueForKey:@"name"]];

                [_locationMapView setCenterCoordinate:CLLocationCoordinate2DMake([[[[_dataDictionary valueForKey:@"editKiss"] valueForKey:@"kissWhere"] valueForKey:@"lat"] floatValue], [[[[_dataDictionary valueForKey:@"editKiss"] valueForKey:@"kissWhere"] valueForKey:@"lon"] floatValue]) animated:YES];
                _locationMapView.scrollEnabled = NO;
                _locationMapView.zoomEnabled = NO;
                _locationMapCenterButton.hidden = YES;
                
                //9901 convert text display to LABEL for stuff
                if (![[[_dataDictionary valueForKey:@"editKiss"] valueForKey:@"desc"] isEqualToString:@""]) {
                    [_descTextView setText:[[_dataDictionary valueForKey:@"editKiss"] valueForKey:@"desc"]];
                } else {
                    _whatSection.hidden = YES;
                    _whatSection.frame = CGRectMake(0, 0, 0, -10);
                }

                if ([[_dataDictionary valueForKey:@"editKiss"] valueForKey:@"image"]) {
                    [_picButton setImage:[UIImage imageWithData:[[_dataDictionary valueForKey:@"editKiss"] valueForKey:@"image"]] forState:UIControlStateNormal];
                } else {
                    _whySection.hidden = YES;
                    _whySection.frame = CGRectMake(0, 0, 0, -10);
                }
            }
                break;
        }
    }

    // dynamically adjust the size of the scolledContainer to fit it's contents... can't use autolayout becuase it frakked up the custom buttons in the buttons header...
    [[_scrollView.subviews objectAtIndex:0] setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.0f
                                                                + _whoSection.frame.size.height + 5.0f
                                                                + _whenSection.frame.size.height + 5.0f
                                                                + _howSection.frame.size.height + 5.0f
                                                                + _whereSection.frame.size.height + 5.0f
                                                                + _whatSection.frame.size.height + 5.0f
                                                                + _whySection.frame.size.height + 5.0f)];
    
    // needs must set the scrollView contentSize to the frame of it's view
    _scrollView.contentSize = CGSizeMake([[_scrollView.subviews objectAtIndex:0]frame].size.width, [[_scrollView.subviews objectAtIndex:0]frame].size.height);

    [self displayUtilityView];
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - GUI Control

-(void)prepareButton:(UIButton*)button withTitle:(NSString*)title {
    button.enabled = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:CCO_BASE_GREY forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
}

#pragma mark - Display/Dismiss Group

-(void)displayUtilityView {
    // a slide-up reveal, not a poop-over
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0.0f, 42.0f, 320.0f, 436.0f);
    }];
}

-(BOOL)dismissUtilityViewWithSave:(BOOL)save {
    // if you're NOT trying to save OR you you're trying to save and do, kill-window-routine
    // otherwise you're left at utility view
    if (!save || (save && [_kissObject saveKiss])) {
        // a slide-down dismiss, not a poop-out
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = CGRectMake(0.0f, 480.0f, 320.0f, 436.0f);
        } completion:^(BOOL finished){
            [self removeFromSuperview];
        }];
        return YES;
    }
    
    return NO;
}

#pragma mark - Segmented Control Group

-(IBAction)segmentedControlValueChanged:(id)sender {
    UIView* targetView;
    switch ([sender selectedSegmentIndex]) {
        case 0: {
            targetView = _whoSection;
        }
            break;
        case 1: {
            targetView = _whenSection;
        }
            break;
        case 2: {
            targetView = _howSection;
        }
            break;
        case 3: {
            targetView = _whereSection;
        }
            break;
        case 4: {
            targetView = _whatSection;
        }
            break;
        case 5: {
            targetView = _whySection;
        }
            break;
    }
    [_scrollView setContentOffset:CGPointMake(0.0f, targetView.frame.origin.y - 5.0f) animated:YES];
}

#pragma mark - Kisser Action Group

-(IBAction)kisserButtonTapped:(id)sender {
    _state = KISSER;
    [sender setBackgroundColor:CCO_BASE_GREY];
    _pickerView = [[ksPickerView alloc]initForState:KISSER withData:[[ROOT ksCD] fetchedResultsController:KSCD_WHOBYNAME]];
    [ROOT enableTopButtons:NO];
    [_pickerView displayPickerView];
}

#pragma mark - Date Action Group

-(IBAction)dateButtonTapped:(id)sender {
    [sender setBackgroundColor:CCO_BASE_GREY];
    _pickerView = [[ksPickerView alloc]initForState:DATE withData:[[ROOT ksCD] fetchedResultsController:DATE]];
    [ROOT enableTopButtons:NO];
    [_pickerView displayPickerView];
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
    _ratingStatus.image = [UIImage imageNamed:@"StatusRatingYes.png"];
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
    _state = LOCATION;

    [sender setBackgroundColor:CCO_BASE_GREY];
    // 9901 also for map touches somewhere else???
    
    // if it's not completely in view, slam to top
    //[_whereButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [_segmentedControl setSelectedSegmentIndex:3];
    _pickerView = [[ksPickerView alloc]initForState:LOCATION withData:[[ROOT ksCD] fetchedResultsController:KSCD_WHEREBYNAME]];
    
    [ROOT enableTopButtons:NO];
    [_pickerView displayPickerView];
}

-(IBAction)locationCenterMapButtonTapped:(id)sender {
    // if it's not completely in view, slam to top
    //[_whereButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [_segmentedControl setSelectedSegmentIndex:3];
    [_locationMapView setCenterCoordinate:[_locationMapView userLocation].coordinate animated:YES];
}

#pragma mark - UITextView Delegate

-(void)keyboardWillShowNotification:(NSNotification*)notification {
    // peg whatSection to top-of-view
    [_segmentedControl setSelectedSegmentIndex:4];
    //[_whatButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)keyboardWillHideNotification:(NSNotification*)notification {
    [_descTextView resignFirstResponder];
    // slap whatSection to bottom of view
    //9901 2x-check this vs. re-size???
    
    [_scrollView setContentOffset:CGPointMake(0.0f, _scrollView.frame.size.height - 122.0f) animated:YES];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
     //9901 is this a solid replacement?
     
    if([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        [_kissObject setKissDescription:textView.text];
        [_kissObject setValidDesc:YES];
        [_kissObject validityCheck];

        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
     
    // need the length delimiting?
    /*
    
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
    
    [_kissObject setKissDescription:textView.text];
    return YES;
     */
}

@end
