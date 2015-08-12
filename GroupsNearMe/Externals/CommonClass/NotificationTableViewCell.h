//
//  NotificationTableViewCell.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/24/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface NotificationTableViewCell : UITableViewCell
@property(nonatomic,retain)AsyncImageView *iconimageView;
@property(nonatomic,retain)UILabel* contentlabel;
@property(nonatomic,retain)UILabel*timelabel;

@end
