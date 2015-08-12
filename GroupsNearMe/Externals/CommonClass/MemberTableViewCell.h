//
//  MemberTableViewCell.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/14/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFImageView.h>
@interface MemberTableViewCell : UITableViewCell
{
    UITapGestureRecognizer*profiletap;
}
@property(nonatomic, assign)id didMemberselectDelegate;

@property(nonatomic,retain)UIView *postView;
@property(nonatomic,retain)PFImageView *profileImageView;
@property(nonatomic,retain)UILabel*namelbl,*timelbl;
@end
