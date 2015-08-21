//
//  CommentViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/24/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "Generic.h"
#import "HPGrowingTextView.h"
#import <ParseUI/PFImageView.h>
#import <Parse/Parse.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Accounts/Accounts.h>
#import "WhatsAppKit.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface CommentViewController : UIViewController<HPGrowingTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate>
{
     HPGrowingTextView *textView;
    Generic*sharedObj;
    CLLocationManager *locationManager;
    CLLocation *_currentLocation;
     PFObject *sharefeed;
    SLComposeViewController *mySlcomposerView;

}
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@property (strong, nonatomic) IBOutlet UIScrollView *fullimageScrollview;

- (IBAction)shareImage:(id)sender;
- (IBAction)closeview:(id)sender;
@property (strong, nonatomic) IBOutlet PFImageView *fullimgView;
@property (strong, nonatomic) IBOutlet UIView *FullimageView;
@property (strong, nonatomic) IBOutlet UIView *insideView;
- (IBAction)flag:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *okbtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelbtn;
@property (strong, nonatomic)PFGeoPoint *point;
- (IBAction)cancelFalg:(id)sender;
- (IBAction)okFlag:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *flagView;
@property (strong, nonatomic) IBOutlet UILabel *groupnamelabel;
@property (strong, nonatomic) IBOutlet PFImageView *groupimageview;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *headerview;
@property (strong, nonatomic) IBOutlet UIButton *b1;
@property (strong, nonatomic) IBOutlet UIButton *b3;
@property (strong, nonatomic) IBOutlet UIButton *b4;

@property (strong, nonatomic) IBOutlet UIButton *b2;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *postView;
@end
