//
//  GroupMemberTableViewCell.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/8/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFImageView.h>
@interface GroupMemberTableViewCell : UITableViewCell
@property(nonatomic,retain)UIView *postView;
@property(nonatomic,retain)PFImageView *profileImageView;
@property(nonatomic,retain)UILabel *adminlbl;
@property(nonatomic,retain)UILabel*namelbl;
@property(nonatomic,retain)UIImageView *separator;
@end
