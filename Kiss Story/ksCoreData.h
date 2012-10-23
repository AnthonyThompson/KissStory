//
//  ksCoreData.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/8/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// Core Data control
#define KSCD_NODATA 0
#define KSCD_DATA 1
#define KSCD_DEBUGDATA 2
#define KSCD_DATA_PATH_NAME @"/KissStory.sqlite"
#define KSCD_DATA_FILE_NAME @"KissStory.sqlite"
#define KSCD_WHOBYNAME 0
#define KSCD_KISSESBYWHEN 1
#define KSCD_KISSESBYSCORE 2
#define KSCD_WHEREBYNAME 3
#define KSCD_SETTINGS 4

@interface ksCoreData : NSObject <NSFetchedResultsControllerDelegate> {
    
@private
    NSManagedObjectContext* managedObjectContext_;
    NSManagedObjectModel* managedObjectModel_;
    NSPersistentStoreCoordinator* persistentStoreCoordinator_;
    
    NSURL* storeURL_;
    NSString* storePath_;
    NSFileManager* fileMan_;
}

@property (nonatomic, readonly, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, readonly, retain) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, readonly, retain) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic, readwrite) int runTime;

@property (nonatomic, readonly, retain) NSURL* storeURL;
@property (nonatomic, readonly, retain) NSString* storePath;
@property (nonatomic, readonly, retain) NSFileManager* fileMan;

-(void)genData;
-(NSFetchedResultsController*)fetchedResultsController:(int)whichfetch;
-(void)saveContext;
-(void)updateSecurity:(NSString*)securityEnabled passcode:(NSString*)passcode;

@end
