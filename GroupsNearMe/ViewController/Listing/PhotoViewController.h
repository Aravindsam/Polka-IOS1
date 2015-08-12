//
//  PhotoViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/16/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import "AppDelegate.h"
@interface PhotoViewController : UIViewController
{
    Generic *sharedObj;
    NSMutableArray *photoArray;
    UIRefreshControl *refreshControl;
}
@property (strong, nonatomic) IBOutlet UIView *noresultlabel;
@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@end
