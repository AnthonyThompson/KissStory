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
#import "ksColorCell.h"
#import "ksSecurityView.h"
#import "ksMapAnnotation.h"
#import "ksAnnotationView.h"
#import "ksKissUtilityView.h"

#define STATE_KISSER 0
#define STATE_DATE 1
#define STATE_RATING 2
#define STATE_LOCATION 3
#define STATE_SETTINGS 4
#define STATE_NEUTRAL 5
#define STATE_ADD 6
#define STATE_EDIT 7
#define STATE_DELETE 8
#define STATE_SECURITY 9

#define KISSER 0
#define DATE 1
#define RATING 2
#define LOCATION 3

#define TWITTERBOOK_FACEBOOK 0
#define TWITTERBOOK_TWITTER 1

@interface ksViewController : UIViewController <NSFetchedResultsControllerDelegate,
                                                UITableViewDelegate,
                                                UITableViewDataSource,
                                                UIActionSheetDelegate,
                                                UINavigationControllerDelegate,
                                                UITextFieldDelegate,
                                                MKMapViewDelegate,
                                                CLLocationManagerDelegate,
                                                MFMailComposeViewControllerDelegate> {
}

-(void)buildSettingsDictionary;

#pragma mark - @properties

@property (nonatomic, retain) ksCoreData* ksCD;
@property (nonatomic, retain) NSMutableDictionary* dataDictionary;
@property (nonatomic, retain) NSMutableDictionary* settingsDictionary;
@property (nonatomic, retain) NSArray* fetchedResultsControllerArray;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) NSMutableArray* annotationArray;
@property (nonatomic, readwrite) float iOSVersion;
@property (nonatomic, readwrite) int state;
@property (nonatomic, retain) NSArray* cellSizeArray;

@property (nonatomic, retain) IBOutlet UIButton* kisserButton;
@property (nonatomic, retain) IBOutlet UIButton* dateButton;
@property (nonatomic, retain) IBOutlet UIButton* ratingButton;
@property (nonatomic, retain) IBOutlet UIButton* locationButton;
@property (nonatomic, retain) IBOutlet UIButton* settingsButton;

@property (nonatomic, retain) IBOutlet UIImageView* topBarView;
@property (nonatomic, retain) IBOutlet UIButton* topLeftButton;
@property (nonatomic, retain) IBOutlet UIButton* topRightButton;

@property (nonatomic, retain) IBOutlet UIView* settingsView;
@property (nonatomic, retain) IBOutlet UILabel* bigVersionLabel;
@property (nonatomic, retain) IBOutlet UILabel* littleVersionLabel;
@property (nonatomic, retain) IBOutlet UISwitch* facebookSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* twitterSwitch;
@property (nonatomic, retain) IBOutlet UISwitch* passcodeSwitch;
@property (nonatomic, retain) IBOutlet UIButton* wwwButton;
@property (nonatomic, retain) IBOutlet UIButton* emailButton;

@property (nonatomic, retain) IBOutlet UIView* twitterBookView;
@property (nonatomic, retain) IBOutlet UILabel* twitterBookLabel;
@property (nonatomic, retain) IBOutlet UILabel* unameLabel;
@property (nonatomic, retain) IBOutlet UILabel* pwordLabel;
@property (nonatomic, retain) IBOutlet UITextField* unameField;
@property (nonatomic, retain) IBOutlet UITextField* pwordField;
@property (nonatomic, retain) IBOutlet UIButton* twitterBookSaveButton;
@property (nonatomic, retain) IBOutlet UIButton* twitterBookCancelButton;

@property (nonatomic, retain) IBOutlet UITableView* mainTableView;
@property (nonatomic, retain) IBOutlet MKMapView* mainMapView;
@property (nonatomic, retain) IBOutlet UIButton* centerMapButton;

@property (nonatomic, retain) IBOutlet UIImageView* wallpaperView;


@end
