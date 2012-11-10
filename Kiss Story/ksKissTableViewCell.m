//
//  ksColorCell.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/12/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissTableViewCell.h"

@implementation ksKissTableViewCell


-(id)init {
    if (self = [super init]) {
        NSLog(@"!!!");
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:(CGRect)frame]) {
        NSLog(@"!!!");
    }
    return self;
}

-(void)awakeFromNib {
    NSLog(@"aFN kKTVC");
    /*
    NSLog(@"0 %@",[_content superview]);
    _content = [[[NSBundle mainBundle] loadNibNamed:@"ksKissItemView" owner:self options:nil] objectAtIndex:0];
    NSLog(@"1 %@",[_content superview]);
     */
}

@end
