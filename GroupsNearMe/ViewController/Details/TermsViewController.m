//
//  TermsViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/8/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "TermsViewController.h"
#import "Toast+UIView.h"
@interface TermsViewController ()

@end

@implementation TermsViewController
@synthesize UrlString,headerTitle;
- (void)viewDidLoad {
    [super viewDidLoad];

    //[_termsWebview setScalesPageToFit:YES];
    sharedObj=[Generic sharedMySingleton];
    _header.backgroundColor=[Generic colorFromRGBHexString:headerColor];
//   NSString *urlString=@"http://groupsnearme.com/Registration/TermsOfUseMobile";
    _headerlbl.text=headerTitle;
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        //[self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
    NSURL *instructionsURL = [[NSURL alloc] initWithString:UrlString];
    [_termsWebview loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)menu:(id)sender {
    if (sharedObj.fromRegister) {
        [[self navigationController]popViewControllerAnimated:YES];
    }
    else{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATE PROFILE" object:nil];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"CALLHOME" object:nil];
//    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
//        
//    }];
    }
}
@end
