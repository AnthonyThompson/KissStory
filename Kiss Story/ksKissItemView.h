//
//  ksKissItemView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 11/9/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ksKissItemView : UIView

-(void)colorizeWithColor:(int)color forType:(int)type;
-(void)makeForTableView;

@property (nonatomic, retain) IBOutlet UIView* headerContainerView;
@property (nonatomic, retain) IBOutlet UILabel* headerLabel;
@property (nonatomic, retain) IBOutlet UIView* headerRatingView;

@property (nonatomic, retain) IBOutlet UIView* dataContainerView;
@property (nonatomic, retain) IBOutlet UIView* dataRatingView;
@property (nonatomic, retain) IBOutlet UIImageView* leftImage;
@property (nonatomic, retain) IBOutlet UILabel* leftLabel;
@property (nonatomic, retain) IBOutlet UIImageView* rightImage;
@property (nonatomic, retain) IBOutlet UILabel* rightLabel;

@property (nonatomic, retain) IBOutlet UIView* photoContainerView;
@property (nonatomic, retain) IBOutlet UIImageView* photoImage;

@property (nonatomic, retain) IBOutlet UIView* descContainerView;
@property (nonatomic, retain) IBOutlet UILabel* descLabel;

@property (nonatomic, retain) UIImage* heartImage;

@end
