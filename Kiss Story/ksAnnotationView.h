//
//  ksAnnotationView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/22/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ksAnnotationView : MKAnnotationView

-(void)displayCallout;
-(void)dismissCallout;

@property (nonatomic, retain) IBOutlet UIView* calloutView;

@property (nonatomic, retain) IBOutlet UIView* headerView;
@property (nonatomic, retain) IBOutlet UIButton* moreButton;
@property (nonatomic, retain) IBOutlet UILabel* headerLabel;
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* leftLabel;
@property (nonatomic, retain) IBOutlet UILabel* rightLabel;
@property (nonatomic, retain) IBOutlet UILabel* bodyLabel;
@property (nonatomic, retain) IBOutlet UIImageView* nameThumb;
@property (nonatomic, retain) IBOutlet UIImageView* leftThumb;
@property (nonatomic, retain) IBOutlet UIImageView* rightThumb;
@property (nonatomic, retain) IBOutlet UIImageView* photoThumb;

@property (nonatomic, readwrite) NSString* title;
@property (nonatomic, readwrite) NSString* reuseIdentifier;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) NSArray* IDArray;
@property (nonatomic, retain) NSArray* locationArray;
@property (nonatomic, retain) NSArray* kisserArray;
@property (nonatomic, retain) NSArray* ratingArray;
@property (nonatomic, retain) NSArray* dateArray;
@property (nonatomic, retain) NSArray* descriptionArray;

@property (nonatomic, readwrite) int color;


@end
