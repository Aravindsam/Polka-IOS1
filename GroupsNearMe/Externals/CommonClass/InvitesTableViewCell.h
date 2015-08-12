//
//  InvitesTableViewCell.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 7/1/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFImageView.h>
@interface InvitesTableViewCell : UITableViewCell
@property(nonatomic,retain)PFImageView *groupImageview;
@property(nonatomic,retain)UILabel*groupnamelbl;
@property(nonatomic,retain)UIView *contentarea;
@property(nonatomic,retain)UIImageView*memberimage;
@property(nonatomic,retain)UILabel*memberlabel,*joinlabel;
@property(nonatomic,retain)UIButton *acceptbtn ,*rejectbtn;
@property(nonatomic, assign)id didinviteselectDelegate;
@end
