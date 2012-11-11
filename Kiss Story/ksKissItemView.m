//
//  ksKissItemView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 11/9/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksViewController.h"
#import "ksKissItemView.h"
#import "ksColorObject.h"
#import "ksCoreData.h"

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

-(void)colorizeWithData:(NSManagedObject*)kissRecord forType:(int)type {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;

    // layer attacks
    _headerContainerView.layer.borderColor = [[[[ksColorObject colorArray] objectAtIndex:[[kissRecord valueForKey:@"score"] intValue]] objectAtIndex:CCO_BASE] CGColor];
    _headerContainerView.layer.borderWidth = 1.0f;
    
    _descContainerView.layer.borderColor = [[[[ksColorObject colorArray] objectAtIndex:[[kissRecord valueForKey:@"score"] intValue]] objectAtIndex:CCO_BASE] CGColor];
    _descContainerView.layer.borderWidth = 1.0f;
    _descContainerView.layer.shadowColor = [[[[ksColorObject colorArray] objectAtIndex:[[kissRecord valueForKey:@"score"] intValue]] objectAtIndex:CCO_LIGHT] CGColor];
    _descContainerView.layer.shadowOpacity = 0.75f;
    _descContainerView.layer.shadowRadius = 0.0f;
    _descContainerView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    
    _photoContainerView.layer.shadowColor = [[[[ksColorObject colorArray] objectAtIndex:[[kissRecord valueForKey:@"score"] intValue]] objectAtIndex:CCO_LIGHT] CGColor];
    _photoContainerView.layer.shadowOpacity = 0.75f;
    _photoContainerView.layer.shadowRadius = 0.0f;
    _photoContainerView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    
    self.layer.shadowColor = [[[[ksColorObject colorArray] objectAtIndex:[[kissRecord valueForKey:@"score"] intValue]] objectAtIndex:CCO_LIGHT] CGColor];
    self.layer.shadowOpacity = 0.75f;
    self.layer.shadowRadius = 0.0f;
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);

    // color corrections
    self.backgroundColor = CCO_BASE_CREAM;
    
    _headerContainerView.backgroundColor = [[[ksColorObject colorArray] objectAtIndex:[[kissRecord valueForKey:@"score"] intValue]] objectAtIndex:CCO_LIGHT];
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerRatingView.backgroundColor = [UIColor clearColor];

    _dataContainerView.backgroundColor = CCO_BASE_CREAM;
    _dataRatingView.backgroundColor = [UIColor clearColor];
    
    _leftImage.backgroundColor = [UIColor clearColor];
    _leftLabel.backgroundColor = [UIColor clearColor];
    _rightImage.backgroundColor = [UIColor clearColor];
    _rightLabel.backgroundColor = [UIColor clearColor];
    
    _photoContainerView.backgroundColor = [UIColor clearColor];
    
    _descLabel.backgroundColor = [UIColor clearColor];

    // images
    for (UIView* subV in [_headerRatingView subviews]) {
        [subV removeFromSuperview];
    }
    
    for (int i = 0; i< [[kissRecord valueForKey:@"score"] intValue]; i++){
        // add hearts
        [_headerRatingView addSubview:[[UIImageView alloc]initWithFrame:CGRectMake(108.0f - (i * 26.0f), 1.0f, 26.0f, 26.0f)]];
        [[[_headerRatingView subviews] lastObject] setImage:[[[ksColorObject imageArray] objectAtIndex:[[kissRecord valueForKey:@"score"] intValue]]objectAtIndex:4]];
        
        // shorten label to accomodate hearts
        _headerLabel.frame = CGRectMake(_headerLabel.frame.origin.x,
                                        _headerLabel.frame.origin.y,
                                        _headerLabel.frame.size.width - 26.0f,
                                        _headerLabel.frame.size.height);
    }

    _leftImage.image = [[[ksColorObject alloc]initDisplayWithColor:[[kissRecord valueForKey:@"score"] intValue] withType:type] leftThumbnailImage];
    _rightImage.image = [[[ksColorObject alloc]initDisplayWithColor:[[kissRecord valueForKey:@"score"] intValue] withType:type] rightThumbnailImage];
    
    _photoImage.image = nil;
    
    // widget and content control
    _photoContainerView.hidden = NO;
    if ([[kissRecord valueForKey:@"image"] isEqualToData:KSCD_DUMMYIMAGE]) {
        //image does NOT exist
        _photoContainerView.hidden = YES;
    } else {
        // image exists
        _photoImage.image = [UIImage imageWithData:[kissRecord valueForKey:@"image"]];
    }
    
    _descContainerView.hidden = NO;
    if ([[kissRecord valueForKey:@"desc"] isEqualToString:@""]) {
        // text does NOT exist
        _descContainerView.hidden = YES;
    } else {
        // text exists
        _descLabel.text = [kissRecord valueForKey:@"desc"];
    }
    
    switch (type) {
        case KISSER: {
            _headerLabel.text = [[kissRecord valueForKey:@"kissWho"] valueForKey:@"name"];
            _leftLabel.text = [[kissRecord valueForKey:@"kissWhere"] valueForKey:@"name"];
            _rightLabel.text = [[NSString alloc]initWithFormat:@"%@",[dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:[[kissRecord valueForKey:@"when"] doubleValue]]]];
        }
            break;
        case DATE: {
            _headerLabel.text = [[NSString alloc]initWithFormat:@"%@",[dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:[[kissRecord valueForKey:@"when"] doubleValue]]]];
            _leftLabel.text = [[kissRecord valueForKey:@"kissWho"] valueForKey:@"name"];
            _rightLabel.text = [[kissRecord valueForKey:@"kissWhere"] valueForKey:@"name"];
            
        }
            break;
        case RATING: {
            _headerLabel.text = [[kissRecord valueForKey:@"kissWho"] valueForKey:@"name"];
            _leftLabel.text = [[NSString alloc]initWithFormat:@"%@",[dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:[[kissRecord valueForKey:@"when"] doubleValue]]]];
            _rightLabel.text = [[kissRecord valueForKey:@"kissWhere"] valueForKey:@"name"];
        }
            break;
    }
}


@end
