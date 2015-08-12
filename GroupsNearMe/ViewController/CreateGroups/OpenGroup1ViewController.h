//
//  OpenGroup1ViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/18/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+ResizeAdditions.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "PECropViewController.h"
@interface OpenGroup1ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,PECropViewControllerDelegate>
{
    NSString *groupname;
    Generic *sharedObj;
    UIImagePickerController *imagePicker;
    BOOL newMedia,next;
    NSString*groupDescription;
    CLLocationManager *locationManager;
    PFGeoPoint *point;
    UIImage* image;
    NSData *groupImageData;

}

@property (strong, nonatomic) IBOutlet UIView *publicView;
@property (strong, nonatomic) IBOutlet UIButton *nextbtn;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *publicScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *groupImageview;
@property (strong, nonatomic) IBOutlet UITextView *aboutTextview;
@property (strong, nonatomic) IBOutlet UIView *headerview;
@property (strong, nonatomic) IBOutlet UITextField *groupnameTextfield;
- (IBAction)nextbtnClicked:(id)sender;
- (IBAction)back:(id)sender;
@end
