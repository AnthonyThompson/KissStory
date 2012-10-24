//
//  ksKissUtilityView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/23/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissUtilityView.h"
#import "ksViewController.h"

@implementation ksKissUtilityView

- (id)initWithFrame:(CGRect)frame {
    NSLog(@"initWithFrame");
    if (self = [super initWithFrame:frame]) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ksKissUtilityView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.frame = frame;
    }
    
    return self;
}

-(id)initForState:(int)whichState withData:(NSDictionary*)whichDictionary {
    NSLog(@"initForState");
    if ([self initWithFrame:CGRectMake(0.0f, 480.0f, 320.0f, 527.0f)]) {
        dataDictionary = [[NSDictionary alloc]initWithDictionary:whichDictionary];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
