//
//  ksColorCell.h
//  Kiss Story
//
//  Created by Anthony Thompson on 10/12/12.
//  Copyright (c) 2012 Geek Gamer Guy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ksColorObject.h"

@interface ksColorCell : UITableViewCell {
}

-(void)colorizeCellWithColor:(int)whichColor withType:(int)whichType;

@property (nonatomic, retain) IBOutlet UIView* container;
@property (nonatomic, retain) IBOutlet UIImageView* frameImage;
@property (nonatomic, retain) IBOutlet UIView* inliner;

@property (nonatomic, retain) IBOutlet UIView* bodyLabelContainer;
@property (nonatomic, retain) IBOutlet UIView* outliner;
@property (nonatomic, retain) IBOutlet UILabel* bodyLabel;
@property (nonatomic, retain) IBOutlet UIView* shadow;
@property (nonatomic, retain) IBOutlet UIView* backing;

@property (nonatomic, retain) IBOutlet UIView* headerContainer;
@property (nonatomic, retain) IBOutlet UIImageView* header;
@property (nonatomic, retain) UIImageView* heartImage;
@property (nonatomic, retain) IBOutlet UILabel* headerLabel;
@property (nonatomic, retain) IBOutlet UILabel* leftLabel;
@property (nonatomic, retain) IBOutlet UILabel* rightLabel;
@property (nonatomic, retain) IBOutlet UIImageView* leftThumbNail;
@property (nonatomic, retain) IBOutlet UIImageView* rightThumbNail;


@property (nonatomic, retain) IBOutlet UIView* photoImageContainer;
@property (nonatomic, retain) IBOutlet UIImageView* photoImage;


@end
