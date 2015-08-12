//
//  MenuListViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/24/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "CreateGroupViewController.h"
#import "ProfileViewController.h"
#import <ParseUI/PFImageView.h>
@interface MenuListViewController : UIViewController
{
    NSArray *menuArray,*menuimageArray;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *namelabel;
@property (strong, nonatomic) IBOutlet PFImageView *profileimageview;
@property (strong, nonatomic) IBOutlet UITableView *Menulist_tableview;
@end
