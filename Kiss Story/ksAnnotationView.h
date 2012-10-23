//
//  ksAnnotationView.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/22/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ksAnnotationView : MKAnnotationView {
    
}

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

//-(IBAction)moreButtonTapped:(id)sender;

@end
