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

- (id)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksKissItemView" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}


-(void)awakeFromNib {
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
    float imageHeight = 0.0f;
    //float textHeight = [[[[_cellSizeArray objectAtIndex:type]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] floatValue];
    float textHeight = [ksKissItemView calcTextSizeForKiss:kissRecord];
    //float labelWidth = ([[kissRecord valueForKey:@"image"]isEqualToData:KSCD_DUMMYIMAGE]) ? 300.0f : 218.0f;
    float labelWidth;

    _photoContainerView.hidden = NO;
    if ([[kissRecord valueForKey:@"image"] isEqualToData:KSCD_DUMMYIMAGE]) {
        //image does NOT exist
        _photoContainerView.hidden = YES;
        labelWidth = 300.0f;
    } else {
        // image exists
        _photoImage.image = [UIImage imageWithData:[kissRecord valueForKey:@"image"]];
        imageHeight += 82.0f;
        labelWidth = 218.0f;
    }
    
    _descContainerView.hidden = NO;
    if ([[kissRecord valueForKey:@"desc"] isEqualToString:@""]) {
        // text does NOT exist
        _descContainerView.hidden = YES;
    } else {
        // text exists
        _descLabel.text = [kissRecord valueForKey:@"desc"];
        
    }
    
    float heightDelta = imageHeight;
    heightDelta = (textHeight > heightDelta) ? textHeight : heightDelta;
    
    _descLabel.frame = CGRectMake(_descLabel.frame.origin.x,
                                  _descLabel.frame.origin.y,
                                  labelWidth,
                                  textHeight);
    
    _descContainerView.frame = CGRectMake(302.0f - labelWidth,
                                          _descContainerView.frame.origin.y,
                                          _descLabel.frame.size.width + 6.0f,
                                          _descLabel.frame.size.height + 6.0f);

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
        case LOCATION: {
            _headerLabel.text = [[kissRecord valueForKey:@"kissWhere"] valueForKey:@"name"];
            _leftLabel.text = [[kissRecord valueForKey:@"kissWho"] valueForKey:@"name"];
            _rightLabel.text = [[NSString alloc]initWithFormat:@"%@",[dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:[[kissRecord valueForKey:@"when"] doubleValue]]]];
        }
            break;
    }
}

+(float)calcTextSizeForKiss:(NSManagedObject*)kissRecord {
    float labelWidth = ([[kissRecord valueForKey:@"image"]isEqualToData:KSCD_DUMMYIMAGE]) ? 300.0f : 218.0f;
    return [[kissRecord valueForKey:@"desc"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail].height;
}

@end
