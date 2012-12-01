//
//  ksKissUtilityView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/23/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ksKissObject.h"
#import "ksPickerView.h"

#define KUV_TEXTFIELD 0
#define KUV_TEXTVIEW 1

@interface ksKissUtilityView : UIView <UITextViewDelegate>

-(id)initForState:(int)whichState withData:(NSDictionary*)whichDictionary;
-(BOOL)dismissUtilityViewWithSave:(BOOL)save;
-(void)displayUtilityView;
-(void)validateWhoWhere;
-(void)updateButton:(UIButton*)button withTitle:(NSString*)title;

@property (nonatomic, retain) NSDictionary* dataDictionary;
@property (nonatomic, readwrite) int state;
@property (nonatomic, retain) ksKissObject* kissObject;
//9901 IS THIS STILL THE CASE???
// need this because upthechain it is asked to dismiss itself
@property (nonatomic, retain) ksPickerView* pickerView;

// to validate topButton control
@property (nonatomic) BOOL validWho;
@property (nonatomic) BOOL validWhere;

// what is this for?
@property (nonatomic, readwrite) int textControl;

@property (nonatomic, retain) IBOutlet UISegmentedControl* segmentedControl;

@property (nonatomic, retain) IBOutlet UIImageView* kisserStatus;
@property (nonatomic, retain) IBOutlet UIImageView* dateStatus;
@property (nonatomic, retain) IBOutlet UIImageView* ratingStatus;
@property (nonatomic, retain) IBOutlet UIImageView* locationStatus;
@property (nonatomic, retain) IBOutlet UIImageView* descStatus;

@property (nonatomic, retain) IBOutlet UIButton* kisserButton;
@property (nonatomic, retain) IBOutlet UIButton* dateButton;
@property (nonatomic, retain) IBOutlet UISlider* ratingSlider;
@property (nonatomic, retain) IBOutlet UIImageView* ratingHeart1;
@property (nonatomic, retain) IBOutlet UIImageView* ratingHeart2;
@property (nonatomic, retain) IBOutlet UIImageView* ratingHeart3;
@property (nonatomic, retain) IBOutlet UIImageView* ratingHeart4;
@property (nonatomic, retain) IBOutlet UIImageView* ratingHeart5;
@property (nonatomic, retain) IBOutlet UIButton* locationButton;
@property (nonatomic, retain) IBOutlet UIButton* locationMapCenterButton;
@property (nonatomic, retain) IBOutlet MKMapView* locationMapView;
@property (nonatomic, retain) IBOutlet UITextView* descTextView;
@property (nonatomic, retain) IBOutlet UIButton* picButton;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIView* whoSection;
@property (nonatomic, retain) IBOutlet UIView* whenSection;
@property (nonatomic, retain) IBOutlet UIView* whatSection;
@property (nonatomic, retain) IBOutlet UIView* whereSection;
@property (nonatomic, retain) IBOutlet UIView* howSection;
@property (nonatomic, retain) IBOutlet UIView* whySection;

@end
