//
//  ksCalloutView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 11/5/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksCalloutView.h"

@implementation ksCalloutView

- (id)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksCalloutView" owner:self options:nil] objectAtIndex:0];
        self.frame = CGRectOffset(self.frame, -(self.frame.size.width/2)+19.0f, -(self.frame.size.height)+39.0f);
        self.hidden = YES;
    }
    
    return self;
}

-(IBAction)safety:(id)sender {
    // doesn't do anything, gets called only after all the hit test stuff
}

@end
