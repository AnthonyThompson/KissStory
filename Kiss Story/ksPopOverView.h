//
//  ksPopOverView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/28/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ksPopOverView : UIView

-(void)displayPopOverViewWithContent:(UIView*)containerView inSuperView:(UIView*)superView;
-(void)dismissPopOverViewInSuperView:(UIView*)superView;

@property (nonatomic, retain) IBOutlet UIView* containerView;
@property (nonatomic, retain) IBOutlet UIImageView* resizableImageView;

@end
