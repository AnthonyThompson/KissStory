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

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksPickerView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

-(id)initForState:(int)whichState withData:(NSFetchedResultsController*)fetchedResults {
    if ([self initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 302.0f)]) {
        
        _fetchedResults = [[NSFetchedResultsController alloc]init];
        _fetchedResults = fetchedResults;
        _state = whichState;
        _stringPickerView.delegate = self;
        _stringPickerView.dataSource = self;
        _screenView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, -42.0f, 320.0f, 524.0f)];
        _screenView.backgroundColor = CCO_BASE_GREY;
        _screenView.alpha = 0.3f;
        
        switch (_state) {
            case KISSER: {
                _datePickerView.hidden = TRUE;
            }
                break;
            case DATE: {
                _stringPickerView.hidden = TRUE;
            }
                break;
            case LOCATION: {
                _datePickerView.hidden = TRUE;
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
    [(ksKissUtilityView*)[[self superview] superview] kisserButton].backgroundColor = CCO_BASE_CREAM;
    [(ksKissUtilityView*)[[self superview] superview] dateButton].backgroundColor = CCO_BASE_CREAM;
    [(ksKissUtilityView*)[[self superview] superview] locationButton].backgroundColor = CCO_BASE_CREAM;

    [self dismissPickerView];
}

-(void)saveWhoWhere:(ksKissObject*)kissObject isNew:(BOOL)isNew {
    UIButton* receiverButton;
    NSString* receiverTitle;

    switch (_state) {
        case KISSER: {
            [[(ksKissUtilityView*)[[self superview] superview] kissObject] setValidWho:YES];

            if ((!isNew) && ([_stringPickerView selectedRowInComponent:0] == 0)) {
                ksKissObject* content = [[ksKissObject alloc]initWithConfiguration:ADDWHOWHERE];
                content.kissWho = [[NSMutableDictionary alloc]init];
                content.addTitle.text = @"Who did you kiss?";
                content.addText.tag = KISSER;
                
                ksPopOverView* popOverView = [[ksPopOverView alloc]initWithFrame:content.frame];
                [popOverView displayPopOverViewWithContent:content withBacking:nil inSuperView:[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
                
                return;
            }

            receiverButton = [(ksKissUtilityView*)[[self superview] superview] kisserButton];
            
            if (!isNew) {
                receiverTitle = [self pickerView:_stringPickerView titleForRow:[_stringPickerView selectedRowInComponent:0] forComponent:0];
                [[kissObject kissWho] setValue:receiverTitle forKey:@"name"];
                [[kissObject kissWho] setValue:[[_fetchedResults fetchedObjects] objectAtIndex:[_stringPickerView selectedRowInComponent:0]] forKey:@"who"];
            } else {
                receiverTitle = [[kissObject kissWho] valueForKey:@"name"];
            }
            
        }
            break;
        case DATE: {
            [[(ksKissUtilityView*)[[self superview] superview] kissObject] setKissDate:[_datePickerView date]];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            
            receiverButton = [(ksKissUtilityView*)[[self superview] superview] dateButton];
            receiverTitle = [dateFormatter stringFromDate:[_datePickerView date]];
        }
            break;
        case LOCATION: {
            [[(ksKissUtilityView*)[[self superview] superview] kissObject] setValidWhere:YES];

            if ((!isNew) && ([_stringPickerView selectedRowInComponent:0] == 0)) {
                ksKissObject* content = [[ksKissObject alloc]initWithConfiguration:ADDWHOWHERE];
                content.kissWhere = [[NSMutableDictionary alloc]init];
                content.addText.tag = LOCATION;
                content.addTitle.text = @"Where did you kiss?";
                
                ksPopOverView* popOverView = [[ksPopOverView alloc]initWithFrame:content.frame];
                [popOverView displayPopOverViewWithContent:content withBacking:nil inSuperView:[ROOT view]];
                
                return;
            }
            
            receiverButton = [(ksKissUtilityView*)[[self superview] superview] locationButton];
            
            if (!isNew) {
                receiverTitle = [self pickerView:_stringPickerView titleForRow:[_stringPickerView selectedRowInComponent:0] forComponent:0];
                [[kissObject kissWhere] setValue:receiverTitle forKey:@"name"];
                [[kissObject kissWhere] setValue:[[_fetchedResults fetchedObjects] objectAtIndex:[_stringPickerView selectedRowInComponent:0]] forKey:@"where"];
                
                [[(ksKissUtilityView*)[[self superview] superview] locationMapView] setCenterCoordinate:CLLocationCoordinate2DMake([[[[[(ksKissUtilityView*)[[self superview] superview] kissObject] kissWhere] valueForKey:@"where"] valueForKey:@"lat"] doubleValue], [[[[[(ksKissUtilityView*)[[self superview] superview] kissObject] kissWhere] valueForKey:@"where"] valueForKey:@"lon"] doubleValue]) animated:YES];
            } else {
                receiverTitle = [[kissObject kissWhere] valueForKey:@"name"];
                
                [[(ksKissUtilityView*)[[self superview] superview] locationMapView] setCenterCoordinate:CLLocationCoordinate2DMake([[[[(ksKissUtilityView*)[[self superview] superview] kissObject] kissWhere] valueForKey:@"lat"] doubleValue], [[[[(ksKissUtilityView*)[[self superview] superview] kissObject] kissWhere] valueForKey:@"lon"] doubleValue]) animated:YES];
            }
        }
            break;
    }

    [receiverButton setTitle:receiverTitle forState:UIControlStateNormal];
    [receiverButton setTitleColor:CCO_BASE_GREY forState:UIControlStateNormal];
    [receiverButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    receiverButton.backgroundColor = CCO_BASE_CREAM;
    
    [self dismissPickerView];
}

-(IBAction)acceptButtonTapped:(id)sender {
    [self saveWhoWhere:[(ksKissUtilityView*)[[self superview] superview] kissObject] isNew:NO];
}

-(void)dismissPickerView{
    [ROOT enableTopButtons:YES];
    
    [(ksPopOverView*)[self superview] dismissPopOverView];
    [[(ksKissUtilityView*)[[self superview] superview] kissObject] validityCheck];
    [self removeFromSuperview];
}

@end
