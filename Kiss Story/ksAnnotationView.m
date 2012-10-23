//
//  ksAnnotationView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/22/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksAnnotationView.h"

@implementation ksAnnotationView

@synthesize headerView;
@synthesize moreButton;
@synthesize headerLabel;
@synthesize nameLabel;
@synthesize rightLabel;
@synthesize leftLabel;
@synthesize bodyLabel;
@synthesize leftThumb;
@synthesize rightThumb;
@synthesize nameThumb;
@synthesize photoThumb;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)moreButtonTapped:(id)sender {
    
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
