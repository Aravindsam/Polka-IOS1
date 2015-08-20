//
//  SecretGrpViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "SecretGrpViewController.h"
#import "SVProgressHUD.h"
#import "UIImage+ResizeAdditions.h"
#import "UIImage+BlurredFrame.h"
#import "GroupModalClass.h"
#import "InsideGroupViewController.h"
#import "Toast+UIView.h"
#define NUMERIC @"1234567890+"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface SecretGrpViewController ()

@end

@implementation SecretGrpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    currentdate=[[NSString alloc]init];
    humanizedType = NSDateHumanizedSuffixAgo;


    timestamp=[[NSString alloc]init];
    sharedObj=[Generic sharedMySingleton];
    _headerview.backgroundColor=[Generic colorFromRGBHexString:headerColor];
   // _gobtn.backgroundColor=[Generic colorFromRGBHexString:headerColor];
      _groupnameTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    create=NO;
     _addlabel.hidden=NO;
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    groupName=[[NSString alloc]init];
    secretcode=[[NSString alloc]init];
    groupimgurl=[[PFFile alloc]init];
    groupId=[[NSString alloc]init];
    otpValue=[[NSString alloc]init];
    mobileno=[[NSString alloc]init];
    groupDescription=[[NSString alloc]init];
    mygroup=[[NSMutableArray alloc]init];
    _headerview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _headerview.layer.borderWidth=0.5;
    
    _aboutTextview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _aboutTextview.layer.borderWidth=0.5;
    _aboutTextview.layer.cornerRadius=5;
    _aboutTextview.clipsToBounds=YES;
    
    _groupnameTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _groupnameTextfield.layer.borderWidth=0.5;
    _groupnameTextfield.layer.cornerRadius=5;
    _groupnameTextfield.clipsToBounds=YES;
    
   
    
    _addlabel.layer.cornerRadius=12.5;
    _addlabel.clipsToBounds=YES;
    
    [_memberbtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    [_adminbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
     sharedObj.MemberApproval=NO;
    
    imagePicker = [[UIImagePickerController alloc] init];
    [_backgroundImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapgestur=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseImage)];
    tapgestur.numberOfTapsRequired=1;
    [_backgroundImageView addGestureRecognizer:tapgestur];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"UserDetails"];
    [query1 whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
    [query1 fromLocalDatastore];
    [query1 whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
    [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error) {
        }
        else{
            userimage =[object objectForKey:@"ThumbnailPicture"];
        }}];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
      //  [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSomething)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   _secretScrollview.contentSize=CGSizeMake(_secretScrollview.frame.size.width, [self findViewHeight:_secretgrpView.frame]);
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _secretScrollview.contentSize=CGSizeMake(_secretScrollview.frame.size.width, [self findViewHeight:_secretgrpView.frame]);
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_secretScrollview setContentOffset:CGPointMake(0, 140)];
}
-(void)doSomething
{
    _secretScrollview.contentSize=CGSizeMake(_secretScrollview.frame.size.width, [self findViewHeight:_secretgrpView.frame]);
}
#pragma mark - CLLocationManagerDelegate
-(void)keyboardWillShow:(id)sender
{
  
    _secretScrollview.contentSize=CGSizeMake(_secretScrollview.frame.size.width, [self findViewHeight:_secretgrpView.frame]+220);
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

-(void)keyboardWillHide:(id)sender
{
    _secretScrollview.contentSize=CGSizeMake(_secretScrollview.frame.size.width, [self findViewHeight:_secretgrpView.frame]);
}
-(CGFloat)findViewHeight:(CGRect)sender
{
    CGFloat hgValue = sender.origin.y +sender.size.height;
    return hgValue;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [self.view makeToast:@"Unable to get your location" duration:3.0 position:@"bottom"];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField==_groupnameTextfield) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length>30) {
            return NO;
        }
        
    }
        return YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([newString length]>250) {
        return NO;
    }
    
    return YES;
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
    if (create) {
        return;
    }
    else{
    sharedObj.groupimageData=nil;
    sharedObj.aboutGroup=nil;
    sharedObj.groupLocation=nil;
    sharedObj.radiusVisibilityVal=0;
    sharedObj.openEntryVal=0;
    sharedObj.GroupName=nil;
    sharedObj.inviteNo=nil;
    sharedObj.otherText=nil;
    sharedObj.AdditionalInfotext=nil;
    sharedObj.greenchannelArray=nil;
    sharedObj.MemberApproval=NO;
    [[self navigationController]popViewControllerAnimated:YES];
    }
}
- (IBAction)memberbtnclicked:(id)sender {
    sharedObj.MemberApproval=NO;
    [_memberbtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    [_adminbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
}
- (IBAction)adminbtnClicked:(id)sender {
    sharedObj.MemberApproval=YES;
    [_adminbtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    [_memberbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    NSString*lat=[NSString stringWithFormat:@"%.6f", currentLocation.coordinate.latitude];
    NSString*lon=[NSString stringWithFormat:@"%.6f", currentLocation.coordinate.longitude];
    
    double latdouble = [lat doubleValue];
    double londouble = [lon doubleValue];
    CLLocationCoordinate2D coord = {latdouble,londouble};
    
    
    
    
    if (currentLocation != nil) {
        point = [PFGeoPoint geoPointWithLatitude:coord.latitude longitude:coord.longitude];
    }
    NSLog(@"Resolving the Address");
    [locationManager stopUpdatingLocation];
}
-(void)chooseImage
{
    [_aboutTextview resignFirstResponder];
    [_groupnameTextfield resignFirstResponder];
    UIAlertView *ImageAlert = [[UIAlertView alloc]
                               initWithTitle:@"Choose Picture From"
                               message:@""
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:@"Photo Gallery", @"Take Photo", nil];
    ImageAlert.tag=11;
    [ImageAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==11) {
        switch (buttonIndex) {
            case 1:
                [self getimagefromgallery];
                break;
            case 2:
                [self getimagefromcamera];
                break;
            default:
                break;
        }
        
    }
    
}
-(void)getimagefromgallery{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]==YES)
    {
        imagePicker.delegate = self;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
-(void)getimagefromcamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = YES;
        imagePicker.showsCameraControls = YES;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        newMedia = YES;
    }
    
    
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        image = [info
                 objectForKey:UIImagePickerControllerOriginalImage];
        PECropViewController *controller = [[PECropViewController alloc] init];
        controller.delegate = self;
        controller.image = image;
        
        
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat length = MIN(width, height);
        controller.imageCropRect = CGRectMake((width - length) / 2,
                                              (height - length) / 2,
                                              length,
                                              length);
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        
        [self presentViewController:navigationController animated:YES completion:NULL];
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
   
     groupImageData=[self compressImage:croppedImage];
 
    _groupImageview.hidden=YES;
    _backgroundImageView.image=croppedImage;
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageView.clipsToBounds = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (_backgroundImageView.image!=nil) {
        _groupImageview.hidden=YES;
        
    }
    else
        _groupImageview.hidden=NO;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error){
        [self showAlert:@"Failed to save image"];
    }
}
-(NSData *)compressImage:(UIImage *)imagedata{
    float actualHeight = imagedata.size.height;
    float actualWidth = imagedata.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    
    NSData *imageData1 = [[NSData alloc] initWithData:UIImageJPEGRepresentation((imagedata), 1.0)];
    
    int imageSize = (int)imageData1.length;
    NSLog(@"SIZE OF IMAGE: %i ", imageSize);
    float compressionQuality;//50 percent compression
    
    if (imageSize < 200000) {
        compressionQuality=1.0;
    }
    else if (imageSize < 500000 && imageSize > 200000)
    {
        compressionQuality=0.9;
    }
    else if (imageSize < 1000000 && imageSize > 500000)
    {
        compressionQuality=0.8;
    }
    else if (imageSize < 5000000 && imageSize>2000000)
    {
        compressionQuality=0.6;
    }
    else if (imageSize < 6000000 && imageSize>5000000)
    {
        compressionQuality=0.4;
        
    }
    else if (imageSize>6000000)
    {
        compressionQuality=0.3;
    }
    else
    {
        compressionQuality=0.5;
    }
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [imagedata drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return  imageData;
}


-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)createSecretGroup:(id)sender {
    if (create) {
        return;
        
    }
    else
    {
        create=YES;
    }
    groupName=_groupnameTextfield.text;
    groupName=[groupName capitalizedString];
    groupName=[groupName stringByTrimmingCharactersInSet:
               [NSCharacterSet whitespaceCharacterSet]];
    if (groupName == NULL || groupName.length ==0) {
        create=NO;
        [self showAlert:@"Please enter group name"];
        [_groupnameTextfield becomeFirstResponder];
        return ;
    }
    
    
    sharedObj.GroupName=groupName;
    [SVProgressHUD showWithStatus:@"Creating Group...." maskType:SVProgressHUDMaskTypeBlack];
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"GroupName" equalTo:groupName];
    [query whereKey:@"GroupLocation" nearGeoPoint:point withinMiles:0.310686];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (error) {
            [SVProgressHUD dismiss];
        }
        else{
            
            
            if (objects.count!=0) {
                 create=NO;
                [SVProgressHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Group name already exists. Please try another name"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
                
                
            }
            else
            {                groupDescription=_aboutTextview.text;
                
                if (groupDescription.length==0) {
                     create=NO;
                    [SVProgressHUD dismiss];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"Please write a description for your group"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                if (_backgroundImageView.image==nil) {
                     create=NO;
                    [SVProgressHUD dismiss];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"Please upload a group image"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                    
                }
                secretcode=[self randomStringWithLength:5];
                NSData* data = groupImageData;
                PFFile *imageFile = [PFFile fileWithName:@"groupImage.png" data:data];
                
                        groupimgurl=imageFile;
                        PFObject *testObject = [PFObject objectWithClassName:@"Group"];
                        testObject[@"MobileNo"]=sharedObj.AccountNumber;
                        testObject[@"CountryName"]=sharedObj.AccountCountry;
                        testObject[@"GroupName"]=sharedObj.GroupName;
                        
                        testObject[@"GroupPicture"]=imageFile;
                        testObject[@"GroupDescription"]=groupDescription;
                        testObject[@"GroupType"]=@"Secret";
                        testObject[@"GroupLocation"]=point;
                        testObject[@"MemberCount"]=[NSNumber numberWithInt:1];
                        testObject[@"NewsFeedCount"]=[NSNumber numberWithInt:0];
                        testObject[@"MemberInvitation"]=[NSNumber numberWithBool:YES];
                        testObject[@"GreenChannel"]=[[NSMutableArray alloc]init];
                        testObject[@"GroupStatus"]=@"Active";
                        testObject[@"MembershipApproval"]=[NSNumber numberWithBool:sharedObj.MemberApproval];
                        testObject[@"JobScheduled"]=[NSNumber numberWithBool:NO];
                        testObject[@"JobHours"]=[NSNumber numberWithInt:0];
                        testObject[@"GroupMembers"]=[[NSMutableArray alloc]initWithObjects:sharedObj.AccountNumber, nil];
                         testObject[@"AdminArray"]=[[NSMutableArray alloc]initWithObjects:sharedObj.AccountNumber, nil];
                        testObject[@"LatestPost"]=@"";
                       
                        testObject[@"AdditionalInfoRequired"]=[NSNumber numberWithBool:NO];
                        testObject[@"InfoRequired"]=@"";
                        testObject[@"VisibiltyRadius"]=[NSNumber numberWithInt:0];
                        testObject[@"SecretStatus"]=[NSNumber numberWithBool:YES];
                        testObject[@"SecretCode"]=secretcode;
                        [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                NSLog(@"Saved");
                                groupId=testObject.objectId;
                                timestamp = [[testObject createdAt] stringWithHumanizedTimeDifference:humanizedType withFullString:YES];
                                PFObject *member=[PFObject objectWithClassName:@"MembersDetails"];
                                member[@"GroupId"]=groupId;
                                member[@"MemberNo"]=sharedObj.AccountNumber;
                                member[@"JoinedDate"]=[NSDate date];
                                member[@"AdditionalInfoProvided"]=@"";
                                member[@"ExitGroup"]=[NSNumber numberWithBool:NO];
                                member[@"GroupAdmin"]=[NSNumber numberWithBool:YES];
                                member[@"UnreadMsgCount"]=[NSNumber numberWithInt:0];
                                member[@"LeaveDate"]=[NSDate date];
                                member[@"MemberImage"]=userimage;
                                member[@"MemberName"]=sharedObj.AccountName;
                                member[@"MemberStatus"]=@"Active";
                                member[@"ExitedBy"]=@"";
                                PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                                
                                member[@"UserId"]=pointer;
                                [member saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (error) {
                                         [SVProgressHUD dismiss];
                                    }
                                    else
                                    {
                                        [SVProgressHUD dismiss];
                                        
                                        PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
                                        
                                        [query getObjectInBackgroundWithId:sharedObj.userId block:^(PFObject *userStats, NSError *error) {
                                            if (error) {
                                                NSLog(@"Data not available insert userdetails");
                                                [SVProgressHUD dismiss];
                                                
                                            } else {
                                               
                                                mygroup=userStats[@"MyGroupArray"];
                                                [mygroup addObject:testObject.objectId];
                                                userStats[@"MyGroupArray"]=mygroup;
                                                [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:1000]];
                                                userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                                userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                                [userStats saveInBackground];
                                                
                                                [self CallMyService];
                                                
                                                
                                            }
                                        }];
                                        

                                    }
                                }];
                                
                            }
                            else{
                                // Error
                                NSLog(@"Error: %@ %@", error, [error userInfo]);
                                [SVProgressHUD dismiss];
                            }
                        }];
                

            }
            
            
        }
    }];

}


-(void)CallMyService
{
    
    [SVProgressHUD showWithStatus:@"Group Created Successfully...." maskType:SVProgressHUDMaskTypeBlack];

    [[NSUserDefaults standardUserDefaults]setObject:mygroup forKey:@"MyGroup"];
                    [SVProgressHUD dismiss];
    
   
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                InsideGroupViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"InsideGroupViewController"];
          
                
                sharedObj.groupType=@"Secret";
                sharedObj.GroupId=groupId;
                sharedObj.frommygroup=NO;
                sharedObj.groupimageurl=groupimgurl;
                sharedObj.groupMember=@"1";
                sharedObj.groupdescription=groupDescription;
                sharedObj.GroupName=sharedObj.GroupName;
                sharedObj.secretCode=secretcode;
                
                sharedObj.currentGroupAdminArray=[[NSMutableArray alloc]initWithObjects:sharedObj.AccountNumber, nil];
                sharedObj.currentGroupmemberArray=[[NSMutableArray alloc]initWithObjects:sharedObj.AccountNumber, nil];
                sharedObj.currentgroupEstablished=timestamp;
                sharedObj.currentgroupAddinfo=NO;
                sharedObj.addinfo=@"";
                sharedObj.currentgroupOpenEntry=0;
                sharedObj.currentgroupradius=0;
                sharedObj.currentgroupSecret=YES;
                [self.navigationController pushViewController:settingsViewController animated:YES];              
    
    PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
    [myquery whereKey:@"objectId" containedIn:mygroup];
    [myquery whereKey:@"GroupStatus" equalTo:@"Active"];
    [myquery orderByDescending:@"updatedAt"];
    [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            
            [PFObject unpinAllObjectsInBackgroundWithName:@"MYGROUP"];
            [PFObject pinAllInBackground:objects withName:@"MYGROUP"];
        }
    }];
    
    
    
    
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
