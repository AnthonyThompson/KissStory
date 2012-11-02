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

@interface ksKissUtilityView : UIView <UITextViewDelegate>

-(id)initForState:(int)whichState withData:(NSDictionary*)whichDictionary;
-(BOOL)dismissUtilityViewWithSave:(BOOL)save;
-(BOOL)dismissUtilityViewWithDelete;
-(void)displayUtilityView;

@property (nonatomic, retain) NSDictionary* dataDictionary;
@property (nonatomic, readwrite) int state;
@property (nonatomic, retain) ksKissObject* kissObject;
// need this because upthechain it is asked to dismiss itself
@property (nonatomic, retain) ksPickerView* pickerView;

@property (nonatomic, retain) IBOutlet UIView* kisserHeader;
@property (nonatomic, retain) IBOutlet UILabel* kisserLabel;
@property (nonatomic, retain) IBOutlet UIButton* kisserButton;

@property (nonatomic, retain) IBOutlet UIView* dateHeader;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel;
@property (nonatomic, retain) IBOutlet UIButton* dateButton;

@property (nonatomic, retain) IBOutlet UIView* ratingHeader;
@property (nonatomic, retain) IBOutlet UILabel* ratingLabel;
@property (nonatomic, retain) IBOutlet UISlider* ratingSlider;
@property (nonatomic, retain) IBOutlet UIImageView* ratingHeart1;
@property (nonatomic, retain) IBOutlet UIImageView* ratingHeart2;
@property (nonatomic, retain) IBOutlet UIImageView* ratingHeart3;
@property (nonatomic, retain) IBOutlet UIImageView* ratingHeart4;
@property (nonatomic, retain) IBOutlet UIImageView* ratingHeart5;

@property (nonatomic, retain) IBOutlet UIView* locationHeader;
@property (nonatomic, retain) IBOutlet UILabel* locationLabel;
@property (nonatomic, retain) IBOutlet UIButton* locationButton;
@property (nonatomic, retain) IBOutlet MKMapView* locationMapView;

@property (nonatomic, retain) IBOutlet UIView* descHeader;
@property (nonatomic, retain) IBOutlet UILabel* descLabel;
@property (nonatomic, retain) IBOutlet UITextView* descTextView;

@property (nonatomic, retain) IBOutlet UIButton* whoButton;
@property (nonatomic, retain) IBOutlet UIButton* whenButton;
@property (nonatomic, retain) IBOutlet UIButton* howButton;
@property (nonatomic, retain) IBOutlet UIButton* whereButton;
@property (nonatomic, retain) IBOutlet UIButton* whatButton;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIView* whoSection;
@property (nonatomic, retain) IBOutlet UIView* whenSection;
@property (nonatomic, retain) IBOutlet UIView* whatSection;
@property (nonatomic, retain) IBOutlet UIView* whereSection;
@property (nonatomic, retain) IBOutlet UIView* howSection;

@end
