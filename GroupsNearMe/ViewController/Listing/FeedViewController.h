//
//  FeedViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/20/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ParseUI/ParseUI.h>
#import "Generic.h"
#import "HPGrowingTextView.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface FeedViewController : UIViewController<HPGrowingTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *feedArray,*postArray,*timeArray;
    Generic*sharedObj;
    UILabel *label,*postlabel;
    HPGrowingTextView *textView1;
    BOOL newMedia;
    CLLocationManager *locationManager;
    CLLocation *_currentLocation;
    UIViewController*viewcontroller;
    UIImageView *photoImageView,*backfroundimageview;
    UITextView *addCaption;
    UIView*backgroundview;
    UIButton *cancelbtn,*sendbtn;
    UIImage *feedimage;
    PFFile*userimage;
    BOOL internetConnected;
    UITapGestureRecognizer*update;
}
@property (strong, nonatomic) IBOutlet UIButton *newpostbtn;

- (IBAction)updatepost:(id)sender;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *b1;
@property (strong, nonatomic) IBOutlet UIButton *b3;
@property (strong, nonatomic) IBOutlet UIButton *b4;
@property (strong, nonatomic)PFGeoPoint *point;
@property (strong, nonatomic) IBOutlet UIButton *b2;
@property (strong, nonatomic) IBOutlet UIView *insideView;
- (IBAction)flag:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *okbtn;
@property (strong, nonatomic) IBOutlet UIButton *cancellbtn;

- (IBAction)cancelFalg:(id)sender;
- (IBAction)okFlag:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *flagView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *newpostView;

@property (strong, nonatomic) IBOutlet UIView *postView;
@end
