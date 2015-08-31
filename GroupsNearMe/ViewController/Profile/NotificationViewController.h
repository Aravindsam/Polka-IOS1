//
//  NotificationViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 8/26/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+HumanizedTime.h"
#import "Generic.h"
@interface NotificationViewController : UIViewController
{
     NSDateHumanizedType humanizedType;
    Generic*sharedObj;

}
@property (strong, nonatomic) IBOutlet UIView *notificationView;
@property (strong, nonatomic) IBOutlet UITableView *notificationtableview;
- (IBAction)back:(id)sender;
@end
