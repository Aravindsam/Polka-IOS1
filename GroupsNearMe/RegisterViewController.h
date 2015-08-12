//
//  RegisterViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Generic.h"
#import "PECropViewController.h"
#import "NSDate+HumanizedTime.h"

@interface RegisterViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
{
    UIImagePickerController *imagePicker;
    BOOL newMedia;
    NSString *name,*gender,*email;
    Generic *sharedObj;
      UIImage* image;
    NSDateHumanizedType humanizedType;

}
@property (strong, nonatomic) IBOutlet UILabel *termlabel;
@property (strong, nonatomic) IBOutlet UILabel *headerlabel;
@property (strong, nonatomic) IBOutlet UIButton *donebtn;
@property (strong, nonatomic) IBOutlet UILabel *privacylabel;

@property (strong, nonatomic) IBOutlet UIScrollView *registerScrollView;
@property (strong, nonatomic) IBOutlet UIButton *malebtn;
- (IBAction)femalebtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *femalebtn;
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundimageview;
@property (strong, nonatomic) IBOutlet UITextField *emailTextfield;

- (IBAction)malebtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageview;
- (IBAction)gotowelcome:(id)sender;
@end
