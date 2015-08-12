//
//  InsideGroupViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/19/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import <ParseUI/PFImageView.h>
@interface InsideGroupViewController : UIViewController<UITabBarDelegate,UIGestureRecognizerDelegate,UIGestureRecognizerDelegate> {
    NSArray *viewControllers;
    IBOutlet UITabBar *tabBar;
    IBOutlet UITabBarItem *feedTabBarItem;
    IBOutlet UITabBarItem *hotTabBarItem;
    UITapGestureRecognizer *imagetap,*labeltap;
    UIViewController *selectedViewController;
    Generic *sharedObj;
    NSString*ownerNumber;
    NSString*currentdate;
    BOOL tap;
    UISwipeGestureRecognizer *leftgesture,*rightgesture;

}
@property (strong, nonatomic) IBOutlet PFImageView *groupImageview;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *grouptitleLabel;
@property(nonatomic,retain)NSString *groupTypeVal;
@property (strong, nonatomic) IBOutlet UIView *tabview;
- (IBAction)back:(id)sender;
@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) IBOutlet UITabBarItem *feedTabBarItem;
@property (nonatomic, retain) IBOutlet UITabBarItem *hotTabBarItem;

@property (nonatomic, retain) UIViewController *selectedViewController;


@end
