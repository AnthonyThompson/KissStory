//
//  ksCalloutView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 11/5/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ksCalloutView : UIView

@property (nonatomic, retain) IBOutlet UILabel* locationLabel;
@property (nonatomic, retain) IBOutlet UIImageView* dateImage;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel;
@property (nonatomic, retain) IBOutlet UILabel* kisserLabel;
@property (nonatomic, retain) IBOutlet UIImageView* kisserImage;
@property (nonatomic, retain) IBOutlet UIView* ratingView;
@property (nonatomic, retain) IBOutlet UILabel* descLabel;
@property (nonatomic, retain) IBOutlet UIView* descLabelContainer;
@property (nonatomic, retain) IBOutlet UIImageView* pinImage;
@property (nonatomic, retain) IBOutlet UIImageView* frameImage;
@property (nonatomic, retain) IBOutlet UIImageView* photoImage;
@property (nonatomic, retain) IBOutlet UIButton* indexButton;

//color elements
@property (nonatomic, retain) IBOutlet UIImageView* headerView;
@property (nonatomic, retain) IBOutlet UIImage* heartImage;

@property (nonatomic, retain) IBOutlet UIView* photoContainer;
@property (nonatomic, retain) IBOutlet UIView* descContainer;


@end
