//
//  MyGroupTableViewCell.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/28/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFImageView.h>
@interface MyGroupTableViewCell : UITableViewCell
@property(nonatomic, assign)id didselectDelegate;
@property(nonatomic,retain)PFImageView *groupImageview;
@property(nonatomic,retain)UILabel*groupnamelbl;
@property(nonatomic,retain)UILabel*grouptypelbl,*adminlbl,*messagecountlabel;
@property(nonatomic,retain)UIImageView *memberImage,*separator;
@property(nonatomic,retain)UILabel*memberlabel;

@end
