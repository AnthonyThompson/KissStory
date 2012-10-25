//
//  ksPickerView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/24/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ksPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

-(id)initForState:(int)whichState withData:(NSFetchedResultsController*)fetchedResults;

@property (nonatomic, retain) NSFetchedResultsController* fetchedResults;
@property (nonatomic, readwrite) int state;

@property (atomic, retain) IBOutlet UIButton* acceptButton;
@property (atomic, retain) IBOutlet UIButton* cancelButton;
@property (atomic, retain) IBOutlet UIPickerView* stringPickerView;
@property (atomic, retain) IBOutlet UIDatePicker* datePickerView;

@end
