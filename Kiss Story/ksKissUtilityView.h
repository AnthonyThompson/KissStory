//
//  ksKissUtilityView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/23/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ksKissUtilityView : UIView {
    NSDictionary* dataDictionary;
}

-(id)initForState:(int)whichState withData:(NSDictionary*)whichDictionary;

@property (atomic, retain) IBOutlet UIView* kisserHeader;
@property (atomic, retain) IBOutlet UILabel* kisserLabel;
@property (atomic, retain) IBOutlet UITextField* kisserText;

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
@property (atomic, retain) IBOutlet UILabel* locationNameLabel;
@property (atomic, retain) IBOutlet MKMapView* locationMapView;

@property (atomic, retain) IBOutlet UIView* descHeader;
@property (atomic, retain) IBOutlet UILabel* descLabel;
@property (atomic, retain) IBOutlet UITextField* descText;

@property (atomic, retain) IBOutlet ksKissUtilityView* toplevelSubView;

@end
