//
//  UpdateAccessPermissionViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/20/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
@interface UpdateAccessPermissionViewController : UIViewController<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *passcodegesture,*addinfogesture;
    NSString *secretcode,*addinfostring;
    Generic *sharedObj;
    NSMutableArray*mygroup;
    BOOL secret,addinfo;
    NSString*currentdate;
}
- (IBAction)passcode:(id)sender;
- (IBAction)addinfo:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *addinfoSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *passcodeSwitch;
- (IBAction)donebtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *passcodeView;
@property (strong, nonatomic) IBOutlet UIView *addinfoView;
@property (strong, nonatomic) IBOutlet UILabel *addinfoLbl;

@property (strong, nonatomic) IBOutlet UILabel *addinfocontentLbl;
@property (strong, nonatomic) IBOutlet UITextField *addinfoTextfield;

@property (strong, nonatomic) IBOutlet UIButton *donebtn;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *passcodeLbl;

@property (strong, nonatomic) IBOutlet UILabel *passcodecontentlbl;
@property (strong, nonatomic) IBOutlet UITextField *passcodetextfield;
@end
