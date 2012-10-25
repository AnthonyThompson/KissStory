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
    switch (_state) {
        case KISSER: {
        }
            break;
        case DATE: {
            
        }
            break;
        case LOCATION: {
        }
            break;
    }
    
    NSString* abba = [[NSString alloc]initWithFormat:@"%i HELLS YEAH %i",row,row];
    return abba;
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 16;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(IBAction)cancelButtonTapped:(id)sender {
    [self dismissPickerView];
}

-(IBAction)acceptButtonTapped:(id)sender {
    [self dismissPickerView];
}

-(void)dismissPickerView {
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0.0f, 480.0f, 320.0f, 436.0f);
    } completion:^(BOOL finished){
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
