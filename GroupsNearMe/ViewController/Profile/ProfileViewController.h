//
//  ProfileViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/13/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "Generic.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ParseUI/PFImageView.h>
#import "PECropViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "KxMenu.h"
#import <Accounts/Accounts.h>
@interface ProfileViewController : UIViewController<UIImagePickerControllerDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
{
    int userPoint;
    BOOL newMedia;
    NSString*profilename;
    NSString*genderval;
    BOOL push,sound;
    PFFile *imageFile;
    NSString*ProfileId;
    Generic*sharedObj;
      UIImage* image;
    SLComposeViewController *mySlcomposerView;


}
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;

- (IBAction)uploadimg:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *fullimageview;
@property (strong, nonatomic) IBOutlet PFImageView *profilefullimgview;
- (IBAction)sharepic:(id)sender;
- (IBAction)close:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *footerlabel;

@property (strong, nonatomic) IBOutlet UILabel *nameCountLabel;
@property (strong, nonatomic) IBOutlet PFImageView *ProfileImageview;
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UIButton *updatebtn;

@property (strong, nonatomic) IBOutlet UIView *headerview;
- (IBAction)updateProfile:(id)sender;
- (IBAction)back:(id)sender;
@end
