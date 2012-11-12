//
//  ksViewController.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/8/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "ksCoreData.h"
#import "ksColorObject.h"
#import "ksAnnotationView.h"
#import "ksKissUtilityView.h"
#import "ksImagePickerViewController.h"
#import "ksKissItemView.h"

#define STATE_KISSER 0
#define STATE_DATE 1
#define STATE_RATING 2
#define STATE_LOCATION 3
#define STATE_PHOTO 4
#define STATE_NEUTRAL 5
#define STATE_ADD 6
#define STATE_EDIT 7
#define STATE_DELETE 8
#define STATE_SECURITY 9
#define STATE_SETTINGS 10

#define KISSER 0
#define DATE 1
#define RATING 2
#define LOCATION 3
#define PHOTO 4

#define MISSINGWHOWHERE 0
#define ADDWHOWHERE 1
#define CONFIRM 2

#define TWITTERBOOK_FACEBOOK 0
#define TWITTERBOOK_TWITTER 1

#define ROOT (ksViewController*)[[[UIApplication sharedApplication] keyWindow] rootViewController]
#define UPTHECHAIN [[[ROOT view] subviews] objectAtIndex:[[[ROOT view] subviews] count] -3]

//#define PHOTO_CELL_SCALE 27.0
//#define NO_PHOTO_CELL_SCALE 35.0

@interface ksViewController : UIViewController <NSFetchedResultsControllerDelegate,
                                                UITableViewDelegate,
                                                UITableViewDataSource,
//UIActionSheetDelegate,
                                                UINavigationControllerDelegate,
                                                MKMapViewDelegate,
                                                CLLocationManagerDelegate,
                                                MFMailComposeViewControllerDelegate,
                                                UIGestureRecognizerDelegate,
                                                UIImagePickerControllerDelegate>

-(void)buildSettingsDictionary;
-(void)buildDataSet;
-(void)enableTopButtons:(BOOL)enable;
-(void)mapUpdate;
-(void)resetMainView;

#pragma mark - @properties

@property (nonatomic, readwrite) float iOSVersion;
@property (nonatomic, readwrite) int state;
@property (nonatomic, retain) NSMutableDictionary* dataDictionary;
@property (nonatomic, retain) NSMutableDictionary* settingsDictionary;
@property (nonatomic, retain) NSArray* fetchedResultsControllerArray;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) NSMutableArray* annotationArray;
//@property (nonatomic, retain) NSArray* cellSizeArray;
@property (nonatomic, retain) NSArray* imageArray;
@property (nonatomic, retain) ksCoreData* ksCD;
@property (nonatomic, retain) ksImagePickerViewController* imagePickerViewController;

@property (nonatomic, retain) IBOutlet UIButton* kisserButton;
@property (nonatomic, retain) IBOutlet UIButton* dateButton;
@property (nonatomic, retain) IBOutlet UIButton* ratingButton;
@property (nonatomic, retain) IBOutlet UIButton* locationButton;
@property (nonatomic, retain) IBOutlet UIButton* photoButton;

@property (nonatomic, retain) IBOutlet UIButton* topLeftButton;
@property (nonatomic, retain) IBOutlet UIButton* topRightButton;
@property (nonatomic, retain) IBOutlet UILabel* topBarLabel;

@property (nonatomic, retain) IBOutlet UIView* mapContainer;

@property (nonatomic, retain) IBOutlet UITableView* mainTableView;
@property (nonatomic, retain) IBOutlet MKMapView* mainMapView;
@property (nonatomic, retain) IBOutlet UIView* mainGalleryView;

@property (nonatomic, retain) IBOutlet UIButton* centerMapButton;

@property (nonatomic, retain) IBOutlet UIImageView* wallpaperView;


@end
