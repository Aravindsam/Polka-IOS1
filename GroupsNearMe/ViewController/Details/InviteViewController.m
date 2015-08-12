//
//  InviteViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/7/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "InviteViewController.h"
#define NUMERIC @"1234567890"
#import "ASIFormDataRequest.h"
#import <Parse/Parse.h>
#import "Toast+UIView.h"
#import "SVProgressHUD.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface InviteViewController ()

@end

@implementation InviteViewController
@synthesize point;
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    memberArray=[[NSMutableArray alloc]init];
    PFQuery *member=[PFQuery queryWithClassName:@"Group"];
    [member fromLocalDatastore];
    [member getObjectInBackgroundWithId:sharedObj.GroupId block:^(PFObject *object, NSError *error) {
        [memberArray addObjectsFromArray:object[@"GroupMembers"]];
    }];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        // [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    string=[[NSString alloc]init];

    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    typegroup=sharedObj.groupType;
    typegroup=[typegroup uppercaseString];
    mobilenoArray=[[NSMutableArray alloc]init];
    tempmobilenoArray=[[NSMutableArray alloc]init];
    usArray=[[NSMutableArray alloc]init];
    indiaArray=[[NSMutableArray alloc]init];
    [_mobileTableview setAllowsSelection:NO];
    [_countrytableview setAllowsSelection:YES];
    countryname=[[NSString alloc]init];
    mobileno=[[NSString alloc]init];
    string1=[[NSString alloc]init];
    CountryArray=[[NSMutableArray alloc]initWithObjects:@"+91",@"+1", nil];
    _countrytableview.hidden=YES;
    _countrycodeTextfield.userInteractionEnabled=NO;
    _countryLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _countryLabel.layer.borderWidth=0.5;
    
    _countrytableview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _countrytableview.layer.borderWidth=0.5;
    
    _mobileTableview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _mobileTableview.layer.borderWidth=0.5;
    
   
    
   
    _mobileTextField.layer.borderWidth=1.0;
    _mobileTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    _headerview.layer.borderWidth=1.0;
    _headerview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    _countrycodeTextfield.layer.cornerRadius = 5;
    _countrycodeTextfield.clipsToBounds = YES;
    _countrycodeTextfield.layer.borderWidth=1.0;
    _countrycodeTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    singletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showcountry:)];
    singletap.numberOfTapsRequired=1;
    _countryLabel.userInteractionEnabled=YES;
    [_countryLabel addGestureRecognizer:singletap];
    _mobileTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [self.view makeToast:@"Unable to get your location" duration:3.0 position:@"bottom"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    point = [PFGeoPoint geoPointWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [locationManager stopUpdatingLocation];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    if (tableView==_mobileTableview) {
        if ([tempmobilenoArray containsObject:[mobilenoArray objectAtIndex:indexPath.row]]) {
            [tempmobilenoArray removeObject:[mobilenoArray objectAtIndex:indexPath.row]];
        }
        [mobilenoArray removeObjectAtIndex:indexPath.row];
     
        // Request table view to reload
        [_mobileTableview reloadData];
    }
   
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_countrytableview) {
         return [CountryArray count];
    }
    else
    return mobilenoArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 44;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (tableView==_countrytableview) {
        cell.textLabel.text=[CountryArray objectAtIndex:indexPath.row];

    }
    else{
    cell.textLabel.text=[mobilenoArray objectAtIndex:indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _countryLabel.text=[CountryArray objectAtIndex:indexPath.row];
    _countrytableview.hidden=YES;
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)stringtext
{
    if (textField==_mobileTextField) {
        
        NSCharacterSet *unacceptedInput = nil;
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:NUMERIC] invertedSet];
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:stringtext];
        if (newString.length>10) {
            return NO;
        }
        else
            return ([[stringtext componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!_countrytableview.hidden) {
        _countrytableview.hidden=YES;
    }
}
- (IBAction)addNum:(id)sender {
    if (!_countrytableview.hidden) {
        _countrytableview.hidden=YES;
    }
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"Can't Connect" duration:3.0 position:@"bottom"];
        
    }
    else{
    [_mobileTextField resignFirstResponder];
    mobileno=_mobileTextField.text;
    countryname=_countryLabel.text;
    mobileno=[mobileno stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceCharacterSet]];
    countryname=[countryname stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceCharacterSet]];
    
    if (countryname == NULL || countryname.length ==0) {
        [self showAlert:@"Not Available"];
        [_mobileTextField becomeFirstResponder];
        return ;
    }
    if (![CountryArray containsObject:countryname]) {
        [self showAlert:@"Please Choose the available Country Code"];
        [_mobileTextField becomeFirstResponder];
        return ;
    }
    if (mobileno == NULL || mobileno.length ==0) {
        [self showAlert:@"Please enter a valid number"];
        [_mobileTextField becomeFirstResponder];
        return ;
    }
    else if (mobileno.length<10)
    {
        [self showAlert:@"Please enter a valid mobile number"];
        [_mobileTextField becomeFirstResponder];
        return ;
    }
    
   
        mobileno=[NSString stringWithFormat:@"%@%@",countryname,mobileno];
   
   
     if (![mobilenoArray containsObject:mobileno]) {
        [mobilenoArray insertObject:mobileno atIndex:0];
        _mobileTextField.text=@"";
         if (![memberArray containsObject:mobileno]) {
             [tempmobilenoArray insertObject:mobileno atIndex:0];
  
         }
        [_mobileTextField resignFirstResponder];
        [self.mobileTableview beginUpdates];
        [self.mobileTableview insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
         [self.mobileTableview endUpdates];
    }

    }
}
-(void)showAlert:(NSString*)text{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)invite:(id)sender {
    if (!_countrytableview.hidden) {
        _countrytableview.hidden=YES;
    }
    if (tempmobilenoArray.count==0) {
        if (_mobileTextField.text.length!=0) {
      
        [_mobileTextField resignFirstResponder];
        mobileno=_mobileTextField.text;
        countryname=_countryLabel.text;
        mobileno=[mobileno stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceCharacterSet]];
        countryname=[countryname stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];
        
        if (countryname == NULL || countryname.length ==0) {
            [self showAlert:@"Not Available"];
            [_mobileTextField becomeFirstResponder];
            return ;
        }
        if (![CountryArray containsObject:countryname]) {
            [self showAlert:@"Please Choose the available Country Code"];
            [_mobileTextField becomeFirstResponder];
            return ;
        }
        if (mobileno == NULL || mobileno.length ==0) {
            [self showAlert:@"Please enter a valid number"];
            [_mobileTextField becomeFirstResponder];
            return ;
        }
        else if (mobileno.length<10)
        {
            [self showAlert:@"Please enter a valid mobile number"];
            [_mobileTextField becomeFirstResponder];
            return ;
        }
        
        
        mobileno=[NSString stringWithFormat:@"%@%@",countryname,mobileno];
         if ([memberArray containsObject:mobileno]) {
             _mobileTextField.text=@"";
         }
         else{
        PFQuery *query=[PFQuery queryWithClassName:@"Invitation"];
        [query whereKey:@"ToUser" equalTo:mobileno];
        [query whereKey:@"GroupId" equalTo:sharedObj.GroupId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                if (objects.count!=0) {
                    
                    for (PFObject*object in objects) {
                        object[@"InvitationStatus"]=@"Active";
                        object[@"InvitationLocation"]=point;
                        [object saveInBackground];
                    }
                }
                else
                {
                    PFObject *postObject = [PFObject objectWithClassName:@"Invitation"];
                    postObject[@"FromUser"]=sharedObj.AccountNumber;
                    postObject[@"ToUser"]=tempString;
                    postObject[@"GroupId"]=sharedObj.GroupId;
                    postObject[@"InvitationLocation"]=point;
                    postObject[@"InvitationStatus"]=@"Active";
                    [postObject saveInBackground];
                    
                }
            }
            else
            {
                PFObject *postObject = [PFObject objectWithClassName:@"Invitation"];
                postObject[@"FromUser"]=sharedObj.AccountNumber;
                postObject[@"ToUser"]=tempString;
                postObject[@"GroupId"]=sharedObj.GroupId;
                postObject[@"InvitationLocation"]=point;
                postObject[@"InvitationStatus"]=@"Active";
                [postObject saveInBackground];
                
            }
            
        }];

        if ([countryname isEqualToString:@"+91"]) {
            [SVProgressHUD showWithStatus:@"Sending invitation ...." maskType:SVProgressHUDMaskTypeBlack];

            NSString *otpUrl;
            [signupRequest clearDelegatesAndCancel];
            [signupRequest cancel];
            
            if(![signupRequest isCancelled]) {
                [signupRequest cancel];
                [signupRequest clearDelegatesAndCancel];
            }
            signupRequest = nil;
            otpUrl=nil;
            otpUrl=[NSString stringWithFormat:@"http://whitelist.smsapi.org/SendSMS.aspx?UserName=Delasoft_SMS&password=617995&MobileNo=%@&SenderID= CHATTR&CDMAHeader=CHATTR&Message=You are invited to join Chatterati group %@. Download the Chatterati mobile app from http://getchatterati.com",mobileno,sharedObj.GroupName];
            //        otpUrl=[NSString stringWithFormat:@"http://bhashsms.com/api/sendmsg.php?user=9445163340&pass=9ca58b4&sender=AJVISH&phone=%@&text=From Chatterati Application: %@ invites you to join in %@ group.You can join by clicking here groupsnearme.com/Groups/GroupName/%@&priority=ndnd&stype=normal",string,sharedObj.AccountName,sharedObj.GroupName,sharedObj.GroupId];
            
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
        else if ([countryname isEqualToString:@"+1"])
        {
            [SVProgressHUD showWithStatus:@"Sending invitation ...." maskType:SVProgressHUDMaskTypeBlack];

            NSString *kTwilioSID = @"AC867b012600c2cea93a1ec999eb88870d";
            NSString *kTwilioSecret = @"1f65e4a8e3c80cfaeb88f356112dbfef";
            NSString *kFromNumber = @"+18708980344";
            NSString *kToNumber = mobileno;
            NSString *kMessage = [NSString stringWithFormat:@"From Chatterati Application: %@ invites you to join in %@ group.You can join by clicking here groupsnearme.com/Groups/GroupName/%@",sharedObj.AccountName,sharedObj.GroupName,sharedObj.GroupId];
            
            __block ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages.json",kTwilioSID]]];
            __weak ASIHTTPRequest *request_b = request;
            [request setUsername:kTwilioSID];
            [request setPassword:kTwilioSecret];
            request.shouldAttemptPersistentConnection   = NO;
            [request addPostValue:kFromNumber forKey:@"From"];
            [request addPostValue:kToNumber forKey:@"To"];
            [request addPostValue:kMessage forKey:@"Body"];
            [request setCompletionBlock:^(){
                [SVProgressHUD showWithStatus:@"Invitations sent" maskType:SVProgressHUDMaskTypeBlack];

                _mobileTextField.text=@"";
                [mobilenoArray removeAllObjects];
                [usArray removeAllObjects];
                [tempmobilenoArray removeAllObjects];
                [indiaArray removeAllObjects];
                [_mobileTableview reloadData];
                [SVProgressHUD dismiss];

                
            }];
            
            [request setFailedBlock:^(){
                NSLog(@"%@",request_b.error);
                [SVProgressHUD dismiss];

            }];
            
            [request startAsynchronous];
            
 
        }
         }
        }
        else
        {
            _mobileTextField.text=@"";
            [mobilenoArray removeAllObjects];
            [usArray removeAllObjects];
            [tempmobilenoArray removeAllObjects];
            [indiaArray removeAllObjects];
            [_mobileTableview reloadData];
        }
    }
    else{
    for (int i=0; i<tempmobilenoArray.count; i++) {
        tempString=[tempmobilenoArray objectAtIndex:i];
        PFQuery *query=[PFQuery queryWithClassName:@"Invitation"];
        [query whereKey:@"ToUser" equalTo:tempString];
        [query whereKey:@"GroupId" equalTo:sharedObj.GroupId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
 
            if (!error) {
                if (objects.count!=0) {
           
                for (PFObject*object in objects) {
                    object[@"InvitationStatus"]=@"Active";
                    object[@"InvitationLocation"]=point;
                    [object saveInBackground];
                }
                }
                else
                {
                    PFObject *postObject = [PFObject objectWithClassName:@"Invitation"];
                    postObject[@"FromUser"]=sharedObj.AccountNumber;
                    postObject[@"ToUser"]=tempString;
                    postObject[@"GroupId"]=sharedObj.GroupId;
                    postObject[@"InvitationLocation"]=point;
                    postObject[@"InvitationStatus"]=@"Active";
                    [postObject saveInBackground];
                    
                }
            }
            else
            {
                PFObject *postObject = [PFObject objectWithClassName:@"Invitation"];
                postObject[@"FromUser"]=sharedObj.AccountNumber;
                postObject[@"ToUser"]=tempString;
                postObject[@"GroupId"]=sharedObj.GroupId;
                postObject[@"InvitationLocation"]=point;
                postObject[@"InvitationStatus"]=@"Active";
                [postObject saveInBackground];
                
            }
            
        }];

        NSString * mystr=[tempString substringToIndex:2];
        if ([mystr isEqualToString:@"+1"]) {
            [usArray addObject:tempString];
        }
        else
        {
            [indiaArray addObject:tempString];
        }

    }
    
  
    
    
    
    
    if (usArray.count!=0&&indiaArray.count==0) {
        [SVProgressHUD showWithStatus:@"Sending invitation ...." maskType:SVProgressHUDMaskTypeBlack];

        string=[usArray componentsJoinedByString:@","];
        NSString *kTwilioSID = @"AC867b012600c2cea93a1ec999eb88870d";
        NSString *kTwilioSecret = @"1f65e4a8e3c80cfaeb88f356112dbfef";
        NSString *kFromNumber = @"+18708980344";
        NSString *kToNumber = string;
        NSString *kMessage = [NSString stringWithFormat:@"From Chatterati Application: %@ invites you to join in %@ group.You can join by clicking here groupsnearme.com/Groups/GroupName/%@",sharedObj.AccountName,sharedObj.GroupName,sharedObj.GroupId];
        
        __block ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages.json",kTwilioSID]]];
        __weak ASIHTTPRequest *request_b = request;
        [request setUsername:kTwilioSID];
        [request setPassword:kTwilioSecret];
        request.shouldAttemptPersistentConnection   = NO;
        [request addPostValue:kFromNumber forKey:@"From"];
        [request addPostValue:kToNumber forKey:@"To"];
        [request addPostValue:kMessage forKey:@"Body"];
        [request setCompletionBlock:^(){
           // NSData *response = [request_b.responseString dataUsingEncoding:NSUTF8StringEncoding];
           // NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
            [SVProgressHUD showWithStatus:@"Invitations sent" maskType:SVProgressHUDMaskTypeBlack];

            _mobileTextField.text=@"";
            [mobilenoArray removeAllObjects];
            [usArray removeAllObjects];
            [tempmobilenoArray removeAllObjects];
            [indiaArray removeAllObjects];
            [_mobileTableview reloadData];
            [SVProgressHUD dismiss];

            
        }];
        
        [request setFailedBlock:^(){
            NSLog(@"%@",request_b.error);
            [SVProgressHUD dismiss];

        }];
        
        [request startAsynchronous];
        
 
    }
    else if (indiaArray.count!=0&&usArray.count==0)
    {
        [SVProgressHUD showWithStatus:@"Sending invitation ...." maskType:SVProgressHUDMaskTypeBlack];

        NSString *otpUrl;
        string=[indiaArray componentsJoinedByString:@","];
        [signupRequest clearDelegatesAndCancel];
        [signupRequest cancel];
        
        if(![signupRequest isCancelled]) {
            [signupRequest cancel];
            [signupRequest clearDelegatesAndCancel];
        }
        signupRequest = nil;
        otpUrl=nil;
         otpUrl=[NSString stringWithFormat:@"http://whitelist.smsapi.org/SendSMS.aspx?UserName=Delasoft_SMS&password=617995&MobileNo=%@&SenderID= CHATTR&CDMAHeader=CHATTR&Message=You are invited to join Chatterati group %@. Download the Chatterati mobile app from http://getchatterati.com",string,sharedObj.GroupName];
//        otpUrl=[NSString stringWithFormat:@"http://bhashsms.com/api/sendmsg.php?user=9445163340&pass=9ca58b4&sender=AJVISH&phone=%@&text=From Chatterati Application: %@ invites you to join in %@ group.You can join by clicking here groupsnearme.com/Groups/GroupName/%@&priority=ndnd&stype=normal",string,sharedObj.AccountName,sharedObj.GroupName,sharedObj.GroupId];
       
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

    else if (usArray.count!=0&&indiaArray.count!=0)
    {
        [SVProgressHUD showWithStatus:@"Sending invitation ...." maskType:SVProgressHUDMaskTypeBlack];

        string=[usArray componentsJoinedByString:@","];
        NSString *kTwilioSID = @"AC867b012600c2cea93a1ec999eb88870d";
        NSString *kTwilioSecret = @"1f65e4a8e3c80cfaeb88f356112dbfef";
        NSString *kFromNumber = @"+18708980344";
        NSString *kToNumber = string;
        NSString *kMessage = [NSString stringWithFormat:@"From Chatterati Application: %@ invites you to join in %@ group.You can join by clicking here groupsnearme.com/Groups/GroupName/%@",sharedObj.AccountName,sharedObj.GroupName,sharedObj.GroupId];
        
        __block ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages.json",kTwilioSID]]];
        __weak ASIHTTPRequest *request_b = request;
        [request setUsername:kTwilioSID];
        [request setPassword:kTwilioSecret];
        request.shouldAttemptPersistentConnection   = NO;
        [request addPostValue:kFromNumber forKey:@"From"];
        [request addPostValue:kToNumber forKey:@"To"];
        [request addPostValue:kMessage forKey:@"Body"];
        [request setCompletionBlock:^(){
           
             NSLog(@"Success US");
             [usArray removeAllObjects];
            NSString *otpUrl;
           
            string1=[indiaArray componentsJoinedByString:@","];
            [signupRequest clearDelegatesAndCancel];
            [signupRequest cancel];
            
            if(![signupRequest isCancelled]) {
                [signupRequest cancel];
                [signupRequest clearDelegatesAndCancel];
            }
            signupRequest = nil;
            otpUrl=nil;
               otpUrl=[NSString stringWithFormat:@"http://whitelist.smsapi.org/SendSMS.aspx?UserName=Delasoft_SMS&password=617995&MobileNo=%@&SenderID= CHATTR&CDMAHeader=CHATTR&Message=You are invited to join Chatterati group %@. Download the Chatterati mobile app from http://getchatterati.com",string1,sharedObj.GroupName];

            
            otpUrl=[otpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            signupRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:otpUrl]];
            [signupRequest setDelegate:self];
            [signupRequest setTimeOutSeconds:60];
            [signupRequest setTag:11];
            [signupRequest setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
            [signupRequest setDidFinishSelector:@selector(requestFinished:)];
            [signupRequest setDidFailSelector:@selector(requestFailed:)];
            
            [signupRequest startAsynchronous];
          
            
        }];
        
        [request setFailedBlock:^(){
            NSLog(@"%@",request_b.error);
            [SVProgressHUD dismiss];

             NSLog(@"Failure US");
        }];
        
        [request startAsynchronous];

    }
    }
}
-(void)requestFinished:(ASIHTTPRequest *)response
{
    NSLog(@"Success INDIA");
    [SVProgressHUD showWithStatus:@"Invitations sent" maskType:SVProgressHUDMaskTypeBlack];
    
    _mobileTextField.text=@"";
    [mobilenoArray removeAllObjects];
    [usArray removeAllObjects];
    [tempmobilenoArray removeAllObjects];
    [indiaArray removeAllObjects];
     [_mobileTableview reloadData];
    [SVProgressHUD dismiss];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([self.countrytableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.countrytableview setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.countrytableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.countrytableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)response
{
     NSLog(@"Failure INDIA");
    [SVProgressHUD dismiss];
}
- (IBAction)back:(id)sender {
    if (!_countrytableview.hidden) {
        _countrytableview.hidden=YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
