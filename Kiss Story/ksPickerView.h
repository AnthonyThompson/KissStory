//
//  ksPickerView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/24/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ksPopOverView.h"

@interface ksPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

-(id)initForState:(int)whichState withData:(NSFetchedResultsController*)fetchedResults;
-(void)displayPickerView;

@property (nonatomic, retain) NSFetchedResultsController* fetchedResults;
@property (nonatomic, readwrite) int state;
@property (nonatomic, retain) ksPopOverView* popOverView;
@property (nonatomic, retain) UIView* screenView;

@property (nonatomic, retain) IBOutlet UIButton* acceptButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelButton;
@property (nonatomic, retain) IBOutlet UIPickerView* stringPickerView;
@property (nonatomic, retain) IBOutlet UIDatePicker* datePickerView;

@end
