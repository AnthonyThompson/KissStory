//
//  ksColorObject.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/18/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksColorObject.h"

@implementation ksColorObject

//@synthesize baseColor;
//@synthesize lightColor;
@synthesize rightThumbnailImage;
@synthesize leftThumbnailImage;
//@synthesize heartImage;
//@synthesize type;
//@synthesize color;

-(id)init{
    if (self = [super init]) {
        _colorArray = [ksColorObject colorArray];
        _imageArray = [ksColorObject imageArray];
    }
    return self;
}

-(id)initCellWithColor:(int)whichColor withType:(int)whichType {
    if (self = [self init]) {
        _color = whichColor;
        _type = whichType;
        
        _lightColor = [[_colorArray objectAtIndex:_color] objectAtIndex:CCO_LIGHT];
        _baseColor = [[_colorArray objectAtIndex:_color] objectAtIndex:CCO_BASE];

        UIImage* leftImage = [[UIImage alloc]init];
        UIImage* rightImage = [[UIImage alloc]init];
        
        switch (whichType) {
            case CCO_KISSER: {
                // location, date
                leftImage = [[_imageArray objectAtIndex:whichColor] objectAtIndex:CCO_LOCATION];
                rightImage = [[_imageArray objectAtIndex:whichColor] objectAtIndex:CCO_DATE];
            }
                break;
            case CCO_DATE: {
                // person, location
                leftImage = [[_imageArray objectAtIndex:whichColor] objectAtIndex:CCO_KISSER];
                rightImage = [[_imageArray objectAtIndex:whichColor] objectAtIndex:CCO_LOCATION];
            }
                break;
            case CCO_RATING: {
                // date, location
                leftImage = [[_imageArray objectAtIndex:whichColor] objectAtIndex:CCO_DATE];
                rightImage = [[_imageArray objectAtIndex:whichColor] objectAtIndex:CCO_LOCATION];
            }
                break;
        }
        
        [self setLeftThumbnailImage:leftImage];
        [self setRightThumbnailImage:rightImage];
        _heartImage = [[_imageArray objectAtIndex:_color] objectAtIndex:CCO_HEART];
    }
    
    return self;
}

+(NSArray*)colorArray {
    return @[@[CCO_LIGHT_GREY,CCO_BASE_GREY],
    @[CCO_LIGHT_BLUE,CCO_BASE_BLUE],
    @[CCO_LIGHT_GREEN,CCO_BASE_GREEN],
    @[CCO_LIGHT_YELLOW,CCO_BASE_YELLOW],
    @[CCO_LIGHT_ORANGE,CCO_BASE_ORANGE],
    @[CCO_LIGHT_RED,CCO_BASE_RED],
    @[CCO_LIGHT_CREAM,CCO_BASE_CREAM]];
}

+(NSArray*)imageArray {
    return @[@[CCO_PERSON_GREY,CCO_DATE_GREY,CCO_RATING_GREY,CCO_LOCATION_GREY,CCO_HEART_GREY,CCO_PIN_GREY],
    @[CCO_PERSON_BLUE,CCO_DATE_BLUE,CCO_RATING_BLUE,CCO_LOCATION_BLUE,CCO_HEART_BLUE,CCO_PIN_BLUE],
    @[CCO_PERSON_GREEN,CCO_DATE_GREEN,CCO_RATING_GREEN,CCO_LOCATION_GREEN,CCO_HEART_GREEN,CCO_PIN_GREEN],
    @[CCO_PERSON_YELLOW,CCO_DATE_YELLOW,CCO_RATING_YELLOW,CCO_LOCATION_YELLOW,CCO_HEART_YELLOW,CCO_PIN_YELLOW],
    @[CCO_PERSON_ORANGE,CCO_DATE_ORANGE,CCO_RATING_ORANGE,CCO_LOCATION_ORANGE,CCO_HEART_ORANGE,CCO_PIN_ORANGE],
    @[CCO_PERSON_RED,CCO_DATE_RED,CCO_RATING_RED,CCO_LOCATION_RED,CCO_HEART_RED,CCO_PIN_RED],
    @[CCO_PERSON_CREAM,CCO_DATE_CREAM,CCO_RATING_CREAM,CCO_LOCATION_CREAM,CCO_HEART_CREAM,CCO_PIN_RAINBOW]];
}

@end
