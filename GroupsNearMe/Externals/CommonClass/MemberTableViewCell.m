//
//  MemberTableViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/14/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "MemberTableViewCell.h"
#import "PostTableViewController.h"
@implementation MemberTableViewCell
@synthesize profileImageView,timelbl,namelbl,postView;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *content = self.contentView;
        
        postView=[[UIView alloc]init];
        [postView setBackgroundColor:[UIColor whiteColor]];
        [content addSubview:postView];
        postView.layer.cornerRadius=5.0;
        postView.clipsToBounds=YES;
        
        profileImageView=[[PFImageView alloc]init];
        profileImageView.userInteractionEnabled=YES;
        
        profiletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profiletap:)];
        profiletap.numberOfTapsRequired=1;
        [profileImageView addGestureRecognizer:profiletap];
        
        [postView addSubview:profileImageView];
        
       
        
        namelbl=[[UILabel alloc]init];
        namelbl.numberOfLines=0;
        namelbl.font=[UIFont fontWithName:@"Lato-Regular" size:16.0];
        namelbl.textColor=[UIColor lightGrayColor];
        [postView addSubview:namelbl];
        
        timelbl=[[UILabel alloc]init];
        timelbl.numberOfLines=0;
        timelbl.textColor=[UIColor lightGrayColor];
        timelbl.font=[UIFont fontWithName:@"Lato-Regular" size:14.0];
        timelbl.textAlignment=NSTextAlignmentLeft;
        [postView addSubview:timelbl];
        
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    postView.frame=CGRectMake(10, 10, contentRect.size.width-20, contentRect.size.height-20);
    profileImageView.frame=CGRectMake(10, 10, 60, 60);
    namelbl.frame=CGRectMake(80,10, contentRect.size.width-90, 50);
    [self findFrameFromString:namelbl.text andCorrespondingLabel:namelbl];
    timelbl.frame=CGRectMake(80, 50, contentRect.size.width-90,20);
    
}
-(void)profiletap:(UITapGestureRecognizer*)sender
{
    NSLog(@"TAP");    UIView *view = sender.view;
    int bTag = (int)view.tag;
    [_didMemberselectDelegate Profiletap:bTag];
}
-(void)findFrameFromString:(NSString*)string andCorrespondingLabel:(UILabel*) label1
{
    CGSize expectedLableSize =[string sizeWithFont:label1.font constrainedToSize:label1.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    CGRect newFrame =  label1.frame;
    newFrame.size.height = expectedLableSize.height;
    label1.frame =newFrame;
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines=0;
    [label1 sizeToFit];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGFloat)findViewHeight:(CGRect)sender
{
    CGFloat hgValue = sender.origin.y +sender.size.height;
    return hgValue;
}
@end
