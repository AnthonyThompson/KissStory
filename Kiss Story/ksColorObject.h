//
//  ksColorObject.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/18/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CCO_LIGHT 0
#define CCO_BASE 1

// because sometime sthe 7th element is a rainbow, sometimes a cream...
#define CCO_RAINBOW_COLOR 6
#define CCO_CREAM_COLOR 6
#define CCO_RED_COLOR 5
#define CCO_ORANGE_COLOR 4
#define CCO_YELLOW_COLOR 3
#define CCO_GREEN_COLOR 2
#define CCO_BLUE_COLOR 1
#define CCO_GREY_COLOR 0

#define CCO_KISSER 0
#define CCO_DATE 1
#define CCO_RATING 2
#define CCO_LOCATION 3
#define CCO_HEART 4
#define CCO_PIN 5

#define CCO_BASE_RED [UIColor colorWithRed:(231.0/255.0) green:(98.0/255.0) blue:(84.0/255.0) alpha:1.0f]
#define CCO_BASE_ORANGE [UIColor colorWithRed:(244.0/255.0) green:(159.0/255.0) blue:(91.0/255.0) alpha:1.0f]
#define CCO_BASE_YELLOW [UIColor colorWithRed:(244.0/255.0) green:(225.0/255.0) blue:(91.0/255.0) alpha:1.0f]
#define CCO_BASE_GREEN [UIColor colorWithRed:(87.0/255.0) green:(174.0/255.0) blue:(87.0/255.0) alpha:1.0f]
#define CCO_BASE_BLUE [UIColor colorWithRed:(112.0/255.0) green:(186.0/255.0) blue:(199.0/255.0) alpha:1.0f]
#define CCO_BASE_GREY [UIColor colorWithRed:(54.0/255.0) green:(47.0/255.0) blue:(45.0/255.0) alpha:1.0f]
#define CCO_BASE_CREAM [UIColor colorWithRed:(242.0/255.0) green:(238.0/255.0) blue:(227.0/255.0) alpha:1.0f]

#define CCO_LIGHT_RED [UIColor colorWithRed:(246.0/255.0) green:(204.0/255.0) blue:(193.0/255.0) alpha:1.0f]
#define CCO_LIGHT_ORANGE [UIColor colorWithRed:(250.0/255.0) green:(221.0/255.0) blue:(194.0/255.0) alpha:1.0f]
#define CCO_LIGHT_YELLOW [UIColor colorWithRed:(248.0/255.0) green:(241.0/255.0) blue:(196.0/255.0) alpha:1.0f]
#define CCO_LIGHT_GREEN [UIColor colorWithRed:(136.0/255.0) green:(181.0/255.0) blue:(153.0/255.0) alpha:0.33f]
#define CCO_LIGHT_BLUE [UIColor colorWithRed:(153.0/255.0) green:(193.0/255.0) blue:(199.0/255.0) alpha:0.33f]
#define CCO_LIGHT_GREY [UIColor colorWithRed:(200.0/255.0) green:(200.0/255.0) blue:(200.0/255.0) alpha:1.0f]
#define CCO_LIGHT_CREAM [UIColor colorWithRed:(242.0/255.0) green:(241.0/255.0) blue:(240.0/255.0) alpha:1.0f]

#define CCO_PERSON_RED [UIImage imageNamed:@"IconPersonRed.png"]
#define CCO_PERSON_ORANGE [UIImage imageNamed:@"IconPersonOrange.png"]
#define CCO_PERSON_YELLOW [UIImage imageNamed:@"IconPersonYellow.png"]
#define CCO_PERSON_GREEN [UIImage imageNamed:@"IconPersonGreen.png"]
#define CCO_PERSON_BLUE [UIImage imageNamed:@"IconPersonBlue.png"]
#define CCO_PERSON_GREY [UIImage imageNamed:@"IconPersonGrey.png"]
#define CCO_PERSON_CREAM [UIImage imageNamed:@"IconPersonCream.png"]

#define CCO_DATE_RED [UIImage imageNamed:@"IconDateRed.png"]
#define CCO_DATE_ORANGE [UIImage imageNamed:@"IconDateOrange.png"]
#define CCO_DATE_YELLOW [UIImage imageNamed:@"IconDateYellow.png"]
#define CCO_DATE_GREEN [UIImage imageNamed:@"IconDateGreen.png"]
#define CCO_DATE_BLUE [UIImage imageNamed:@"IconDateBlue.png"]
#define CCO_DATE_GREY [UIImage imageNamed:@"IconDateGrey.png"]
#define CCO_DATE_CREAM [UIImage imageNamed:@"IconDateCream.png"]

#define CCO_RATING_RED [UIImage imageNamed:@"IconHeartRed.png"]
#define CCO_RATING_ORANGE [UIImage imageNamed:@"IconHeartOrange.png"]
#define CCO_RATING_YELLOW [UIImage imageNamed:@"IconHeartYellow.png"]
#define CCO_RATING_GREEN [UIImage imageNamed:@"IconHeartGreen.png"]
#define CCO_RATING_BLUE [UIImage imageNamed:@"IconHeartBlue.png"]
#define CCO_RATING_GREY [UIImage imageNamed:@"IconHeartGrey.png"]
#define CCO_RATING_CREAM [UIImage imageNamed:@"IconHeartCream.png"]

#define CCO_LOCATION_RED [UIImage imageNamed:@"IconLocationRed.png"]
#define CCO_LOCATION_ORANGE [UIImage imageNamed:@"IconLocationOrange.png"]
#define CCO_LOCATION_YELLOW [UIImage imageNamed:@"IconLocationYellow.png"]
#define CCO_LOCATION_GREEN [UIImage imageNamed:@"IconLocationGreen.png"]
#define CCO_LOCATION_BLUE [UIImage imageNamed:@"IconLocationBlue.png"]
#define CCO_LOCATION_GREY [UIImage imageNamed:@"IconLocationGrey.png"]
#define CCO_LOCATION_CREAM [UIImage imageNamed:@"IconLocationCream.png"]

#define CCO_HEART_RED [UIImage imageNamed:@"IconHeartRedShadow.png"]
#define CCO_HEART_ORANGE [UIImage imageNamed:@"IconHeartOrangeShadow.png"]
#define CCO_HEART_YELLOW [UIImage imageNamed:@"IconHeartYellowShadow.png"]
#define CCO_HEART_GREEN [UIImage imageNamed:@"IconHeartGreenShadow.png"]
#define CCO_HEART_BLUE [UIImage imageNamed:@"IconHeartBlueShadow.png"]
#define CCO_HEART_GREY [UIImage imageNamed:@"IconHeartGreyShadow.png"]
#define CCO_HEART_CREAM [UIImage imageNamed:@"IconHeartCreamShadow.png"]

#define CCO_PIN_RED [UIImage imageNamed:@"PinRed.png"]
#define CCO_PIN_ORANGE [UIImage imageNamed:@"PinOrange.png"]
#define CCO_PIN_YELLOW [UIImage imageNamed:@"PinYellow.png"]
#define CCO_PIN_GREEN [UIImage imageNamed:@"PinGreen.png"]
#define CCO_PIN_BLUE [UIImage imageNamed:@"PinBlue.png"]
#define CCO_PIN_GREY [UIImage imageNamed:@"PinGrey.png"]
#define CCO_PIN_RAINBOW [UIImage imageNamed:@"PinRainbow.png"]

@interface ksColorObject : NSObject {
}

-(id)initCellWithColor:(int)whichColor withType:(int)whichType;
-(id)init;

+(NSArray*)colorArray;
+(NSArray*)imageArray;

@property (nonatomic, retain) UIColor* baseColor;
@property (nonatomic, retain) UIColor* lightColor;
@property (nonatomic, retain) UIImage* leftThumbnailImage;
@property (nonatomic, retain) UIImage* rightThumbnailImage;
@property (nonatomic, retain) UIImage* heartImage;
@property (nonatomic, retain) NSArray* imageArray;
@property (nonatomic, retain) NSArray* colorArray;
@property (nonatomic, readwrite) int color;
@property (nonatomic, readwrite) int type;

@end
