//
//  TextTableViewCell.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/14/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KILabel.h"
#import <ParseUI/PFImageView.h>
@interface TextTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer*singletap;
    UITapGestureRecognizer*profiletap;

}
@property(nonatomic, assign)id didtextselectDelegate;
@property(nonatomic,retain)PFImageView*postImageview,*profileimageview;
@property(nonatomic,retain)UILabel *profilenamelabel;
@property(nonatomic,retain)UILabel*timelabel;

@property(nonatomic,retain)KILabel *textvalLabel;
@property(nonatomic,retain)UILabel*pointlabel,*toplinelabel,*bottomlinelabel;

@property(nonatomic,retain)UIButton*upvotebtn;
@property(nonatomic,retain)UIButton*flagbtn;
@property(nonatomic,retain)UIButton*deletebtn;
@property(nonatomic,retain)UIButton*downvotebtn;
@property(nonatomic,retain)UIButton*replybtn;
//@property(nonatomic,retain)UIButton*sharebtn;


@property(nonatomic,retain)UIView *postView;

@end
