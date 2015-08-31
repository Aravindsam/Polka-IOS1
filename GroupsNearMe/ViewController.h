//
//  ViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import "MFSideMenu.h"
#import "MyGroupViewController.h"
#import "NearbyViewController.h"
#import "NSDate+HumanizedTime.h"
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#import "NotificationViewController.h"

@interface ViewController : UIViewController<UITabBarDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate> {
    NSArray *viewControllers;
    IBOutlet UITabBar *tabBar;
    IBOutlet UITabBarItem *nearbyTabBarItem;
    IBOutlet UITabBarItem *mygroupTabBarItem;
    NearbyViewController *profileViewController;
    MyGroupViewController *postViewController;
    UIViewController *selectedViewController;
    Generic*sharedObj;
    int userPoint;
    NSString*currentdate;
    UISearchBar *thesearchBar;
    NSMutableArray*tempnearbyArray,*resultArray;
    int arrayindex;
    NSMutableArray *mygroupIDArray;
    UISwipeGestureRecognizer *leftgesture,*rightgesture;
    NSDateHumanizedType humanizedType;

}


@property (strong, nonatomic) IBOutlet UISearchBar *thesearchBar;
- (IBAction)backsearch:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *headerview;
@property (strong, nonatomic) IBOutlet UIView *searchView;

@property (strong, nonatomic) IBOutlet UIView *tabview;
@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) IBOutlet UITabBarItem *nearbyTabBarItem;
@property (nonatomic, retain) IBOutlet UITabBarItem *mygroupTabBarItem;
@property (strong, nonatomic) IBOutlet UILabel *indicationlbl;

- (IBAction)searchbtnAction:(id)sender;
@property (nonatomic, retain) UIViewController *selectedViewController;
- (IBAction)showMenu:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *userbadge;
- (IBAction)userbadgeBtnAction:(id)sender;
- (IBAction)notificationbtnAction:(id)sender;


@end

