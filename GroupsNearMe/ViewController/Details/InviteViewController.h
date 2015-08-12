//
//  InviteViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/7/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
@class ASIHTTPRequest;
@interface InviteViewController : UIViewController<CLLocationManagerDelegate>
{
     NSString *mobileno,*countryname;
    NSMutableArray *CountryArray,*mobilenoArray,*indiaArray,*usArray,*memberArray,*tempmobilenoArray;
    UITapGestureRecognizer*singletap;
    Generic*sharedObj;
    ASIHTTPRequest *signupRequest;
        NSString*tempString,*typegroup;
    CLLocationManager *locationManager;
    CLLocation *_currentLocation;
    NSString*string;
    NSString*string1;
}
@property (strong, nonatomic)PFGeoPoint *point;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *headerview;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UITableView *countrytableview;
@property (strong, nonatomic) IBOutlet UITextField *countrycodeTextfield;
@property (strong, nonatomic) IBOutlet UITextField *mobileTextField;
- (IBAction)addNum:(id)sender;
- (IBAction)invite:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *mobileTableview;
- (IBAction)back:(id)sender;

@end
