//
//  ksKissItemView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 11/9/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissItemView.h"
#import "ksColorObject.h"

@implementation ksKissItemView

-(void)awakeFromNib {
}

-(void)makeForTableView {

    _dataContainerView.frame = CGRectMake(_dataContainerView.frame.origin.x,
                                          _dataContainerView.frame.origin.y,
                                          _dataContainerView.frame.size.width,
                                          _dataContainerView.frame.size.height - _dataRatingView.frame.size.height);
    
    _photoContainerView.frame = CGRectMake(_photoContainerView.frame.origin.x,
                                           _photoContainerView.frame.origin.y - _dataRatingView.frame.size.height,
                                           _photoContainerView.frame.size.width,
                                           _photoContainerView.frame.size.height);

    _descContainerView.frame = CGRectMake(_descContainerView.frame.origin.x,
                                           _descContainerView.frame.origin.y - _dataRatingView.frame.size.height,
                                           _descContainerView.frame.size.width,
                                           _descContainerView.frame.size.height);
    
    [_dataRatingView removeFromSuperview];
}

// need colorization code
-(void)colorizeWithColor:(int)color forType:(int)type {

    // layer attacks
    _headerContainerView.layer.borderColor = [[[[ksColorObject colorArray] objectAtIndex:color] objectAtIndex:CCO_BASE] CGColor];
    _headerContainerView.layer.borderWidth = 1.0f;
    
    _descContainerView.layer.borderColor = [[[[ksColorObject colorArray] objectAtIndex:color] objectAtIndex:CCO_BASE] CGColor];
    _descContainerView.layer.borderWidth = 1.0f;
    _descContainerView.layer.shadowColor = [[[[ksColorObject colorArray] objectAtIndex:color] objectAtIndex:CCO_LIGHT] CGColor];
    _descContainerView.layer.shadowOpacity = 1.0f;
    _descContainerView.layer.shadowRadius = 0.0f;
    _descContainerView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    
    _photoContainerView.layer.shadowColor = [[[[ksColorObject colorArray] objectAtIndex:color] objectAtIndex:CCO_LIGHT] CGColor];
    _photoContainerView.layer.shadowOpacity = 1.0f;
    _photoContainerView.layer.shadowRadius = 0.0f;
    _photoContainerView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);

    // color corrections
    self.backgroundColor = CCO_BASE_CREAM;
    
    _headerContainerView.backgroundColor = [[[ksColorObject colorArray] objectAtIndex:color] objectAtIndex:CCO_LIGHT];
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerRatingView.backgroundColor = [UIColor clearColor];

    _dataContainerView.backgroundColor = CCO_BASE_CREAM;
    _dataRatingView.backgroundColor = [UIColor clearColor];
    
    _leftImage.backgroundColor = [UIColor clearColor];
    _leftLabel.backgroundColor = [UIColor clearColor];
    _rightImage.backgroundColor = [UIColor clearColor];
    _rightLabel.backgroundColor = [UIColor clearColor];
    
    _photoContainerView.backgroundColor = [UIColor clearColor];

    // images
    for (UIView* subV in [_headerRatingView subviews]) {
        [subV removeFromSuperview];
    }
    
    _leftImage.image = [[[ksColorObject alloc]initDisplayWithColor:color withType:type] leftThumbnailImage];
    _rightImage.image = [[[ksColorObject alloc]initDisplayWithColor:color withType:type] rightThumbnailImage];
    
    _photoImage.image = nil;
    
    
    //content.dataRatingView.hidden = YES;
    //content.dataRatingView.frame = CGRectMake(content.dataRatingView.frame.origin.x, content.dataRatingView.frame.origin.x, 0, 0);
    /*
     content.dataContainerView.frame = CGRectMake(content.dataContainerView.frame.origin.x,
     content.dataContainerView.frame.origin.y,
     content.dataContainerView.frame.size.width,
     content.dataContainerView.frame.size.height - content.dataRatingView.frame.size.height);
     */



    //9901
    
    
    /*
        // these all need to be re-set before/after use/reuse
        _frameImage.image = [[UIImage imageNamed:@"FrameGeneric.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
     
     _headerContainerView.backgroundColor = [[[ksColorObject alloc]initDisplayWithColor:color withType:type] lightColor];
     
     
        
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
    */

}


@end
