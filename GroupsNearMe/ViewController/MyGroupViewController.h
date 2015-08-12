//
//  MyGroupViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import "AppDelegate.h"
#import "NSDate+HumanizedTime.h"

@interface MyGroupViewController : UIViewController
{
    Generic *sharedobj;
    NSMutableArray *mygroupIDArray;
    UILabel*label;
    NSDate *lastupdate;
    NSString*currentdate;
    UITapGestureRecognizer*switchtap;
    NSDateHumanizedType humanizedType;

}
@property (strong, nonatomic) IBOutlet UILabel *switchtotab;
@property (nonatomic, assign) UINavigationController *navigationController;
@property (strong, nonatomic) IBOutlet UIView *noresultView;

@property (strong, nonatomic) IBOutlet UITableView *mygroupTableview;
@property (strong, nonatomic) IBOutlet UILabel *noresultlabel;

@end
