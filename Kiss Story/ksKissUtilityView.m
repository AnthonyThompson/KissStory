//
//  ksKissUtilityView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/23/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissUtilityView.h"
#import "ksViewController.h"
#import "ksAnnotationView.h"

@implementation ksKissUtilityView

#pragma mark - Inits

-(id)initForState:(int)whichState withData:(NSDictionary*)whichDictionary {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksKissUtilityView" owner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(0.0f, 480.0f, 320.0f, 436.0f);
        
        //generic all-cases inits
        self.dataDictionary = [[NSDictionary alloc]initWithDictionary:whichDictionary];
        self.kissObject = [[ksKissObject alloc]init];
        
        self.validWho = NO;
        self.validWhere = NO;
        
        self.state = whichState;
        self.textControl = KUV_TEXTVIEW;
        
        [self.ratingSlider setThumbImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
        [self.ratingSlider setMinimumTrackImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
        [self.ratingSlider setMaximumTrackImage:[UIImage imageNamed:@"Invisible1x1.png"] forState:UIControlStateNormal];
        
        self.locationMapView.delegate = ROOT;
        self.locationMapView.showsUserLocation = YES;
        [self.locationMapView removeAnnotations:[self.locationMapView annotations]];
        [self.locationMapView addAnnotations:[ROOT annotationArray]];
        self.locationMapView.region = MKCoordinateRegionMake([self.locationMapView userLocation].coordinate, MKCoordinateSpanMake(0.0025f, 0.0025f));

        //state-specific inits & adjustments; custom data loading, &c.
        switch (self.state) {
            case STATE_ADD: {
                [self.ratingSlider addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ratingSliderTapped:)]];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
            }
                break;
            case STATE_EDIT: {
                
                self.kisserStatus.image = [UIImage imageNamed:@"StatusKisserYes.png"];
                self.dateStatus.image = [UIImage imageNamed:@"StatusDateYes.png"];
                self.ratingStatus.image = [UIImage imageNamed:@"StatusRatingYes.png"];
                self.locationStatus.image = [UIImage imageNamed:@"StatusLocationYes.png"];
                self.descStatus.image = [UIImage imageNamed:@"StatusDescriptionYes.png"];
                
                [self prepareButtonForEdit:self.kisserButton withTitle:[[[self.dataDictionary valueForKey:@"editKiss"] valueForKey:@"kissWho"] valueForKey:@"name"]];

                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

                [self prepareButtonForEdit:self.dateButton withTitle:[dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:[[[self.dataDictionary valueForKey:@"editKiss"] valueForKey:@"when"] intValue]]]];
                
                self.ratingSlider.value = [[[self.dataDictionary valueForKey:@"editKiss"] valueForKey:@"score"] floatValue];
                [self ratingSliderValueChanged:self.ratingSlider];
                self.ratingSlider.enabled = NO;
                
                [self prepareButtonForEdit:self.locationButton withTitle:[[[self.dataDictionary valueForKey:@"editKiss"] valueForKey:@"kissWhere"] valueForKey:@"name"]];

                [self.locationMapView setCenterCoordinate:CLLocationCoordinate2DMake([[[[self.dataDictionary valueForKey:@"editKiss"] valueForKey:@"kissWhere"] valueForKey:@"lat"] floatValue], [[[[self.dataDictionary valueForKey:@"editKiss"] valueForKey:@"kissWhere"] valueForKey:@"lon"] floatValue]) animated:YES];
                self.locationMapView.scrollEnabled = NO;
                self.locationMapView.zoomEnabled = NO;
                self.locationMapCenterButton.hidden = YES;
                
                if (![[[self.dataDictionary valueForKey:@"editKiss"] valueForKey:@"desc"] isEqualToString:@""]) {
                    [self.descTextView setText:[[self.dataDictionary valueForKey:@"editKiss"] valueForKey:@"desc"]];
                } else {
                    self.whatSection.hidden = YES;
                    self.whatSection.frame = CGRectMake(0, 0, 0, 0);
                }

                if (![[[self.dataDictionary valueForKey:@"editKiss"] valueForKey:@"image"] isEqualToData:KSCD_DUMMYIMAGE]) {
                    [self.picButton setImage:[UIImage imageWithData:[[self.dataDictionary valueForKey:@"editKiss"] valueForKey:@"image"]] forState:UIControlStateNormal];
                } else {
                    self.whySection.hidden = YES;
                    self.whySection.frame = CGRectMake(0, 0, 0, 0);
                }
            }
                break;
        }
    }

    // dynamically adjust the size of the scolledContainer to fit it's contents... can't use autolayout becuase it frakked up the custom buttons in the buttons header...
    [[self.scrollView.subviews objectAtIndex:0] setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.0f
                                                                + self.whoSection.frame.size.height + 5.0f
                                                                + self.whenSection.frame.size.height + 5.0f
                                                                + self.howSection.frame.size.height + 5.0f
                                                                + self.whereSection.frame.size.height + 5.0f
                                                                + self.whatSection.frame.size.height + 5.0f
                                                                + self.whySection.frame.size.height + 5.0f)];
    
    // needs must set the scrollView contentSize to the frame of it's view
    self.scrollView.contentSize = CGSizeMake([[self.scrollView.subviews objectAtIndex:0]frame].size.width, [[self.scrollView.subviews objectAtIndex:0]frame].size.height);

    [self displayUtilityView];
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - GUI Control

-(void)updateButton:(UIButton*)button withTitle:(NSString*)title {
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:CCO_BASE_GREY forState:UIControlStateNormal];
    [button setBackgroundColor:CCO_BASE_CREAM];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
}

-(void)prepareButtonForEdit:(UIButton*)button withTitle:(NSString*)title {
    //9901 is this needed?  Can't these be defaults or something?
    button.enabled = NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:CCO_BASE_GREY forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
}

-(void)updateMap:(NSDictionary*)whereDictionary {
    if ([whereDictionary valueForKey:@"where"]) {
        // a new location, extract lat/lon
        float lat = [[[whereDictionary objectForKey:@"where"] valueForKey:@"lat"] floatValue];
        float lon = [[[whereDictionary objectForKey:@"where"] valueForKey:@"lon"] floatValue];
        [_locationMapView setCenterCoordinate:CLLocationCoordinate2DMake(lat, lon) animated:YES];
    }
}

#pragma mark - Display/Dismiss Group

-(void)displayUtilityView {
    // a slide-up reveal, not a poop-over
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0.0f, 42.0f, 320.0f, 436.0f);
    }];
}

-(BOOL)dismissUtilityViewWithSave:(BOOL)save {
    // if you're NOT trying to save OR you're trying to save and do, kill-window-routine
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
    _textControl = KUV_TEXTFIELD;
    
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
    _textControl = KUV_TEXTFIELD;

    [sender setBackgroundColor:CCO_BASE_GREY];
    // 9901 also for map touches somewhere else???
    
    // if it's not completely in view, slam to top
    [_segmentedControl setSelectedSegmentIndex:3];
    _pickerView = [[ksPickerView alloc]initForState:LOCATION withData:[[ROOT ksCD] fetchedResultsController:KSCD_WHEREBYNAME]];
    
    [ROOT enableTopButtons:NO];
    [_pickerView displayPickerView];
}

-(IBAction)locationCenterMapButtonTapped:(id)sender {
    // if it's not completely in view, slam to top
    [_segmentedControl setSelectedSegmentIndex:3];
    [_locationMapView setCenterCoordinate:[_locationMapView userLocation].coordinate animated:YES];
}

#pragma mark - Picture Action Group

-(IBAction)takePicture:(id) sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    //9901
    //poopOver for camera/roll?
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:ROOT];
    [ROOT presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UITextView Delegate

-(void)keyboardWillShowNotification:(NSNotification*)notification {
    // discriminate between textview && textfield
    if (_textControl == KUV_TEXTVIEW) {
        [_segmentedControl setSelectedSegmentIndex:4];
        [self segmentedControlValueChanged:_segmentedControl];
    }
}

-(void)keyboardWillHideNotification:(NSNotification*)notification {
    [_descTextView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [_kissObject setKissDescription:textView.text];
        //9901 check length of descText here; if < 1 then NO.png
        [_descStatus setImage:[UIImage imageNamed:@"StatusDescriptionYes.png"]];

        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

#pragma mark - Data Control

-(void)validateWhoWhere {
    if (_validWho) {
        [_kisserStatus setImage:[UIImage imageNamed:@"StatusKisserYes.png"]];
    }
    
    if (_validWhere) {
        [_locationStatus setImage:[UIImage imageNamed:@"StatusLocationYes.png"]];
    }
    
    if (_validWho && _validWhere) {
        [[ROOT topRightButton] setHidden:NO];
    }
}

@end
