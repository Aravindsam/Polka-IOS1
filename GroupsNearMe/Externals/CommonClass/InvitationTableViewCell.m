//
//  InvitationTableViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/14/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "InvitationTableViewCell.h"
#import "PostTableViewController.h"
@implementation InvitationTableViewCell
@synthesize profileImageView,welcomelbl,namelbl,timelbl,additionallabel,infolabel,verticallabel,acceptbtn,rejectbtn,postView;
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
        rejectbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [postView addSubview:rejectbtn];
        
        profileImageView=[[PFImageView alloc]init];
        [postView addSubview:profileImageView];
        
        welcomelbl=[[UILabel alloc]init];
        welcomelbl.numberOfLines=0;
        welcomelbl.font=[UIFont fontWithName:@"Lato-Regular" size:15.0];
        welcomelbl.textColor=[UIColor lightGrayColor];
        [postView addSubview:welcomelbl];
        
        namelbl=[[UILabel alloc]init];
        namelbl.numberOfLines=0;
        namelbl.font=[UIFont fontWithName:@"Lato-Regular" size:16.0];
        namelbl.textColor=[UIColor blackColor];
        [postView addSubview:namelbl];
        
        timelbl=[[UILabel alloc]init];
        timelbl.numberOfLines=0;
        timelbl.textColor=[UIColor lightGrayColor];
        timelbl.font=[UIFont fontWithName:@"Lato-Regular" size:14.0];
        [postView addSubview:timelbl];
        
        acceptbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [postView addSubview:acceptbtn];
        
        verticallabel=[[UILabel alloc]init];
        verticallabel.backgroundColor=[UIColor lightGrayColor];
        [postView addSubview:verticallabel];
        
        additionallabel=[[UILabel alloc]init];
        additionallabel.numberOfLines=0;
        additionallabel.font=[UIFont fontWithName:@"Lato-Medium" size:16.0];
        [postView addSubview:additionallabel];
        
        infolabel=[[UILabel alloc]init];
        infolabel.numberOfLines=0;
        infolabel.font=[UIFont fontWithName:@"Lato-Medium" size:16.0];
        [postView addSubview:infolabel];
        
        [acceptbtn addTarget:self action:@selector(acceptbtn:) forControlEvents:UIControlEventTouchUpInside];
        [rejectbtn addTarget:self action:@selector(rejectbtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    postView.frame=CGRectMake(10, 10, contentRect.size.width-20, contentRect.size.height-20);
    acceptbtn.frame=CGRectMake(contentRect.size.width-60, 40,30, 30);
    profileImageView.frame=CGRectMake(10,10, 60,60);

    namelbl.frame=CGRectMake(80, 0, contentRect.size.width-110, 30);
    welcomelbl.frame=CGRectMake(80, [self findViewHeight:namelbl.frame], contentRect.size.width-170,20);
    timelbl.frame=CGRectMake(80, 55, contentRect.size.width-170,15);
    rejectbtn.frame=CGRectMake(contentRect.size.width-105,40,30, 30);
    verticallabel.frame=CGRectMake(0, 80, contentRect.size.width, 0.5);
    additionallabel.frame=CGRectMake(5, 82, contentRect.size.width-20, 20);
    infolabel.frame=CGRectMake(5, 105, contentRect.size.width-20, 25);
    
}
-(void)rejectbtn:(UIButton*)sender
{
    NSLog(@"REJECT");
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [_didinviteselectDelegate rejectAction:bTag];
}
-(void)acceptbtn:(UIButton*)sender
{
    NSLog(@"ACCEPT");
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [_didinviteselectDelegate acceptAction:bTag];
}
-(CGFloat)findViewHeight:(CGRect)sender
{
    CGFloat hgValue = sender.origin.y +sender.size.height;
    return hgValue;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
