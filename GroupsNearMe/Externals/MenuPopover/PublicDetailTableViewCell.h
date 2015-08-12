//
//  PublicDetailTableViewCell.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/13/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFImageView.h>
#import "KILabel.h"
@interface PublicDetailTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer*singletap;
}
@property(nonatomic, assign)id didselectDelegate;
@property(nonatomic,retain)PFImageView*postImageview,*profileimageview;
@property(nonatomic,retain)UILabel *profilenamelabel;
@property(nonatomic,retain)KILabel *textvalLabel;
@property(nonatomic,retain)UILabel*timelabel;
@property(nonatomic,retain)UIButton*upvotebtn;
@property(nonatomic,retain)UIButton*flagbtn;
@property(nonatomic,retain)UIButton*downvotebtn;
@property(nonatomic,retain)UILabel*pointlabel,*toplinelabel,*bottomlinelabel;
//@property(nonatomic,retain)UIButton*sharebtn;
@property(nonatomic,retain)UIView *postView;

@property(nonatomic,retain)UIButton*deletebtn;
@end
