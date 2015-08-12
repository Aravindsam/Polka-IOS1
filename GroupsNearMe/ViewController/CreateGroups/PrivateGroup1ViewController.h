//
//  PrivateGroup1ViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/18/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import "Generic.h"
#import <Parse/Parse.h>
#import "PrivateGroup2ViewController.h"
#import "PECropViewController.h"
@interface PrivateGroup1ViewController : UIViewController<CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
{
    NSString *groupName;
    PFGeoPoint *pointVal;
    Generic *sharedObj;
    CLLocationCoordinate2D centre;
    UIImagePickerController *imagePicker;
    NSString*groupDescription;
    BOOL newMedia,next;
    PFGeoPoint *point;
    UIImage* image;
      NSData *groupImageData;
}

@property (strong, nonatomic) IBOutlet UILabel *addlabel;
@property (strong, nonatomic) IBOutlet UIButton *adminbtn;
- (IBAction)adminbtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *memberbtn;
- (IBAction)memberbtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIView *privateview;
@property (strong, nonatomic) IBOutlet UIScrollView *privateScrollview;
@property (strong, nonatomic) IBOutlet UIImageView *groupImageview;
@property (strong, nonatomic) IBOutlet UITextView *aboutTextview;
@property (nonatomic, strong) CLLocationManager *locationManager;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *headerview;
- (IBAction)nextbtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *groupnameTextfield;
@property (strong, nonatomic) IBOutlet UIButton *nextbtn;
@end
