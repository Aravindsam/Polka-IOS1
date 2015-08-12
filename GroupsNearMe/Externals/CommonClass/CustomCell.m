//
//  CustomCell.m
//  AJNotification
//
//  Created by Jannath Begum on 12/11/14.
//  Copyright (c) 2014 Vishwak. All rights reserved.
//

#import "CustomCell.h"
#import "ViewController.h"
@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *content = self.contentView;
        self.textValueLabel =[[UILabel alloc]init];
        self.textValueLabel.numberOfLines=0;
        
        self.timeLabel=[[UILabel alloc]init];
        self.timeLabel.textColor=[UIColor lightGrayColor];
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        self.textValueLabel.backgroundColor=[UIColor clearColor];
        self.Selectimage=[[UIImageView alloc]init];
        self.timeLabel.font=[UIFont systemFontOfSize:12.0];
        [self.Selectimage setImage:[UIImage imageNamed:@"uncheck.png"]];
        self.Selectimage.tag=11;
//        [self.Selectimage setUserInteractionEnabled:YES];
//        [self.textValueLabel setUserInteractionEnabled:YES];
//        [self.textValueLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)]];
        [content addSubview:self.Selectimage];
        [content addSubview:self.textValueLabel];
        [content addSubview:self.timeLabel];
    }
    return self;
}
-(void)tapped:(id)sender
{
    NSLog(@"Tapped");
   // int touchtag=((UIGestureRecognizer *)sender).view.tag;

   //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:EmailTextArray forKey:@"Subscribed"];
//    [defaults synchronize];
   // [_didselectDelegate showDetails:touchtag];

} 
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    self.textValueLabel.frame = CGRectMake(45, 5, contentRect.size.width-55, contentRect.size.height-10);
    self.timeLabel.frame=CGRectMake(100, self.textValueLabel.frame.size.height-8, 210, 15);
    self.Selectimage.frame = CGRectMake(5, (self.textValueLabel.frame.size.height/2)-10, 30, 30);
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
