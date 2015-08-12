//
//  InvitationTableViewCell.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/14/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFImageView.h>
@interface InvitationTableViewCell : UITableViewCell
{
    
}
@property(nonatomic, assign)id didinviteselectDelegate;
@property(nonatomic,retain)UIView*postView;
@property(nonatomic,retain)PFImageView *profileImageView;
@property(nonatomic,retain)UILabel*welcomelbl,*namelbl,*timelbl,*additionallabel,*infolabel,*verticallabel;
@property(nonatomic,retain)UIButton *acceptbtn ,*rejectbtn;

@end
