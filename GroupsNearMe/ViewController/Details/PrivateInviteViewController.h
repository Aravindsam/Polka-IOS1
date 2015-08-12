//
//  PrivateInviteViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/22/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
@class ASIHTTPRequest;
#define NUMERIC @"1234567890"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "GroupModalClass.h"
#import <CoreLocation/CoreLocation.h>
#import "CustomCell.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface PrivateInviteViewController : UIViewController<CLLocationManagerDelegate>
{
   
    NSMutableArray *CountryArray;
    Generic*sharedObj;
    ASIHTTPRequest *signupRequest;
    UITapGestureRecognizer*singletap,*singletap1,*greenchanneltap,*inviteTap;
    NSMutableArray*myGroupArray,*mygroupIdArray,*mygroup,*mobilenoArray,*indiaArray,*usArray,*memberArray,*tempmobilenoArray;
    NSString*groupId,*groupimgurl;
    NSString *mobileno,*countryname;
    NSString*tempString;
    BOOL openEntry;
    NSString*currentdate;
    UILabel*label;
     int openentry;
    CLLocationManager *locationManager;
    CLLocation *_currentLocation;
    NSString*string1;
}
@property (strong, nonatomic)PFGeoPoint *point;
@property (strong, nonatomic) IBOutlet UIScrollView *invitescrollview;

@property (strong, nonatomic) IBOutlet UIImageView *inviteImgview;
@property (strong, nonatomic) IBOutlet UIView *openentryView;
@property (strong, nonatomic) IBOutlet UISwitch *openSwitch;

@property (strong, nonatomic) IBOutlet UIView *inviteView;
@property (strong, nonatomic) IBOutlet UILabel *invitelbel;
@property (strong, nonatomic) IBOutlet UIView *sliderView;
- (IBAction)back:(id)sender;
- (IBAction)openEntrybtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *minsbtn;
@property (strong, nonatomic) IBOutlet UIButton *hour1btn;
- (IBAction)hour1btnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *daybtn;
- (IBAction)daybtnAction:(id)sender;
- (IBAction)hour6btnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *hour6btn;
@property (strong, nonatomic) IBOutlet UIButton *createbtn;
- (IBAction)createGroup:(id)sender;
- (IBAction)openEntrySwitch:(id)sender;

- (IBAction)addNum:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UITableView *countrytableview;
@property (strong, nonatomic) IBOutlet UITextField *countrycodeTextfield;
@property (strong, nonatomic) IBOutlet UITextField *mobileTextField;

@property (strong, nonatomic) IBOutlet UITableView *mobileTableview;
@end
