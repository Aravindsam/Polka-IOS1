//
//  SecretGrpViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import "PECropViewController.h"
#import "NSDate+HumanizedTime.h"

@interface SecretGrpViewController : UIViewController<UIImagePickerControllerDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
{
    UIImagePickerController *imagePicker;
    BOOL newMedia;
    CLLocationManager *locationManager;
    NSString*groupName,*groupDescription,*groupId,*otpValue;
    NSString*mobileno,*secretcode,*currentdate,*timestamp;
    Generic*sharedObj;
    NSMutableArray*mygroup;
    PFGeoPoint *point;
    BOOL create;
    PFFile*groupimgurl;
    UIImage* image;
    NSData *groupImageData;
    NSDateHumanizedType humanizedType;

}

@property (strong, nonatomic) IBOutlet UILabel *addlabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *gobtn;

@property (strong, nonatomic) IBOutlet UIImageView *groupImageview;
- (IBAction)memberbtnclicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *adminbtn;
@property (strong, nonatomic) IBOutlet UIButton *memberbtn;

@property (strong, nonatomic) IBOutlet UIView *headerview;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *aboutTextview;
@property (strong, nonatomic) IBOutlet UITextField *groupnameTextfield;
- (IBAction)adminbtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *secretScrollview;
@property (strong, nonatomic) IBOutlet UIView *secretgrpView;
- (IBAction)createSecretGroup:(id)sender;
@end
