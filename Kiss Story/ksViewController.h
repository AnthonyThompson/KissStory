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
#import "ksSecurity.h"
#import "ksMapAnnotation.h"
#import "ksAnnotationView.h"

#define STATE_KISSER 0
#define STATE_DATE 1
#define STATE_RATING 2
#define STATE_LOCATION 3
#define STATE_SETTINGS 4
#define STATE_NEUTRAL 5
#define STATE_SECURITY 6

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
                                                UIPickerViewDelegate,
                                                UINavigationControllerDelegate,
//UIPickerViewDataSource,
                                                UITextFieldDelegate,
                                                MKMapViewDelegate,
                                                CLLocationManagerDelegate,
                                                MFMailComposeViewControllerDelegate> {
}


/*
#pragma mark - UIPickerViewDelegate

-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component;
 */

#pragma mark - Inits

-(void)initDataStructures;

#pragma mark - GUI Control

-(void)initGuiObjects;
-(void)buttonControl:(id)sender;
-(void)dismissSettingsView;
-(void)viewCameAlive;
-(void)displayTwitterBookView:(int)whichView;
-(void)dismissTwitterBookView;

#pragma mark - Data Creation

-(NSArray*)headerAndSectionArraysForData:(int)whichData;
-(void)buildSettingsDictionary;
-(void)buildDataDictionary;

#pragma mark - IBActions

-(IBAction)kisserButtonTapped:(id)sender;
-(IBAction)dateButtonTapped:(id)sender;
-(IBAction)ratingButtonTapped:(id)sender;
-(IBAction)locationButtonTapped:(id)sender;
-(IBAction)settingsButtonTapped:(id)sender;
-(IBAction)topLeftButtonTapped:(id)sender;
-(IBAction)topRightButtonTapped:(id)sender;

-(IBAction)emailButtonTapped:(id)sender;
-(IBAction)wwwButtonTapped:(id)sender;
-(IBAction)facebookSwitchSwitched:(id)sender;
-(IBAction)twitterSwitchSwitched:(id)sender;
-(IBAction)passcodeSwitchSwitched:(id)sender;

-(IBAction)twitterbookSaveButtonTapped:(id)sender;
-(IBAction)twitterbookCancelButtonTapped:(id)sender;

#pragma mark - UItableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView;
-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - MFMailComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

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

@property (nonatomic, retain) IBOutlet ksSecurity* ksSecure;

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

@property (nonatomic, retain) IBOutlet UIImageView* wallpaperView;

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


@end
