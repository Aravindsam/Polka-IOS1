//
//  StarViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 7/1/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "StarViewController.h"

@interface StarViewController ()

@end

@implementation StarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.profileImage=[[NSUserDefaults standardUserDefaults]objectForKey:@"ProfilePicture"];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
  
        PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
        [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
        [query fromLocalDatastore];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if (error) {
            }
            else{
                PFFile *imageFile =[object objectForKey:@"ProfilePicture"];
                [[NSUserDefaults standardUserDefaults]setObject:imageFile.url forKey:@"ProfilePicture"];
                sharedObj.profileImage=[[NSUserDefaults standardUserDefaults]objectForKey:@"ProfilePicture"];
                _profilenamelbl.text=sharedObj.AccountName;
                _profileimgview.file=imageFile;
                [_profileimgview loadInBackground];
            }
        }];

    
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

- (IBAction)back:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
}
@end
