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

    // these all need to be re-set before/after use/reuse
    _frameImage.image = [[UIImage imageNamed:@"Frame.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
    
    _header.backgroundColor = [[[ksColorObject alloc]initCellWithColor:whichColor withType:whichType] lightColor];
    _leftThumbNail.image = [[[ksColorObject alloc]initCellWithColor:whichColor withType:whichType] leftThumbnailImage];
    _rightThumbNail.image = [[[ksColorObject alloc]initCellWithColor:whichColor withType:whichType] rightThumbnailImage];
    _heartImage.image = [[[ksColorObject alloc]initCellWithColor:whichColor withType:whichType] heartImage];
    
    _photoImage.image = nil;
    _bodyLabelContainer.hidden = NO;
    _photoImageContainer.hidden = NO;
    
    //_bodyLabel.frame = CGRectMake(4.0f, 1.0f, 210.0f, 20.0f);
    _bodyLabelContainer.frame = CGRectMake(83.0f, 70.0f, 218.0f, 24.0f);

    //self.frame = CGRectMake(0.0f, 0.0f, 320.0f, 173.0f);
    //_container.frame = CGRectMake(3.0f, 3.0f, 314.0f, 167.0f);

    /*
    _frameImage.frame = CGRectMake(0.0f, 0.0f, 314.0f, 167.0f);
    _inliner.frame = CGRectMake(6.0f, 6.0f, 300.0f, 151.0f);
    _headerContainer.frame = CGRectMake(1.0f, 1.0f, 299.0f, 67.0f);
    _shadow.frame = CGRectMake(2.0f, 2.0f, 213.0f, 24.0f);
     */
}

@end
