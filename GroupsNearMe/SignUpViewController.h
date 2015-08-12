//
//  SignUpViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
@class ASIHTTPRequest;

@interface SignUpViewController : UIViewController
{
    NSMutableArray *CountryArray,*mygroupIDArray;
    UITapGestureRecognizer*singletap;
    NSString *mobileno,*countryname,*countrycode,*otpValue;
    Generic*sharedObj;
    ASIHTTPRequest *signupRequest;

    
}
@property (strong, nonatomic) IBOutlet UIScrollView *signUpScrollView;
@property (strong, nonatomic) IBOutlet UIButton *gobutton;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UITableView *countrytableview;
@property (strong, nonatomic) IBOutlet UITextField *mobileTextField;
- (IBAction)sendOTP:(id)sender;
@end
