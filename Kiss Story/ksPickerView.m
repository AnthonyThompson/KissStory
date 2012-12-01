//
//  ksPickerView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/24/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksPickerView.h"
#import "ksViewController.h"
#import "ksPopOverView.h"

@implementation ksPickerView

#pragma mark - Inits

-(id)initForState:(int)whichState withData:(NSFetchedResultsController*)fetchedResults {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksPickerView" owner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(0.0f, 0.0f, 300.0f, 302.0f);
        
        self.fetchedResults = [[NSFetchedResultsController alloc]init];
        self.fetchedResults = fetchedResults;
        self.state = whichState;
        self.stringPickerView.delegate = self;
        self.stringPickerView.dataSource = self;
        self.screenView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, -42.0f, 320.0f, 524.0f)];
        self.screenView.backgroundColor = CCO_BASE_GREY;
        self.screenView.alpha = 0.3f;
        
        switch (self.state) {
            case KISSER: {
                self.datePickerView.hidden = TRUE;
            }
                break;
            case DATE: {
                self.stringPickerView.hidden = TRUE;
            }
                break;
            case LOCATION: {
                self.datePickerView.hidden = TRUE;
            }
                break;
        }
    }

    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(void)displayPickerView {
    ksPopOverView* popOverView = [[ksPopOverView alloc]initWithFrame:self.frame];
    [popOverView displayPopOverViewWithContent:self withBacking:_screenView inSuperView:[[[ROOT view] subviews] lastObject]];
}

#pragma mark - UIPickerViewDelegate

-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_state == DATE)
        return @"";
    
    return [[[_fetchedResults fetchedObjects] objectAtIndex:row] valueForKey:@"name"];
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[_fetchedResults fetchedObjects] count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(IBAction)cancelButtonTapped:(id)sender {
    [[ROOT kissUtilityView] kisserButton].backgroundColor = CCO_BASE_CREAM;
    [[ROOT kissUtilityView] dateButton].backgroundColor = CCO_BASE_CREAM;
    [[ROOT kissUtilityView] locationButton].backgroundColor = CCO_BASE_CREAM;
    //[(ksKissUtilityView*)[[self superview] superview] kisserButton].backgroundColor = CCO_BASE_CREAM;
    //[(ksKissUtilityView*)[[self superview] superview] dateButton].backgroundColor = CCO_BASE_CREAM;
    //[(ksKissUtilityView*)[[self superview] superview] locationButton].backgroundColor = CCO_BASE_CREAM;

    [self dismissPickerView];
}

-(IBAction)acceptButtonTapped:(id)sender {
    // accept button hit; a row of the picker has been accepted.
    // if it's not 0, then grab object and push down to kiss object
    // if it's 0, then lanuch the text field
    
    switch (_state) {
        case KISSER: {
            if ([_stringPickerView selectedRowInComponent:0] == 0) {
                ksKissObject* content = [[ksKissObject alloc]initWithConfiguration:ADDWHOWHERE];
                content.kissWho = [[NSMutableDictionary alloc]init];
                content.addTitle.text = @"Who did you kiss?";
                content.addText.tag = KISSER;
                
                ksPopOverView* popOverView = [[ksPopOverView alloc]initWithFrame:content.frame];
                [popOverView displayPopOverViewWithContent:content withBacking:nil inSuperView:[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
            } else {
                NSMutableDictionary* whoDict = [[NSMutableDictionary alloc]init];
                [whoDict setValue:@"who" forKey:@"type"];
                [whoDict setValue:[[_fetchedResults fetchedObjects] objectAtIndex:[_stringPickerView selectedRowInComponent:0]] forKey:@"who"];
                
                [[[ROOT kissUtilityView] kissObject] newWhoWhere:whoDict];
                [self dismissPickerView];
            }
        }
            break;
        case DATE: {
            [[[ROOT kissUtilityView] kissObject] saveDate:[_datePickerView date]];
            [self dismissPickerView];
        }
            break;
        case LOCATION: {
            if ([_stringPickerView selectedRowInComponent:0] == 0) {
                ksKissObject* content = [[ksKissObject alloc]initWithConfiguration:ADDWHOWHERE];
                content.kissWho = [[NSMutableDictionary alloc]init];
                content.addTitle.text = @"Where did you kiss?";
                content.addText.tag = LOCATION;
                
                ksPopOverView* popOverView = [[ksPopOverView alloc]initWithFrame:content.frame];
                [popOverView displayPopOverViewWithContent:content withBacking:nil inSuperView:[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
            } else {
                NSMutableDictionary* whereDict = [[NSMutableDictionary alloc]init];
                [whereDict setValue:@"where" forKey:@"type"];
                [whereDict setValue:[[_fetchedResults fetchedObjects] objectAtIndex:[_stringPickerView selectedRowInComponent:0]] forKey:@"where"];
                
                [[[ROOT kissUtilityView] kissObject] newWhoWhere:whereDict];
                [self dismissPickerView];
            }
        }
            break;
    }
}

-(void)dismissPickerView{
    [ROOT enableTopButtons:YES];
    [(ksPopOverView*)[self superview] dismissPopOverView];
    [self removeFromSuperview];
}

@end
