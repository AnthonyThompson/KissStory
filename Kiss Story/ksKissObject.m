//
//  ksKissObject.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/26/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksKissObject.h"
#import "ksViewController.h"

@implementation ksKissObject

@synthesize state = _state;
@synthesize kissWho = _kissWho;
@synthesize kissDate = _kissDate;
@synthesize kissRating = _kissRating;
@synthesize kissWhere = _kissWhere;
@synthesize kissDescription = _kissDescription;

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ksKissObject" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.frame = frame;
        self.hidden = YES;

        _kissDate = [NSDate date];
        _kissRating = 0;
        _kissDescription = [[NSString alloc]init];
        
        _jamesImage = [[UIImage imageNamed:@"PopoverStretchCap.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(34, 19, 34, 19)];
        _uiiv = [[UIImageView alloc]initWithImage:_jamesImage];
        _uiiv.frame = CGRectMake(0,0,160,240);
        [_testView addSubview:_uiiv];
        
        _coreData = [(ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController] ksCD];

        /*
        NSEntityDescription* kissEntity = [NSEntityDescription entityForName:@"Kisses" inManagedObjectContext:[_coreData managedObjectContext]];
        _kissKiss = [[NSManagedObject alloc]initWithEntity:kissEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];
         */
        
        NSEntityDescription* whoEntity = [NSEntityDescription entityForName:@"Who" inManagedObjectContext:[_coreData managedObjectContext]];
        _kissWho = [[NSManagedObject alloc]initWithEntity:whoEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];
        
        NSEntityDescription* whereEntity = [NSEntityDescription entityForName:@"Where" inManagedObjectContext:[_coreData managedObjectContext]];
        _kissWhere = [[NSManagedObject alloc]initWithEntity:whereEntity insertIntoManagedObjectContext:[_coreData managedObjectContext]];
    }
    
    return self;
}

-(BOOL)saveKiss {
    return NO;
    
    self.hidden = NO;
    
    [UIView animateWithDuration:1.5f animations:^{
        //_testView.transform = CGAffineTransformScale(_testView.transform, 125.0f, 125.0f);
        //_testView.frame=CGRectMake(200, 200, 200, 200);
        _uiiv.frame=CGRectMake(_uiiv.frame.origin.x, _uiiv.frame.origin.y, 200, 200);
    }];
    
    return NO;
    
    //9901
    
    //1st validate name and location
    
    // if not validated
    //  poop-over (confirm buttons dimiss poop-over, hide self, return NO)

    // 
    
    
    
    
    
    
    //9901
    //where does this happen?
    //[self removeFromSuperview];
    
    
    

    // grey, uiai
    // validate values
    // if !OK, then pop-over
    // if OK, then save
    //      insert into context
    //      save context
    //
    //      rebuild frcs?
    //      reload table data?
    
    /*
    
    NSString* titleString;
    NSEntityDescription* entity;
    NSManagedObject* manObj;
    NSMutableSet* whoKey;
    NSMutableSet* whereKey;

    _kissKiss = [NSEntityDescription insertNewObjectForEntityForName:@"Kisses" inManagedObjectContext:[_coreData managedObjectContext]];
    [_kissKiss setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]] forKey:@"id"];
    [_kissKiss setValue:_kissWho forKey:@"kissWho"];
    [_kissKiss setValue:_kissWhere forKey:@"kissWhere"];
    [_kissKiss setValue:[NSNumber numberWithDouble:[_kissDate timeIntervalSince1970]] forKey:@"when"];
    [_kissKiss setValue:[NSNumber numberWithInt:_kissRating] forKey:@"score"];
    [_kissKiss setValue:_kissDescription forKey:@"desc"];

    whoKey = [_kissWho mutableSetValueForKey:@"kissRecord"];
    [whoKey addObject:_kissKiss];
    whereKey = [_kissWhere mutableSetValueForKey:@"kissRecord"];
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
    
    return YES;
     */
}

@end
