//
//  UpdateGroupProfileViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/20/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PECropViewController.h"
#import <ParseUI/PFImageView.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "KxMenu.h"
#import <Accounts/Accounts.h>
@interface UpdateGroupProfileViewController : UIViewController<UIImagePickerControllerDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate,MFMailComposeViewControllerDelegate>

{
    IBOutlet UILabel *memberCountLabel;
    UIImagePickerController *imagePicker;
    BOOL newMedia;
    Generic*sharedObj;
    NSString*groupName,*groupDescription;
    UITapGestureRecognizer *singletap;
    NSMutableArray*mygroup;
    NSString*typegroup;
    BOOL update;
    PFGeoPoint *point;
    SLComposeViewController *mySlcomposerView;

    UITapGestureRecognizer *membertap;
    CLLocationManager *locationManager;
    UIImage* image;
    NSString*currentdate;
    NSMutableArray *myGroupIdArray;
    NSString*inviationId;
    NSMutableArray*invitationarray;
    NSMutableArray*invitationArray,*ownerGroup,*groupMembers,*unquieArray;
    PFFile*userimage;
}
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;

- (IBAction)uploadimage:(id)sender;
@property(nonatomic,assign)BOOL Fromnearby;
@property(nonatomic,assign)int indexval;
@property (strong, nonatomic) IBOutlet UIButton *joinbutton;
- (IBAction)joingroup:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *estabilishedlabel;
@property (strong, nonatomic) IBOutlet UIView *fullimgView;
@property (strong, nonatomic) IBOutlet PFImageView *fullgroupimage;
- (IBAction)close:(id)sender;
- (IBAction)sharepic:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundeffectImageview;

@property (strong, nonatomic) IBOutlet UIButton *changeimagebtn;
@property (strong, nonatomic) IBOutlet UILabel *adminlbl;
@property (strong, nonatomic) IBOutlet UILabel *memberlbl;
@property (strong, nonatomic) IBOutlet UILabel *membershiplabel;
- (IBAction)updateprofile:(id)sender;
@property (strong, nonatomic) IBOutlet PFImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *gobtn;
- (IBAction)memberbtnclicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *adminbtn;
@property (strong, nonatomic) IBOutlet UIButton *memberbtn;
@property (strong, nonatomic) IBOutlet UITextView *aboutTextview;
@property (strong, nonatomic) IBOutlet UITextField *groupnameTextfield;
- (IBAction)adminbtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *profilegrpScrollview;
@property (strong, nonatomic) IBOutlet UIView *profilegrpgrpView;
@end
