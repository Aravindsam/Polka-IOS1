//
//  SettingViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/30/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "SettingViewController.h"
#import "SVProgressHud.h"
#import "Toast+UIView.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    _headerview.backgroundColor=[Generic colorFromRGBHexString:headerColor];
//    _savebtn.backgroundColor=[Generic colorFromRGBHexString:headerColor];
    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    sharedObj.pushnotificaion=[[NSUserDefaults standardUserDefaults]boolForKey:@"PushNotification"];
    sharedObj.soundnotification=[[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationGrp"];
    sharedObj.AccountGender=[[NSUserDefaults standardUserDefaults]objectForKey:@"Gender"];
   ProfileId=[[NSString alloc]init];
    if (sharedObj.AccountGender.length==0) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
        [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
        
        [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if (error) {
            }
            else{
                ProfileId=object.objectId;

                if ([object objectForKey:@"PushNotification"]) {
                    [self.pushswitchbtn setOn:YES animated:YES];
                }
                else
                {
                    [self.pushswitchbtn setOn:NO animated:YES];
                }
                
                if ([object objectForKey:@"NotificationSound"]) {
                    [self.soundswitchbtn setOn:YES animated:YES];
                }
                else
                {
                    [self.soundswitchbtn setOn:NO animated:YES];
                }
                push=[[object objectForKey:@"PushNotification"]boolValue];
                
                sound=[[object objectForKey:@"NotificationSound"]boolValue];
                
                [[NSUserDefaults standardUserDefaults]setBool:sound forKey:@"NotificationGrp"];
                [[NSUserDefaults standardUserDefaults]setBool:push forKey:@"PushNotification"];
                sharedObj.pushnotificaion=[[NSUserDefaults standardUserDefaults]boolForKey:@"PushNotification"];
                sharedObj.soundnotification=[[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationGrp"];
                
                
                
                
                
                
                
                
                
                
            }
        }];
        
        
    }
    else
    {
        
        PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
        [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
        [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if (error) {
            }
            else{
                ProfileId=object.objectId;
            }
        }];
        if (sharedObj.pushnotificaion)
            [self.pushswitchbtn setOn:YES animated:YES];
        else
            [self.pushswitchbtn setOn:NO animated:YES];
        
        if (sharedObj.soundnotification)
            [self.soundswitchbtn setOn:YES animated:YES];
        else
            [self.soundswitchbtn setOn:NO animated:YES];
        push=sharedObj.pushnotificaion;
        sound=sharedObj.soundnotification;
    }
    // Do any additional setup after loading the view.
}
- (IBAction)soundswitch:(id)sender {
    if ([sender isOn]) {
        sound=YES;
    }
    else
    {
        sound=NO;
    }
    
}

- (IBAction)pushswitch:(id)sender {
    if ([sender isOn]) {
        push=YES;
    }
    else
    {
        push=NO;
        
    }
}
- (IBAction)back:(id)sender {
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATE PROFILE" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CALLHOME" object:nil];
//    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
//        
//    }];
    //  [[self navigationController]popViewControllerAnimated:YES];
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

- (IBAction)save:(id)sender {
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
          if (push)
            [self.pushswitchbtn setOn:YES animated:YES];
        else
           [self.pushswitchbtn setOn:NO animated:YES];
    
        if (sound)
            [self.soundswitchbtn setOn:YES animated:YES];
        else
            [self.soundswitchbtn setOn:NO animated:YES];
    [SVProgressHUD showWithStatus:@"Updating Setting ....." maskType:SVProgressHUDMaskTypeBlack];

    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:ProfileId block:^(PFObject *gameScore, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
        }
        else
        {
            gameScore[@"PushNotification"]=[NSNumber numberWithBool:push];
            gameScore[@"NotificationSound"]=[NSNumber numberWithBool:sound];
            gameScore[@"UpdateImage"]=[NSNumber numberWithBool:NO];
            gameScore[@"UpdateName"]=[NSNumber numberWithBool:NO];
            [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [SVProgressHUD showWithStatus:@"Setting Updated Successfully ....." maskType:SVProgressHUDMaskTypeBlack];
                    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
                    [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                    [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
                    
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                        if (error) {
                            [SVProgressHUD dismiss];
                        }
                        else{
                              [PFObject unpinAllObjectsInBackgroundWithName:@"USERDETAILS"];
                            [object pinInBackgroundWithName:@"USERDETAILS"];

                            ProfileId=object.objectId;
                            if ([[object objectForKey:@"PushNotification"]boolValue]) {
                                [self.pushswitchbtn setOn:YES animated:YES];
                            }
                            else
                            {
                                [self.pushswitchbtn setOn:NO animated:YES];
                            }
                            
                            if ([[object objectForKey:@"NotificationSound"]boolValue]) {
                                [self.soundswitchbtn setOn:YES animated:YES];
                            }
                            else
                            {
                                [self.soundswitchbtn setOn:NO animated:YES];
                            }
                            push=[[object objectForKey:@"PushNotification"]boolValue];
                            
                            sound=[[object objectForKey:@"NotificationSound"]boolValue];
                            [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"NotificationSound"] forKey:@"NotificationGrp"];
                            [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"PushNotification"] forKey:@"PushNotification"];
                            sharedObj.pushnotificaion=[[NSUserDefaults standardUserDefaults]boolForKey:@"PushNotification"];
                            sharedObj.soundnotification=[[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationGrp"];
                        }
                        [SVProgressHUD dismiss];
                    }];
                    
                    
                }
                else
                {
                    [SVProgressHUD dismiss];
                   
                }
                
            }];
        }
        
    }];

    }
}
@end
