//
//  TermsViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/8/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "Generic.h"
@interface TermsViewController : UIViewController
{
    Generic *sharedObj;
}
- (IBAction)menu:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *headerlbl;

@property (strong, nonatomic) IBOutlet UIView *header;
@property (strong, nonatomic) IBOutlet UIWebView *termsWebview;
@property(strong ,nonatomic)NSString*headerTitle;
@property(strong,nonatomic)NSString *UrlString;
@end
