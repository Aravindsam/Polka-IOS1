//
//  PrivateInviteViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/22/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "PrivateInviteViewController.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
@interface PrivateInviteViewController ()

@end

@implementation PrivateInviteViewController
@synthesize point;
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    currentdate=[[NSString alloc]init];
    memberArray=[[NSMutableArray alloc]init];
    PFQuery *member=[PFQuery queryWithClassName:@"Group"];
    [member fromLocalDatastore];
    [member getObjectInBackgroundWithId:sharedObj.GroupId block:^(PFObject *object, NSError *error) {
        [memberArray addObjectsFromArray:object[@"GroupMembers"]];
    }];
     _inviteView.hidden=NO;
     string1=[[NSString alloc]init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        // [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    mobilenoArray=[[NSMutableArray alloc]init];
   
    mobileno=[[NSString alloc]init];
    groupimgurl=[[NSString alloc]init];
    tempmobilenoArray=[[NSMutableArray alloc]init];

    countryname=[[NSString alloc]init];
    usArray=[[NSMutableArray alloc]init];
    indiaArray=[[NSMutableArray alloc]init];
    [_mobileTableview setAllowsSelection:NO];
    [_countrytableview setAllowsSelection:YES];
    CountryArray=[[NSMutableArray alloc]initWithObjects:@"+91",@"+1", nil];
    _countrytableview.hidden=YES;
    _countrycodeTextfield.userInteractionEnabled=NO;
    _countryLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _countryLabel.layer.borderWidth=0.5;
    
    _countrytableview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _countrytableview.layer.borderWidth=0.5;
    
    if (sharedObj.currentgroupOpenEntry==0 ) {
        openEntry=NO;
      [self.openSwitch setOn:NO animated:YES];
        _sliderView.hidden=YES;
    }
    else
    {
        openEntry=YES;
        [self.openSwitch setOn:YES animated:YES];
        _sliderView.hidden=NO;

    }
    if (_inviteView.hidden) {
        _openentryView.frame=CGRectMake(0, 55, 320, 58);
        _sliderView.frame=CGRectMake(8, 108, 304, 165);
        _createbtn.frame=CGRectMake(5, 450, 310, 40);
    }
    else
    {
        _openentryView.frame=CGRectMake(0, 350, 320, 58);
        _sliderView.frame=CGRectMake(8, 408, 304, 165);
        if (openEntry) {
            _createbtn.frame=CGRectMake(5, 580, 310, 40);
            
        }
        else
        {
            _createbtn.frame=CGRectMake(5, 450, 310, 40);
            
        }

    }
    _mobileTableview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _mobileTableview.layer.borderWidth=0.5;
    
    
    
    if (sharedObj.currentgroupOpenEntry==15) {
        [_minsbtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        [_hour1btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_hour6btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_daybtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    }
    else if (sharedObj.currentgroupOpenEntry==1)
    {
        [_minsbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_hour1btn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        [_hour6btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_daybtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    }
    else if (sharedObj.currentgroupOpenEntry==6)
    {
        [_minsbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_hour1btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_hour6btn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        [_daybtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    }
    else if (sharedObj.currentgroupOpenEntry==24)
    {
        [_minsbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_hour1btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_hour6btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_daybtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
   
    

    _mobileTextField.layer.borderWidth=1.0;
    _mobileTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
   
    _countrycodeTextfield.layer.borderWidth=1.0;
    _countrycodeTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    singletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showcountry:)];
    singletap.numberOfTapsRequired=1;
    _countryLabel.userInteractionEnabled=YES;
    [_countryLabel addGestureRecognizer:singletap];
    
    
    
    
    _invitelbel.userInteractionEnabled=YES;
    inviteTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(invitetap)];
    inviteTap.numberOfTapsRequired=1;
    [_invitelbel addGestureRecognizer:inviteTap];
    
    
   
    
  
   
    sharedObj.selectedIdArray=sharedObj.currentgreenchannelId;
   
    
   
   
    _inviteImgview.image=[UIImage imageNamed:@"down_arrow.png"];
    
    _mobileTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _invitescrollview.contentSize=CGSizeMake(_invitescrollview.frame.size.width, [self findViewHeight:_createbtn.frame]+10);    // Do any additional setup after loading the view.
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

-(void)invitetap
{
    
    
    _countrytableview.hidden=YES;
    if (_inviteView.hidden) {
        _inviteView.hidden=NO;
        _inviteImgview.image=[UIImage imageNamed:@"up_arrow.png"];
       
        _openentryView.frame=CGRectMake(0, 350, 320, 58);
        _sliderView.frame=CGRectMake(8, 408, 304, 165);
        if (openEntry) {
            _createbtn.frame=CGRectMake(5, 580, 310, 40);

        }
        else
        {
            _createbtn.frame=CGRectMake(5, 450, 310, 40);

        }
    }
    else
    {
        _inviteView.hidden=YES;
        _inviteImgview.image=[UIImage imageNamed:@"down_arrow.png"];
        _openentryView.frame=CGRectMake(0, 55, 320, 58);
        _sliderView.frame=CGRectMake(8, 108, 304, 165);
         _createbtn.frame=CGRectMake(5, 450, 310, 40);
    }
    if (openEntry) {
        _sliderView.hidden=NO;
    }
    else
    {
        _sliderView.hidden=YES;
    }
    _invitescrollview.contentSize=CGSizeMake(_invitescrollview.frame.size.width, [self findViewHeight:_createbtn.frame]+10);
   
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!_countrytableview.hidden) {
        _countrytableview.hidden=YES;
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==_countrytableview) {
        return [CountryArray count];
    }
    
    else if (tableView==_mobileTableview)
    {
        return mobilenoArray.count;
    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_countrytableview) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text=[CountryArray objectAtIndex:indexPath.row];
        return cell;
    }
    else if (tableView==_mobileTableview)
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.text=[mobilenoArray objectAtIndex:indexPath.row];
        return cell;
    }
       return nil;
    
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    if (tableView==_mobileTableview) {
        [mobilenoArray removeObjectAtIndex:indexPath.row];
        if ([tempmobilenoArray containsObject:[mobilenoArray objectAtIndex:indexPath.row]]) {
            [tempmobilenoArray removeObject:[mobilenoArray objectAtIndex:indexPath.row]];
        }

        // Request table view to reload
        [_mobileTableview reloadData];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==_countrytableview) {
        _countryLabel.text=[CountryArray objectAtIndex:indexPath.row];
        _countrytableview.hidden=YES;
           }
    
    
}
- (IBAction)addNum:(id)sender {
    [_mobileTextField resignFirstResponder];
    if (!_countrytableview.hidden) {
        _countrytableview.hidden=YES;
    }
    mobileno=_mobileTextField.text;
    countryname=_countryLabel.text;
    mobileno=[mobileno stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceCharacterSet]];
    countryname=[countryname stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceCharacterSet]];
    
    if (countryname == NULL || countryname.length ==0) {
       
         [self.view makeToast:@"Not Available" duration:3.0 position:@"bottom"];
        [_mobileTextField becomeFirstResponder];
        return ;
    }
    if (![CountryArray containsObject:countryname]) {
         [self.view makeToast:@"Please Choose the available Country Code" duration:3.0 position:@"bottom"];
        [_mobileTextField becomeFirstResponder];
        return ;
    }
    if (mobileno == NULL || mobileno.length ==0) {
         [self.view makeToast:@"Please enter a valid number" duration:3.0 position:@"bottom"];
        [_mobileTextField becomeFirstResponder];
        return ;
    }
    else if (mobileno.length<10)
    {
         [self.view makeToast:@"Please enter a valid mobile number" duration:3.0 position:@"bottom"];
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

-(void)findFrameFromString:(NSString*)string andCorrespondingLabel:(UILabel*) label1
{
    CGSize expectedLableSize =[string sizeWithFont:label1.font constrainedToSize:label1.frame.size lineBreakMode:NSLineBreakByWordWrapping];
    CGRect newFrame =  label1.frame;
    newFrame.size.height = expectedLableSize.height;
    label1.frame =newFrame;
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines=0;
    [label1 sizeToFit];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_countrytableview || tableView==_mobileTableview) {
        return 44;
    }
       return 0;
}


#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)callInvite
{if (tempmobilenoArray.count==0) {
    if (_mobileTextField.text.length!=0) {
        
        [_mobileTextField resignFirstResponder];
        mobileno=_mobileTextField.text;
        countryname=_countryLabel.text;
        mobileno=[mobileno stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceCharacterSet]];
        countryname=[countryname stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];
        
        if (countryname == NULL || countryname.length ==0) {
            
             [self.view makeToast:@"Not Available" duration:3.0 position:@"bottom"];
            [_mobileTextField becomeFirstResponder];
            return ;
        }
        if (![CountryArray containsObject:countryname]) {
             [self.view makeToast:@"Please Choose the available Country Code" duration:3.0 position:@"bottom"];
            [_mobileTextField becomeFirstResponder];
            return ;
        }
        if (mobileno == NULL || mobileno.length ==0) {
             [self.view makeToast:@"Please enter a valid number" duration:3.0 position:@"bottom"];
            [_mobileTextField becomeFirstResponder];
            return ;
        }
        else if (mobileno.length<10)
        {
             [self.view makeToast:@"Please enter a valid mobile number" duration:3.0 position:@"bottom"];
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
                    // NSData *response = [request_b.responseString dataUsingEncoding:NSUTF8StringEncoding];
                    // NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
                    _mobileTextField.text=@"";
                    [mobilenoArray removeAllObjects];
                    [usArray removeAllObjects];
                    [tempmobilenoArray removeAllObjects];
                    [indiaArray removeAllObjects];
                    [_mobileTableview reloadData];
                    
                }];
                
                [request setFailedBlock:^(){
                    NSLog(@"%@",request_b.error);
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
        NSString*string=[[NSString alloc]init];
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
        NSString *otpUrl;
        NSString*string=[[NSString alloc]init];
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
        NSString*string=[[NSString alloc]init];
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
            NSLog(@"Failure US");
            [SVProgressHUD dismiss];

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
-(void)requestFailed:(ASIHTTPRequest *)response
{
    NSLog(@"Failure INDIA");
    [SVProgressHUD dismiss];
}


- (IBAction)createGroup:(id)sender
{
    if (!_countrytableview.hidden) {
        _countrytableview.hidden=YES;
    }
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
        if (tempmobilenoArray.count==0) {
            if (_mobileTextField.text.length!=0) {
                 [SVProgressHUD showWithStatus:@"Sending invitation ...." maskType:SVProgressHUDMaskTypeBlack];
              [self callInvite];
                sharedObj.currentgroupOpenEntry=openentry;
                sharedObj.currentgreenchannelId=sharedObj.selectedIdArray;
                PFQuery*groupQuery=[PFQuery queryWithClassName:@"Group"];
                [groupQuery whereKey:@"objectId" equalTo:sharedObj.GroupId];
                [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!error) {
                        object[@"GreenChannel"]=[NSMutableArray arrayWithArray:sharedObj.selectedIdArray];
                        if (openEntry) {
                            
                            if (openentry ==0) {
                                object[@"JobScheduled"]=[NSNumber numberWithBool:NO];
                                object[@"JobHours"]=[NSNumber numberWithInt:0];
                                object[@"GroupType"]=@"Private";
                            }
                            else
                            {
                                object[@"JobScheduled"]=[NSNumber numberWithBool:YES];
                                object[@"JobHours"]=[NSNumber numberWithInt:sharedObj.currentgroupOpenEntry];
                                object[@"GroupType"]=@"Private";
                            }
                        }
                        else
                        {
                            object[@"JobScheduled"]=[NSNumber numberWithBool:NO];
                            object[@"JobHours"]=[NSNumber numberWithInt:0];
                            object[@"GroupType"]=@"Private";
                            
                        }
                        
                        [object saveInBackground];
                        [self CallMyService];
                    }
                    else
                    {
                        [SVProgressHUD dismiss];
                    }
                }];
            
            }
            else
            {
                if (mobilenoArray.count!=0) {
                      [SVProgressHUD showWithStatus:@"Sending invitation ...." maskType:SVProgressHUDMaskTypeBlack];
                }else
                 [SVProgressHUD showWithStatus:@"Updating Open Entry ...." maskType:SVProgressHUDMaskTypeBlack];
                
                sharedObj.currentgroupOpenEntry=openentry;
                sharedObj.currentgreenchannelId=sharedObj.selectedIdArray;
                PFQuery*groupQuery=[PFQuery queryWithClassName:@"Group"];
                [groupQuery whereKey:@"objectId" equalTo:sharedObj.GroupId];
                [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (!error) {
                        object[@"GreenChannel"]=[NSMutableArray arrayWithArray:sharedObj.selectedIdArray];
                        if (openEntry) {
                            
                            if (openentry ==0) {
                                object[@"JobScheduled"]=[NSNumber numberWithBool:NO];
                                object[@"JobHours"]=[NSNumber numberWithInt:0];
                                object[@"GroupType"]=@"Private";
                            }
                            else
                            {
                                object[@"JobScheduled"]=[NSNumber numberWithBool:YES];
                                object[@"JobHours"]=[NSNumber numberWithInt:sharedObj.currentgroupOpenEntry];
                                object[@"GroupType"]=@"Private";
                            }
                        }
                        else
                        {
                            object[@"JobScheduled"]=[NSNumber numberWithBool:NO];
                            object[@"JobHours"]=[NSNumber numberWithInt:0];
                            object[@"GroupType"]=@"Private";
                            
                        }
                        
                        [object saveInBackground];
                         if (mobilenoArray.count!=0) {
                             [SVProgressHUD showWithStatus:@"Invitations sent" maskType:SVProgressHUDMaskTypeBlack];
                         }
                        else
                        [SVProgressHUD showWithStatus:@"Updated Open Entry successfully" maskType:SVProgressHUDMaskTypeBlack];
                        
                        _mobileTextField.text=@"";
                        [mobilenoArray removeAllObjects];
                        [usArray removeAllObjects];
                        [tempmobilenoArray removeAllObjects];
                        [indiaArray removeAllObjects];
                        [_mobileTableview reloadData];
                        [SVProgressHUD dismiss];
                        [self CallMyService];
                    }
                    else
                    {
                        [SVProgressHUD dismiss];
                    }
                }];
            }

            
            
        
        }
        else{
        [SVProgressHUD showWithStatus:@"Sending invitation ...." maskType:SVProgressHUDMaskTypeBlack];
               [self callInvite];
    sharedObj.currentgroupOpenEntry=openentry;
    sharedObj.currentgreenchannelId=sharedObj.selectedIdArray;
            
    PFQuery*groupQuery=[PFQuery queryWithClassName:@"Group"];
    [groupQuery whereKey:@"objectId" equalTo:sharedObj.GroupId];
    [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            object[@"GreenChannel"]=[NSMutableArray arrayWithArray:sharedObj.selectedIdArray];
            if (openEntry) {
               
            if (openentry ==0) {
                object[@"JobScheduled"]=[NSNumber numberWithBool:NO];
                object[@"JobHours"]=[NSNumber numberWithInt:0];
                object[@"GroupType"]=@"Private";
            }
            else
            {
                object[@"JobScheduled"]=[NSNumber numberWithBool:YES];
                object[@"JobHours"]=[NSNumber numberWithInt:sharedObj.currentgroupOpenEntry];
                object[@"GroupType"]=@"Private";
            }
            }
            else
            {
                object[@"JobScheduled"]=[NSNumber numberWithBool:NO];
                object[@"JobHours"]=[NSNumber numberWithInt:0];
                object[@"GroupType"]=@"Private";
                
            }

            [object saveInBackground];
            
            [self CallMyService];
        }
        else
        {
            [SVProgressHUD dismiss];
        }
    }];
    }
    }
    
}

- (IBAction)openEntrySwitch:(id)sender {
    
    if ([sender isOn]) {
        openEntry=YES;
        _sliderView.hidden=NO;
        [self.openSwitch setOn:YES animated:YES];
        if (!_inviteView.hidden) {
            _openentryView.frame=CGRectMake(0, 350, 320, 58);
            _sliderView.frame=CGRectMake(8, 408, 304, 165);
            _createbtn.frame=CGRectMake(5, 580, 310, 40);
        }
        else
        {
            _openentryView.frame=CGRectMake(0, 55, 320, 58);
            _sliderView.frame=CGRectMake(8, 108, 304, 165);
            _createbtn.frame=CGRectMake(5, 450, 310, 40);
        }
    }
    else
    {
        openEntry=NO;
        _sliderView.hidden=YES;
        [self.openSwitch setOn:NO animated:YES];
        if (!_inviteView.hidden) {
            _openentryView.frame=CGRectMake(0, 350, 320, 58);
            _sliderView.frame=CGRectMake(8, 408, 304, 165);
            _createbtn.frame=CGRectMake(5, 450, 310, 40);
        }
        else
        {
            _openentryView.frame=CGRectMake(0, 55, 320, 58);
            _sliderView.frame=CGRectMake(8, 108, 304, 165);
            _createbtn.frame=CGRectMake(5, 450, 310, 40);
        }

    }
    
    _invitescrollview.contentSize=CGSizeMake(_invitescrollview.frame.size.width, [self findViewHeight:_createbtn.frame]+10);
}
-(void)CallMyService
{
    
    mygroup=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
    [myquery whereKey:@"objectId" containedIn:mygroup];
    [myquery whereKey:@"GroupStatus" equalTo:@"Active"];
    [myquery orderByDescending:@"updatedAt"];
    [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
            [SVProgressHUD dismiss];
        } else {
            
            [PFObject unpinAllObjectsInBackgroundWithName:@"MYGROUP"];
            [PFObject pinAllInBackground:objects withName:@"MYGROUP"];
            [SVProgressHUD dismiss];
        }
    }];

    
       
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
    if (!_countrytableview.hidden) {
        _countrytableview.hidden=YES;
    }
    [[self navigationController]popViewControllerAnimated:YES];
}

- (IBAction)openEntrybtnAction:(id)sender {
    [_minsbtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    [_hour1btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [_hour6btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [_daybtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    openentry=15;

}




- (IBAction)hour1btnAction:(id)sender {
    [_minsbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [_hour1btn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    [_hour6btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [_daybtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
     openentry=1;
}
- (IBAction)daybtnAction:(id)sender {
    [_minsbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [_hour1btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [_hour6btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [_daybtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
     openentry=24;
}

- (IBAction)hour6btnAction:(id)sender {
    [_minsbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [_hour1btn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [_hour6btn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    [_daybtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
 openentry=6;
}
@end
