//
//  ksCalloutView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 11/5/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ksKissItemView.h"

@interface ksCalloutView : UIView

@property (nonatomic, retain) IBOutlet UIImageView* pinImage;
@property (nonatomic, retain) IBOutlet UIButton* indexButton;
@property (nonatomic, retain) IBOutlet UIImageView* containerFrameImage;

@property (nonatomic, retain) IBOutlet ksKissItemView* container;


@end
