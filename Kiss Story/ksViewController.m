//
//  ksViewController.m
//  Kiss Story
//
//  Created by Anthony Thompson on 10/8/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import "ksViewController.h"
#import "ksAppDelegate.h"
#import "ksSettingsView.h"
#import "ksSecurityView.h"

@implementation ksViewController

@synthesize ksCD;
@synthesize topRightButton = _topRightButton;
@synthesize topLeftButton = _topLeftButton;

#pragma mark - Init Group

-(void)initDataStructures {
    // inits data structures

    ksCD = [[ksCoreData alloc]init];

    _fetchedResultsControllerArray = [[NSArray alloc]init];
    _dataDictionary = [[NSMutableDictionary alloc]init];
    _settingsDictionary = [[NSMutableDictionary alloc]init];
    _annotationArray = [[NSMutableArray alloc]init];

    [self initLocationManager];
    [self buildDataSet];

    _state = STATE_NEUTRAL;
}

-(void)buildDataSet {
    NSMutableArray* tempArray = [[NSMutableArray alloc]initWithObjects:nil];
    for (int i = 0; i< 5; i++) {
        [tempArray addObject:[ksCD fetchedResultsController:i]];
    }
    _fetchedResultsControllerArray = tempArray;
    
    [self buildDataDictionary];
    [self buildSettingsDictionary];
    //_cellSizeArray = [[NSArray alloc]initWithArray:[self buildCellSizeArray]];
    _imageArray = [[NSArray alloc]initWithArray:[self buildImageArray]];
    [self buildAnnotationArray];
}

#pragma mark - GUI control

-(void)initGuiObjects {
    [_kisserButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    _mainMapView.delegate = self;
    
    _wallpaperView.alpha = 1.0f;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.clipsToBounds = YES;

    _mainMapView.showsUserLocation = YES;
    [self mapUpdate];
}

-(void)mapUpdate {
    [self annotateMap];
    _mainMapView.region = [self getMapRegion];
}

-(void)buttonControl:(id)sender {
    if ([sender tag] != KISSER ) {
        _kisserButton.frame = CGRectMake(0.0f, 440.0f, 64.0f, 40.0f);
        [_kisserButton setImage:[UIImage imageNamed:@"ButtonKisserUnselected.png"]
                       forState:UIControlStateNormal];
    }
    
    if ([sender tag] != DATE ) {
        _dateButton.frame = CGRectMake(64.0f, 440.0f, 64.0f, 40.0f);
        [_dateButton setImage:[UIImage imageNamed:@"ButtonDateUnselected.png"]
                     forState:UIControlStateNormal];
    }
    
    if ([sender tag] != RATING ) {
        _ratingButton.frame = CGRectMake(128.0f, 440.0f, 64.0f, 40.0f);
        [_ratingButton setImage:[UIImage imageNamed:@"ButtonRatingUnselected.png"]
                       forState:UIControlStateNormal];
    }
    
    if ([sender tag] != LOCATION ) {
        _locationButton.frame = CGRectMake(192.0f, 440.0f, 64.0f, 40.0f);
        [_locationButton setImage:[UIImage imageNamed:@"ButtonLocationUnselected.png"]
                         forState:UIControlStateNormal];
    }
    
    if ([sender tag] != PHOTO ) {
        _photoButton.frame = CGRectMake(256.0f, 440.0f, 64.0f, 40.0f);
        [_photoButton setImage:[UIImage imageNamed:@"ButtonPhotoUnselected.png"]
                         forState:UIControlStateNormal];
    }
}

-(void)mainViewDisplay:(id)sender {
    _mainTableView.hidden = YES;
    _mapContainer.hidden = YES;
    _mainGalleryView.hidden = YES;
    
    [sender setHidden:NO];
}

-(void)viewCameAlive {
    if ([ksSecurityView securityCheck:_settingsDictionary]) {
        _wallpaperView.alpha = 0.0f;
        ksSecurityView* securityView = [[ksSecurityView alloc]initForProcess:SEC_PROCESS_RUNTIMELOGIN withData:_settingsDictionary];
        [securityView displaySecurityView];
    } else {
        // fade-out privacy filter
        [UIView animateWithDuration:0.5f animations:^{
            _wallpaperView.alpha = 0.0f;
        }];
    }
}

-(void)resetMainView {
    [_topLeftButton setImage:[UIImage imageNamed:@"ButtonHeaderGear.png"] forState:UIControlStateNormal];
    [_topRightButton setImage:[UIImage imageNamed:@"ButtonHeaderPlus.png"] forState:UIControlStateNormal];
    
    //9901 this does not sufficiently track prior-to-edit/delete state
    int tempState = _state;
    tempState = STATE_KISSER;
    _state = STATE_NEUTRAL;
    switch (tempState) {
        case STATE_KISSER: {
            [_kisserButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case STATE_DATE: {
            [_dateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case STATE_RATING: {
            [_ratingButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case STATE_LOCATION: {
            [_locationButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case STATE_PHOTO: {
            [_photoButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
            break;
    }
    
    [_mainTableView reloadData];
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

-(NSArray*)buildImageArray {
    NSMutableArray* returnArray = [[NSMutableArray alloc]init];
    
    for (NSManagedObject* managedObject in [[_fetchedResultsControllerArray objectAtIndex:0]fetchedObjects]) {
        [returnArray addObject:[managedObject valueForKey:@"image"]];
    }

    return (NSArray*)returnArray;
}

-(void)buildAnnotationArray {
    // kill existing annotationArray
    [_annotationArray removeAllObjects];
    
    // dataDict is two arrays: headers and sections
    // gotta skip headers, so only object at index:1 is interesting
    int dataIndex = 1;
    for (int i = 0; i < [[[_dataDictionary valueForKey:@"tableData3"]objectAtIndex:dataIndex]count]; i++) {
        ksAnnotationView* annotation = [[ksAnnotationView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 37.0f, 39.0f)];

        // extract the data beyond the header array (index:1), at the array of fetched objects
        // just need the coord & title once, and we know that there's always an object at index:0
        NSManagedObject* locationObject = [[[[_dataDictionary valueForKey:@"tableData3"]objectAtIndex:1]objectAtIndex:i]objectAtIndex:0];
        
        annotation.coordinate = CLLocationCoordinate2DMake([[[locationObject valueForKey:@"kissWhere"]valueForKey:@"lat"]floatValue], [[[locationObject valueForKey:@"kissWhere"]valueForKey:@"lon"]floatValue]);
        annotation.title = [[locationObject valueForKey:@"kissWhere"]valueForKey:@"name"];
        
        //9901
        // this is a 0,0 location discriminator, won't be needed after data is purged?
        if (!((annotation.coordinate.latitude == 0.0f) && (annotation.coordinate.longitude == 0.0f))) {

            NSMutableArray* kisses = [[NSMutableArray alloc]init];

            // now loop through kisses at this location and array them
            for (int j = 0; j < [[[[_dataDictionary valueForKey:@"tableData3"]objectAtIndex:1]objectAtIndex:i]count]; j ++) {
                [kisses addObject:(NSManagedObject*)[[[[_dataDictionary valueForKey:@"tableData3"]objectAtIndex:1]objectAtIndex:i]objectAtIndex:j]];
            }
            // add array to the ksAnnotationView object
            annotation.kissArray = kisses;

            // add the ksAnnotationView to the annotation array
            [_annotationArray addObject:annotation];
        }
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

#pragma mark - Top Button Action Group

-(IBAction)topLeftButtonTapped:(id)sender {
    switch (_state) {
        case STATE_KISSER:
        case STATE_DATE:
        case STATE_RATING:
        case STATE_LOCATION:
        case STATE_PHOTO: {
            // gear button/settings
            ksSettingsView* settingsView = [[ksSettingsView alloc]init];
            [settingsView displaySettingsView];
        }
            break;
        case STATE_EDIT:
        case STATE_ADD: {
            // cancelled
            if ([[[self.view subviews] lastObject] dismissUtilityViewWithSave:NO]) {
                [_topLeftButton setImage:[UIImage imageNamed:@"ButtonHeaderGear.png"] forState:UIControlStateNormal];
                [_topRightButton setImage:[UIImage imageNamed:@"ButtonHeaderPlus.png"] forState:UIControlStateNormal];
                [_kisserButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            _state = STATE_KISSER;
        }
            break;
    }
}

-(IBAction)topRightButtonTapped:(id)sender {
    switch(_state) {
        case STATE_KISSER:
        case STATE_DATE:
        case STATE_RATING:
        case STATE_LOCATION:
        case STATE_PHOTO: {
            // add a new kiss
            _state = STATE_ADD;
            _topBarLabel.text = @"Add A Kiss";
            [_topLeftButton setImage:[UIImage imageNamed:@"ButtonHeaderCancel.png"] forState:UIControlStateNormal];
            [_topRightButton setImage:[UIImage imageNamed:@"ButtonHeaderSave.png"] forState:UIControlStateNormal];
            _topRightButton.hidden = YES;
            
            [self.view addSubview:[[ksKissUtilityView alloc]initForState:_state withData:_dataDictionary]];
        }
            break;
        case STATE_ADD: {
            // save kiss
            if ([[[self.view subviews] lastObject] dismissUtilityViewWithSave:YES]) {
                [_topLeftButton setImage:[UIImage imageNamed:@"ButtonHeaderGear.png"] forState:UIControlStateNormal];
                [_topRightButton setImage:[UIImage imageNamed:@"ButtonHeaderPlus.png"] forState:UIControlStateNormal];
                [_kisserButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        case STATE_EDIT: {
            // delete kiss
            ksKissObject* content = [[ksKissObject alloc]initWithConfiguration:CONFIRM];
            content.confirmTitle.text = @"Really delete this kiss?";
            ksPopOverView* popOverView = [[ksPopOverView alloc]initWithFrame:content.frame];
            [popOverView displayPopOverViewWithContent:content withBacking:nil inSuperView:self.view];
        }
            break;
    }
}

-(void)enableTopButtons:(BOOL)enable {
    _topLeftButton.enabled = enable;
    _topRightButton.enabled = enable;
}

#pragma mark - Kisser Action Group

-(IBAction)kisserButtonTapped:(id)sender {
    if (_state == STATE_KISSER)
        return;

    _kisserButton.frame = CGRectMake(0.0f, 416.0f, 64.0f, 64.0f);
    [_kisserButton setImage:[UIImage imageNamed:@"ButtonKisserSelected.png"]
                   forState:UIControlStateNormal];
    _topBarLabel.text = @"Kissers";

    [self buttonControl:sender];
    [self mainViewDisplay:_mainTableView];

    _state = STATE_KISSER;
    [_mainTableView reloadData];
    
    // for when it's an empty table
    if ([_mainTableView numberOfSections] > 0 && [_mainTableView numberOfRowsInSection:0] > 0) {
            [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - Date Action Group

-(IBAction)dateButtonTapped:(id)sender {
    if (_state == STATE_DATE)
        return;

    _dateButton.frame = CGRectMake(64.0f, 416.0f, 64.0f, 64.0f);
    [_dateButton setImage:[UIImage imageNamed:@"ButtonDateSelected.png"]
                 forState:UIControlStateNormal];
    _topBarLabel.text = @"Dates";
    
    [self buttonControl:sender];
    [self mainViewDisplay:_mainTableView];
    
    _state = STATE_DATE;
    [_mainTableView reloadData];
    [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Rating Action Group

-(IBAction)ratingButtonTapped:(id)sender {
    if (_state == STATE_RATING)
        return;

    _ratingButton.frame = CGRectMake(128.0f, 416.0f, 64.0f, 64.0f);
    [_ratingButton setImage:[UIImage imageNamed:@"ButtonRatingSelected.png"]
                   forState:UIControlStateNormal];
    _topBarLabel.text = @"Ratings";
    
    [self buttonControl:sender];
    [self mainViewDisplay:_mainTableView];
    
    _state = STATE_RATING;
    [_mainTableView reloadData];
    [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Location Action Group

-(IBAction)locationButtonTapped:(id)sender {
    if (_state == STATE_LOCATION)
        return;

    _locationButton.frame = CGRectMake(192.0f, 416.0f, 64.0f, 64.0f);
    [_locationButton setImage:[UIImage imageNamed:@"ButtonLocationSelected.png"]
                     forState:UIControlStateNormal];
    _topBarLabel.text = @"Locations";
    
    [self buttonControl:sender];
    [self mainViewDisplay:_mapContainer];
    
    _state = STATE_LOCATION;
}

-(IBAction)mapCenterButtonTapped:(id)sender {
    [_mainMapView setCenterCoordinate:[_mainMapView userLocation].coordinate animated:YES];
}

#pragma mark - Photo Action Group

-(IBAction)photoButtonTapped:(id)sender {
    if (_state == STATE_PHOTO)
        return;
    
    _photoButton.frame = CGRectMake(256.0f, 416.0f, 64.0f, 64.0f);
    [_photoButton setImage:[UIImage imageNamed:@"ButtonPhotoSelected.png"]
                     forState:UIControlStateNormal];
    _topBarLabel.text = @"Photos";
    
    [self buttonControl:sender];
    [self mainViewDisplay:_mainGalleryView];
    
    _state = STATE_PHOTO;
}

#pragma mark - UITableView Group

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([[[_dataDictionary valueForKey:[NSString stringWithFormat:@"tableData%i",_state]]objectAtIndex:0]count]);
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // the header view container, the whole thing
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 318.0f, 28.0f)];
    headerView.backgroundColor = CCO_LIGHT_CREAM;
    headerView.layer.borderColor = [[UIColor whiteColor] CGColor];

    // the colored banner w/info
    UIView* headerBanner = [[UIView alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 318.0f, 28.0f)];
    headerBanner.backgroundColor = [[[ksColorObject colorArray]objectAtIndex:(5-(section%5))]objectAtIndex:CCO_BASE];

    // the header text
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(34.0f, 1.0f, headerView.frame.size.width - 34.0f, 28.0f)];
    headerLabel.textColor = CCO_BASE_CREAM;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:22.0f];
    headerLabel.shadowColor = CCO_BASE_GREY;
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.text = [[[_dataDictionary valueForKey:[NSString stringWithFormat:@"tableData%i",_state]]objectAtIndex:0]objectAtIndex:section];

    // the header icon
    UIImageView* headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(6.0f, 3.0f, 24.0f, 24.0f)];
    headerImageView.layer.shadowColor = [CCO_BASE_GREY CGColor];
    headerImageView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerImageView.layer.shadowOpacity = 1.0f;
    headerImageView.layer.shadowRadius = 0.0f;

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
            int headerCount = [headerLabel.text intValue];
            headerLabel.text = @"";
           
            if (headerCount == 0) {
                // the zero heart
                headerBanner.backgroundColor = CCO_LIGHT_GREY;
                headerImageView.image = [UIImage imageNamed:@"IconHeartGreyShadow.png"];
            } else {
                // 1 - 5 hearts
                headerBanner.backgroundColor = [[[ksColorObject colorArray]objectAtIndex:headerCount]objectAtIndex:CCO_BASE];

                for (int i = 0; i < headerCount; i++) {
                    [headerBanner addSubview:[[UIImageView alloc]initWithFrame:CGRectMake(6.0f + (i*26.0f), 2.0f, 24.0f, 24.0f)]];
                    [[[headerBanner subviews] lastObject] setImage:[UIImage imageNamed:@"IconHeartCreamShadow.png"]];
                }
            }
        }
            break;
    }

    [headerView addSubview:headerBanner];
    [headerView addSubview:headerImageView];
    [headerView addSubview:headerLabel];

    return headerView;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[NSString alloc]init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([[[[_dataDictionary valueForKey:[NSString stringWithFormat:@"tableData%i",_state]]objectAtIndex:1]objectAtIndex:section]count]);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float textBuffer = 12.0f;
    float imageBuffer = 5.0f;
    float rowHeight = 67.0f;
    float imageHeight = 0.0f;

    if (![[[[[[_dataDictionary valueForKey:[NSString stringWithFormat:@"tableData%i",_state]]objectAtIndex:1]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] valueForKey:@"image"]isEqualToData:KSCD_DUMMYIMAGE]) {
        imageHeight = (imageBuffer + 82.0f);
    }

    float textHeight = textBuffer + [ksKissItemView calcTextSizeForKiss:[[[[_dataDictionary valueForKey:[NSString stringWithFormat:@"tableData%i",_state]]objectAtIndex:1]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];

    return rowHeight += (textHeight > imageHeight) ? textHeight : imageHeight;
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[NSArray alloc]init];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* cellID = @"ksKissTableViewCell";
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    //This prevents crashes when the table is still scrolling and someone flips to map/photos
    if (_state > RATING) return cell;

    NSManagedObject* manObj = [[[[_dataDictionary valueForKey:[[NSString alloc]initWithFormat:@"tableData%i",_state]]objectAtIndex:1]objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

    ksKissItemView* content = [[[NSBundle mainBundle] loadNibNamed:@"ksKissItemView" owner:cell options:nil] objectAtIndex:0];
    [content colorizeWithData:manObj forType:_state];

    // indented width to allow shadow effects
    content.frame = CGRectMake(3, 3, 312, cell.frame.size.height - 6);
    [cell addSubview:content];
    return cell;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _topBarLabel.text = @"Kiss Details";
    [_topLeftButton setImage:[UIImage imageNamed:@"ButtonHeaderOK.png"] forState:UIControlStateNormal];
    [_topRightButton setImage:[UIImage imageNamed:@"ButtonHeaderDelete.png"] forState:UIControlStateNormal];
    
    NSDictionary* singleCellDictionary = [[NSDictionary alloc]initWithObjects:@[[[[[_dataDictionary objectForKey:[NSString stringWithFormat:@"tableData%i",_state]] objectAtIndex:1] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]] forKeys:@[@"editKiss"]];

    _state = STATE_EDIT;
    
    [self.view addSubview:[[ksKissUtilityView alloc]initForState:STATE_EDIT withData:singleCellDictionary]];
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
    // tightens the view region
    
    // The min is set to the max, and the max is set to the min, so that the locations can re-set them, and we'll know...
    double minLat=360.0f,minLon=360.0f;
    double maxLat=-360.0f,maxLon=-360.0f;
    
    for (ksAnnotationView* annotation in [_mainMapView annotations]) {
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
    [_mainMapView removeAnnotations:[_mainMapView annotations]];

    // add all annotations
    [_mainMapView addAnnotations:_annotationArray];
}

-(ksAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // I guess we don't want to annotate user location?
    if (![annotation isMemberOfClass:[ksAnnotationView class]]) {
        return nil;
    }
    ksAnnotationView* annotationView = [[ksAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"resuableIdentifier"];

    // the image is normally centered itself on the point, so offset for the size of the image itself
    // move it up by half the size
    // move it right by 2/3 because of drop shadow, et al
    //float offSetHeight = annotationView.image.size.height/-2;
    //float offSetWidth = annotationView.image.size.width/2/3;
    annotationView.centerOffset = CGPointMake(annotationView.image.size.width/2/3,annotationView.image.size.height/-2);

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(ksAnnotationView*)view {
    // have to discriminate against the MKUserLocation
    if ([view class] == [ksAnnotationView class]) {
        [view displayCallout];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(ksAnnotationView*)view {
    // have to discriminate against the MKUserLocation
    if ([view class] == [ksAnnotationView class]) {
        [view dismissCallout];
    }
}

#pragma mark - VC super class

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        [self initDataStructures];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGuiObjects];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - DISORGANIZED BULLSHIT

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[[[self view]subviews]lastObject]kissObject].kissPicture = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[[[[self view]subviews]lastObject]picButton]setImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
