//
//  ksCalloutView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 11/5/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ksCalloutView : UIView

@property (nonatomic, retain) IBOutlet UILabel* whereLabel;
@property (nonatomic, retain) IBOutlet UIButton* moreButton;

@property (nonatomic, retain) IBOutlet UIImageView* whoThumb;
@property (nonatomic, retain) IBOutlet UILabel* whoLabel;

@property (nonatomic, retain) IBOutlet UIImageView* ratingImage;

@property (nonatomic, retain) IBOutlet UILabel* descLabel;

@property (nonatomic, retain) IBOutlet UIImageView* pinImage;

@property (nonatomic, retain) IBOutlet UIImageView* photoThumb;

@property (nonatomic, retain) IBOutlet UIImageView* whenThumb;
@property (nonatomic, retain) IBOutlet UILabel* whenLabel;

@property (nonatomic, retain) IBOutlet UIView* headerView;

@end
