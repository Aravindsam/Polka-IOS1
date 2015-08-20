//
//  OTPVerifyViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "OTPVerifyViewController.h"
#import "SVProgressHUD.h"
#import "ViewController.h"
#import "GroupModalClass.h"
#import "Toast+UIView.h"
#import <Parse/Parse.h>
#define NUMERIC @"1234567890"
@interface OTPVerifyViewController ()

@end

@implementation OTPVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      userstatus=[[NSString alloc]init];
    currentdate=[[NSString alloc]init];
    mygroupIDArray=[[NSMutableArray alloc]init];
    sharedObj=[Generic sharedMySingleton];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    otpString=[[NSString alloc]init];
    scheckotp=[[NSString alloc]init];
    _nextbtn.layer.borderWidth=2.0;
    _nextbtn.layer.borderColor=[UIColor whiteColor].CGColor;
    
    _otpTextField.layer.borderWidth=1.0;
    _otpTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Didn't get verification code?"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    _verificationlbl.attributedText = [attributeString copy];
    _verificationlbl.userInteractionEnabled=YES;
    UITapGestureRecognizer *singletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gobacktosignin)];
    singletap.numberOfTapsRequired=1.0;
    [_verificationlbl addGestureRecognizer:singletap];
    // Do any additional setup after loading the view.
}
-(void)gobacktosignin
{
    [[self navigationController]popViewControllerAnimated:YES];
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_otpTextField) {
        
        NSCharacterSet *unacceptedInput = nil;
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:NUMERIC] invertedSet];
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length>4) {
            return NO;
        }
        else
            return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)getInfo:(id)sender {
    [_otpTextField resignFirstResponder];
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
    [SVProgressHUD showWithStatus:@"Verifying ..." maskType:SVProgressHUDMaskTypeBlack];
    
    otpString=_otpTextField.text;
    
    otpString=[otpString stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceCharacterSet]];
    
    if (otpString == NULL || otpString.length ==0) {
        [SVProgressHUD dismiss];
          [self.view makeToast:@"Please enter verification code" duration:3.0 position:@"bottom"];
        [_otpTextField becomeFirstResponder];
        return ;
    }
    PFQuery *query = [PFQuery queryWithClassName:@"MobileVerification"];
    [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
    [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
   

    [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
            
            
            scheckotp=[userStats objectForKey:@"VerificationCode"];
            
            if ([otpString isEqualToString:scheckotp]) {
                
                
                PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
                [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
                
                
                [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                    if (error) {
                    [SVProgressHUD dismiss];
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            RegisterViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
                            [[self navigationController]pushViewController:settingsViewController animated:YES];
                        
                    } else {
                        [SVProgressHUD showWithStatus:@"Signing In..." maskType:SVProgressHUDMaskTypeBlack];
                        [PFObject unpinAllObjectsInBackgroundWithName:@"USERDETAILS"];
                        [userStats pinInBackgroundWithName:@"USERDETAILS"];
                        userstatus=userStats[@"UserState"];
                        userstatus=[userstatus uppercaseString];
                        
                        
                        if ([userstatus isEqualToString:@"ACTIVE"]) {
                            
                            
                            PFFile*profilepic=userStats[@"ProfilePicture"];
                            
                            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"Login"];
                            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"UserName"] forKey:@"UserName"];
                            [[NSUserDefaults standardUserDefaults]setObject:userStats.objectId forKey:@"USERID"];
                            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"MobileNo"] forKey:@"MobileNo"];
                            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"CountryName"] forKey:@"Country"];
                            [[NSUserDefaults standardUserDefaults]setObject:profilepic.url forKey:@"ProfilePicture"];
                            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"NameChangeCount"] forKey:@"NameCount"];
                            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"Badgepoint"] forKey:@"BadgePoint"];
                            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"UserState"] forKey:@"UserState"];
                            [[NSUserDefaults standardUserDefaults]setBool:[userStats[@"PushNotification"]boolValue] forKey:@"PushNotification"];
                            [[NSUserDefaults standardUserDefaults]setBool:[userStats[@"NotificationSound"]boolValue] forKey:@"NotificationGrp"];
                            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"GroupInvitation"] forKey:@"GroupInvite"];
                            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"MyGroupArray"] forKey:@"MyGroup"];
                          
                            [self CallMyService];
                        }
                        else if ([userstatus isEqualToString:@"SUSPENEDED"])
                        {
                             [SVProgressHUD dismiss];
                        
                            
                               [self.view makeToast:@"Your account has been suspended. You may try later." duration:3.0 position:@"bottom"];
                            return ;
                        }
                        else if ([userstatus isEqualToString:@"BANNED"])
                        {
                            [SVProgressHUD dismiss];
                           
                             [self.view makeToast:@"Your account has been blocked." duration:3.0 position:@"bottom"];
                            return ;
                        }
                    }
                }];

            }
            else
            {
                [SVProgressHUD dismiss];
  [self.view makeToast:@"Incorrect verification code" duration:3.0 position:@"bottom"];
                return;
            }

                  }

      else {
            [SVProgressHUD dismiss];
           [self.view makeToast:@"Incorrect verification code" duration:3.0 position:@"bottom"];
            return;
        }
        
        
    }];
    
    }

}

-(void)CallMyService
{
    mygroupIDArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
    [myquery whereKey:@"objectId" containedIn:mygroupIDArray];
    [myquery whereKey:@"GroupStatus" equalTo:@"Active"];
    [myquery orderByDescending:@"updatedAt"];
    [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            [PFObject unpinAllObjectsInBackgroundWithName:@"MYGROUP"];
            [PFObject pinAllInBackground:objects withName:@"MYGROUP"];
            [SVProgressHUD dismiss];
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation setDeviceTokenFromData:sharedObj.deviceToken];
            currentInstallation[@"MobileNo"]=sharedObj.AccountNumber;
             [currentInstallation saveInBackground];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATE PROFILE" object:nil];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"Start"];
            sharedObj.Starting=[[NSUserDefaults standardUserDefaults]objectForKey:@"Start"];
            [[self navigationController]pushViewController:settingsViewController animated:YES];

        }
    }];
    
    
}




@end
