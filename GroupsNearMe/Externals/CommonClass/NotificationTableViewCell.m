//
//  NotificationTableViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/24/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell
@synthesize iconimageView,contentlabel,timelabel;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *content = self.contentView;
        
        iconimageView=[[AsyncImageView alloc]init];
        [content addSubview:iconimageView];
        
        contentlabel=[[UILabel alloc]init];
        contentlabel.numberOfLines=0;
        contentlabel.font=[UIFont fontWithName:@"Lato-Regular" size:16.0];
        contentlabel.textColor=[UIColor blackColor];
        [content addSubview:contentlabel];
        
        
        timelabel=[[UILabel alloc]init];
        timelabel.numberOfLines=0;
        timelabel.textColor=[UIColor lightGrayColor];
        timelabel.font=[UIFont fontWithName:@"Lato-Regular" size:14.0];
        [content addSubview:timelabel];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    iconimageView.frame=CGRectMake(10, 5, 70, 70);
    contentlabel.frame=CGRectMake(85, 5, contentRect.size.width-90,1000);
    [self findFrameFromString:contentlabel.text andCorrespondingLabel:contentlabel];
    contentlabel.frame=CGRectMake(85, 5, contentRect.size.width-90,contentlabel.frame.size.height);
    timelabel.frame=CGRectMake(85, [self findViewHeight:contentlabel.frame]+5, contentRect.size.width-90, 20);

    
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
