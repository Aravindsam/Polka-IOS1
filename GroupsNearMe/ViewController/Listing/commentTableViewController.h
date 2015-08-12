//
//  commentTableViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/27/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Generic.h"
#import "KxMenu.h"
#import <Accounts/Accounts.h>
#import "WhatsAppKit.h"
#import "SVProgressHUD.h"
#import "PAPLoadMoreCell.h"
#import <CoreLocation/CoreLocation.h>
#import "NSDate+HumanizedTime.h"
@class commentTableViewController;

@protocol commentTableViewControllerDataSource <NSObject>


@end
@interface commentTableViewController : PFQueryTableViewController<MFMailComposeViewControllerDelegate,CLLocationManagerDelegate>
{
    Generic*sharedObj;
    UILabel*label;
    float tableHeight;
    NSMutableArray*flagArray;
    int flagindex;
    NSMutableArray*likeArray;
    NSMutableArray*dislikeArray;
    NSMutableArray*flagUserArray;
    SLComposeViewController *mySlcomposerView;
    NSString*currentuserMobileNo;
    PFObject *sharefeed;
    int flagcount,userflagcount;
    int deleteindex;
    CLLocationManager *locationManager;
    CLLocation *_currentLocation;
    PFImageView *largeImageView;
    UIView *viewcontroller;
    NSDateHumanizedType humanizedType;

}
-(void)Profiletap:(int)index8;
- (void)postWasCreated;
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@property (strong, nonatomic)PFGeoPoint *point;
-(void)imageAction:(int)index;
-(void)upvoteAction:(int)index;
-(void)downvoteAction:(int)index1;
-(void)flagAction:(int)index2;
-(void)shareAction:(int)index3 :(UIButton*)sender;
-(void)deleteAction:(int)index7;
 @property (nonatomic) BOOL doneLoading;
@property (nonatomic, weak) id<commentTableViewControllerDataSource> dataSource;

@end
