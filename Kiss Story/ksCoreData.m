//
//  ksCoreData.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/8/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksCoreData.h"

@implementation ksCoreData

@synthesize managedObjectContext = managedObjectContext_;
@synthesize managedObjectModel = managedObjectModel_;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator_;
@synthesize storeURL = storeURL_;
@synthesize storePath = storePath_;
@synthesize fileMan = fileMan_;

#pragma mark - Inits

- (id)init{
    if (self = [super init]) {
    }
    
#ifdef DEBUG
    // KSCD_DATA = initial place-values; anon, addNew, &c
    //_runTime = KSCD_DATA;
    
    // KSCD_DEBUGDATA = ladies && settings
    _runTime = KSCD_DEBUGDATA;
    
    // KSCD_NODATA = no data generated at all BE CAREFUL WITH THIS ONE MY FRIEND
    //_runTime = KSCD_NODATA;
#else
    _runTime = KSCD_DATA;
#endif

    return self;
}

#pragma mark - Core Data Stack

-(NSManagedObjectModel *)managedObjectModel {
    // managedObjectModel = the actual data model
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    
    // model not specified directly; mergedModelFromBundles loads every model in the project
    managedObjectModel_ = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel_;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    NSError* err = nil;
    
    if (persistentStoreCoordinator_ != nil)
        return persistentStoreCoordinator_;
    
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // if it's not there, fill with data after creation
    BOOL preExists = FALSE;
    NSArray* ls = [[self fileMan] contentsOfDirectoryAtPath:[[self storeURL] path] error:&err];
    for (NSString* file in ls) {
        if ([file isEqualToString:KSCD_DATA_FILE_NAME]) {
            preExists = TRUE;
        }
    }
    
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:[self storePath]] options:nil error:&err]){
        NSLog(@"ksCD pSC ****    UNRESOLVED ERROR    ****\n%@, %@", err, [err userInfo]);
        abort();
    }
    
    // If it doesn't already exist && we need data, make that data mang
    if ((!preExists) && (_runTime != KSCD_NODATA)) {
        [self genData];
    }
    
    return persistentStoreCoordinator_;
}

- (NSManagedObjectContext *)managedObjectContext {
    // the virtual in-memory representation
    if (managedObjectContext_ != nil)
        return managedObjectContext_;
    
    if ([self persistentStoreCoordinator] != nil){
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    }
    
    return managedObjectContext_;
}

- (void)saveContext {
    NSError *err = nil;
    if ([self managedObjectContext] != nil){
        if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&err]){
            NSLog(@"ksCD sC ****    UNRESOLVED ERROR    ****\n%@, %@", err, [err userInfo]);
            abort();
        }
    }
}

#pragma mark - Filename Exposure

-(NSURL*)storeURL {
    NSError* err = nil;
    storeURL_ = [[self fileMan] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    return storeURL_;
}

-(NSString*)storePath {
    storePath_ = [[[self storeURL] path] stringByAppendingString:KSCD_DATA_PATH_NAME];
    return storePath_;
}

-(NSFileManager*)fileMan {
    if (fileMan_ != nil)
        return fileMan_;
    
    fileMan_ = [[NSFileManager alloc]init];
    
    return fileMan_;
}

#pragma mark - Setting Utilities

-(void)updateSecurity:(NSString*)securityEnabled passcode:(NSString*)passcode {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* settingsEntity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managedObjectContext_];
    [fetchRequest setEntity:settingsEntity];
    NSError* err=nil;
    NSArray* fetchRequestArray = [managedObjectContext_ executeFetchRequest:fetchRequest error:&err];
    
    for (int i=0; i < [fetchRequestArray count]; i++) {
        NSManagedObject* settingsObj = [fetchRequestArray objectAtIndex:i];
        if ([[settingsObj valueForKey:@"keyName"] isEqualToString:@"securityEnabled"]) {
            [settingsObj setValue:securityEnabled forKey:@"keyValue"];
        }
        if ([[settingsObj valueForKey:@"keyName"] isEqualToString:@"passcode"]) {
            [settingsObj setValue:passcode forKey:@"keyValue"];
        }
    }
    
    [self saveContext];
}

#pragma mark - Data Loading

-(void)genData{
    NSEntityDescription* whoEntity = [NSEntityDescription entityForName:@"Who" inManagedObjectContext:[self managedObjectContext]];
    NSEntityDescription* whereEntity = [NSEntityDescription entityForName:@"Where" inManagedObjectContext:[self managedObjectContext]];
    NSEntityDescription* settingsEntity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:[self managedObjectContext]];
    
    NSManagedObject* mystKisser = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
    [mystKisser setValue:[NSNumber numberWithDouble:0.0f] forKey:@"id"];
    [mystKisser setValue:@"¿Mystery Kisser?" forKey:@"name"];
    [mystKisser setValue:@"Kisser unknown" forKey:@"desc"];
    
    NSManagedObject* addWho = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
    [addWho setValue:[NSNumber numberWithDouble:-1.0f] forKey:@"id"];
    [addWho setValue:@"+ Add a new kisser" forKey:@"name"];
    [addWho setValue:@"" forKey:@"desc"];

    NSManagedObject* mystWhere = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
    [mystWhere setValue:[NSNumber numberWithDouble:0.0f] forKey:@"id"];
    [mystWhere setValue:@"¿Mystery Place?" forKey:@"name"];
    [mystWhere setValue:[NSNumber numberWithFloat:0.0f] forKey:@"lat"];
    [mystWhere setValue:[NSNumber numberWithFloat:0.0f] forKey:@"lon"];
    
    NSManagedObject* addWhere = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
    [addWhere setValue:[NSNumber numberWithDouble:-1.0f] forKey:@"id"];
    [addWhere setValue:@"+ Add a new place to kiss" forKey:@"name"];
    [addWhere setValue:[NSNumber numberWithFloat:0.0f] forKey:@"lat"];
    [addWhere setValue:[NSNumber numberWithFloat:0.0f] forKey:@"lon"];

    NSManagedObject* s0 = [NSEntityDescription insertNewObjectForEntityForName:[settingsEntity name] inManagedObjectContext:[self managedObjectContext]];
    [s0 setValue:@"securityEnabled" forKey:@"keyName"];
    [s0 setValue:@"NO" forKey:@"keyValue"];
    
    NSManagedObject* s1 = [NSEntityDescription insertNewObjectForEntityForName:[settingsEntity name] inManagedObjectContext:[self managedObjectContext]];
    [s1 setValue:@"passcode" forKey:@"keyName"];
    [s1 setValue:@"" forKey:@"keyValue"];
    
    NSManagedObject* s2 = [NSEntityDescription insertNewObjectForEntityForName:[settingsEntity name] inManagedObjectContext:[self managedObjectContext]];
    [s2 setValue:@"twitterEnabled" forKey:@"keyName"];
    [s2 setValue:@"NO" forKey:@"keyValue"];
    
    NSManagedObject* s3 = [NSEntityDescription insertNewObjectForEntityForName:[settingsEntity name] inManagedObjectContext:[self managedObjectContext]];
    [s3 setValue:@"twitterName" forKey:@"keyName"];
    [s3 setValue:@"" forKey:@"keyValue"];
    
    NSManagedObject* s4 = [NSEntityDescription insertNewObjectForEntityForName:[settingsEntity name] inManagedObjectContext:[self managedObjectContext]];
    [s4 setValue:@"twitterPass" forKey:@"keyName"];
    [s4 setValue:@"" forKey:@"keyValue"];
    
    NSManagedObject* s5 = [NSEntityDescription insertNewObjectForEntityForName:[settingsEntity name] inManagedObjectContext:[self managedObjectContext]];
    [s5 setValue:@"facebookEnabled" forKey:@"keyName"];
    [s5 setValue:@"NO" forKey:@"keyValue"];
    
    NSManagedObject* s6 = [NSEntityDescription insertNewObjectForEntityForName:[settingsEntity name] inManagedObjectContext:[self managedObjectContext]];
    [s6 setValue:@"facebookName" forKey:@"keyName"];
    [s6 setValue:@"" forKey:@"keyValue"];
    
    NSManagedObject* s7 = [NSEntityDescription insertNewObjectForEntityForName:[settingsEntity name] inManagedObjectContext:[self managedObjectContext]];
    [s7 setValue:@"facebookPass" forKey:@"keyName"];
    [s7 setValue:@"" forKey:@"keyValue"];
    
#ifdef DEBUG
    
    double clicker = 0.0f;
    NSEntityDescription* kissesEntity = [NSEntityDescription entityForName:@"Kisses" inManagedObjectContext:[self managedObjectContext]];
    
    if (_runTime == KSCD_DEBUGDATA) {
        /*
        
        NSManagedObject* jessicadrew = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [jessicadrew setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [jessicadrew setValue:@"Jessica Drew" forKey:@"name"];
        [jessicadrew setValue:@"" forKey:@"desc"];
        
         */
        NSManagedObject* nauticathorn = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [nauticathorn setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [nauticathorn setValue:@"Nautica Thorn" forKey:@"name"];
        [nauticathorn setValue:@"" forKey:@"desc"];
        
        NSManagedObject* agathaharkness = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [agathaharkness setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [agathaharkness setValue:@"Agatha Harkness" forKey:@"name"];
        [agathaharkness setValue:@"witchy woman" forKey:@"desc"];
        
        NSManagedObject* jvd = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [jvd setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [jvd setValue:@"Janet van Dyne" forKey:@"name"];
        [jvd setValue:@"waspy woman" forKey:@"desc"];
        /*
        
        NSManagedObject* j = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [j setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [j setValue:@"Jessica" forKey:@"name"];
        [j setValue:@"" forKey:@"desc"];
        
        NSManagedObject* mk = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [mk setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [mk setValue:@"Misty Knight" forKey:@"name"];
        [mk setValue:@"Tastes like robot?" forKey:@"desc"];
         */
        
        NSManagedObject* EveMendez = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [EveMendez setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [EveMendez setValue:@"Eve Mendez" forKey:@"name"];
        [EveMendez setValue:@"" forKey:@"desc"];
        
        NSManagedObject* EvaAngelina = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [EvaAngelina setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [EvaAngelina setValue:@"Eva Angelina" forKey:@"name"];
        [EvaAngelina setValue:@"BFF!" forKey:@"desc"];
        
        NSManagedObject* Ultron = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [Ultron setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [Ultron setValue:@"Ultron" forKey:@"name"];
        [Ultron setValue:@"" forKey:@"desc"];
        
        NSManagedObject* fc = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [fc setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [fc setValue:@"Francesca \"Captain\" Cook" forKey:@"name"];
        [fc setValue:@"Frankie" forKey:@"desc"];
        
        /*
        NSManagedObject* JessicaWerd = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [JessicaWerd setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [JessicaWerd setValue:@"Jessica Werd" forKey:@"name"];
        [JessicaWerd setValue:@"" forKey:@"desc"];
        
        NSManagedObject* EveArden = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [EveArden setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [EveArden setValue:@"Eve Arden" forKey:@"name"];
        [EveArden setValue:@"Sloppy! Sloppy! Sloppy!" forKey:@"desc"];
        
        NSManagedObject* EvaFerrari = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [EvaFerrari setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [EvaFerrari setValue:@"Eva Ferrari" forKey:@"name"];
        [EvaFerrari setValue:@"The Italian job" forKey:@"desc"];
        
        NSManagedObject* Sara = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [Sara setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [Sara setValue:@"Sara" forKey:@"name"];
        [Sara setValue:@"" forKey:@"desc"];
        
        NSManagedObject* Soleil = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [Soleil setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [Soleil setValue:@"Soleil" forKey:@"name"];
        [Soleil setValue:@"" forKey:@"desc"];
         */
        
        NSManagedObject* ea = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [ea setValue:[NSNumber numberWithDouble:([[NSDate date] timeIntervalSinceReferenceDate]+clicker++)] forKey:@"id"];
        [ea setValue:@"eve arden" forKey:@"name"];
        [ea setValue:@"" forKey:@"desc"];
        
        NSManagedObject* el = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [el setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [el setValue:@"evangeline lilly" forKey:@"name"];
        [el setValue:@"Smoke much?" forKey:@"desc"];
        /*
        
        NSManagedObject* Brunchillda = [NSEntityDescription insertNewObjectForEntityForName:[whoEntity name] inManagedObjectContext:[self managedObjectContext]];
        [Brunchillda setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [Brunchillda setValue:@"Brünchillda" forKey:@"name"];
        [Brunchillda setValue:@"" forKey:@"desc"];
         */
        
        NSManagedObject* theClub = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
        [theClub setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [theClub setValue:@"Gold Club" forKey:@"name"];
        [theClub setValue:[NSNumber numberWithFloat:37.78592773467008f] forKey:@"lat"];
        [theClub setValue:[NSNumber numberWithFloat:-122.39942193031311f] forKey:@"lon"];
        
        NSManagedObject* MayaHouse = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
        [MayaHouse setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [MayaHouse setValue:@"Maya's House" forKey:@"name"];
        [MayaHouse setValue:[NSNumber numberWithFloat:37.82295498023623f] forKey:@"lat"];
        [MayaHouse setValue:[NSNumber numberWithFloat:-122.3718810081482f] forKey:@"lon"];
        
        NSManagedObject* RivieraMaya = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
        [RivieraMaya setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [RivieraMaya setValue:@"Riviera Maya" forKey:@"name"];
        [RivieraMaya setValue:[NSNumber numberWithFloat:20.212f] forKey:@"lat"];
        [RivieraMaya setValue:[NSNumber numberWithFloat:-87.466f] forKey:@"lon"];
        
        NSManagedObject* Marriott = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
        [Marriott setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [Marriott setValue:@"Marriot Suites" forKey:@"name"];
        [Marriott setValue:[NSNumber numberWithFloat:37.60283375930652f] forKey:@"lat"];
        [Marriott setValue:[NSNumber numberWithFloat:-122.37298607826233f] forKey:@"lon"];
        
        /*
        NSManagedObject* parkPlace = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
        [volvo setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [volvo setValue:@"Park Place (in the park)" forKey:@"name"];
        [volvo setValue:[NSNumber numberWithFloat:37.892169f] forKey:@"lat"];
        [volvo setValue:[NSNumber numberWithFloat:-122.272682f] forKey:@"lon"];
         */
        
        NSManagedObject* Ranch = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
        [Ranch setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [Ranch setValue:@"The Ranch" forKey:@"name"];
        [Ranch setValue:[NSNumber numberWithFloat:37.28854f] forKey:@"lat"];
        [Ranch setValue:[NSNumber numberWithFloat:-121.796314f] forKey:@"lon"];
        
        NSManagedObject* tesoro = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
        [tesoro setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [tesoro setValue:@"El Tesoro (back room)" forKey:@"name"];
        [tesoro setValue:[NSNumber numberWithFloat:35.253513f] forKey:@"lat"];
        [tesoro setValue:[NSNumber numberWithFloat:-80.825839f] forKey:@"lon"];

        NSManagedObject* Submarine = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
        [Submarine setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [Submarine setValue:@"Sub Shop" forKey:@"name"];
        [Submarine setValue:[NSNumber numberWithFloat:37.71735f] forKey:@"lat"];
        [Submarine setValue:[NSNumber numberWithFloat:-122.216721f] forKey:@"lon"];

        NSManagedObject* ef = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
        [ef setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [ef setValue:@"Enchanted forest" forKey:@"name"];
        [ef setValue:[NSNumber numberWithFloat:37.88039f] forKey:@"lat"];
        [ef setValue:[NSNumber numberWithFloat:-122.295771f] forKey:@"lon"];
        /*
        
        NSManagedObject* hustler = [NSEntityDescription insertNewObjectForEntityForName:[whereEntity name] inManagedObjectContext:[self managedObjectContext]];
        [hustler setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [hustler setValue:@"The Hustler" forKey:@"name"];
        [hustler setValue:[NSNumber numberWithFloat:37.797483f] forKey:@"lat"];
        [hustler setValue:[NSNumber numberWithFloat:-122.405917f] forKey:@"lon"];
         */
        
        NSMutableSet* mystKisserK = [mystKisser mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* RivieraMayaK = [RivieraMaya mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* jvdK = [jvd mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* MarriottK = [Marriott mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* agathaharknessK = [agathaharkness mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* mystWhereK = [mystWhere mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* fcK = [fc mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* nauticathornK = [nauticathorn mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* theClubK = [theClub mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* EvaAngelinaK = [EvaAngelina mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* MayaHouseK = [MayaHouse mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* UltronK = [Ultron mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* elK = [el mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* eaK = [ea mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* efK = [ef mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* SubmarineK = [Submarine mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* tesoroK = [tesoro mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* RanchK = [Ranch mutableSetValueForKey:@"kissRecord"];
        NSMutableSet* EveMendezK = [EveMendez mutableSetValueForKey:@"kissRecord"];
        
        //9901
        //UIImage* testImage = [UIImage imageNamed:@"WindowPasscode.png"];
        NSData* imageData = UIImagePNGRepresentation([UIImage imageNamed:@"WindowPasscode.png"]);
        
        //NSData* dummyData = [@"dummy" dataUsingEncoding:NSUTF8StringEncoding];
        
        NSManagedObject* k1 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k1 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k1 setValue:[NSNumber numberWithDouble:1314620201.0f] forKey:@"when"];
        [k1 setValue:[NSNumber numberWithInt:0] forKey:@"score"];
        [k1 setValue:@"123456789a123456789b123456789c" forKey:@"desc"];
        [k1 setValue:KSCD_DUMMYIMAGE forKey:@"image"];
        [k1 setValue:mystKisser forKey:@"kissWho"];
        [k1 setValue:RivieraMaya forKey:@"kissWhere"];
        [mystKisserK addObject:k1];
        [RivieraMayaK addObject:k1];
        
        NSManagedObject* k2 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k2 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k2 setValue:[NSNumber numberWithDouble:1314533801.0f] forKey:@"when"];
        [k2 setValue:[NSNumber numberWithInt:1] forKey:@"score"];
        [k2 setValue:@"123456789a123456789b123456789c123456789d" forKey:@"desc"];
        [k2 setValue:KSCD_DUMMYIMAGE forKey:@"image"];
        [k2 setValue:jvd forKey:@"kissWho"];
        [k2 setValue:Marriott forKey:@"kissWhere"];
        [MarriottK addObject:k2];
        [jvdK addObject:k2];
        
        NSManagedObject* k3 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k3 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k3 setValue:[NSNumber numberWithDouble:1312201001.0f] forKey:@"when"];
        [k3 setValue:[NSNumber numberWithInt:2] forKey:@"score"];
        [k3 setValue:@"123456789a123456789b123456789c123456789d123456789e" forKey:@"desc"];
        [k3 setValue:KSCD_DUMMYIMAGE forKey:@"image"];
        [k3 setValue:agathaharkness forKey:@"kissWho"];
        [k3 setValue:mystWhere forKey:@"kissWhere"];
        [mystWhereK addObject:k3];
        [agathaharknessK addObject:k3];
        
        NSManagedObject* k4 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k4 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k4 setValue:[NSNumber numberWithDouble:1312201001.0f] forKey:@"when"];
        [k4 setValue:[NSNumber numberWithInt:3] forKey:@"score"];
        [k4 setValue:@"123456789a123456789b123456789c123456789d123456789e123456789f" forKey:@"desc"];
        [k4 setValue:KSCD_DUMMYIMAGE forKey:@"image"];
        [k4 setValue:mystKisser forKey:@"kissWho"];
        [k4 setValue:RivieraMaya forKey:@"kissWhere"];
        [mystKisserK addObject:k4];
        [RivieraMayaK addObject:k4];
        
        NSManagedObject* k5 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k5 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k5 setValue:[NSNumber numberWithDouble:1312201001.0f] forKey:@"when"];
        [k5 setValue:[NSNumber numberWithInt:4] forKey:@"score"];
        [k5 setValue:@"123456789a123456789b123456789c123456789d123456789e123456789f123456789g" forKey:@"desc"];
        [k5 setValue:KSCD_DUMMYIMAGE forKey:@"image"];
        [k5 setValue:mystKisser forKey:@"kissWho"];
        [k5 setValue:mystWhere forKey:@"kissWhere"];
        [mystKisserK addObject:k5];
        [mystWhereK addObject:k5];
        
        NSManagedObject* k6 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k6 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k6 setValue:[NSNumber numberWithDouble:1312201001.0f] forKey:@"when"];
        [k6 setValue:[NSNumber numberWithInt:5] forKey:@"score"];
        [k6 setValue:@"123456789a123456789b123456789c123456789d123456789e123456789f123456789g123456789h" forKey:@"desc"];
        [k6 setValue:KSCD_DUMMYIMAGE forKey:@"image"];
        [k6 setValue:nauticathorn forKey:@"kissWho"];
        [k6 setValue:theClub forKey:@"kissWhere"];
        [theClubK addObject:k6];
        [nauticathornK addObject:k6];
        
        NSManagedObject* k7 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k7 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k7 setValue:[NSNumber numberWithDouble:1312201001.0f] forKey:@"when"];
        [k7 setValue:[NSNumber numberWithInt:0] forKey:@"score"];
        [k7 setValue:@"123456789a123456789b123456789c123456789d123456789e123456789f123456789g123456789h123456789i" forKey:@"desc"];
        [k7 setValue:KSCD_DUMMYIMAGE forKey:@"image"];
        [k7 setValue:nauticathorn forKey:@"kissWho"];
        [k7 setValue:RivieraMaya forKey:@"kissWhere"];
        [nauticathornK addObject:k7];
        [RivieraMayaK addObject:k7];
        
        NSManagedObject* k8 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k8 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k8 setValue:[NSNumber numberWithDouble:1312489220.0f] forKey:@"when"];
        [k8 setValue:[NSNumber numberWithInt:1] forKey:@"score"];
        [k8 setValue:@"123456789a123456789b123456789c123456789d123456789e123456789f123456789g123456789h123456789i123456789j" forKey:@"desc"];
        [k8 setValue:KSCD_DUMMYIMAGE forKey:@"image"];
        [k8 setValue:EvaAngelina forKey:@"kissWho"];
        [k8 setValue:MayaHouse forKey:@"kissWhere"];
        [MayaHouseK addObject:k8];
        [EvaAngelinaK addObject:k8];
        
        NSManagedObject* k9 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k9 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k9 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]-200000.0f] forKey:@"when"];
        [k9 setValue:[NSNumber numberWithInt:2] forKey:@"score"];
        [k9 setValue:@"123456789a123456789b123456789c123456789d123456789e123456789f123456789g123456789h123456789i123456789j123456789k" forKey:@"desc"];
        [k9 setValue:KSCD_DUMMYIMAGE forKey:@"image"];
        [k9 setValue:fc forKey:@"kissWho"];
        [k9 setValue:MayaHouse forKey:@"kissWhere"];
        [fcK addObject:k9];
        [MayaHouseK addObject:k9];
        
        NSManagedObject* k10 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k10 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k10 setValue:[NSNumber numberWithDouble:1312489220.0f] forKey:@"when"];
        [k10 setValue:[NSNumber numberWithInt:3] forKey:@"score"];
        [k10 setValue:@"123456789a123456789b123456789c123456789d123456789e123456789f123456789g123456789h123456789i123456789j123456789k123456789L" forKey:@"desc"];
        [k10 setValue:imageData forKey:@"image"];
        [k10 setValue:fc forKey:@"kissWho"];
        [k10 setValue:mystWhere forKey:@"kissWhere"];
        [fcK addObject:k10];
        [mystWhereK addObject:k10];
        
        NSManagedObject* k11 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k11 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k11 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]-150000.0f] forKey:@"when"];
        [k11 setValue:[NSNumber numberWithInt:5] forKey:@"score"];
        [k11 setValue:@"123456789a123456789b123456789c123456789d123456789e123456789f123456789g123456789h123456789i123456789j123456789k123456789L123456789m" forKey:@"desc"];
        [k11 setValue:imageData forKey:@"image"];
        [k11 setValue:fc forKey:@"kissWho"];
        [k11 setValue:MayaHouse forKey:@"kissWhere"];
        [MayaHouseK addObject:k11];
        [fcK addObject:k11];
        
        NSManagedObject* k12 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k12 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k12 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]-100000.0f] forKey:@"when"];
        [k12 setValue:[NSNumber numberWithInt:5] forKey:@"score"];
        [k12 setValue:@"123456789a123456789b123456789c123456789d123456789e123456789f123456789g123456789h123456789i123456789j123456789k123456789L123456789m123456789n" forKey:@"desc"];
        [k12 setValue:imageData forKey:@"image"];
        [k12 setValue:nauticathorn forKey:@"kissWho"];
        [k12 setValue:tesoro forKey:@"kissWhere"];
        [nauticathornK addObject:k12];
        [tesoroK addObject:k12];
        
        NSManagedObject* k13 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k13 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k13 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"when"];
        [k13 setValue:[NSNumber numberWithInt:0] forKey:@"score"];
        [k13 setValue:@"Just paying down some debts TODAY" forKey:@"desc"];
        [k13 setValue:imageData forKey:@"image"];
        [k13 setValue:fc forKey:@"kissWho"];
        [k13 setValue:MayaHouse forKey:@"kissWhere"];
        [fcK addObject:k13];
        [MayaHouseK addObject:k13];
        
        NSManagedObject* k14 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k14 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k14 setValue:[NSNumber numberWithDouble:1000000.0f] forKey:@"when"];
        [k14 setValue:[NSNumber numberWithInt:1] forKey:@"score"];
        [k14 setValue:@"123456789a" forKey:@"desc"];
        [k14 setValue:imageData forKey:@"image"];
        [k14 setValue:nauticathorn forKey:@"kissWho"];
        [k14 setValue:ef forKey:@"kissWhere"];
        [nauticathornK addObject:k14];
        [efK addObject:k14];
        
        NSManagedObject* k15 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k15 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k15 setValue:[NSNumber numberWithDouble:1313447521.0f] forKey:@"when"];
        [k15 setValue:[NSNumber numberWithInt:2] forKey:@"score"];
        [k15 setValue:@"OMG THIS WAS SOOOO ROMANTICAL!!! HE HAD BK SLIDERS ALREADY THERE W/HIS OWN BACON!!! LOL XLRG FRIES AND BOTTOMLESS BLIZZARDS!!!  MOUTHFULL!!!" forKey:@"desc"];
        [k15 setValue:imageData forKey:@"image"];
        [k15 setValue:fc forKey:@"kissWho"];
        [k15 setValue:Submarine forKey:@"kissWhere"];
        [SubmarineK addObject:k15];
        [fcK addObject:k15];
        
        NSManagedObject* k16 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k16 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k16 setValue:[NSNumber numberWithInt:1013447521] forKey:@"when"];
        [k16 setValue:[NSNumber numberWithInt:3] forKey:@"score"];
        [k16 setValue:@"FINALLY!!!!!!1111!!!!ONE" forKey:@"desc"];
        [k16 setValue:imageData forKey:@"image"];
        [k16 setValue:Ultron forKey:@"kissWho"];
        [k16 setValue:tesoro forKey:@"kissWhere"];
        [tesoroK addObject:k16];
        [UltronK addObject:k16];
        
        NSManagedObject* k17 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k17 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k17 setValue:[NSNumber numberWithDouble:1313965921.0f] forKey:@"when"];
        [k17 setValue:[NSNumber numberWithInt:4] forKey:@"score"];
        [k17 setValue:@"ZOMG" forKey:@"desc"];
        [k17 setValue:imageData forKey:@"image"];
        [k17 setValue:EvaAngelina forKey:@"kissWho"];
        [k17 setValue:Ranch forKey:@"kissWhere"];
        [RanchK addObject:k17];
        [EvaAngelinaK addObject:k17];
        
        NSManagedObject* k18 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k18 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k18 setValue:[NSNumber numberWithDouble:1314743521.0f] forKey:@"when"];
        [k18 setValue:[NSNumber numberWithInt:5] forKey:@"score"];
        [k18 setValue:@"One of us was a _corpse_!" forKey:@"desc"];
        [k18 setValue:imageData forKey:@"image"];
        [k18 setValue:EveMendez forKey:@"kissWho"];
        [k18 setValue:mystWhere forKey:@"kissWhere"];
        [EveMendezK addObject:k18];
        [mystWhereK addObject:k18];
        
        NSManagedObject* k19 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k19 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k19 setValue:[NSNumber numberWithDouble:1314829921.0f] forKey:@"when"];
        [k19 setValue:[NSNumber numberWithInt:5] forKey:@"score"];
        [k19 setValue:@"This was a massive and irreversable step towards the penultimate expression of a century's lost yearning and belief in sex without contempt" forKey:@"desc"];
        [k19 setValue:imageData forKey:@"image"];
        [k19 setValue:mystKisser forKey:@"kissWho"];
        [k19 setValue:MayaHouse forKey:@"kissWhere"];
        [mystKisserK addObject:k19];
        [MayaHouseK addObject:k19];
        
        NSManagedObject* k20 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k20 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k20 setValue:[NSNumber numberWithDouble:1213965921.0f] forKey:@"when"];
        [k20 setValue:[NSNumber numberWithInt:1] forKey:@"score"];
        [k20 setValue:imageData forKey:@"image"];
        [k20 setValue:@"Too short a bliss!" forKey:@"desc"];
        [k20 setValue:Ultron forKey:@"kissWho"];
        [k20 setValue:Submarine forKey:@"kissWhere"];
        [UltronK addObject:k20];
        [SubmarineK addObject:k20];
        
        NSManagedObject* k21 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k21 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k21 setValue:[NSNumber numberWithDouble:1312201001.0f] forKey:@"when"];
        [k21 setValue:[NSNumber numberWithInt:5] forKey:@"score"];
        [k21 setValue:@"WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" forKey:@"desc"];
        [k21 setValue:imageData forKey:@"image"];
        [k21 setValue:el forKey:@"kissWho"];
        [k21 setValue:RivieraMaya forKey:@"kissWhere"];
        [RivieraMayaK addObject:k21];
        [elK addObject:k21];
        
        NSManagedObject* k22 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k22 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k22 setValue:[NSNumber numberWithDouble:1312351001.0f] forKey:@"when"];
        [k22 setValue:[NSNumber numberWithInt:0] forKey:@"score"];
        [k22 setValue:@"" forKey:@"desc"];
        [k22 setValue:imageData forKey:@"image"];
        [k22 setValue:ea forKey:@"kissWho"];
        [k22 setValue:mystWhere forKey:@"kissWhere"];
        [eaK addObject:k22];
        [mystWhereK addObject:k22];
        
        NSManagedObject* k23 = [NSEntityDescription insertNewObjectForEntityForName:[kissesEntity name] inManagedObjectContext:[self managedObjectContext]];
        [k23 setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceReferenceDate]+clicker++] forKey:@"id"];
        [k23 setValue:[NSNumber numberWithDouble:1310001001.0f] forKey:@"when"];
        [k23 setValue:[NSNumber numberWithInt:3] forKey:@"score"];
        [k23 setValue:@"" forKey:@"desc"];
        [k23 setValue:imageData forKey:@"image"];
        [k23 setValue:agathaharkness forKey:@"kissWho"];
        [k23 setValue:mystWhere forKey:@"kissWhere"];
        [mystWhereK addObject:k23];
        [agathaharknessK addObject:k23];
        
        // Seetings keys are set above, prior to looping, with NO values
        
        // securityEnabled
        [s0 setValue:@"securityEnabled" forKey:@"keyName"];
        [s0 setValue:@"YES" forKey:@"keyValue"];
        
        // passcode
        [s1 setValue:@"passcode" forKey:@"keyName"];
        [s1 setValue:@"8888" forKey:@"keyValue"];
        
        // twitterEnabled
        [s2 setValue:@"twitterEnabled" forKey:@"keyName"];
        [s2 setValue:@"NO" forKey:@"keyValue"];
        
        // twitterName
        [s3 setValue:@"twitterName" forKey:@"keyName"];
        [s3 setValue:@"" forKey:@"keyValue"];

        // twitterPass
        [s4 setValue:@"twitterPass" forKey:@"keyName"];
        [s4 setValue:@"" forKey:@"keyValue"];

        // FBenabled
        [s5 setValue:@"facebookEnabled" forKey:@"keyName"];
        [s5 setValue:@"NO" forKey:@"keyValue"];

        // FBname
        [s6 setValue:@"facebookName" forKey:@"keyName"];
        [s6 setValue:@"" forKey:@"keyValue"];
        
        // FBpass
        [s7 setValue:@"facebookPass" forKey:@"keyName"];
        [s7 setValue:@"" forKey:@"keyValue"];

    }
    
#endif
    
    NSError *err = nil;
    if ([self managedObjectContext] != nil){
        if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&err]){
            NSLog(@"ksCD genData ****    UNRESOLVED ERROR    ****\n%@, %@", err, [err userInfo]);
            abort();
        }
    }
}

-(NSFetchedResultsController*)fetchedResultsController:(int)whichfetch {
    NSString* entityName = @"";
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setFetchBatchSize:24];
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc]init];
    NSString* cache = [NSString stringWithFormat:@"%i",whichfetch];
    
    switch (whichfetch) {
        case KSCD_KISSESBYWHO: {
            // KISSES by NAME by SCORE by WHERE by WHEN
            entityName = @"Kisses";
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"kissWho.name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"score"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"kissWhere.name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"when"
                                                                   ascending:NO]];
        }
            break;
        case KSCD_KISSESBYWHEN: {
            // KISSES by WHEN by SCORE by WHO by WHERE
            entityName = @"Kisses";
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"when"
                                                                   ascending:NO]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"score"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"kissWho.name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"kissWhere.name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
        }
            break;
        case KSCD_KISSESBYSCORE: {
            // KISSES by SCORE by WHO by WHEN by WHERE
            entityName = @"Kisses";
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"score"
                                                                   ascending:NO
                                                                    selector:@selector(caseInsensitiveCompare:)]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"kissWho.name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"when"
                                                                   ascending:NO]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"kissWhere.name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
        }
            break;
        case KSCD_KISSESBYWHERE: {
            // KISSES by WHERE by WHEN by WHO by SCORE
            entityName = @"Kisses";
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"kissWhere.name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"when"
                                                                   ascending:NO]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"kissWho.name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"score"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
        }
            break;
        case KSCD_SETTINGS: {
            entityName = @"Settings";
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"keyName"
                                                                   ascending:NO
                                                                    selector:@selector(caseInsensitiveCompare:)]];
        }
            break;
        case KSCD_WHOBYNAME: {
            entityName = @"Who";
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
        }
            break;
        case KSCD_WHEREBYNAME: {
            entityName = @"Where";
            [sortDescriptors addObject:[[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)]];
        }
            break;
    }

    // w/out this, caches are retained from PREVIOUS RUN, and crap out if objects have been added
    [NSFetchedResultsController deleteCacheWithName:nil];

    // Construct FRC
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController* fRC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                         managedObjectContext:[self managedObjectContext]
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:cache];
    [fRC setDelegate:self];

    // Do the fetching
    NSError* err = nil;
    if (![fRC performFetch:&err]) {
        NSLog(@" ***** ksCD performFetch ***** %@, %@", err, [err userInfo]);
        abort();
    }

    return fRC;
}

@end