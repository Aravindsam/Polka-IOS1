//
//  OTPVerifyViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "Generic.h"
@interface OTPVerifyViewController : UIViewController
{
    NSString*otpString,*scheckotp;
    Generic *sharedObj;
        NSString*userstatus;
    NSString *mobileno,*countryname;
    NSMutableArray*mygroupIDArray;
    NSString*currentdate;
}
@property (strong, nonatomic) IBOutlet UILabel *verificationlbl;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundmageview;
@property (strong, nonatomic) IBOutlet UITextField *otpTextField;
- (IBAction)getInfo:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *nextbtn;
@end
