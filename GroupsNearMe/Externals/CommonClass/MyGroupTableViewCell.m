//
//  MyGroupTableViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/28/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "MyGroupTableViewCell.h"
#import "MyGroupViewController.h"

@implementation MyGroupTableViewCell

@synthesize memberlabel,groupImageview,groupnamelbl,grouptypelbl,adminlbl,messagecountlabel,memberImage,separator;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *content = self.contentView;
        groupImageview=[[PFImageView alloc]init];
        [content addSubview:groupImageview];
        [groupImageview.layer setMasksToBounds:YES];
        
        
        memberImage=[[UIImageView alloc]init];
        memberImage.image=[UIImage imageNamed:@"members.png"];
        memberImage.alpha=0.6;
        [content addSubview:memberImage];
        
        separator=[[UIImageView alloc]init];
        separator.image=[UIImage imageNamed:@"line.png"];
        [content addSubview:separator];
        
        groupnamelbl=[[UILabel alloc]init];
        groupnamelbl.numberOfLines=0;
        [groupnamelbl setFont:[UIFont fontWithName:@"Lato-Regular" size:14.0]];
        [content addSubview:groupnamelbl];
        
    
        grouptypelbl=[[UILabel alloc]init];
               grouptypelbl.textColor=[UIColor darkGrayColor];
        grouptypelbl.textAlignment=NSTextAlignmentLeft;
        grouptypelbl.font=[UIFont fontWithName:@"Lato-Regular" size:11.0];
        grouptypelbl.alpha=0.6;
        [content addSubview:grouptypelbl];
        
        adminlbl=[[UILabel alloc]init];
       
        adminlbl.text=@"Admin";
        adminlbl.font=[UIFont fontWithName:@"Lato-Regular" size:13.0];
        adminlbl.textAlignment=NSTextAlignmentCenter;
        adminlbl.textColor=[UIColor darkGrayColor];
        adminlbl.alpha=0.6;

        [content addSubview:adminlbl];
        
        memberlabel=[[UILabel alloc]init];
        
        memberlabel.textAlignment=NSTextAlignmentLeft;
        memberlabel.textColor=[UIColor darkGrayColor];

        memberlabel.alpha=0.6;
      
        [content addSubview:memberlabel];
        
        
        messagecountlabel=[[UILabel alloc]init];
        messagecountlabel.textColor=[UIColor whiteColor];
        [messagecountlabel setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:152.0/255.0 blue:0.0/255.0 alpha:1.0]];
        messagecountlabel.textAlignment=NSTextAlignmentCenter;
        [content addSubview:messagecountlabel];
        
        messagecountlabel.font=[UIFont fontWithName:@"Lato-Regular" size:11.0];

        
               memberlabel.font=[UIFont fontWithName:@"Lato-Regular" size:11.0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    groupImageview.frame=CGRectMake(5, 5,65,65);
  
    groupnamelbl.frame=CGRectMake(80, 5,contentRect.size.width-150,30);
    [self findFrameFromString:groupnamelbl.text andCorrespondingLabel:groupnamelbl];
    memberImage.frame=CGRectMake(80,55, 15, 15);
    memberlabel.frame=CGRectMake(100, 55,  contentRect.size.width-140,15);
    [self findFrameFromString:memberlabel.text andCorrespondingLabel:memberlabel];
    memberlabel.frame=CGRectMake(100, 55,memberlabel.frame.size.width+10,15);
    grouptypelbl.frame=CGRectMake(memberlabel.frame.size.width+100,55, 60, 15);
    messagecountlabel.frame=CGRectMake(contentRect.size.width-35,47.5 , 22.5, 22.5);
    messagecountlabel.layer.cornerRadius=11.25;
    messagecountlabel.clipsToBounds=YES;
     adminlbl.frame=CGRectMake(contentRect.size.width-60,5, 50, 20);
    separator.frame=CGRectMake(0, contentRect.size.height-0.5, contentRect.size.width, 0.5);

    
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

@end
