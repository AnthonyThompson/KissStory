//
//  ksKissUtilityView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/23/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissUtilityView.h"
#import "ksViewController.h"
#import "ksPickerView.h"

@implementation ksKissUtilityView

@synthesize kissWhoObject = _kissWhoObject;
@synthesize kissDate = _kissDate;
@synthesize kissRating = _kissRating;
@synthesize kissWhereObject = _kissWhereObject;
@synthesize kissDescription = _kissDescription;

#pragma mark - Inits

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ksKissUtilityView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.frame = frame;
    }
    
    return self;
}

-(id)initForState:(int)whichState withData:(NSDictionary*)whichDictionary {
    if ([self initWithFrame:CGRectMake(0.0f, 480.0f, 320.0f, 436.0f)]) {
        _dataDictionary = [[NSDictionary alloc]initWithDictionary:whichDictionary];
        _state = whichState;
        
        switch (_state) {
            case STATE_ADD: {
                _kissWhoObject = [[NSObject alloc]init];
                _kissDate = 0.0f;
                _kissRating = 0;
                _kissWhereObject = [[NSObject alloc]init];
                _kissDescription = [[NSString alloc]init];
            }
        }
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Kisser Action Group

-(IBAction)kisserButtonTapped:(id)sender {
    [self addSubview:[[ksPickerView alloc]initForState:KISSER withData:[[(ksViewController*) [[self window] rootViewController] ksCD] fetchedResultsController:0]]];
}

#pragma mark - Date Action Group

-(IBAction)dateButtonTapped:(id)sender {
    [self addSubview:[[ksPickerView alloc]initForState:DATE withData:[[(ksViewController*) [[self window] rootViewController] ksCD] fetchedResultsController:0]]];
}

#pragma mark - Rating Action Group

-(IBAction)ratingSliderTouched:(id)sender {
    
}

#pragma mark - Location Action Group

-(IBAction)locationButtonTapped:(id)sender {
    [self addSubview:[[ksPickerView alloc]initForState:LOCATION withData:[[(ksViewController*) [[self window] rootViewController] ksCD] fetchedResultsController:0]]];
}

-(IBAction)locationCenterMapButtonTapped:(id)sender {
    
}

#pragma mark - Description Action Group

-(IBAction)descriptionTextViewTapped:(id)sender {
    
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
