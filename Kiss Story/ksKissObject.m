//
//  ksKissObject.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/26/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissObject.h"
#import "ksViewController.h"
#import "ksPopOverView.h"
#import "ksKissUtilityView.h"

@implementation ksKissObject

@synthesize state = _state;
@synthesize kissWho = _kissWho;
@synthesize kissDate = _kissDate;
@synthesize kissRating = _kissRating;
@synthesize kissWhere = _kissWhere;
@synthesize kissDescription = _kissDescription;
@synthesize addTitle = _addTitle;

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksKissObject" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        
        _kissDate = [NSDate date];
        _kissRating = 0;
        _kissDescription = [[NSString alloc]init];
        
        _kissWho = [[NSMutableDictionary alloc]init];
        _kissWhere = [[NSMutableDictionary alloc]init];

        _coreData = [(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] ksCD];
    }
    
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(BOOL)validateValues {
    int validity = VALID_DATA;
    
    // if no name, then the dictionary is empty
    if (![_kissWho valueForKey:@"name"]) validity++;
    if (![_kissWhere valueForKey:@"name"]) validity+=2;
    
    if (validity == VALID_DATA) return YES;
    
    ksKissObject* content = [[[NSBundle mainBundle] loadNibNamed:@"ksKissObject" owner:self options:nil] objectAtIndex:0];
    ksPopOverView* popOverView = [[ksPopOverView alloc]initWithFrame:content.frame];
    
    content.popOverTitle.text = @"Missing Kiss Details!";

    switch (validity) {
        case INVALID_WHO_ENTITY: {
            content.popOverText.text = @"Who did you kiss?";
        }
            break;
        case INVALID_WHERE_ENTITY: {
            content.popOverText.text = @"Where did you kiss?";
        }
            break;
        case INVALID_WHO_AND_WHERE_ENTITY: {
            content.popOverText.text = @"Who did you kiss, and where did you kiss them?";
        }
            break;
    }

    [popOverView displayPopOverViewWithContent:content withBacking:nil inSuperView:[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
    
    return NO;
}

-(BOOL)saveKiss {

    if (![self validateValues]) {
        return NO;
    }

    if (![_kissWho objectForKey:@"who"]) {
        // no who, so new object to insert
        NSEntityDescription* whoEntity = [NSEntityDescription entityForName:@"Who" inManagedObjectContext:[_coreData managedObjectContext]];
        NSManagedObject* newWho = [[NSManagedObject alloc]initWithEntity:whoEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];
        
        [newWho setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]] forKey:@"id"];
        [newWho setValue:[_kissWho objectForKey:@"name"] forKey:@"name"];
        
        [_kissWho setValue:newWho forKey:@"who"];
    }
    
    if (![_kissWhere objectForKey:@"where"]) {
        // no where, so new object to insert
        NSEntityDescription* whereEntity = [NSEntityDescription entityForName:@"Where" inManagedObjectContext:[_coreData managedObjectContext]];
        NSManagedObject* newWhere = [[NSManagedObject alloc]initWithEntity:whereEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];
        
        [newWhere setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]] forKey:@"id"];
        [newWhere setValue:[_kissWho objectForKey:@"name"] forKey:@"name"];
        [newWhere setValue:[NSNumber numberWithFloat:[[_kissWho objectForKey:@"lat"] floatValue]] forKey:@"lat"];
        [newWhere setValue:[NSNumber numberWithFloat:[[_kissWho objectForKey:@"lon"] floatValue]] forKey:@"lon"];
        
        [_kissWhere setValue:newWhere forKey:@"where"];
    }

    NSEntityDescription* kissEntity = [NSEntityDescription entityForName:@"Kisses" inManagedObjectContext:[_coreData managedObjectContext]];
    NSManagedObject* newKiss = [[NSManagedObject alloc]initWithEntity:kissEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];

    [newKiss setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]] forKey:@"id"];
    [newKiss setValue:[_kissWho valueForKey:@"who"] forKey:@"kissWho"];
    [newKiss setValue:[_kissWhere valueForKey:@"where"] forKey:@"kissWhere"];
    [newKiss setValue:[NSNumber numberWithFloat:[_kissDate timeIntervalSince1970]] forKey:@"when"];
    [newKiss setValue:[NSNumber numberWithInt:_kissRating] forKey:@"score"];
    [newKiss setValue:_kissDescription forKey:@"desc"];

    NSMutableSet* whoKey = [[_kissWho valueForKey:@"who"] mutableSetValueForKey:@"kissRecord"];
    [whoKey addObject:newKiss];
    NSMutableSet* whereKey = [[_kissWhere valueForKey:@"where"] mutableSetValueForKey:@"kissRecord"];
    [whereKey addObject:newKiss];

    //9901 rate app stuff
    /*
    int saveKissCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"savedKisses"];
    
    // -1 is the turn-off key
    if (saveKissCount > -1) {
        saveKissCount++;
        [[NSUserDefaults standardUserDefaults] setInteger:saveKissCount forKey:@"savedKisses"];
        
        if (saveKissCount > 99999) {
            
            //9901 poop-over here
            NSString* titleString = [[NSString alloc]initWithFormat:@"Having fun with %@?",[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleName"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString
                                                            message:@"Please rate it and tell others!"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Remind me later", @"Rate now", @"Never ask again", nil];
            alert.delegate = self;
            [alert show];
        }
    }
     */
    
    [_coreData saveContext];
    [(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] buildDataSet];
    [(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] mapUpdate];

    return YES;
}

-(IBAction)dismissButtonTapped:(id)sender {
    [(ksPopOverView*)[[sender superview] superview] dismissPopOverView];
}

-(IBAction)addAcceptButtonTapped:(id)sender {
    // dismiss newW pop-over
    [(ksPopOverView*)[self superview] dismissPopOverView];

    // dismiss pickerView && save
    [[UPTHECHAIN pickerView] saveWhoWhere:self isNew:YES];
}
-(IBAction)addCancelButtonTapped:(id)sender {
    [(ksPopOverView*)[self superview] dismissPopOverView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self superview].frame=CGRectOffset([self superview].frame, 0.0f, -55.0f);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch ([textField tag]) {
        case KISSER: {
            [_kissWho removeObjectForKey:@"who"];
            [_kissWho setValue:textField.text forKey:@"name"];
            [[UPTHECHAIN kissObject] setKissWho:_kissWho];
        }
            break;
        case LOCATION: {
            [_kissWhere removeObjectForKey:@"where"];
            [_kissWhere setValue:textField.text forKey:@"name"];
            [_kissWhere setValue:[NSNumber numberWithDouble:[[[UPTHECHAIN locationMapView] userLocation] coordinate].latitude] forKey:@"lat"];
            [_kissWhere setValue:[NSNumber numberWithDouble:[[[UPTHECHAIN locationMapView] userLocation] coordinate].longitude] forKey:@"lon"];
            [[UPTHECHAIN kissObject] setKissWhere:_kissWhere];
        }
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    _addAcceptButton.hidden = NO;
    [self superview].frame=CGRectOffset([self superview].frame, 0.0f, 55.0f);
    return YES;
}

@end
