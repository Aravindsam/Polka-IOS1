//
//  CustomCell.h
//  AJNotification
//
//  Created by Jannath Begum on 12/11/14.
//  Copyright (c) 2014 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
@interface CustomCell : UITableViewCell
{
    NSMutableArray *EmailTextArray;
}
@property(nonatomic,retain)UILabel *textValueLabel;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)UIImageView *Selectimage;
@property(nonatomic, assign)id didselectDelegate;
@end
