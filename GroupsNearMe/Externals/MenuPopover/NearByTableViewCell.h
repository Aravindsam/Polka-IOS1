//
//  NearByTableViewCell.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/10/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFImageView.h>
#import "Generic.h"
@interface NearByTableViewCell : UITableViewCell
@property(nonatomic, assign)id didselectDelegate;
@property(nonatomic,retain)PFImageView *groupImageview;
@property(nonatomic,retain)UILabel*groupnamelbl;
@property(nonatomic,retain)UILabel*grouptypelbl;
@property(nonatomic,retain)UILabel*memberlabel;
@property(nonatomic,retain)UIButton*joinbtn;
@property(nonatomic,retain)UILabel *requestlabel;
@property(nonatomic,retain)UILabel *aboutLabel;
@property(nonatomic,retain)UIImageView *memberImage,*separator;
@property(nonatomic,readwrite)float aboutHeight;

@end
