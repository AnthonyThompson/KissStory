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
@synthesize validWhere = _validWhere;
@synthesize validWho = _validWho;
@synthesize validDate = _validDate;
@synthesize validDesc = _validDesc;

@synthesize addText = _addText;

#pragma mark - Inits

-(id)init {
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

-(id)initWithConfiguration:(int)configuration {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksKissObject" owner:self options:nil] objectAtIndex:configuration];
        [self initData];
        
        switch (configuration) {
            case SHARE: {
                _facebookSwitch = [[DCRoundSwitch alloc]initWithFrame:CGRectMake(167.0f, 60.0f, 79.0f, 27.0f)];
                _facebookSwitch.onTintColor = [UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:182.0f/255.0f alpha:1.0f];
                _twitterSwitch = [[DCRoundSwitch alloc]initWithFrame:CGRectMake(167.0f, 102.0f, 79.0f, 27.0f)];
                _twitterSwitch.onTintColor = [UIColor colorWithRed:64.0f/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
                
                [self addSubview:_facebookSwitch];
                [self addSubview:_twitterSwitch];
            }
                break;
        }
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Data Init

-(void)initData {
    _kissDate = [NSDate date];
    _kissRating = 0;
    _kissDescription = [[NSString alloc]init];
    
    _kissWho = [[NSMutableDictionary alloc]init];
    _kissWhere = [[NSMutableDictionary alloc]init];
    
    _validWho = NO;
    _validWhere = NO;
    
    _coreData = [ROOT ksCD];
    
}

#pragma mark - Data Actions

-(void)validityCheck {
    if (_validWho) {
        [[[[[ROOT view] subviews] objectAtIndex:10] kisserStatus] setImage:[UIImage imageNamed:@"StatusKisserYes.png"]];
    }
    
    if (_validWhere) {
        [[[[[ROOT view] subviews] objectAtIndex:10] locationStatus] setImage:[UIImage imageNamed:@"StatusLocationYes.png"]];
    }
    
    if (_validDate) {
        [[[[[ROOT view] subviews] objectAtIndex:10] dateStatus] setImage:[UIImage imageNamed:@"StatusDateYes.png"]];
    }

    if (_validDesc) {
        [[[[[ROOT view] subviews] objectAtIndex:10] descStatus] setImage:[UIImage imageNamed:@"StatusDescriptionYes.png"]];
    }

    if (_validWho && _validWhere) {
        [[ROOT topRightButton] setHidden:NO];
    }
}

-(BOOL)saveKiss {
    if (![_kissWho objectForKey:@"who"]) {
        // no who, so new object to insert
        NSEntityDescription* whoEntity = [NSEntityDescription entityForName:@"Who" inManagedObjectContext:[_coreData managedObjectContext]];
        NSManagedObject* newWho = [[NSManagedObject alloc]initWithEntity:whoEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];
        
        [newWho setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]] forKey:@"id"];
        [newWho setValue:[_kissWho objectForKey:@"name"] forKey:@"name"];
        
        [_kissWho setValue:newWho forKey:@"who"];
        [_kissWho removeObjectForKey:@"name"];
    }
    
    if (![_kissWhere objectForKey:@"where"]) {
        // no where, so new object to insert
        NSEntityDescription* whereEntity = [NSEntityDescription entityForName:@"Where" inManagedObjectContext:[_coreData managedObjectContext]];
        NSManagedObject* newWhere = [[NSManagedObject alloc]initWithEntity:whereEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];

        [newWhere setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]] forKey:@"id"];
        [newWhere setValue:[_kissWhere objectForKey:@"name"] forKey:@"name"];

        //pulling lat/lon from current map cooords
        [newWhere setValue:[NSNumber numberWithFloat:[[[[[ROOT view] subviews] lastObject] locationMapView] centerCoordinate].latitude] forKey:@"lat"];
        [newWhere setValue:[NSNumber numberWithFloat:[[[[[ROOT view] subviews] lastObject] locationMapView] centerCoordinate].longitude] forKey:@"lon"];

        [_kissWhere setValue:newWhere forKey:@"where"];
        [_kissWhere removeObjectForKey:@"name"];
        [_kissWhere removeObjectForKey:@"lat"];
        [_kissWhere removeObjectForKey:@"lon"];
    }

    NSEntityDescription* kissEntity = [NSEntityDescription entityForName:@"Kisses" inManagedObjectContext:[_coreData managedObjectContext]];
    NSManagedObject* newKiss = [[NSManagedObject alloc]initWithEntity:kissEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];

    [newKiss setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]] forKey:@"id"];
    [newKiss setValue:[_kissWho valueForKey:@"who"] forKey:@"kissWho"];
    [newKiss setValue:[_kissWhere valueForKey:@"where"] forKey:@"kissWhere"];
    [newKiss setValue:[NSNumber numberWithFloat:[_kissDate timeIntervalSince1970]] forKey:@"when"];
    [newKiss setValue:[NSNumber numberWithInt:_kissRating] forKey:@"score"];
    [newKiss setValue:_kissDescription forKey:@"desc"];
    if (_kissPicture) {
        [newKiss setValue:UIImagePNGRepresentation(_kissPicture) forKey:@"image"];
    } else {
        [newKiss setValue:KSCD_DUMMYIMAGE forKey:@"image"];
    }

    NSMutableSet* whoKey = [[_kissWho valueForKey:@"who"] mutableSetValueForKey:@"kissRecord"];
    [whoKey addObject:newKiss];
    NSMutableSet* whereKey = [[_kissWhere valueForKey:@"where"] mutableSetValueForKey:@"kissRecord"];
    [whereKey addObject:newKiss];
    
    // 9901 saved!  want to share?
    ksKissObject* content = [[ksKissObject alloc]initWithConfiguration:SHARE];
    ksPopOverView* popOverView = [[ksPopOverView alloc]initWithFrame:content.frame];
    [popOverView displayPopOverViewWithContent:content withBacking:nil inSuperView:[ROOT view]];
    
    

    

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

    [self dataRebuild];
    return YES;
}

-(void)deleteKiss {
    [[_coreData managedObjectContext] deleteObject:[[UPTHECHAIN dataDictionary] objectForKey:@"editKiss"]];

    // this deletes singleton who's
    if ([[[[[UPTHECHAIN dataDictionary] objectForKey:@"editKiss"] valueForKey:@"kissWho"] valueForKey:@"kissRecord"] count] == 1) {
        [[_coreData managedObjectContext] deleteObject:[[[UPTHECHAIN dataDictionary] objectForKey:@"editKiss"] valueForKey:@"kissWho"]];
    }
    
    // this deletes singleton where's
    if ([[[[[UPTHECHAIN dataDictionary] objectForKey:@"editKiss"] valueForKey:@"kissWhere"] valueForKey:@"kissRecord"] count] == 1) {
        [[_coreData managedObjectContext] deleteObject:[[[UPTHECHAIN dataDictionary] objectForKey:@"editKiss"] valueForKey:@"kissWhere"]];
    }

    [self dataRebuild];
    [UPTHECHAIN dismissUtilityViewWithSave:NO];
    [ROOT resetMainView];
}

-(void)dataRebuild {
    [_coreData saveContext];
    [ROOT buildDataSet];
    [ROOT mapUpdate];
}

#pragma mark - KissDetailWarning Group

-(IBAction)dismissButtonTapped:(id)sender {
    [(ksPopOverView*)[[sender superview] superview] dismissPopOverView];
}

#pragma mark - AddWhoWhere Group

-(IBAction)addCancelButtonTapped:(id)sender {
    [UPTHECHAIN setTextControl:KUV_TEXTVIEW];
    [(ksPopOverView*)[self superview] dismissPopOverView];
}

#pragma mark - ConfirmAction Group

-(IBAction)cancelConfirmButtonTapped:(id)sender {
    [(ksPopOverView*)[self superview] dismissPopOverView];
}

-(IBAction)confirmConfirmButtonTapped:(id)sender {
    [self deleteKiss];
    [(ksPopOverView*)[self superview] dismissPopOverView];
}

#pragma mark - ShareKiss Group

-(IBAction)shareConfirmButtonTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:@"Initial Tweet Text!"];
        if (_kissPicture) [tweetSheet addImage:_kissPicture];
        
        [ROOT presentViewController:tweetSheet animated:YES completion:nil];
    }

    [(ksPopOverView*)[self superview] dismissPopOverView];
}



#pragma mark - UITextFieldDelegate group

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
    [UPTHECHAIN setTextControl:KUV_TEXTVIEW];
    [(ksPopOverView*)[self superview] dismissPopOverView];
    [[UPTHECHAIN pickerView] saveWhoWhere:self isNew:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self superview].frame=CGRectOffset([self superview].frame, 0.0f, 55.0f);
    return YES;
}

@end
