//
//  CreateGroupViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "Generic.h"
@interface CreateGroupViewController : UIViewController<UIGestureRecognizerDelegate>
{
    NSMutableArray *grouptype,*groupdetailArray,*grouptypeimg;
    int selectedIndex;
    Generic *sharedObj;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UITableView *createtableView;
- (IBAction)movetocreate:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *createbtn;

@end
