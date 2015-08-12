//
//  SignUpViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "SignUpViewController.h"
#define NUMERIC @"1234567890"
#import <Parse/Parse.h>
#import "OTPVerifyViewController.h"
#import "Toast+UIView.h"
#import "SVProgressHUD.h"
#import "ASIFormDataRequest.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedObj=[Generic sharedMySingleton];
  
    otpValue=[[NSString alloc]init];
    countryname=[[NSString alloc]init];
    countrycode=[[NSString alloc]init];
    mobileno=[[NSString alloc]init];
    mygroupIDArray=[[NSMutableArray alloc]init];
    CountryArray=[[NSMutableArray alloc]initWithObjects:@"+91",@"+1", nil];
    
    
    _countryLabel.layer.borderColor=[UIColor whiteColor].CGColor;
    _countryLabel.layer.borderWidth=0.5;
    _countryLabel.userInteractionEnabled=YES;
    
    _countrytableview.layer.borderColor=[UIColor whiteColor].CGColor;
    _countrytableview.layer.borderWidth=0.5;
    _countrytableview.hidden=YES;
    
    _mobileTextField.clipsToBounds = YES;
    _mobileTextField.layer.borderWidth=1.0;
    _mobileTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    _gobutton.layer.borderColor=[UIColor whiteColor].CGColor;
    _gobutton.layer.borderWidth=2.0;
    
    singletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showcountry:)];
    singletap.numberOfTapsRequired=1;
    [_countryLabel addGestureRecognizer:singletap];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _signUpScrollView.contentSize=CGSizeMake(_signUpScrollView.frame.size.width, _signUpScrollView.frame.size.height);
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

     _signUpScrollView.contentSize=CGSizeMake(_signUpScrollView.frame.size.width, _signUpScrollView.frame.size.height);
}
-(void)keyboardWillShow:(id)sender
{
    
    _signUpScrollView.contentSize=CGSizeMake(_signUpScrollView.frame.size.width, [self findViewHeight:_gobutton.frame]+250);
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField==_mobileTextField) {
        [_signUpScrollView setContentOffset:CGPointMake(0, 100) animated:YES];
        
    }
}

-(void)keyboardWillHide:(id)sender
{
    _signUpScrollView.contentSize=CGSizeMake(_signUpScrollView.frame.size.width, _signUpScrollView.frame.size.height);
}
-(CGFloat)findViewHeight:(CGRect)sender
{
    CGFloat hgValue = sender.origin.y +sender.size.height;
    return hgValue;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_mobileTextField) {
        
        NSCharacterSet *unacceptedInput = nil;
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:NUMERIC] invertedSet];
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length>10) {
            return NO;
        }
        else
            return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
    return YES;
}
-(void)showcountry:(UIGestureRecognizer*)gesture
{
    if (_countrytableview.hidden) {
        _countrytableview.hidden=NO;
    }
    else
    {
        _countrytableview.hidden=YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CountryArray count];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[CountryArray objectAtIndex:indexPath.row];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _countryLabel.text=[CountryArray objectAtIndex:indexPath.row];
    _countrytableview.hidden=YES;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)sendOTP:(id)sender {
    
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
 
    }
    else{
    
    [_mobileTextField resignFirstResponder];
    mobileno=_mobileTextField.text;
    countrycode=_countryLabel.text;
    mobileno=[mobileno stringByTrimmingCharactersInSet:
           [NSCharacterSet whitespaceCharacterSet]];
    countrycode=[countrycode stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceCharacterSet]];

    if (countrycode == NULL || countrycode.length ==0) {
        [SVProgressHUD dismiss];
        [self showAlert:@"Not Available"];
        return ;
    }
    if (![CountryArray containsObject:countrycode]) {
        [SVProgressHUD dismiss];
        [self showAlert:@"Please Choose the available Country Code"];
        return ;
    }
    if (mobileno == NULL || mobileno.length ==0) {
        [SVProgressHUD dismiss];
        [self showAlert:@"Please enter a valid number"];
        [_mobileTextField becomeFirstResponder];
        return ;
    }
    else if (mobileno.length<10)
    {
        [SVProgressHUD dismiss];
        [self showAlert:@"Please enter a valid mobile number"];
        [_mobileTextField becomeFirstResponder];
        return ;
    }
        if ([countrycode isEqualToString:@"+91"]) {
            countryname=@"India";
        }
        else
        {
            countryname=@"US";

        }
 
        mobileno=[NSString stringWithFormat:@"%@%@",countrycode,mobileno];
       
    
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeBlack];
            [self sendOTPSMS];
            
    }

   
}

-(void)sendOTPSMS
{
    //MobileVerification
   otpValue=[self randomStringWithLength:4];
   PFQuery *query = [PFQuery queryWithClassName:@"MobileVerification"];
    [query whereKey:@"MobileNo" equalTo:mobileno];
     [query whereKey:@"CountryName" equalTo:countryname];
   

    [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
            userStats[@"VerificationCode"]=otpValue;
            [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self sendSMS];
                }
            }];
        }
        else
        {
            PFObject *query = [PFObject objectWithClassName:@"MobileVerification"];
            query[@"VerificationCode"] =otpValue ;
            query[@"MobileNo"] = mobileno;
            query[@"CountryName"]=countryname;
            [query saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self sendSMS];
                }
            }];

        }
        
                 }];

    
   

    
}
-(void)sendSMS
{
    if ([countryname isEqualToString:@"US"]) {
        NSString *kTwilioSID = @"AC867b012600c2cea93a1ec999eb88870d";
        NSString *kTwilioSecret = @"1f65e4a8e3c80cfaeb88f356112dbfef";
        NSString *kFromNumber = @"+18708980344";
        NSString *kToNumber = mobileno;
        NSString *kMessage = [NSString stringWithFormat:@"One time password from Chatterati to verify your mobile is   %@. Do not disclose OTP to anyone.",otpValue];
        
        __block ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages.json",kTwilioSID]]];
        __weak ASIHTTPRequest *request_b = request;
        [request setUsername:kTwilioSID];
        [request setPassword:kTwilioSecret];
        request.shouldAttemptPersistentConnection   = NO;
        [request addPostValue:kFromNumber forKey:@"From"];
        [request addPostValue:kToNumber forKey:@"To"];
        [request addPostValue:kMessage forKey:@"Body"];
        [request setCompletionBlock:^(){
            [SVProgressHUD dismiss];
            NSData *response = [request_b.responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            
            NSLog(@"%@",responseDict);
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [[NSUserDefaults standardUserDefaults]setObject:mobileno forKey:@"MobileNo"];
            [[NSUserDefaults standardUserDefaults]setObject:countryname forKey:@"CountryName"];
            sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
            sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
            OTPVerifyViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"OTPVerifyViewController"];
            [[self navigationController]pushViewController:settingsViewController animated:YES];
            
        }];
        
        [request setFailedBlock:^(){
                [SVProgressHUD dismiss];
            NSLog(@"%@",request_b.error);
        }];
        
        [request startAsynchronous];
        
        
    }
    else{
        NSString *otpUrl;
        
        [signupRequest clearDelegatesAndCancel];
        [signupRequest cancel];
        
        if(![signupRequest isCancelled]) {
            [signupRequest cancel];
            [signupRequest clearDelegatesAndCancel];
        }
        signupRequest = nil;
        otpUrl=nil;
       // otpUrl=[NSString stringWithFormat:@"http://bhashsms.com/api/sendmsg.php?user=9445163340&pass=9ca58b4&sender=AJVISH&phone=%@&text=One time password from Chatterati to verify your mobile is %@. Do not disclose OTP to anyone.&priority=ndnd&stype=normal",mobileno,otpValue];
        
        otpUrl=[NSString stringWithFormat:@"http://whitelist.smsapi.org/SendSMS.aspx?UserName=Delasoft_SMS&password=617995&MobileNo=%@&SenderID=CHATTR&CDMAHeader=CHATTR&Message=Your mobile verification code from Chatterati App is %@. Do not disclose or share.",mobileno,otpValue];
        
        /* otpUrl=[NSString stringWithFormat:@"https://hapi.smsapi.org/SendSMS.aspx?UserName=demo_sms&password=763957&MobileNo=%@&SenderID=911002002000&CDMAHeader=SMSDemo&Message=%@",mobileno,[NSString stringWithFormat:@"From Groupnearme Application : One Time Password (OTP) to complete your authentication is  %@. Do not disclose OTP to anyone.",otpValue]];*/
        otpUrl=[otpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        signupRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:otpUrl]];
        [signupRequest setDelegate:self];
        [signupRequest setTimeOutSeconds:60];
        [signupRequest setTag:11];
        [signupRequest setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
        [signupRequest setDidFinishSelector:@selector(requestFinished:)];
        [signupRequest setDidFailSelector:@selector(requestFailed:)];
        
        [signupRequest startAsynchronous];
        
    }

}
-(void)requestFinished:(ASIHTTPRequest *)response
{
    if (signupRequest.tag==11) {
        if (response.responseString.length==0)
        {
            [SVProgressHUD dismiss];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Service unavailable please try later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [SVProgressHUD dismiss];
        [[NSUserDefaults standardUserDefaults]setObject:mobileno forKey:@"MobileNo"];
        [[NSUserDefaults standardUserDefaults]setObject:countryname forKey:@"CountryName"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OTPVerifyViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"OTPVerifyViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)response
{
    [SVProgressHUD dismiss];
    [self.view makeToast:@"Service unavailable please try later" duration:3.0 position:@"bottom"];
   
   
}

-(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

-(void)showAlert:(NSString*)text{
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                message:text
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
[alert show];
}
@end
