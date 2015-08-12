//
//  ContactUsViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/8/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "Generic.h"
#import <Parse/Parse.h>
@interface ContactUsViewController : UIViewController<UITextViewDelegate>
{
    NSMutableArray *categoryArray;
    UITapGestureRecognizer*singletap;
    NSString *mobileno,*description,*category;
    Generic*sharedObj;
    
}
@property (strong, nonatomic) IBOutlet UIButton *sendbtn;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionView;
- (IBAction)menu:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *header;
@property (strong, nonatomic) IBOutlet UILabel *categorylbl;
@property (strong, nonatomic) IBOutlet UITableView *categoryTableView;
@property (strong, nonatomic) IBOutlet UILabel *backgroundlbl;

- (IBAction)contactUsbtn:(id)sender;
@end
