//
//  ksKissUtilityView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/23/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ksKissUtilityView : UIView <UITextViewDelegate>

-(id)initForState:(int)whichState withData:(NSDictionary*)whichDictionary;
-(void)dismissUtilityView;

@property (atomic, retain) IBOutlet UIView* kisserHeader;
@property (atomic, retain) IBOutlet UILabel* kisserLabel;
@property (atomic, retain) IBOutlet UIButton* kisserButton;

@property (atomic, retain) IBOutlet UIView* dateHeader;
@property (atomic, retain) IBOutlet UILabel* dateLabel;
@property (atomic, retain) IBOutlet UIButton* dateButton;

@property (atomic, retain) IBOutlet UIView* ratingHeader;
@property (atomic, retain) IBOutlet UILabel* ratingLabel;
@property (atomic, retain) IBOutlet UISlider* ratingSlider;
@property (atomic, retain) IBOutlet UIImageView* ratingHeart1;
@property (atomic, retain) IBOutlet UIImageView* ratingHeart2;
@property (atomic, retain) IBOutlet UIImageView* ratingHeart3;
@property (atomic, retain) IBOutlet UIImageView* ratingHeart4;
@property (atomic, retain) IBOutlet UIImageView* ratingHeart5;

@property (atomic, retain) IBOutlet UIView* locationHeader;
@property (atomic, retain) IBOutlet UILabel* locationLabel;
@property (atomic, retain) IBOutlet UIButton* locationButton;
@property (atomic, retain) IBOutlet MKMapView* locationMapView;

@property (atomic, retain) IBOutlet UIView* descHeader;
@property (atomic, retain) IBOutlet UILabel* descLabel;
@property (atomic, retain) IBOutlet UITextView* descTextView;

@property (atomic, retain) NSDictionary* dataDictionary;
@property (atomic, readwrite) int state;

@property (atomic, retain) NSObject* kissWhoObject;
@property (atomic, readwrite) NSDate* kissDate;
@property (atomic, readwrite) int kissRating;
@property (atomic, retain) NSObject* kissWhereObject;
@property (atomic, retain) NSString* kissDescription;

@property (atomic, retain) IBOutlet UIButton* whoButton;
@property (atomic, retain) IBOutlet UIButton* whenButton;
@property (atomic, retain) IBOutlet UIButton* howButton;
@property (atomic, retain) IBOutlet UIButton* whereButton;
@property (atomic, retain) IBOutlet UIButton* whatButton;
@property (atomic, retain) IBOutlet UIScrollView* scrollView;

@property (atomic, retain) IBOutlet UIView* whoSection;
@property (atomic, retain) IBOutlet UIView* whenSection;
@property (atomic, retain) IBOutlet UIView* whatSection;
@property (atomic, retain) IBOutlet UIView* whereSection;
@property (atomic, retain) IBOutlet UIView* howSection;



@end
