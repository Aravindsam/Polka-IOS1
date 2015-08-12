//
//  AppDelegate.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import "MFSideMenuContainerViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Generic *sharedObj;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

