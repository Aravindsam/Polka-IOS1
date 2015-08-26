//
//  PublicDetailTableViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/13/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "PublicDetailTableViewCell.h"
#import "commentTableViewController.h"
@implementation PublicDetailTableViewCell
@synthesize textvalLabel,timelabel,upvotebtn,downvotebtn,pointlabel,toplinelabel,bottomlinelabel,postView,flagbtn,postImageview,profileimageview,profilenamelabel,deletebtn;
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
        textvalLabel.numberOfLines=0;
        textvalLabel.lineBreakMode=NSLineBreakByCharWrapping;
        textvalLabel.linkDetectionTypes ^= KILinkTypeURL;
        textvalLabel.userInteractionEnabled=YES;
        textvalLabel.lineBreakMode=NSLineBreakByCharWrapping;
        [textvalLabel setFont:[UIFont fontWithName:@"Lato-regular" size:16.0]];
        [postView addSubview:textvalLabel];
        
        timelabel =[[UILabel alloc]init];
        timelabel.font=[UIFont fontWithName:@"Lato-regular" size:10.0];
        timelabel.textAlignment=NSTextAlignmentLeft;
        timelabel.textColor=[UIColor lightGrayColor];

        [postView addSubview:timelabel];
        
        profilenamelabel =[[UILabel alloc]init];
        profilenamelabel.font=[UIFont fontWithName:@"Lato-regular" size:13.0];
        profilenamelabel.textAlignment=NSTextAlignmentLeft;
        profilenamelabel.textColor=[UIColor lightGrayColor];

        [postView addSubview:profilenamelabel];
        
        profileimageview=[[PFImageView alloc]init];
        [postView addSubview:profileimageview];
        
        pointlabel =[[UILabel alloc]init];
        pointlabel.font=[UIFont systemFontOfSize:10.0];
        pointlabel.numberOfLines=0;
        pointlabel.textColor=[UIColor lightGrayColor];
        pointlabel.userInteractionEnabled=YES;
        
        singletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pointtap:)];
        singletap.numberOfTapsRequired=1;
        [postImageview addGestureRecognizer:singletap];
        
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
        
      

        
        deletebtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [deletebtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        
        [postView addSubview:deletebtn];
        
        toplinelabel=[[UILabel alloc]init];
        toplinelabel.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [postView addSubview:toplinelabel];
        
        bottomlinelabel=[[UILabel alloc]init];
        bottomlinelabel.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [postView addSubview:bottomlinelabel];

        
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
    [_didselectDelegate deleteAction:bTag];
}
-(void)pointtap:(UITapGestureRecognizer*)sender
{
    NSLog(@"TAP");    UIView *view = sender.view;
   int bTag = (int)view.tag;
   [_didselectDelegate imageAction:bTag];
    
}

-(void)upvote:(UIButton*)sender
{
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [_didselectDelegate upvoteAction:bTag];
}
-(void)downvote:(UIButton*)sender
{
     NSLog(@"DOWNVOTE");
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [_didselectDelegate downvoteAction:bTag];
    
}

-(void)share:(UIButton*)sender
{
     NSLog(@"SHARE");
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [_didselectDelegate shareAction:bTag :sender];
}
-(void)flag:(UIButton*)sender
{
    NSLog(@"FLAG");
    UIButton *button = (UIButton *)sender;
    int bTag = (int)button.tag;
    [_didselectDelegate flagAction:bTag];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    
    postView.frame=CGRectMake(10, 5, contentRect.size.width-20, contentRect.size.height-10);
    if (postImageview.hidden) {
        
        if (profileimageview.hidden) {
            deletebtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
            flagbtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
            timelabel.frame=CGRectMake(10, 0, postView.frame.size.width-140, 40);
            toplinelabel.frame=CGRectMake(0,52 , postView.frame.size.width, 0.5);
            timelabel.font=[UIFont fontWithName:@"Lato-Bold" size:13.0];
        }
        else{
            profileimageview.frame=CGRectMake(10, 10, 35, 35);
            profilenamelabel.frame=CGRectMake(47, 5,postView.frame.size.width-135, 20);
            deletebtn.frame=CGRectMake(postView.frame.size.width-40,0, 40, 40);
            flagbtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
            timelabel.frame=CGRectMake(47, 33, postView.frame.size.width-135, 15);
            toplinelabel.frame=CGRectMake(0,[self findViewHeight:profileimageview.frame]+7 , postView.frame.size.width, 0.5);
        }

         textvalLabel.frame=CGRectMake(10, [self findViewHeight:toplinelabel.frame]+5,postView.frame.size.width-20,postView.frame.size.height-132);
        [self findFrameFromString:textvalLabel.text andCorrespondingLabel:textvalLabel];
        pointlabel.frame=CGRectMake(10, [self findViewHeight:textvalLabel.frame],postView.frame.size.width-70, 30);
        
        
        bottomlinelabel.frame=CGRectMake(0,[self findViewHeight:pointlabel.frame]+5 , postView.frame.size.width, 0.5);
        
        upvotebtn.frame=CGRectMake(postView.frame.size.width-40, [self findViewHeight:bottomlinelabel.frame]+5, 40, 40);
        downvotebtn.frame=CGRectMake(postView.frame.size.width-80, [self findViewHeight:bottomlinelabel.frame]+5, 40, 40);
        
     
        
    }
    else
    {
        if (profileimageview.hidden) {
            timelabel.frame=CGRectMake(10, 0, postView.frame.size.width-135, 40);
            toplinelabel.frame=CGRectMake(0,52 , postView.frame.size.width, 0.5);
            timelabel.font=[UIFont fontWithName:@"Lato-Bold" size:13.0];
        }
        else{
            profileimageview.frame=CGRectMake(10, 10, 35, 35);
            profilenamelabel.frame=CGRectMake(47, 5,postView.frame.size.width-135, 20);
            timelabel.frame=CGRectMake(47, 33, postView.frame.size.width-135, 15);
            toplinelabel.frame=CGRectMake(0,[self findViewHeight:profileimageview.frame]+7 , postView.frame.size.width, 0.5);
        }
        deletebtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
        flagbtn.frame=CGRectMake(postView.frame.size.width-40, 0, 40, 40);
        if (textvalLabel.hidden) {
            
               postImageview.frame=CGRectMake(2, [self findViewHeight:toplinelabel.frame]+8, self.postView.frame.size.width-4, self.postView.frame.size.height-150);
            
            pointlabel.frame=CGRectMake(10, [self findViewHeight:postImageview.frame]+5,postView.frame.size.width-70, 30);
        }
        else
        {
            textvalLabel.frame=CGRectMake(10, [self findViewHeight:toplinelabel.frame]+5,postView.frame.size.width-20,postView.frame.size.height-(170+self.postView.frame.size.height-210));
            [self findFrameFromString:textvalLabel.text andCorrespondingLabel:textvalLabel];
            postImageview.frame=CGRectMake(2, [self findViewHeight:textvalLabel.frame], self.postView.frame.size.width-4, self.postView.frame.size.height-(90+[self findViewHeight:textvalLabel.frame]));
            pointlabel.frame=CGRectMake(10, [self findViewHeight:postImageview.frame]+5,postView.frame.size.width-70, 30);
        }
     
        bottomlinelabel.frame=CGRectMake(0,[self findViewHeight:pointlabel.frame]+5 , postView.frame.size.width, 0.5);
        upvotebtn.frame=CGRectMake(postView.frame.size.width-40, [self findViewHeight:bottomlinelabel.frame], 40, 40);
        downvotebtn.frame=CGRectMake(postView.frame.size.width-80, [self findViewHeight:bottomlinelabel.frame], 40, 40);
        

    }

  
   
    
    
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
