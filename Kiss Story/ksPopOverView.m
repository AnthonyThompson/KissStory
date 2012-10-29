//
//  ksPopOverView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/28/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksPopOverView.h"

@implementation ksPopOverView

@synthesize containerView = _containerView;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksPopOverView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        _resizableImageView.image = [[UIImage imageNamed:@"PopoverStretchCap.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(34, 19, 34, 19)];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(void)displayPopOverViewWithContent:(UIView*)containerView withBacking:(UIView*)backingView inSuperView:(UIView*)superView {

    if (!backingView) {
        backingView = [[[NSBundle mainBundle] loadNibNamed:@"ksPopOverView" owner:self options:nil] objectAtIndex:1];
    }

    containerView.frame = CGRectMake(10,10,containerView.frame.size.width,containerView.frame.size.height);
    [self addSubview:containerView];
    
    self.frame = CGRectMake(160.0f - (self.frame.size.width/2.0f),240.0f - (self.frame.size.height/2.0f),self.frame.size.width,self.frame.size.height);
    self.transform = CGAffineTransformScale(self.transform, 0.1f, 0.1f);

    [superView addSubview:backingView];
    [superView addSubview:self];

    [UIView animateWithDuration:0.33f animations:^{
        self.transform = CGAffineTransformScale(self.transform, 12.50f, 12.50f);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.15f animations:^{
            self.transform = CGAffineTransformScale(self.transform, 0.64f, 0.64f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15f animations:^{
                self.transform = CGAffineTransformScale(self.transform, 1.25f, 1.25f);
            }];
        }];
    }];
}

-(void)dismissPopOverViewInSuperView:(UIView*)superView {
    [UIView animateWithDuration:0.33f animations:^{
        self.transform = CGAffineTransformScale(self.transform, 0.01f, 0.01f);
    } completion:^(BOOL finished){
        [[[superView subviews] lastObject] removeFromSuperview];
        [[[superView subviews] lastObject] removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
