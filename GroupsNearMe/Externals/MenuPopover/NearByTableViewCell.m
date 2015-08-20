//
//  NearByTableViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/10/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "NearByTableViewCell.h"
#import "NearbyViewController.h"
@implementation NearByTableViewCell
@synthesize joinbtn,memberlabel,groupImageview,groupnamelbl,grouptypelbl,requestlabel,aboutLabel,aboutHeight,separator,memberImage;

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
        
        aboutLabel=[[UILabel alloc]init];
        aboutLabel.numberOfLines=0;
        [aboutLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:15.0]];
        [content addSubview:aboutLabel];
        
        
        grouptypelbl=[[UILabel alloc]init];
                grouptypelbl.textColor=[UIColor darkGrayColor];
        grouptypelbl.alpha=0.6;
        grouptypelbl.textAlignment=NSTextAlignmentLeft;
        grouptypelbl.font=[UIFont fontWithName:@"Lato-Regular" size:11.0];
        [content addSubview:grouptypelbl];
        memberlabel=[[UILabel alloc]init];
        memberlabel.textAlignment=NSTextAlignmentLeft;
     
        memberlabel.textColor=[UIColor darkGrayColor];
        memberlabel.alpha=0.6;
        memberlabel.font=[UIFont fontWithName:@"Lato-Regular" size:11.0];
        [content addSubview:memberlabel];
        
        requestlabel=[[UILabel alloc]init];
        requestlabel.font=[UIFont fontWithName:@"Lato-Regular" size:10.0];
        requestlabel.layer.borderWidth=1.0;
        requestlabel.textAlignment=NSTextAlignmentCenter;
        [requestlabel setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:152.0/255.0 blue:0.0/255.0 alpha:1.0]];
        requestlabel.textColor=[UIColor whiteColor];
       
        requestlabel.layer.borderColor=[UIColor clearColor].CGColor;
        [content addSubview:requestlabel];
        
        
        joinbtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [joinbtn addTarget:self action:@selector(joingroup:) forControlEvents:UIControlEventTouchUpInside];
        [joinbtn setBackgroundColor:[UIColor colorWithRed:2.0/255.0 green:105.0/255.0 blue:153.0/255.0 alpha:1.0]];
      
        [content addSubview:joinbtn];
        
    }
    return self;
}
-(void)joingroup:(UIButton*)sender
{
    int bTag = (int)sender.tag;
    [_didselectDelegate joinbuttonPressed:bTag];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    groupImageview.frame=CGRectMake(5, 5,65,65);
    groupnamelbl.frame=CGRectMake(80,5,contentRect.size.width-80,30);
    [self findFrameFromString:groupnamelbl.text andCorrespondingLabel:groupnamelbl];
    memberImage.frame=CGRectMake(80,55, 15, 15);
    memberlabel.frame=CGRectMake(100, 55,  contentRect.size.width-140,15);
    [self findFrameFromString:memberlabel.text andCorrespondingLabel:memberlabel];
    memberlabel.frame=CGRectMake(100, 55,memberlabel.frame.size.width+10,15);
    grouptypelbl.frame=CGRectMake(memberlabel.frame.size.width+100,55, 55, 15);
    
    requestlabel.frame=CGRectMake(contentRect.size.width-80,(contentRect.size.height/2)+10,70,20);
    [joinbtn setFrame:CGRectMake(contentRect.size.width-80,(contentRect.size.height/2)+10,70, 20)];
    separator.frame=CGRectMake(0, contentRect.size.height-0.5, contentRect.size.width, 0.5);

    //requestlabel.backgroundColor=[UIColor redColor];
    
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
