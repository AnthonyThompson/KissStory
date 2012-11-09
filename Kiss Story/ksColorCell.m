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
    _frameImage.image = [[UIImage imageNamed:@"FrameGeneric.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
    
    _header.backgroundColor = [[[ksColorObject alloc]initDisplayWithColor:whichColor withType:whichType] lightColor];
    _leftThumbNail.image = [[[ksColorObject alloc]initDisplayWithColor:whichColor withType:whichType] leftThumbnailImage];
    _rightThumbNail.image = [[[ksColorObject alloc]initDisplayWithColor:whichColor withType:whichType] rightThumbnailImage];
    _heartImage.image = [[[ksColorObject alloc]initDisplayWithColor:whichColor withType:whichType] heartImage];
    
    _photoImage.image = nil;
    _descLabelContainer.hidden = NO;
    _photoImageContainer.hidden = NO;
    
    _descLabelContainer.frame = CGRectMake(83.0f, 70.0f, 218.0f, 24.0f);
    _descLabelContainer.layer.shadowColor = CCO_GREY_COLOR;
    _descLabelContainer.layer.shadowOpacity = 0.33f;
    _descLabelContainer.layer.shadowRadius = 0.0f;
    _descLabelContainer.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    _descLabelContainer.layer.borderColor = CCO_GREY_COLOR;
    _descLabelContainer.layer.borderWidth = 1.0f;

}

@end
