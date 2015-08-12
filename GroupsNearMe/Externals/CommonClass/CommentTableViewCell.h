//
//  CommentTableViewCell.h
//  LBG
//
//  Created by Jannath Begum on 3/29/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFImageView.h>
@interface CommentTableViewCell : UITableViewCell
{
    UITapGestureRecognizer*profiletap;
}
@property(nonatomic, assign)id didcommentselectDelegate;

@property(nonatomic,retain)PFImageView*profileimage;
@property(nonatomic,retain)UILabel*commentLabel;
@property(nonatomic,retain)UILabel*timelabel;
@property(nonatomic,retain)UILabel*namelabel;
@property(nonatomic,retain)UIView*Containerview;
@end
