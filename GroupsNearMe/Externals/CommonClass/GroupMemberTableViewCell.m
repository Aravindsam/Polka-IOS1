//
//  GroupMemberTableViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/8/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "GroupMemberTableViewCell.h"

@implementation GroupMemberTableViewCell
@synthesize postView,namelbl,profileImageView,adminlbl,separator;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *content = self.contentView;
        postView=[[UIView alloc]init];
        [postView setBackgroundColor:[UIColor clearColor]];
        [content addSubview:postView];
       
        
        profileImageView=[[PFImageView alloc]init];
        [postView addSubview:profileImageView];
        
        separator=[[UIImageView alloc]init];
        separator.image=[UIImage imageNamed:@"line.png"];
        [content addSubview:separator];
        
        adminlbl=[[UILabel alloc]init];
        adminlbl.textColor=[UIColor lightGrayColor];
        adminlbl.text=@"A";
        adminlbl.textAlignment=NSTextAlignmentCenter;
        adminlbl.layer.borderWidth=1.0;
        adminlbl.font=[UIFont fontWithName:@"Lato-Regular" size:13.0];
        adminlbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [postView addSubview:adminlbl];
        
        namelbl=[[UILabel alloc]init];
        namelbl.numberOfLines=0;
        namelbl.font=[UIFont fontWithName:@"Lato-Regular" size:16.0];
        namelbl.textColor=[UIColor blackColor];
        [postView addSubview:namelbl];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    postView.frame=CGRectMake(10, 10, contentRect.size.width-20, contentRect.size.height-20);
      namelbl.frame=CGRectMake(65,30,postView.frame.size.width-95, 20);
    [namelbl sizeToFit];
    profileImageView.frame=CGRectMake(0, 0, 50, 50);
    adminlbl.frame=CGRectMake(namelbl.frame.size.width+85, 35, 15, 15);
    separator.frame=CGRectMake(0, contentRect.size.height-0.5, contentRect.size.width, 0.5);

  
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
