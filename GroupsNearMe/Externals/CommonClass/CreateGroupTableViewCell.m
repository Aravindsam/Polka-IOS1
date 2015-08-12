//
//  CreateGroupTableViewCell.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/15/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "CreateGroupTableViewCell.h"

@implementation CreateGroupTableViewCell
@synthesize namelabel,detaillabel,selectimageview,containerview,grouptypeimageview;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *content = self.contentView;
        containerview=[[UIView alloc]init];

        [content addSubview:containerview];
        
        namelabel=[[UILabel alloc]init];
        namelabel.font=[UIFont fontWithName:@"Lato-Regular" size:15.0];
        [containerview addSubview:namelabel];
        
        detaillabel=[[UILabel alloc]init];
        detaillabel.font=[UIFont fontWithName:@"Lato-Regular" size:12.0];
        detaillabel.numberOfLines=0;
        [containerview addSubview:detaillabel];
        
        selectimageview=[[UIImageView alloc]init];
        selectimageview.image=[UIImage imageNamed:@"unselected.png"];
        [containerview addSubview:selectimageview];
        
        grouptypeimageview=[[UIImageView alloc]init];
        [containerview addSubview:grouptypeimageview];
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    containerview.frame=CGRectMake(10, 10, contentRect.size.width-20, contentRect.size.height-20);
    selectimageview.frame=CGRectMake(containerview.frame.size.width-20,27.5,25,25);
    namelabel.frame=CGRectMake(55, 3, containerview.frame.size.width-55,25);
    detaillabel.frame=CGRectMake(57, 30, containerview.frame.size.width-90, 75);
    [detaillabel sizeToFit];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
