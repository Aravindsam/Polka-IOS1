//
//  PostTableViewController.h
//  LBG
//
//  Created by Jannath Begum on 3/24/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "FeedViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "Generic.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSDate+HumanizedTime.h"
@class PostTableViewController;

@protocol PostTableViewControllerDataSource <NSObject>


@end
@interface PostTableViewController : PFQueryTableViewController<MFMailComposeViewControllerDelegate,CLLocationManagerDelegate>
{
    UILabel*label;
    float tableHeight;
    CGSize height;
    Generic*sharedObj;
    NSMutableArray*likeArray;
    NSMutableArray*dislikeArray;
    NSMutableArray*inviteArray,*groupMembers,*unquieArray,*mygroup,*ownergroup,*adminArray;
    NSString*objectidval;
    NSMutableArray*flagArray,*flagUserArray;
    int flagindex;
    int acceptindex,deleteindex;
    PFObject *sharefeed;
    BOOL Accept,approval;
    NSString*currentuserMobileNo;
    int flagcount,userflagcount;
    CLLocationManager *locationManager;
    CLLocation *_currentLocation;
    PFFile*userimage;
    int updateCount;
    int oldcount;
    NSDateHumanizedType humanizedType;

}
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;

@property (strong, nonatomic)PFGeoPoint *point;
-(void)imageAction:(int)index;
-(void)upvoteAction:(int)index;
-(void)downvoteAction:(int)index1;
-(void)flagAction:(int)index2;
-(void)shareAction:(int)index3 :(UIButton*)sender;
-(void)comment:(int)index4;
-(void)acceptAction:(int)index5;
-(void)rejectAction:(int)index6;
-(void)deleteAction:(int)index7;
-(void)Profiletap:(int)index8;
-(void)postWasCreated;

-(void)callService;
@property (nonatomic, weak) id<PostTableViewControllerDataSource> dataSource;

@end
