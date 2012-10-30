//
//  ksKissObject.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/26/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissObjectView.h"
#import "ksViewController.h"

@implementation ksKissObjectView

@synthesize state = _state;
@synthesize kissWho = _kissWho;
@synthesize kissDate = _kissDate;
@synthesize kissRating = _kissRating;
@synthesize kissWhere = _kissWhere;
@synthesize kissDescription = _kissDescription;

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ksKissObjectView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        
        _kissDate = [NSDate date];
        _kissRating = 0;
        _kissDescription = [[NSString alloc]init];
        
        _kissKiss = [[NSObject alloc]init];
        _kissWho = [[NSObject alloc]init];
        _kissWhere = [[NSObject alloc]init];

        _coreData = [(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] ksCD];
    }
    
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(BOOL)validateValues {
    int validity = VALID_DATA;
    
    if ([[_kissWho valueForKey:@"id"] doubleValue] == 0.0f) validity++;
    if ([[_kissWhere valueForKey:@"id"] doubleValue] == 0.0f) validity+=2;
    
    if (validity == VALID_DATA) return YES;
    
    _popOverTitle.text = @"Missing Kiss Details!";
    NSString* popOverText;
    
    switch (validity) {
        case INVALID_WHO_ENTITY: {
            popOverText = @"Who did you kiss?";
        }
            break;
        case INVALID_WHERE_ENTITY: {
            popOverText = @"Where did you kiss?";
        }
            break;
        case INVALID_WHO_AND_WHERE_ENTITY: {
            popOverText = @"Who did you kiss, and where did you kiss them?";
        }
            break;
    }
    
    _popOverText.text = popOverText;
    _popOverView = [[ksPopOverView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width + 20.0f, self.frame.size.height + 20.0f)];
    [_popOverView displayPopOverViewWithContent:self withBacking:nil inSuperView:[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];

    return NO;
}

-(BOOL)saveKiss {
    
    if (![self validateValues]) {
        return NO;
    }

    NSEntityDescription* kissEntity = [NSEntityDescription entityForName:@"Kisses" inManagedObjectContext:[_coreData managedObjectContext]];
    NSManagedObject* newKiss = [[NSManagedObject alloc]initWithEntity:kissEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];

    [newKiss setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]] forKey:@"id"];
    [newKiss setValue:_kissWho forKey:@"kissWho"];
    [newKiss setValue:_kissWhere forKey:@"kissWhere"];
    [newKiss setValue:[NSNumber numberWithDouble:[_kissDate timeIntervalSince1970]] forKey:@"when"];
    [newKiss setValue:[NSNumber numberWithInt:_kissRating] forKey:@"score"];
    [newKiss setValue:_kissDescription forKey:@"desc"];

    NSMutableSet* whoKey = [_kissWho mutableSetValueForKey:@"kissRecord"];
    [whoKey addObject:newKiss];
    NSMutableSet* whereKey = [_kissWhere mutableSetValueForKey:@"kissRecord"];
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

    return YES;
}

-(IBAction)popOverButtonTapped:(id)sender {
    [_popOverView dismissPopOverViewInSuperView:[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
}


@end
