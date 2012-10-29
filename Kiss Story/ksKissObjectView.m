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
        _popOverView = [[ksPopOverView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width + 20.0f, self.frame.size.height + 20.0f)];

        _coreData = [(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] ksCD];
        
        NSEntityDescription* whoEntity = [NSEntityDescription entityForName:@"Who" inManagedObjectContext:[_coreData managedObjectContext]];
        _kissWho = [[NSManagedObject alloc]initWithEntity:whoEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];
        
        NSEntityDescription* whereEntity = [NSEntityDescription entityForName:@"Where" inManagedObjectContext:[_coreData managedObjectContext]];
        _kissWhere = [[NSManagedObject alloc]initWithEntity:whereEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];
    }
    
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(BOOL)validateValues {
    NSLog(@"kKOV vV");
    int validity = VALID_DATA;
    
    if ([[_kissWho valueForKey:@"id"] doubleValue] == 0.0f) validity++;
    if ([[_kissWhere valueForKey:@"id"] doubleValue] == 0.0f) validity+=2;
    
    if (validity == VALID_DATA) return YES;
    
    _popOverTitle.text = @"Missing Details!";
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
    
    _popOverView = [[ksPopOverView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width + 10.0f, self.frame.size.height + 10.0f)];
    _popOverView = [[ksPopOverView alloc]initWithFrame:CGRectMake(160.0f - (_popOverView.frame.size.width/2),240.0f - (_popOverView.frame.size.height/2), _popOverView.frame.size.width, _popOverView.frame.size.height)];
    
    _popOverView.resizableImageView.frame = CGRectMake(0.0f,0.0f,_popOverView.frame.size.width,_popOverView.frame.size.height);
    _popOverView.containerView.frame = CGRectMake(0.0f,0.0f,_popOverView.frame.size.width - 30.0f,_popOverView.frame.size.height - 30.0f);
    
    
    [_popOverView displayPopOverViewWithContent:self inSuperView:[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
    
    //[_popOverView.containerView addSubview:self];
    
    //_popOverView.transform = CGAffineTransformScale(_popOverView.transform, 0.01f, 0.01f);
    //[[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view] addSubview:_popOverView];
    //[_popOverView displayPopOverView];


    return NO;
}

-(BOOL)saveKiss {
    
    if (![self validateValues]) {
        return NO;
    }

    _kissKiss = [NSEntityDescription insertNewObjectForEntityForName:@"Kisses" inManagedObjectContext:[_coreData managedObjectContext]];

    [_kissKiss setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]] forKey:@"id"];
    [_kissKiss setValue:_kissWho forKey:@"kissWho"];
    [_kissKiss setValue:_kissWhere forKey:@"kissWhere"];
    [_kissKiss setValue:[NSNumber numberWithDouble:[_kissDate timeIntervalSince1970]] forKey:@"when"];
    [_kissKiss setValue:[NSNumber numberWithInt:_kissRating] forKey:@"score"];
    [_kissKiss setValue:_kissDescription forKey:@"desc"];

    NSMutableSet* whoKey = [_kissWho mutableSetValueForKey:@"kissRecord"];
    [whoKey addObject:_kissKiss];
    NSMutableSet* whereKey = [_kissWhere mutableSetValueForKey:@"kissRecord"];
    [whereKey addObject:_kissKiss];
    
    int saveKissCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"savedKisses"];
    
    // -1 is the turn-off key
    if (saveKissCount > -1) {
        saveKissCount++;
        [[NSUserDefaults standardUserDefaults] setInteger:saveKissCount forKey:@"savedKisses"];
        
        if (saveKissCount > 4) {
            
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
    
    [_coreData saveContext];
    [(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] buildDataSet];

    return YES;
}

-(IBAction)popOverButtonTapped:(id)sender {
    [_popOverView dismissPopOverViewInSuperView:[(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] view]];
}


@end
