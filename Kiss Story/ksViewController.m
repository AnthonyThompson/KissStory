//
//  ksViewController.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/8/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksViewController.h"
#import "ksAppDelegate.h"

@interface ksViewController ()

@end

@implementation ksViewController

@synthesize ksCD;

#pragma mark - Init Group

-(void)initDataStructures {
    // inits data structures

    ksCD = [[ksCoreData alloc]init];

    // build FRC array
    _fetchedResultsControllerArray = [[NSArray alloc]init];
    NSMutableArray* tempArray = [[NSMutableArray alloc]initWithObjects:nil];
    for (int i = 0; i< 5; i++) {
        [tempArray addObject:[ksCD fetchedResultsController:i]];
    }
    _fetchedResultsControllerArray = tempArray;
    
    // build dataDictionary here
    _dataDictionary = [[NSMutableDictionary alloc]init];
    [self buildDataDictionary];
    
    // build settingsDictionary here
    _settingsDictionary = [[NSMutableDictionary alloc]init];
    [self buildSettingsDictionary];
    
    // build cellSise array here
    _cellSizeArray = [[NSArray alloc]initWithArray:[self buildCellSizeArray]];
    
    // annotationArray
    _annotationArray = [[NSMutableArray alloc]init];
    [self buildAnnotationArray];
    
    //location manager
    [self initLocationManager];
    
    //9901
    // default launch state, may be useful later?
    _state = STATE_NEUTRAL;
}

#pragma mark - Data Build Group

-(void)buildDataDictionary {
    // tabledata for KISSER, DATE, RATING and LOCATION
    for (int i = 0; i < 4; i++) {
        [_dataDictionary setObject:[self headerAndSectionArraysForData:i] forKey:[[NSString alloc]initWithFormat:@"tableData%i",i]];
    }
}

-(void)buildSettingsDictionary {
    for (NSFetchedResultsController* fetched in [[_fetchedResultsControllerArray objectAtIndex:4] fetchedObjects]) {
        NSString* keyString = [[NSString alloc]initWithString:[fetched valueForKey:@"keyName"]];
        NSString* valueString = [[NSString alloc]initWithString:[fetched valueForKey:@"keyValue"]];
        [_settingsDictionary setValue:valueString forKey:keyString];
    }
}

-(NSArray*)headerAndSectionArraysForData:(int)whichData {
    // the current header
    NSString* currentSection = [[NSString alloc]init];
    // the ordered collection of data for the current section
    NSMutableArray* currentSectionDataResults = [[NSMutableArray alloc] init];
    // ordered collection of headers
    NSMutableArray* titles = [[NSMutableArray alloc] init];
    
    // ordered collection of SECTIONS of data
    NSMutableArray* sectionDataCollection = [[NSMutableArray alloc] init];

    // enumerate the fetched objects
    for (NSFetchedResultsController* fetched in [[_fetchedResultsControllerArray objectAtIndex:whichData]fetchedObjects]) {
                
        NSString* titleKey;
                
                switch (whichData) {
                    case KISSER: {
                        // KISSES by NAME
                        // here building a list of kissWho.name initials, and then the records by section based on kissWho.name
                        titleKey = [[[[fetched valueForKey:@"kissWho"]valueForKey:@"name"]substringToIndex:1]uppercaseString];
                    }
                        break;
                    case DATE: {
                        // KISSES by DATE
                        // here building a list of normalized datestrings, and then the records by section based on date category
                        titleKey = [self formatStringForDate:[[NSDate alloc] initWithTimeIntervalSince1970:[[fetched valueForKey:@"when"] doubleValue]] relativeToDate:[NSDate date]];
                    }
                        break;
                    case RATING: {
                        // KISSES by SCORE
                        // integer headers, section by rating
                        titleKey = [[fetched valueForKey:@"score"] stringValue];
                    }
                        break;
                    case LOCATION: {
                        // KISSES by WHERE
                        // name headers, section by whereName
                        titleKey = [[fetched valueForKey:@"kissWhere"]valueForKey:@"name"];
                    }
                        break;
                }
                
                // is this a new title or are we already working on it?
                if (![titleKey isEqualToString:currentSection]) {
                    //it's a new title, so start a new section
                    currentSection = titleKey;
                    
                    // add it to titles
                    [titles addObject:titleKey];
                    
                    // if there already exists data for this section
                    if ([currentSectionDataResults count] > 0) {
                        // we are starting a new section, so save current data to old section
                        [sectionDataCollection addObject:currentSectionDataResults];
                        // zero-out data collector
                        currentSectionDataResults = [[NSMutableArray alloc] init];
                        // add just fetched object to data collector
                        [currentSectionDataResults addObject:fetched];
                    } else {
                        // there does not already exist data for this section
                        [currentSectionDataResults addObject:fetched];
                    }

                } else {
                    // it was NOT a new initial, so add it's data to the current section
                    [currentSectionDataResults addObject:fetched];
                }
            }

    //default for all cases; might have missed the last section contents
    if ([currentSectionDataResults count] > 0) {
        [sectionDataCollection addObject:currentSectionDataResults];
    }

    return @[titles,sectionDataCollection];
}

-(NSArray*)buildCellSizeArray {
    NSMutableArray* returnArray = [[NSMutableArray alloc]init];
    
    // the 3 data sets
    for (int i=0; i < 3;i++) {
        
        // section
        NSMutableArray* sectionArray = [[NSMutableArray alloc]init];
        
        //the number of sections in data set i
        for (int j = 0; j < [[[_dataDictionary valueForKey:[[NSString alloc]initWithFormat:@"tableData%i",i]]objectAtIndex:1] count]; j++) {
            
            NSMutableArray* rowArray = [[NSMutableArray alloc]init];

            // the numbers of rows rows in section j
            for (int k = 0; k < [[[[_dataDictionary valueForKey:[[NSString alloc]initWithFormat:@"tableData%i",i]]objectAtIndex:1]objectAtIndex:j] count]; k++) {
                
                // the data object at data/section/row
                NSManagedObject* manObj = [[[[_dataDictionary valueForKey:[[NSString alloc]initWithFormat:@"tableData%i",i]]objectAtIndex:1]objectAtIndex:j]objectAtIndex:k];

                // 44 seems to work for bodyLabel.width = and Systemfont 13
                int ix = [[manObj valueForKey:@"desc"] length]/44;
                if (ix < (float)[[manObj valueForKey:@"desc"] length]/44.0f) ix++;

                [rowArray addObject:[NSNumber numberWithInt:ix]];
            }
            [sectionArray addObject:rowArray];
        }
        [returnArray addObject:sectionArray];
    }
    return (NSArray*)returnArray;
}

-(void)buildAnnotationArray {
    // kill existing annotationArray
    [_annotationArray removeAllObjects];
    
    // dataDict is two arrays: headers and sections
    // gotta skip headers, so only object at index:1 is interesting
    for (int i = 0; i < [[[_dataDictionary valueForKey:@"tableData3"]objectAtIndex:1]count]; i++) {
        ksMapAnnotation* annotation = [[ksMapAnnotation alloc]init];

        // extract the data beyond the header array (index:1), at the array of fetched objects
        // just need the coord once, and we know that there's always an object at index:0
        NSManagedObject* coordinateObject = [[[[_dataDictionary valueForKey:@"tableData3"]objectAtIndex:1]objectAtIndex:i]objectAtIndex:0];
        
        annotation.coordinate = CLLocationCoordinate2DMake([[[coordinateObject valueForKey:@"kissWhere"]valueForKey:@"lat"]floatValue], [[[coordinateObject valueForKey:@"kissWhere"]valueForKey:@"long"]floatValue]);

        // our temp arrays
        NSMutableArray* IDs = [[NSMutableArray alloc]init];
        NSMutableArray* locations = [[NSMutableArray alloc]init];
        NSMutableArray* kissers = [[NSMutableArray alloc]init];
        NSMutableArray* ratings = [[NSMutableArray alloc]init];
        NSMutableArray* dates = [[NSMutableArray alloc]init];
        NSMutableArray* descriptions = [[NSMutableArray alloc]init];
        
        // now loop through all of the elements and break into separate arrays for ksMapAnnotation storage
        for (int j = 0; j < [[[[_dataDictionary valueForKey:@"tableData3"]objectAtIndex:1]objectAtIndex:i]count]; j ++) {
            NSManagedObject* locationObject = [[[[_dataDictionary valueForKey:@"tableData3"]objectAtIndex:1]objectAtIndex:i]objectAtIndex:j];

            // fill temp arrays
            [IDs addObject:[locationObject valueForKey:@"id"]];
            [locations addObject:[[locationObject valueForKey:@"kissWhere"]valueForKey:@"name"]];
            [kissers addObject:[[locationObject valueForKey:@"kissWho"]valueForKey:@"name"]];
            [ratings addObject:[locationObject valueForKey:@"score"]];
            [dates addObject:[locationObject valueForKey:@"when"]];
            [descriptions addObject:[locationObject valueForKey:@"desc"]];
        }
        
        // add arrays to the ksMapAnnotation object
        annotation.IDArray = [[NSArray alloc]initWithArray:IDs];
        annotation.locationArray = [[NSArray alloc]initWithArray:locations];
        annotation.kisserArray = [[NSArray alloc]initWithArray:kissers];
        annotation.ratingArray = [[NSArray alloc]initWithArray:ratings];
        annotation.dateArray = [[NSArray alloc]initWithArray:dates];
        annotation.descriptionArray = [[NSArray alloc]initWithArray:descriptions];

        // add the ksMapAnnotation to the annotation array
        [_annotationArray addObject:annotation];
    }
}

#pragma mark - Formatting

-(NSString*)formatStringForDate:(NSDate*)forDate relativeToDate:(NSDate*)relativeDate {
    const unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* gregCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* relativeComps = [gregCal components:units fromDate:relativeDate];
    NSDateComponents* forComps = [gregCal components:units fromDate:forDate];
    
    NSString* dateString = [NSString stringWithFormat:@"%i", forComps.year];
    if (relativeComps.year == forComps.year
        && relativeComps.month == forComps.month
        && relativeComps.day == forComps.day) {
        dateString = @"Today";
    } else if (relativeComps.year == forComps.year
               && relativeComps.month == forComps.month
               && (relativeComps.day-forComps.day == 1)) {
        dateString = @"Yesterday";
    } else if (relativeComps.year == forComps.year
               && relativeComps.month == forComps.month) {
        dateString = @"This Month";
    } else if (relativeComps.year == forComps.year
               && (relativeComps.month-forComps.month==1)) {
        dateString = @"Last Month";
    }
    return dateString;
}

#pragma mark - Kisser Action Group

-(IBAction)kisserButtonTapped:(id)sender {
    if (_state == STATE_KISSER)
        return;

    _kisserButton.frame = CGRectMake(0.0f, 416.0f, 64.0f, 64.0f);
    [_kisserButton setImage:[UIImage imageNamed:@"ButtonKisserSelected.png"]
                   forState:UIControlStateNormal];
    _topBarView.image = [UIImage imageNamed:@"TitleKisserCream.png"];
    [self buttonControl:sender];
    
    _mainTableView.hidden = NO;
    _mainMapView.hidden = YES;
    _settingsView.hidden = YES;
    
    _state = STATE_KISSER;
    [_mainTableView reloadData];
    
    // for when it's an empty table
    if ([_mainTableView numberOfSections] > 0
        && [_mainTableView numberOfRowsInSection:0] > 0) {
            [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - Date Action Group

-(IBAction)dateButtonTapped:(id)sender {
    if (_state == STATE_DATE)
        return;

    _dateButton.frame = CGRectMake(64.0f, 416.0f, 64.0f, 64.0f);
    [_dateButton setImage:[UIImage imageNamed:@"ButtonDateSelected.png"]
                 forState:UIControlStateNormal];
    _topBarView.image = [UIImage imageNamed:@"TitleDateCream.png"];
    [self buttonControl:sender];

    _mainTableView.hidden = NO;
    _mainMapView.hidden = YES;
    _settingsView.hidden = YES;
    
    _state = STATE_DATE;
    [_mainTableView reloadData];
    [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Rating Action Group

-(IBAction)ratingButtonTapped:(id)sender {
    if (_state == STATE_RATING)
        return;

    _ratingButton.frame = CGRectMake(128.0f, 416.0f, 64.0f, 64.0f);
    [_ratingButton setImage:[UIImage imageNamed:@"ButtonRatingSelected.png"]
                   forState:UIControlStateNormal];
    _topBarView.image = [UIImage imageNamed:@"TitleRatingCream.png"];
    [self buttonControl:sender];
    
    _mainTableView.hidden = NO;
    _mainMapView.hidden = YES;
    _settingsView.hidden = YES;
    
    _state = STATE_RATING;
    [_mainTableView reloadData];
    [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Location Action Group

-(IBAction)locationButtonTapped:(id)sender {
    if (_state == STATE_LOCATION)
        return;

    _locationButton.frame = CGRectMake(192.0f, 416.0f, 64.0f, 64.0f);
    [_locationButton setImage:[UIImage imageNamed:@"ButtonLocationSelected.png"]
                     forState:UIControlStateNormal];
    _topBarView.image = [UIImage imageNamed:@"TitleLocationCream.png"];
    [self buttonControl:sender];

    _mainMapView.hidden = NO;
    _settingsView.hidden = YES;
    _mainTableView.hidden = YES;
    
    _state = STATE_LOCATION;
}

#pragma mark - Settings Action Group

-(IBAction)settingsButtonTapped:(id)sender {
    if (_state == STATE_SETTINGS)
        return;
    
    _settingsButton.frame = CGRectMake(256.0f, 416.0f, 64.0f, 64.0f);
    [_settingsButton setImage:[UIImage imageNamed:@"ButtonSettingsSelected.png"]
                     forState:UIControlStateNormal];
    _topBarView.image = [UIImage imageNamed:@"TitleSettingsCream.png"];
    _topRightButton.hidden = YES;
    
    /*
    if ([ksSecurityView securityCheck:_settingsDictionary]) {
        _passcodeSwitch.on = YES;
    } else {
        _passcodeSwitch.on = NO;
    }
     */
    
    _passcodeSwitch.on = [ksSecurityView securityCheck:_settingsDictionary];

    [self buttonControl:sender];
    
    _settingsView.hidden = NO;
    _mainMapView.hidden = YES;
    _mainTableView.hidden = YES;

    _state = STATE_SETTINGS;
}

-(IBAction)emailButtonTapped:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        mailer.subject = @"Question or comment about KissStory";
        NSArray *toRecipients = [NSArray arrayWithObjects:@"ksfeedback@geekgamerguy.com",nil];
        mailer.toRecipients = toRecipients;
        [self presentViewController:mailer
                           animated:YES
                         completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Disabled"
                                                        message:@"Your device cannot compose a mail message"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)wwwButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://geekgamerguy.com/gggmobile/"]];
}



#pragma mark - UITableView Group

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([[[_dataDictionary valueForKey:[NSString stringWithFormat:@"tableData%i",_state]]objectAtIndex:0]count]);
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // the header view container, the whole thing
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 20.0f)];
    headerView.backgroundColor = CCO_LIGHT_CREAM;

    // the colored banner w/info
    UIView* headerBanner = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 20.0f)];
    headerBanner.backgroundColor = [[[ksColorObject colorArray]objectAtIndex:(5-(section%5))]objectAtIndex:CCO_BASE];

    // the header text
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(32.0f, 0.0f, headerView.bounds.size.width-44.0f, 18.0f)];
    headerLabel.textColor = CCO_BASE_CREAM;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:14.0f];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.5f);
    headerLabel.text = [[[_dataDictionary valueForKey:[NSString stringWithFormat:@"tableData%i",_state]]objectAtIndex:0]objectAtIndex:section];
    
    // the banner cut-out for the flag look
    UIImageView* headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HeaderBannerOverlay.png"]];
    headerImage.frame = CGRectMake(160.0f, 0.0f, 160.0f, 20.0f);

    // the header icon
    UIImageView* headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 1.0f, 18.0f, 18.0f)];

    switch (_state) {
        case KISSER: {
            headerImageView.image = [UIImage imageNamed:@"IconPersonCream.png"];
        }
            break;
        case DATE: {
            headerImageView.image = [UIImage imageNamed:@"IconDateCream.png"];
        }
            break;
        case RATING: {
            headerImageView.image = [UIImage imageNamed:@""];
            headerLabel.text = @"";
            
            for (int i = 0; i < (5 - section); i++) {
                [headerBanner addSubview:[[UIImageView alloc]initWithFrame:CGRectMake(10.0f + (i*26.0f), 1.0f, 18.0f, 18.0f)]];
                [[[headerBanner subviews] lastObject] setImage:[UIImage imageNamed:@"IconHeartCreamShadow.png"]];
            }
            headerBanner.backgroundColor = [[[ksColorObject colorArray]objectAtIndex:(5 - section)]objectAtIndex:CCO_BASE];
            if ((5-section) == 0) {
                headerBanner.backgroundColor = CCO_LIGHT_GREY;
            }
        }
            break;
    }

    [headerView addSubview:headerBanner];
    [headerView addSubview:headerImageView];
    [headerView addSubview:headerLabel];
    [headerView addSubview:headerImage];

    return headerView;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[NSString alloc]init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([[[[_dataDictionary valueForKey:[NSString stringWithFormat:@"tableData%i",_state]]objectAtIndex:1]objectAtIndex:section]count]);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (67.0f + ([[[[_cellSizeArray objectAtIndex:_state]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] intValue] * 18.0f));
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[NSArray alloc]init];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellID = @"ksCC";
    
    NSManagedObject* manObj = [[[[_dataDictionary valueForKey:[[NSString alloc]initWithFormat:@"tableData%i",_state]]objectAtIndex:1]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;

    [tableView registerNib:[UINib nibWithNibName:@"ksColorCell"
                                          bundle:[NSBundle mainBundle]]
                            forCellReuseIdentifier:cellID];
    ksColorCell* cell = (ksColorCell*)[tableView dequeueReusableCellWithIdentifier:cellID
                                                                      forIndexPath:indexPath];

    [cell colorizeCellWithColor:[[manObj valueForKey:@"score"] intValue] withType:_state];
    
    //This prevents crashes when the table is still scrolling and someone flips to map/settings
    if (_state > RATING) return cell;

    switch (_state) {
        case KISSER: {
            cell.headerLabel.text = [[manObj valueForKey:@"kissWho"] valueForKey:@"name"];
            cell.leftLabel.text = [[manObj valueForKey:@"kissWhere"] valueForKey:@"name"];
            cell.rightLabel.text = [[NSString alloc]initWithFormat:@"%@",[dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:[[manObj valueForKey:@"when"] doubleValue]]]];
        }
            break;
        case DATE: {
            cell.headerLabel.text = [[NSString alloc]initWithFormat:@"%@",[dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:[[manObj valueForKey:@"when"] doubleValue]]]];
            cell.leftLabel.text = [[manObj valueForKey:@"kissWho"] valueForKey:@"name"];
            cell.rightLabel.text = [[manObj valueForKey:@"kissWhere"] valueForKey:@"name"];
            
        }
            break;
        case RATING: {
            cell.headerLabel.text = [[manObj valueForKey:@"kissWho"] valueForKey:@"name"];
            cell.leftLabel.text = [[NSString alloc]initWithFormat:@"%@",[dateFormatter stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:[[manObj valueForKey:@"when"] doubleValue]]]];
            cell.rightLabel.text = [[manObj valueForKey:@"kissWhere"] valueForKey:@"name"];
        }
            break;
    }
    
    for (int i = 0; i< [[manObj valueForKey:@"score"] intValue]; i++){
        [cell.header addSubview:[[UIImageView alloc]initWithFrame:CGRectMake(285.0f - (i * 24.0f), 3.0f, 19.0f, 19.0f)]];
        [[[cell.header subviews] lastObject] setImage:[[[ksColorObject imageArray] objectAtIndex:[[manObj valueForKey:@"score"] intValue]]objectAtIndex:4]];
    }

    cell.bodyLabel.text = [manObj valueForKey:@"desc"];
    
    int size = [[[[_cellSizeArray objectAtIndex:_state]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] intValue];
    
    // bodylabel is itself and new height
    cell.bodyLabel.frame = CGRectMake(cell.bodyLabel.frame.origin.x, cell.bodyLabel.frame.origin.y, cell.bodyLabel.frame.size.width, (size * 18.0f));
    
    // container is itself and height + 58 + bodyLabel height
    cell.container.frame = CGRectMake(cell.container.frame.origin.x, cell.container.frame.origin.y, cell.container.frame.size.width, 58.0f + cell.bodyLabel.frame.size.height);
    
    // inliner is itself and height + container height - 2
    cell.inliner.frame = CGRectMake(cell.inliner.frame.origin.x, cell.inliner.frame.origin.y, cell.inliner.frame.size.width, cell.container.frame.size.height - 2.0f);

    return cell;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //9901
    
    // opens the individual kiss view
    return indexPath;
}

#pragma mark - Map Group

-(void)initLocationManager {
    // initializes location manager and tunes services at startup
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [_locationManager startMonitoringSignificantLocationChanges];
}

-(MKCoordinateRegion)getMapRegion {
    //9901
    // IS THIS NECCESSARY?  DOES THE DEFAULT NOT TIGHTEN TO ALL ANNOTATIONS?
    // tightens the view region
    
    // The min is set to the max, and the max is set to the min, so that the locations can re-set them, and we'll know...
    double minLat=360.0f,minLon=360.0f;
    double maxLat=-360.0f,maxLon=-360.0f;
    
    for (ksMapAnnotation* annotation in [_mainMapView annotations]) {
        if (annotation.coordinate.latitude < minLat) minLat = annotation.coordinate.latitude;
        if (annotation.coordinate.latitude > maxLat) maxLat = annotation.coordinate.latitude;
        if (annotation.coordinate.longitude < minLon) minLon = annotation.coordinate.longitude;
        if (annotation.coordinate.longitude > maxLon) maxLon = annotation.coordinate.longitude;
    }
    
    // if the mins are maxed or the maxes are minned, then they were not set by annotations; therefore, manually adjust to a reasonable window
    if (minLat == 360.0f) minLat = -89.0f;
    if (maxLat == -360.0f) maxLat = 89.0f;
    if (minLon == 360.0f) minLon = -89.0f;
    if (maxLon == -360.0f) maxLon = 89.0f;
    
    // center map on lat/long
    CLLocation* newCenter = [[CLLocation alloc] initWithLatitude: (maxLat+minLat)/2.0f longitude: (maxLon+minLon)/2.0f];
    
    // This is to accommodate the annotation at all zoom levels...
    // it's half the minUnit * times the zoom level of minUnits per *Span
    // the half the minunit is to accomiodate the height of the annotation...
    //9901 THIS WILL BE ADJUST TO THE SIZE OF THE ANNOTATION...
    float latSpan = fabs(maxLat-minLat);
    float lonSpan = fabs(maxLon-minLon);
    
    double minUnit = 0.025f;
    
    if (lonSpan < minUnit) lonSpan = minUnit;

    if (latSpan < minUnit) {
        latSpan = minUnit;
    } else {
        latSpan += ((minUnit/2.0f)*(latSpan/minUnit));
        if (latSpan > 178.0f) latSpan = 178.0f;
    }

    return MKCoordinateRegionMake(newCenter.coordinate, MKCoordinateSpanMake(latSpan, lonSpan));
}


-(void)annotateMap {
    // kill all existing annotations
    [_mainMapView removeAnnotations:_annotationArray];

    // add all annotations
    [_mainMapView addAnnotations:_annotationArray];
}

-(ksAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    ksAnnotationView* annotationView = [[ksAnnotationView alloc]initWithAnnotation:(ksMapAnnotation*)annotation reuseIdentifier:@"resuableIdentifier"];

    // I guess we don't want to annotate user location?
    if (![annotation isMemberOfClass:[ksMapAnnotation class]]) {
        return nil;
    }

    annotationView.image = [[[ksColorObject imageArray]objectAtIndex:[(ksMapAnnotation*)annotation color]]objectAtIndex:CCO_PIN];
    
    if ([annotation isMemberOfClass:[MKUserLocation class]]) {
        annotationView.image = [UIImage imageNamed:@"IconHeartRedShadow.png"];
    }
    
    //9901
    //re-size on fly or re-build image?
    //mAV.frame = CGRectMake(mAV.bounds.origin.x, mAV.bounds.origin.y, mAV.frame.size.width/1.5f, mAV.frame.size.height/1.5f);
    
    annotationView.canShowCallout = YES;
    
    // the image is normally centered itself on the point, so offset for the size of the image itself
    // move it up by half the size
    int offSetHeight = annotationView.image.size.height/-2;
    //move it right by 2/3 because of drop shadow, et al
    int offSetWidth = annotationView.image.size.width/2/3;
    annotationView.centerOffset = CGPointMake(offSetWidth,offSetHeight);
    return annotationView;
}


#pragma mark - TwitterBook Group

-(void)displayTwitterBookView:(int)whichView {
    switch (whichView) {
        case TWITTERBOOK_FACEBOOK: {
            _twitterBookLabel.text = @"Facebook Identity";
            _unameLabel.text = @"Facebook User Name";
            _pwordLabel.text = @"Facebook Password";
            _unameField.text = [_settingsDictionary valueForKey:@"facebookName"];
            _pwordField.text = [_settingsDictionary valueForKey:@"facebookPass"];
            _twitterBookSaveButton.tag = TWITTERBOOK_FACEBOOK;
            _twitterBookCancelButton.tag = TWITTERBOOK_FACEBOOK;
        }
            break;
        case TWITTERBOOK_TWITTER: {
            _twitterBookLabel.text = @"Twitter Identity";
            _unameLabel.text = @"Twitter User Name";
            _pwordLabel.text = @"Twitter Password";
            _unameField.text = [_settingsDictionary valueForKey:@"twitterName"];
            _pwordField.text = [_settingsDictionary valueForKey:@"twitterPass"];
            _twitterBookSaveButton.tag = TWITTERBOOK_TWITTER;
            _twitterBookCancelButton.tag = TWITTERBOOK_TWITTER;
        }
            break;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        _twitterBookView.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
    }];
}

-(IBAction)twitterbookCancelButtonTapped:(id)sender {
    switch ([sender tag]) {
        case TWITTERBOOK_FACEBOOK: {
            if ([_facebookSwitch isOn]) {
                _facebookSwitch.on = NO;
            } else {
                _facebookSwitch.on = YES;
            }
        }
            break;
        case TWITTERBOOK_TWITTER: {
            if ([_twitterSwitch isOn]) {
                _twitterSwitch.on = NO;
            } else {
                _twitterSwitch.on = YES;
            }
        }
            break;
    }
    [self dismissTwitterBookView];
}

-(IBAction)twitterbookSaveButtonTapped:(id)sender {
    switch ([sender tag]) {
        case TWITTERBOOK_FACEBOOK: {
            //[appDelegate openSessionWithAllowLoginUI:YES];
            NSLog(@"FB");
            ksAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [appDelegate openSessionWithAllowLoginUI:YES];
        }
            break;
        case TWITTERBOOK_TWITTER: {
            
        }
            break;
    }
    
    //test login
    // if pass then save & dismiss
    // if fail then error message
}

-(void)dismissTwitterBookView {
    [UIView animateWithDuration:0.5f animations:^{
        _twitterBookView.frame = CGRectMake(0.0, 430.0, 320.0, 386.0);
    }];
}

#pragma mark - Twitter Group

-(IBAction)twitterSwitchSwitched:(id)sender {
    if ([(UISwitch*)sender isOn]) {
        // was off, is now ON
        [self displayTwitterBookView:TWITTERBOOK_TWITTER];
    } else {
        // was on, is now OFF
        // set the bit off
    }
}

#pragma mark - Facebook Group

-(IBAction)facebookSwitchSwitched:(id)sender {
    ksAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
        [sender setOn:NO];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
        [sender setOn:YES];
    }
}

#pragma mark - Top Button Action Group

-(IBAction)topLeftButtonTapped:(id)sender {
    switch (_state) {
        case STATE_ADD: {
            _topLeftButton.hidden = YES;
            [_topRightButton setImage:[UIImage imageNamed:@"ButtonHeaderPlus.png"] forState:UIControlStateNormal];

            [UIView animateWithDuration:0.5f animations:^{
                [[[self.view subviews] lastObject] setFrame:CGRectMake(0.0f, 480.0f, 320.0f, 436.0f)];
            }
            completion:^(BOOL finished){
                [[[self.view subviews] lastObject] removeFromSuperview];
            }];

            _state = STATE_KISSER;
        }
    }
}

-(IBAction)topRightButtonTapped:(id)sender {
    switch(_state) {
        case STATE_KISSER:
        case STATE_DATE:
        case STATE_RATING:
        case STATE_LOCATION:
        case STATE_SETTINGS: {
            // add kiss
            _state = STATE_ADD;
            
            _topBarView.image = [UIImage imageNamed:@"TitleAddKissCream.png"];
            [_topLeftButton setImage:[UIImage imageNamed:@"ButtonHeaderCancel.png"] forState:UIControlStateNormal];
            [_topRightButton setImage:[UIImage imageNamed:@"ButtonHeaderSave.png"] forState:UIControlStateNormal];
            _topRightButton.hidden = NO;
            _topLeftButton.hidden = NO;

            [self.view addSubview:[[ksKissUtilityView alloc]initForState:_state withData:_dataDictionary]];

            [UIView animateWithDuration:0.5f animations:^{
                [[[self.view subviews] lastObject] setFrame:CGRectMake(0.0f, 44.0f, 320.0f, 436.0f)];
            }];
        }
            break;
        case STATE_ADD: {
            // save & dismiss utlity view
            _topLeftButton.hidden = YES;
            _topRightButton.hidden = NO;
            [_topRightButton setImage:[UIImage imageNamed:@"ButtonHeaderPlus.png"] forState:UIControlStateNormal];

            [UIView animateWithDuration:0.5f animations:^{
                [[[self.view subviews] lastObject] setFrame:CGRectMake(0.0f, 480.0f, 320.0f, 436.0f)];
            }
                             completion:^(BOOL finished){
                                 [[[self.view subviews] lastObject] removeFromSuperview];
                             }];
            
            _state = STATE_KISSER;
        }
            break;
    }
}

#pragma mark - Passcode Action Group

-(IBAction)passcodeSwitchSwitched:(id)sender {
    if ([(UISwitch*)sender isOn]) {
        // was off, is now ON, so set a new passcode
        [self.view addSubview:[[ksSecurityView alloc]initForProcess:SEC_PROCESS_SETNEW withData:_settingsDictionary]];
    } else {
        // was on, is now OFF, so disable current passcode
        [self.view addSubview:[[ksSecurityView alloc]initForProcess:SEC_PROCESS_DISABLE withData:_settingsDictionary]];
    }
}

#pragma mark - GUI control

-(void)initGuiObjects {
    [_kisserButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    _topLeftButton.hidden = YES;
    _mainMapView.delegate = self;
    
    _facebookSwitch.on = NO;
    if ([[_settingsDictionary valueForKey:@"facebookEnabled"] isEqualToString:@"YES"]) {
        _facebookSwitch.on = YES;
    }
    
    _twitterSwitch.on = NO;
    if ([[_settingsDictionary valueForKey:@"twitterEnabled"] isEqualToString:@"YES"]) {
        _twitterSwitch.on = YES;
    }

    _wallpaperView.alpha = 1.0f;
    
    _twitterBookView.frame = CGRectMake(0.0, 480.0, 320.0, 480.0);
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.clipsToBounds = YES;
    [_mainTableView reloadData];
    
    _mainMapView.showsUserLocation = YES;

    [self annotateMap];

    _bigVersionLabel.text = [[NSString alloc]initWithFormat:@"%@ v%@.%@%@",
                              [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"],
                              [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"],
                              [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey],
#ifdef DEBUG
                              @"d"
#else
                              @""
#endif
                              ];
    _littleVersionLabel.text = [[NSString alloc]initWithFormat:@"%@ logo and app are\n© 2012 Geek Gamer Guy Mobile LLC\nAll rights reserved",
                                 [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"]];
}

-(void)buttonControl:(id)sender {
    if ([sender tag] != KISSER ) {
        _kisserButton.frame = CGRectMake(0.0f, 430.0f, 64.0f, 50.0f);
        [_kisserButton setImage:[UIImage imageNamed:@"ButtonKisserUnselected.png"]
                       forState:UIControlStateNormal];
    }
    
    if ([sender tag] != DATE ) {
        _dateButton.frame = CGRectMake(64.0f, 430.0f, 64.0f, 50.0f);
        [_dateButton setImage:[UIImage imageNamed:@"ButtonDateUnselected.png"]
                     forState:UIControlStateNormal];
    }
    
    if ([sender tag] != RATING ) {
        _ratingButton.frame = CGRectMake(128.0f, 430.0f, 64.0f, 50.0f);
        [_ratingButton setImage:[UIImage imageNamed:@"ButtonRatingUnselected.png"]
                       forState:UIControlStateNormal];
    }
    
    if ([sender tag] != LOCATION ) {
        _locationButton.frame = CGRectMake(192.0f, 430.0f, 64.0f, 50.0f);
        [_locationButton setImage:[UIImage imageNamed:@"ButtonLocationUnselected.png"]
                         forState:UIControlStateNormal];
    }
    
    if ([sender tag] != 4 ) {
        _settingsButton.frame = CGRectMake(256.0f, 430.0f, 64.0f, 50.0f);
        [_settingsButton setImage:[UIImage imageNamed:@"ButtonSettingsUnselected.png"]
                         forState:UIControlStateNormal];
        _topRightButton.hidden = NO;
    }
}

-(void)viewCameAlive {
    if ([ksSecurityView securityCheck:_settingsDictionary]) {
        [self.view addSubview:[[ksSecurityView alloc]initForProcess:SEC_PROCESS_RUNTIMELOGIN withData:_settingsDictionary]];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            _wallpaperView.alpha = 0.0f;
        }];
    }
}

#pragma mark - VC super class

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        [self initDataStructures];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGuiObjects];
    [self viewCameAlive];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            //NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
