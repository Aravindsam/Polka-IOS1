//
//  CommentTableViewCell.m
//  LBG
//
//  Created by Jannath Begum on 3/29/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "CommentTableViewCell.h"

#import "commentTableViewController.h"
@implementation CommentTableViewCell
@synthesize profileimage,commentLabel,timelabel,Containerview,namelabel,didcommentselectDelegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        Containerview=[[UIView alloc]init];
        [self.contentView addSubview:Containerview];
        profileimage=[[PFImageView alloc]init];
        [Containerview addSubview:profileimage];
        commentLabel=[[UILabel alloc]init];
        commentLabel.numberOfLines=0;
        commentLabel.font=[UIFont fontWithName:@"Lato-Medium" size:15.0];
        Containerview.backgroundColor=[UIColor whiteColor];
        [Containerview addSubview:commentLabel];
        
        profileimage.userInteractionEnabled=YES;
        
        profiletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profiletap:)];
        profiletap.numberOfTapsRequired=1;
        [profileimage addGestureRecognizer:profiletap];
        
        namelabel=[[UILabel alloc]init];
        namelabel.numberOfLines=0;
        namelabel.font=[UIFont fontWithName:@"Lato-Medium" size:14.0];
        namelabel.backgroundColor=[UIColor whiteColor];
        namelabel.textColor=[UIColor lightGrayColor];
        [Containerview addSubview:namelabel];
        
        timelabel=[[UILabel alloc]init];
        timelabel.font=[UIFont systemFontOfSize:10];
        timelabel.font=[UIFont fontWithName:@"Lato-Regular" size:10.0];
        timelabel.textColor=[UIColor lightGrayColor];
        [Containerview addSubview:timelabel];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame=[self.contentView bounds];
    self.Containerview.frame=CGRectMake(10, 0, frame.size.width-20, frame.size.height-1.0);
    self.profileimage.frame=CGRectMake(10,10,35,35);
    self.namelabel.frame=CGRectMake(50,10,frame.size.width-75,35);
    [namelabel sizeToFit];
    self.timelabel.frame=CGRectMake(50, self.namelabel.frame.size.height+10, frame.size.width-6, 15);
    self.commentLabel.frame=CGRectMake(10, 52, frame.size.width-40, frame.size.height-35);
    [commentLabel sizeToFit];
    
}
-(void)profiletap:(UITapGestureRecognizer*)sender
{
    NSLog(@"TAP");    UIView *view = sender.view;
    int bTag = (int)view.tag;
    [didcommentselectDelegate Profiletap:bTag];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
