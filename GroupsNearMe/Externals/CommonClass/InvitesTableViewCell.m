//
//  InvitesTableViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 7/1/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "InvitesTableViewCell.h"
#import "PendingInviteViewController.h"
@implementation InvitesTableViewCell
@synthesize memberlabel,groupImageview,groupnamelbl,acceptbtn,rejectbtn,joinlabel,contentarea,memberimage;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *content = self.contentView;
        
        contentarea=[[UIView alloc]init];
        contentarea.layer.cornerRadius=5.0;
        contentarea.backgroundColor=[UIColor whiteColor];
        contentarea.clipsToBounds=YES;
        [content addSubview:contentarea];
        
        groupImageview=[[PFImageView alloc]init];
        [contentarea addSubview:groupImageview];
        
        memberimage=[[UIImageView alloc]init];
        [memberimage setImage:[UIImage imageNamed:@"members.png"]];
        [contentarea addSubview:memberimage];
        
        groupnamelbl=[[UILabel alloc]init];
        groupnamelbl.numberOfLines=0;
        [groupnamelbl setFont:[UIFont fontWithName:@"Lato-Regular" size:14.0]];
        [contentarea addSubview:groupnamelbl];
        
        joinlabel=[[UILabel alloc]init];
        joinlabel.numberOfLines=0;
        [joinlabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14.0]];
        joinlabel.textColor=[UIColor darkGrayColor];
        joinlabel.text=@"Invites you to join";
        [contentarea addSubview:joinlabel];
        
        memberlabel=[[UILabel alloc]init];
     
        memberlabel.textAlignment=NSTextAlignmentCenter;
        memberlabel.textColor=[UIColor lightGrayColor];
        [memberlabel setFont:[UIFont fontWithName:@"Lato-Regular" size:12.0]];
        memberlabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        [contentarea addSubview:memberlabel];
        
        rejectbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [contentarea addSubview:rejectbtn];
        acceptbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [contentarea addSubview:acceptbtn];
        [acceptbtn addTarget:self action:@selector(acceptbtn:) forControlEvents:UIControlEventTouchUpInside];
        [rejectbtn addTarget:self action:@selector(rejectbtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    contentarea.frame=CGRectMake(10, 10,contentRect.size.width-20, contentRect.size.height-20);
    groupImageview.frame=CGRectMake(10, 10,70,70);
    
    groupnamelbl.frame=CGRectMake(90, 10,contentRect.size.width-100,40);
    [self findFrameFromString:groupnamelbl.text andCorrespondingLabel:groupnamelbl];
    memberlabel.frame=CGRectMake(112, 60,  contentRect.size.width-100,20);
    [self findFrameFromString:memberlabel.text andCorrespondingLabel:memberlabel];
    memberlabel.frame=CGRectMake(114, 60,memberlabel.frame.size.width,20);
    memberimage.frame=CGRectMake(90, 60, 20, 20);
    joinlabel.frame=CGRectMake(90, [self findViewHeight:groupnamelbl.frame]+2, contentRect.size.width-100, 20);
    rejectbtn.frame=CGRectMake(contentRect.size.width-110, 50, 30, 30);
    acceptbtn.frame=CGRectMake(contentRect.size.width-60, 50, 30, 30);
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
-(void)findFrameFromString:(NSString*)string andCorrespondingLabel:(UILabel*) label1
{
    CGSize expectedLableSize =[string sizeWithFont:label1.font constrainedToSize:label1.frame.size lineBreakMode:NSLineBreakByCharWrapping];
    CGRect newFrame =  label1.frame;
    newFrame.size.height = expectedLableSize.height;
    label1.frame =newFrame;
    label1.lineBreakMode = NSLineBreakByCharWrapping;
    label1.numberOfLines=0;
    [label1 sizeToFit];
    
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
