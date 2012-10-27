//
//  ksPickerView.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/24/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksPickerView.h"
#import "ksViewController.h"

@implementation ksPickerView

#pragma mark - Inits

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ksPickerView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

-(id)initForState:(int)whichState withData:(NSFetchedResultsController*)fetchedResults {
    if ([self initWithFrame:CGRectMake(0.0f, 480.0f, 320.0f, 436.0f)]) {
        _fetchedResults = [[NSFetchedResultsController alloc]init];
        _fetchedResults = fetchedResults;
        _state = whichState;
        _stringPickerView.delegate = self;
        _stringPickerView.dataSource = self;
        [self disableHeaderButtons];
        
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
    
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0.0f, 0.0f, 320.0f, 436.0f);
    }];

    return self;
}


-(void)awakeFromNib {
    [super awakeFromNib];
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
    [self dismissPickerView];
}

-(IBAction)acceptButtonTapped:(id)sender {
    //9901 save picked stuff
    
    UIButton* receiverButton;
    NSString* receiverTitle;

    switch (_state) {
        case KISSER: {
            // 9901 discriminate for add new
            [[(ksKissUtilityView*)[self superview] kissObject] setKissWho:[[_fetchedResults fetchedObjects] objectAtIndex:[_stringPickerView selectedRowInComponent:0]]];
            
            receiverButton = [(ksKissUtilityView*)[self superview] kisserButton];
            receiverTitle = [self pickerView:_stringPickerView titleForRow:[_stringPickerView selectedRowInComponent:0] forComponent:0];
        }
            break;
        case DATE: {
            [[(ksKissUtilityView*)[self superview] kissObject] setKissDate:[_datePickerView date]];

            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            
            receiverButton = [(ksKissUtilityView*)[self superview] dateButton];
            receiverTitle = [dateFormatter stringFromDate:[_datePickerView date]];
        }
            break;
        case LOCATION: {
            // 9901 discriminate for add new
            [[(ksKissUtilityView*)[self superview] kissObject] setKissWhere:[[_fetchedResults fetchedObjects] objectAtIndex:[_stringPickerView selectedRowInComponent:0]]];

            // adjust map to reflect this location
            [[(ksKissUtilityView*)[self superview] locationMapView] setCenterCoordinate:CLLocationCoordinate2DMake([[[[(ksKissUtilityView*)[self superview] kissObject] kissWhere] valueForKey:@"lat"] doubleValue], [[[[(ksKissUtilityView*)[self superview] kissObject] kissWhere] valueForKey:@"lon"] doubleValue]) animated:YES];

            receiverButton = [(ksKissUtilityView*)[self superview] locationButton];
            receiverTitle = [self pickerView:_stringPickerView titleForRow:[_stringPickerView selectedRowInComponent:0] forComponent:0];
        }
            break;
    }
    
    [receiverButton setTitle:receiverTitle forState:UIControlStateNormal];
    [receiverButton setTitleColor:CCO_BASE_GREY forState:UIControlStateNormal];
    [receiverButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];

    [self dismissPickerView];
}

-(void)dismissPickerView{
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0.0f, 480.0f, 320.0f, 436.0f);
    } completion:^(BOOL finished){
        [[(ksKissUtilityView*)[self superview] kisserButton] setEnabled:YES];
        [[(ksKissUtilityView*)[self superview] dateButton] setEnabled:YES];
        [[(ksKissUtilityView*)[self superview] locationButton] setEnabled:YES];
        [self enableHeaderButtons];
        [self removeFromSuperview];
    }];
}

-(void)disableHeaderButtons {
    [[(ksViewController*)[[self window] rootViewController] topRightButton] setAlpha:0.5f];
    [[(ksViewController*)[[self window] rootViewController] topRightButton] setEnabled:NO];
    [[(ksViewController*)[[self window] rootViewController] topLeftButton] setAlpha:0.5f];
    [[(ksViewController*)[[self window] rootViewController] topLeftButton] setEnabled:NO];
}

-(void)enableHeaderButtons {
    [[(ksViewController*)[[self window] rootViewController] topRightButton] setAlpha:1.0f];
    [[(ksViewController*)[[self window] rootViewController] topRightButton] setEnabled:YES];
    [[(ksViewController*)[[self window] rootViewController] topLeftButton] setAlpha:1.0f];
    [[(ksViewController*)[[self window] rootViewController] topLeftButton] setEnabled:YES];
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
