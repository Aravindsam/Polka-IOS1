//
//  TextTableViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/14/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "TextTableViewCell.h"
#import "PostTableViewController.h"
@implementation TextTableViewCell
@synthesize textvalLabel,timelabel,upvotebtn,downvotebtn,pointlabel,replybtn,postView,flagbtn,profileimageview,profilenamelabel,deletebtn,postImageview,toplinelabel,bottomlinelabel,didtextselectDelegate;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *content = self.contentView;
        
        postView=[[UIView alloc]init];
        [postView setBackgroundColor:[UIColor whiteColor]];
        [content addSubview:postView];
        
        postImageview=[[PFImageView alloc]init];
        postImageview.userInteractionEnabled=YES;
        [postView addSubview:postImageview];
        
        textvalLabel=[[KILabel alloc]init];
        textvalLabel.numberOfLines=5;
        textvalLabel.linkDetectionTypes ^= KILinkTypeURL;
        textvalLabel.userInteractionEnabled=YES;
        [textvalLabel setFont:[UIFont fontWithName:@"Lato-regular" size:16.0]];
        [postView addSubview:textvalLabel];
        
        timelabel =[[UILabel alloc]init];
        timelabel.font=[UIFont fontWithName:@"Lato-regular" size:10.0];
        timelabel.textAlignment=NSTextAlignmentLeft;
        timelabel.textColor=[UIColor darkGrayColor];

        [postView addSubview:timelabel];
        
        profilenamelabel =[[UILabel alloc]init];
        profilenamelabel.font=[UIFont fontWithName:@"Lato-Regular" size:13.0];
        profilenamelabel.textAlignment=NSTextAlignmentLeft;
        profilenamelabel.textColor=[UIColor darkGrayColor];
        [postView addSubview:profilenamelabel];
        
        profileimageview=[[PFImageView alloc]init];
        profileimageview.userInteractionEnabled=YES;
        
        profiletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profiletap:)];
        profiletap.numberOfTapsRequired=1;
        [profileimageview addGestureRecognizer:profiletap];
        [postView addSubview:profileimageview];
        
        pointlabel =[[UILabel alloc]init];
        pointlabel.font=[UIFont systemFontOfSize:10.0];
        pointlabel.numberOfLines=0;
        pointlabel.textColor=[UIColor lightGrayColor];
        pointlabel.userInteractionEnabled=YES;
        

        
        pointlabel.textAlignment=NSTextAlignmentLeft;
        [postView addSubview:pointlabel];
        
        upvotebtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [upvotebtn addTarget:self action:@selector(upvote:) forControlEvents:UIControlEventTouchUpInside];
        
        [postView addSubview:upvotebtn];
        
        flagbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [flagbtn addTarget:self action:@selector(flag:) forControlEvents:UIControlEventTouchUpInside];
        
        [postView addSubview:flagbtn];
        
        downvotebtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [downvotebtn addTarget:self action:@selector(downvote:) forControlEvents:UIControlEventTouchUpInside];
        
        [postView addSubview:downvotebtn];
        
        replybtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [replybtn addTarget:self action:@selector(reply:) forControlEvents:UIControlEventTouchUpInside];
        [replybtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [postView addSubview:replybtn];
        

        
        toplinelabel=[[UILabel alloc]init];
        toplinelabel.backgroundColor=[UIColor lightGrayColor];
        toplinelabel.alpha=0.2;
        [postView addSubview:toplinelabel];
        
        bottomlinelabel=[[UILabel alloc]init];
        bottomlinelabel.backgroundColor=[UIColor lightGrayColor];
        bottomlinelabel.alpha=0.2;
        [postView addSubview:bottomlinelabel];
        
        deletebtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [deletebtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        
        [postView addSubview:deletebtn];
        
        postView.layer.cornerRadius=5.0;
        postView.clipsToBounds=YES;
       
        
        
    }
    return self;
}
-(void)delete:(UIButton*)sender
{
    NSLog(@"DELETE");
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [didtextselectDelegate deleteAction:bTag];
}
-(void)profiletap:(UITapGestureRecognizer*)sender
{
    NSLog(@"TAP");    UIView *view = sender.view;
    int bTag = (int)view.tag;
    [didtextselectDelegate Profiletap:bTag];
}
-(void)pointtap:(UITapGestureRecognizer*)sender
{
    NSLog(@"TAP");
    
}
-(void)upvote:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [didtextselectDelegate upvoteAction:bTag];
}
-(void)downvote:(UIButton*)sender
{
    NSLog(@"DOWNVOTE");
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [didtextselectDelegate downvoteAction:bTag];
    
}
-(void)reply:(UIButton*)sender
{
    NSLog(@"REPLY");
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [didtextselectDelegate comment:bTag];
}
-(void)share:(UIButton*)sender
{
    NSLog(@"SHARE");
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [didtextselectDelegate shareAction:bTag :sender];
}
-(void)flag:(UIButton*)sender
{
    NSLog(@"FLAG");
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [didtextselectDelegate flagAction:bTag];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    
    postView.frame=CGRectMake(10, 5, contentRect.size.width-20, contentRect.size.height-10);
    
    if (postImageview.hidden) {
        
        if (profileimageview.hidden) {
            deletebtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
            flagbtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
            timelabel.frame=CGRectMake(10, 0, postView.frame.size.width-135, 40);
            toplinelabel.frame=CGRectMake(0,55 , postView.frame.size.width, 0.5);
            timelabel.font=[UIFont fontWithName:@"Lato-Bold" size:13.0];
        }
        else{
        profileimageview.frame=CGRectMake(10, 10, 35, 35);
        profilenamelabel.frame=CGRectMake(50, 5,postView.frame.size.width-135, 20);
              deletebtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
            flagbtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
        timelabel.frame=CGRectMake(50, 33, postView.frame.size.width-135, 12);
        toplinelabel.frame=CGRectMake(0,[self findViewHeight:profileimageview.frame]+10 , postView.frame.size.width, 0.5);
        }
        textvalLabel.frame=CGRectMake(10, [self findViewHeight:toplinelabel.frame]+3,postView.frame.size.width-20,90);
    
   
    
     pointlabel.frame=CGRectMake(10, [self findViewHeight:textvalLabel.frame]+10,postView.frame.size.width-60, 30);
    
    
     bottomlinelabel.frame=CGRectMake(0,[self findViewHeight:pointlabel.frame]+2 , postView.frame.size.width, 0.5);
        

        upvotebtn.frame=CGRectMake(postView.frame.size.width-40, [self findViewHeight:bottomlinelabel.frame]+2, 40, 40);
        downvotebtn.frame=CGRectMake(postView.frame.size.width-80, [self findViewHeight:bottomlinelabel.frame]+2, 40, 40);
        replybtn.frame=CGRectMake(10,[self findViewHeight:bottomlinelabel.frame]+10, 30, 30);

      [textvalLabel sizeToFit];
    }
    else
    {
        
        if (profileimageview.hidden) {
            timelabel.frame=CGRectMake(10, 0, postView.frame.size.width-135, 40);
            toplinelabel.frame=CGRectMake(0,55 , postView.frame.size.width, 0.5);
             timelabel.font=[UIFont fontWithName:@"Lato-Bold" size:13.0];
        }
        else{
            profileimageview.frame=CGRectMake(10, 10, 35, 35);
            profilenamelabel.frame=CGRectMake(50, 5,postView.frame.size.width-135, 20);
            timelabel.frame=CGRectMake(50, 33, postView.frame.size.width-135, 12);
            toplinelabel.frame=CGRectMake(0,[self findViewHeight:profileimageview.frame]+10 , postView.frame.size.width, 0.5);
        }
       
          deletebtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
        flagbtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
       
        
        if (textvalLabel.hidden) {
             postImageview.frame=CGRectMake(0, [self findViewHeight:toplinelabel.frame]+8, self.postView.frame.size.width, self.postView.frame.size.height-150);
             pointlabel.frame=CGRectMake(10, [self findViewHeight:postImageview.frame]+10,postView.frame.size.width-60, 30);
        }
        else
        {
            textvalLabel.frame=CGRectMake(10, [self findViewHeight:toplinelabel.frame]+3,postView.frame.size.width-20,45);
            postImageview.frame=CGRectMake(0, [self findViewHeight:textvalLabel.frame], self.postView.frame.size.width, self.postView.frame.size.height-195);
             pointlabel.frame=CGRectMake(10,[self findViewHeight:postImageview.frame]+10,postView.frame.size.width-60, 30);
        }
        
      
       
        
        
        bottomlinelabel.frame=CGRectMake(0,[self findViewHeight:pointlabel.frame]+2 , postView.frame.size.width, 0.5);
        

        upvotebtn.frame=CGRectMake(postView.frame.size.width-40, [self findViewHeight:bottomlinelabel.frame]+2, 40, 40);
        downvotebtn.frame=CGRectMake(postView.frame.size.width-80, [self findViewHeight:bottomlinelabel.frame]+2, 40, 40);
        replybtn.frame=CGRectMake(10,[self findViewHeight:bottomlinelabel.frame]+10, 30, 30);


    }
    
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
