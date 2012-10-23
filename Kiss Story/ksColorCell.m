//
//  ksColorCell.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/12/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksColorCell.h"

@implementation ksColorCell

-(id)init {
    self = [super init];
    if (self) {
        _heartImage = [[UIImageView alloc]init];
    }
    return self;
}

-(void)colorizeCellWithColor:(int)whichColor withType:(int)whichType {

    for (UIView* subV in [_header subviews]) {
        [subV removeFromSuperview];
    }

    _header.backgroundColor = [[[ksColorObject alloc]initCellWithColor:whichColor withType:whichType] lightColor];
    _leftThumbNail.image = [[[ksColorObject alloc]initCellWithColor:whichColor withType:whichType] leftThumbnailImage];
    _rightThumbNail.image = [[[ksColorObject alloc]initCellWithColor:whichColor withType:whichType] rightThumbnailImage];
    _heartImage.image = [[[ksColorObject alloc]initCellWithColor:whichColor withType:whichType] heartImage];
}

@end
