//
//  UpdateGroupProfileViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/20/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "UpdateGroupProfileViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "UIImage+BlurredFrame.h"
#import "GroupModalClass.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "WhatsAppKit.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "KxMenu.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface UpdateGroupProfileViewController ()

@end

@implementation UpdateGroupProfileViewController
@synthesize Fromnearby,indexval;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
        update=NO;
    _fullimgView.hidden=YES;
    invitationArray=[[NSMutableArray alloc]init];
    imagePicker=[[UIImagePickerController alloc]init];
    ownerGroup=[[NSMutableArray alloc]init];
    groupMembers=[[NSMutableArray alloc]init];
    unquieArray=[[NSMutableArray alloc]init];
    invitationarray=[[NSMutableArray alloc]init];
    mygroup=[[NSMutableArray alloc]init];
    inviationId=[[NSString alloc]init];
    myGroupIdArray=[[NSMutableArray alloc]init];
    _groupnameTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    currentdate=[[NSString alloc]init];
    sharedObj=[Generic sharedMySingleton];
    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];

    typegroup=sharedObj.groupType;
    typegroup=[typegroup uppercaseString];
   // _titleLabel.text=[NSString stringWithFormat:@"%@ GROUP PROFILE",typegroup ];
    _estabilishedlabel.text=[NSString stringWithFormat:@" Estd : %@",sharedObj.currentgroupEstablished];
    mygroup=[[NSMutableArray alloc]init];
    myGroupIdArray=[[NSMutableArray alloc]init];
    if ([sharedObj.groupMember isEqualToString:@"1"]) {
     memberCountLabel.text=[NSString stringWithFormat:@"%@",sharedObj.groupMember];
    }
    
    else
        memberCountLabel.text=[NSString stringWithFormat:@"%@",sharedObj.groupMember];
   
   
    groupName=[[NSString alloc]init];
    groupDescription=[[NSString alloc]init];
 

    if (sharedObj.currentgroupAccess) {
        sharedObj.MemberApproval=sharedObj.currentgroupAccess;
        [_adminbtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        [_memberbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    }
    else
    {
        sharedObj.MemberApproval=sharedObj.currentgroupAccess;
      
        
        [_memberbtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        [_adminbtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    }
    
    _backgroundImageView.file=sharedObj.groupimageurl;
    _fullgroupimage.file=sharedObj.groupimageurl;
    [_backgroundImageView loadInBackground];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageView.clipsToBounds = YES;
    _backgroundImageView.userInteractionEnabled=YES;
    
  /*  UIGraphicsBeginImageContext(CGSizeMake(320, 35));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // drawing with a gray fill color
    CGContextSetRGBFillColor(context,  0., 0., 0., 0.4);
    // Add Filled Rectangle,
    CGContextFillRect(context, CGRectMake(0.0, 0.0, 320, 17.5));
    
    // drawing with a black fill color
    CGContextSetRGBFillColor(context,  0., 0., 0., 0.6);
    // Add Filled Rectangle,
    CGContextFillRect(context, CGRectMake(0.0, 17.5, 320, 17.5));
    
    UIImage* resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _estabilishedlabel.backgroundColor = [UIColor colorWithPatternImage:resultingImage];*/

  
    _groupnameTextfield.text=sharedObj.GroupName;
    _aboutTextview.text=sharedObj.groupdescription;
    singletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageFull)];
    singletap.numberOfTapsRequired=1.0;
    [_backgroundImageView addGestureRecognizer:singletap];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSomething)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _profilegrpScrollview.contentSize=CGSizeMake(_profilegrpScrollview.frame.size.width, [self findViewHeight:_profilegrpgrpView.frame]+20);
    if (Fromnearby) {
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
        _joinbutton.hidden=NO;
        if ([sharedObj.groupType isEqualToString:@"Private"]) {
            [_joinbutton setTitle:@"JOIN" forState:UIControlStateNormal];
        }
        else if ([sharedObj.groupType isEqualToString:@"Public"]) {
              [_joinbutton setTitle:@"OPEN" forState:UIControlStateNormal];
        }
        else
        {
            [_joinbutton setTitle:@"OPEN" forState:UIControlStateNormal];
        }
    }
    else
    {
        _joinbutton.hidden=YES;
    }
    if (![sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
         _gobtn.hidden=YES;
        _groupnameTextfield.userInteractionEnabled=NO;
        _aboutTextview.userInteractionEnabled=NO;
        _memberbtn.hidden=YES;
        _adminbtn.hidden=YES;
        _memberlbl.hidden=YES;
        _adminlbl.hidden=YES;
        _membershiplabel.hidden=YES;
        _changeimagebtn.hidden=YES;
    }
    else
    {
        _gobtn.hidden=NO;
          _changeimagebtn.hidden=NO;
         _groupnameTextfield.userInteractionEnabled=YES;
         _aboutTextview.userInteractionEnabled=YES;
        _aboutTextview.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _aboutTextview.layer.borderWidth=0.5;
        _aboutTextview.layer.cornerRadius=5;
        _aboutTextview.clipsToBounds=YES;
        
        _groupnameTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _groupnameTextfield.layer.borderWidth=0.5;
        _groupnameTextfield.layer.cornerRadius=5;
        _groupnameTextfield.clipsToBounds=YES;
        if ([sharedObj.groupType isEqualToString:@"Public"]||[sharedObj.groupType isEqualToString:@"Open"]) {
            _memberbtn.hidden=YES;
            _adminbtn.hidden=YES;
            _memberlbl.hidden=YES;
            _adminlbl.hidden=YES;
            _membershiplabel.hidden=YES;
        }
        else{
        _memberbtn.hidden=NO;
        _adminbtn.hidden=NO;
        _memberlbl.hidden=NO;
        _adminlbl.hidden=NO;
        _membershiplabel.hidden=NO;
        }
    }
   
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
       // [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    
   
    // Do any additional setup after loading the view.
}

-(void)showImageFull
{
    _fullimgView.hidden=NO;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [self.view makeToast:@"Unable to get your location" duration:3.0 position:@"bottom"];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _profilegrpScrollview.contentSize=CGSizeMake(_profilegrpScrollview.frame.size.width, [self findViewHeight:_profilegrpgrpView.frame]+20);
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_profilegrpScrollview setContentOffset:CGPointMake(0, 140)];
}
-(void)doSomething
{
    _profilegrpScrollview.contentSize=CGSizeMake(_profilegrpScrollview.frame.size.width, [self findViewHeight:_profilegrpgrpView.frame]+20);
}
#pragma mark - CLLocationManagerDelegate
-(void)keyboardWillShow:(id)sender
{
    
    _profilegrpScrollview.contentSize=CGSizeMake(_profilegrpScrollview.frame.size.width, [self findViewHeight:_profilegrpgrpView.frame]+250);
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}
-(void)keyboardWillHide:(id)sender
{
    _profilegrpScrollview.contentSize=CGSizeMake(_profilegrpScrollview.frame.size.width, [self findViewHeight:_profilegrpgrpView.frame]+20);
}
-(CGFloat)findViewHeight:(CGRect)sender
{
    CGFloat hgValue = sender.origin.y +sender.size.height;
    return hgValue;
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
    
    
    
    
    
    _backgroundImageView.image=image;
    [_backgroundImageView loadInBackground];
    _fullgroupimage.image=image;
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageView.clipsToBounds = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}



-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error){
        [self showAlert:@"Failed to save image"];
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

- (IBAction)updateprofile:(id)sender {
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
    [SVProgressHUD showWithStatus:@"Updating Profile...." maskType:SVProgressHUDMaskTypeBlack];
    if (update) {
        return;
    }
    else
    {
        update=YES;
    }
  
    groupName=_groupnameTextfield.text;
    groupName=[groupName capitalizedString];
    groupName=[groupName stringByTrimmingCharactersInSet:
               [NSCharacterSet whitespaceCharacterSet]];
    if (groupName == NULL || groupName.length ==0) {
       update=NO;
        [SVProgressHUD dismiss];
        [self showAlert:@"Please enter group name"];
        [_groupnameTextfield becomeFirstResponder];
        return ;
    }
    groupDescription=_aboutTextview.text;
    
    if (groupDescription.length==0) {
        update=NO;
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
          update=NO;
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please upload a group image"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    sharedObj.groupdescription=groupDescription;
    
    if ([groupName isEqualToString:sharedObj.GroupName]) {
        PFQuery*groupQuery=[PFQuery queryWithClassName:@"Group"];
        [groupQuery whereKey:@"objectId" equalTo:sharedObj.GroupId];
        [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            NSData* data = UIImageJPEGRepresentation(_backgroundImageView.image, 0.8f);
            PFFile *imageFile1 = [PFFile fileWithName:@"Group.png" data:data];
            
            [imageFile1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    object[@"GroupName"]=sharedObj.GroupName;
                    object[@"GroupDescription"]=sharedObj.groupdescription;
                    object[@"MembershipApproval"]=[NSNumber numberWithBool:sharedObj.MemberApproval];
                    object[@"GroupPicture"]=imageFile1;
                    sharedObj.groupimageurl=imageFile1;
                    sharedObj.currentgroupAccess=sharedObj.MemberApproval;
                    [object saveInBackground];
                    [self CallMyService];
                }
                else
                {
                    [SVProgressHUD dismiss];
                }
            }];
            
            
            
        }];
    }
    else
    {sharedObj.GroupName=groupName;
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"GroupName" equalTo:groupName];
    [query whereKey:@"GroupLocation" nearGeoPoint:point withinMiles:0.310686];
    [query whereKey:@"GroupStatus" equalTo:@"Active"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (error) {
            [SVProgressHUD dismiss];
        }
        else{
            
            
            if (objects.count!=0) {
                  update=NO;
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
            {

    PFQuery*groupQuery=[PFQuery queryWithClassName:@"Group"];
    [groupQuery whereKey:@"objectId" equalTo:sharedObj.GroupId];
    [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    NSData* data = UIImageJPEGRepresentation(_backgroundImageView.image, 0.8f);
    PFFile *imageFile1 = [PFFile fileWithName:@"Group.png" data:data];
    
    [imageFile1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            object[@"GroupName"]=sharedObj.GroupName;
            object[@"GroupDescription"]=sharedObj.groupdescription;
            object[@"MembershipApproval"]=[NSNumber numberWithBool:sharedObj.MemberApproval];
            object[@"GroupPicture"]=imageFile1;
            sharedObj.groupimageurl=imageFile1;
            sharedObj.currentgroupAccess=sharedObj.MemberApproval;
            [object saveInBackground];
            [self CallMyService];
        }
        else
        {
            [SVProgressHUD dismiss];
        }
    }];
   
        
        
    }];
            }
        }
    }];
    }
    }

}
-(void)CallMyService
{
        [SVProgressHUD showWithStatus:@"Profile updated successfully" maskType:SVProgressHUDMaskTypeBlack];
      update=NO;
    myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
    [myquery whereKey:@"objectId" containedIn:myGroupIdArray];
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

- (IBAction)back:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
}
- (IBAction)joingroup:(id)sender {
    
    myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    
    GroupModalClass *modal;
    if (sharedObj.search) {
        modal = [sharedObj.searchNearby objectAtIndex:indexval];
        
    }
    else{
        modal = [sharedObj.NearByGroupArray objectAtIndex:indexval];
        
    }
    
    if ([modal.groupType isEqualToString:@"Private"]) {
        if (modal.openEntry>0) {
            [self joinfree:indexval];
            
        }
        else{
            if (modal.groupChannelArray.count!=0) {
                NSMutableSet *intersection = [NSMutableSet setWithArray:modal.groupChannelArray];
                [intersection intersectSet:[NSSet setWithArray:myGroupIdArray]];
                NSArray *array4 = [intersection allObjects];
                if (array4.count!=0) {
                    [self joinfree:indexval];
                }
                else
                {
                    if (modal.addInfoRequired) {
                        inviationId=modal.groupId;
                        
                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Additional Information" message:[NSString stringWithFormat:@"Enter %@",modal.addinfoString] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                        [alert addButtonWithTitle:@"Join"];
                        [alert setTag:33];
                        [alert show];
                        
                    }
                    else if (modal.secretCode.length!=0) {
                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Verification" message:@"Please enter passcode to join this group" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                        [alert addButtonWithTitle:@"Join"];
                        [alert setTag:44];
                        [alert show];
                        
                    }
                    else
                    {
                         [SVProgressHUD showWithStatus:@"Request to join Group..." maskType:SVProgressHUDMaskTypeBlack];
                        inviationId=modal.groupId;
                        PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
                        testObject[@"PostStatus"]=@"Active";
                        testObject[@"GroupId"]=modal.groupId;
                        testObject[@"MemberName"]=sharedObj.AccountName;
                        testObject[@"MobileNo"]=sharedObj.AccountNumber;
                        testObject[@"PostType"]=@"Invitation";
                        testObject[@"FeedLocation"]=point;
                        testObject[@"PostText"]=@"No Information Available";
                        testObject[@"MemberImage"]=userimage;
                        PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                        
                        testObject[@"UserId"]=pointer;
                        [testObject saveInBackground];
                        
                        PFQuery *query = [PFQuery queryWithClassName:@"Group"];
                        [query whereKey:@"objectId" equalTo:modal.groupId];
                        
                        [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                            if (error) {
                                NSLog(@"Data not available insert userdetails");
                                [SVProgressHUD dismiss];
                                
                                
                            } else {
                                userStats[@"LatestPost"]=[NSString stringWithFormat:@"No Additional Information Available"];
                               
                                [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        [self sendinginvitation];
                                    }
                                }];
                            }
                        }];
                        
                        
                    }
                }
            }
            else if (modal.secretCode.length!=0) {
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Verification" message:@"Please enter passcode to join this group" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert addButtonWithTitle:@"Join"];
                [alert setTag:44];
                [alert show];
                
            }
            
            else if (modal.addInfoRequired) {
                inviationId=modal.groupId;
                
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Additional Information" message:[NSString stringWithFormat:@"Enter %@",modal.addinfoString] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert addButtonWithTitle:@"Join"];
                [alert setTag:33];
                [alert show];
                
                
            }
            else
            {
                 [SVProgressHUD showWithStatus:@"Request to join Group..." maskType:SVProgressHUDMaskTypeBlack];
                inviationId=modal.groupId;
                PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
                testObject[@"PostStatus"]=@"Active";
                testObject[@"GroupId"]=modal.groupId;
                testObject[@"MemberName"]=sharedObj.AccountName;
                testObject[@"MobileNo"]=sharedObj.AccountNumber;
                testObject[@"PostType"]=@"Invitation";
                testObject[@"MemberImage"]=userimage;
                
                testObject[@"FeedLocation"]=point;
                testObject[@"PostText"]=@"No Information Available";
                PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                
                testObject[@"UserId"]=pointer;
                [testObject saveInBackground];
                
                PFQuery *query = [PFQuery queryWithClassName:@"Group"];
                [query whereKey:@"objectId" equalTo:modal.groupId];
                
                [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                    if (error) {
                        NSLog(@"Data not available insert userdetails");
                        [SVProgressHUD dismiss];
                        
                        
                    } else {
                        userStats[@"LatestPost"]=[NSString stringWithFormat:@"No Additional Information Available"];
                       
                        [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                [self sendinginvitation];
                                
                            }
                        }];
                    }
                }];
            }
        }
        
    }
    else
    {
        [self joinfree:indexval];
    }
    
}

-(void)sendinginvitation
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
    [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
    [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error) {
            [SVProgressHUD dismiss];
        }
        else{
            
            invitationarray=object[@"GroupInvitation"];
            [invitationarray addObject:inviationId];
            object[@"GroupInvitation"]=invitationarray;
            object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
            object[@"UpdateName"]=[NSNumber numberWithBool:NO];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    
                    [[NSUserDefaults standardUserDefaults]setObject:invitationarray forKey:@"GroupInvite"];
                    [SVProgressHUD dismiss];
                    [[self navigationController]popViewControllerAnimated:YES];
                }
            }];
            
            
            
        }
    }];
}

-(void)joinfree:(int)index
{
    [SVProgressHUD showWithStatus:@"Joining Group..." maskType:SVProgressHUDMaskTypeBlack];
    myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    unquieArray=[NSMutableArray arrayWithArray:myGroupIdArray];
    [unquieArray removeObjectsInArray:ownerGroup];
    
    GroupModalClass *modal;
    if (sharedObj.search) {
        modal = [sharedObj.searchNearby objectAtIndex:index];
        
    }
    else{
        modal = [sharedObj.NearByGroupArray objectAtIndex:index];
        
    }
    
    PFObject *member=[PFObject objectWithClassName:@"MembersDetails"];
    member[@"GroupId"]=modal.groupId;
    member[@"MemberNo"]=sharedObj.AccountNumber;
    member[@"MemberImage"]=userimage;
    member[@"MemberName"]=sharedObj.AccountName;
    member[@"JoinedDate"]=[NSDate date];
    member[@"AdditionalInfoProvided"]=@"";
    member[@"GroupAdmin"]=[NSNumber numberWithBool:NO];
    member[@"UnreadMsgCount"]=[NSNumber numberWithInt:0];
    member[@"ExitGroup"]=[NSNumber numberWithBool:NO];
    member[@"LeaveDate"]=[NSDate date];
    member[@"MemberStatus"]=@"Active";
    member[@"ExitedBy"]=@"";
    PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
    
    member[@"UserId"]=pointer;
    [member saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            PFQuery *query = [PFQuery queryWithClassName:@"Group"];
            [query whereKey:@"objectId" equalTo:modal.groupId];
            
            [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                if (error) {
                    NSLog(@"Data not available insert userdetails");
                    [SVProgressHUD dismiss];
                    
                    
                } else {
                    [userStats incrementKey:@"MemberCount" byAmount:[NSNumber numberWithInt:1]];
                    groupMembers=userStats[@"GroupMembers"];
                    [groupMembers addObject:sharedObj.AccountNumber];
                    userStats[@"GroupMembers"]=groupMembers;
                    [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            NSString*countstring=[NSString stringWithFormat:@"%@",userStats[@"MemberCount"]];
                            if ([countstring isEqualToString:@"20"]) {
                                PFQuery *query1 = [PFQuery queryWithClassName:@"UserDetails"];
                                [query1 whereKey:@"MobileNo" containedIn:modal.groupAdminArray];
                                
                                [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    for (PFObject *userStats in objects) {
                                        
                                        [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:1000]];
                                        userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                        userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                        [userStats saveInBackground];
                                    }
                                    
                                    
                                }];
                                
                                
                            }
                            else if([countstring isEqualToString:@"50"])
                            {PFQuery *query1 = [PFQuery queryWithClassName:@"UserDetails"];
                                [query1 whereKey:@"MobileNo" containedIn:modal.groupAdminArray];
                                
                                [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    for (PFObject *userStats in objects) {
                                        
                                        [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:2000]];
                                        userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                        userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                        [userStats saveInBackground];
                                    }
                                    
                                    
                                }];
                                
                                
                            }
                            
                            
                            PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
                            [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                            
                            [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
                            [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                                if (error) {
                                    NSLog(@"Data not available insert userdetails");
                                    [SVProgressHUD dismiss];
                                    
                                    
                                } else {
                                    if (unquieArray.count==0) {
                                        [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:1000]];
                                    }
                                    else{
                                        [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:100]];
                                    }
                                    mygroup=userStats[@"MyGroupArray"];
                                    [mygroup addObject:modal.groupId];
                                    userStats[@"MyGroupArray"]=mygroup;
                                    userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                    userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                    [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        if (!error) {
                                             [self godetailsScreen];
                                            
                                        }
                                    }];
                                    
                                }
                            }];
                            
                        }
                    }];
                    
                }
            }];
            
        }
    }];
}
-(void)godetailsScreen
{
   
    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
    [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
    [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
    
    [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (error) {
            NSLog(@"Data not available insert userdetails");
            [SVProgressHUD dismiss];
        } else {
            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"GroupInvitation"] forKey:@"GroupInvite"];
            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"MyGroupArray"] forKey:@"MyGroup"];
            GroupModalClass *modal;
            if (sharedObj.search) {
                modal = [sharedObj.searchNearby objectAtIndex:indexval];
                
            }
            else{
                modal = [sharedObj.NearByGroupArray objectAtIndex:indexval];
                
            }
            PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
            testObject[@"PostStatus"]=@"Active";
            
            testObject[@"GroupId"]=modal.groupId;
            testObject[@"MemberName"]=sharedObj.AccountName;
            testObject[@"MobileNo"]=sharedObj.AccountNumber;
            testObject[@"PostType"]=@"Member";
            testObject[@"MemberImage"]=userimage;
            
            testObject[@"PostText"]=[NSString stringWithFormat:@"%@ - newly joined in this group",sharedObj.AccountName];
            testObject[@"CommentCount"]=[NSNumber numberWithInt:0];
            testObject[@"PostPoint"]=[NSNumber numberWithInt:0];
            testObject[@"FlagCount"]=[NSNumber numberWithInt:0];
            testObject[@"LikeUserArray"]=[[NSMutableArray alloc]init];
            testObject[@"DisLikeUserArray"]=[[NSMutableArray alloc]init];
            testObject[@"FlagArray"]=[[NSMutableArray alloc]init];
            testObject[@"FeedLocation"]=point;
            PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
            
            testObject[@"UserId"]=pointer;
            [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                testObject[@"FeedupdatedAt"]=testObject.updatedAt;
                [testObject saveInBackground];
            }];
          
            
            myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
            PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
            [myquery whereKey:@"objectId" containedIn:myGroupIdArray];
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
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SERVICEREFRESH" object:nil];
                    [[self navigationController]popViewControllerAnimated:YES];
                }
            }];

           
        }
    }];
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

    
    if (alertView.tag==33)
    {
        if (buttonIndex == 1)
        {
            
            GroupModalClass *modal;
            if (sharedObj.search) {
                modal = [sharedObj.searchNearby objectAtIndex:indexval];
                
            }
            else{
                modal = [sharedObj.NearByGroupArray objectAtIndex:indexval];
                
            }
            UITextField *Additioninfo = [alertView textFieldAtIndex:0];
            if (Additioninfo.text.length!=0) {
                PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
                testObject[@"PostStatus"]=@"Active";
                
                testObject[@"GroupId"]=modal.groupId;
                testObject[@"MemberName"]=sharedObj.AccountName;
                testObject[@"MobileNo"]=sharedObj.AccountNumber;
                testObject[@"PostType"]=@"Invitation";
                testObject[@"MemberImage"]=userimage;
                PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                
                testObject[@"UserId"]=pointer;
                testObject[@"FeedLocation"]=point;
                testObject[@"PostText"]=[NSString stringWithFormat:@"%@ - %@",modal.addinfoString,Additioninfo.text];
                [testObject saveInBackground];
                
                PFQuery *query = [PFQuery queryWithClassName:@"Group"];
                [query whereKey:@"objectId" equalTo:modal.groupId];
                
                [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                    if (error) {
                        NSLog(@"Data not available insert userdetails");
                        [SVProgressHUD dismiss];
                        
                        
                    } else {
                        userStats[@"LatestPost"]=[NSString stringWithFormat:@"%@ - %@",modal.addinfoString,Additioninfo.text];
                       
                        [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                [self sendinginvitation];
                                
                            }
                        }];
                    }
                }];
                
                
                
            }
        }
      
        
    }
    
    else if(alertView.tag==44)
    {
        if (buttonIndex == 1)
        {
            
            GroupModalClass *modal;
            if (sharedObj.search) {
                modal = [sharedObj.searchNearby objectAtIndex:indexval];
                
            }
            else{
                modal = [sharedObj.NearByGroupArray objectAtIndex:indexval];
                
            }
            UITextField *Additioninfo = [alertView textFieldAtIndex:0];
            
            if ([Additioninfo.text isEqualToString:modal.secretCode]) {
                [self joinfree:indexval];
            }
            else
            {
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Error" message:@"Incorrect Passcode entered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                errorAlert.tag=111;
                [errorAlert show];
                
            }
        }
        
    }
    
    
}
- (IBAction)uploadimage:(id)sender {
    [self chooseImage];
}
- (IBAction)close:(id)sender {
     _fullimgView.hidden=YES;
}

- (IBAction)sharepic:(id)sender {
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"Share through"
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"Facebook"
                     image:[UIImage imageNamed:@"Facebook"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Twitter"
                     image:[UIImage imageNamed:@"twitter"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"WhatsApp"
                     image:[UIImage imageNamed:@"Whatsapp"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Mail"
                     image:[UIImage imageNamed:@"mail"]
                    target:self
                    action:@selector(pushMenuItem:)]
      
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:self.view.frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(KxMenuItem*)sender
{
    NSLog(@"%@", sender.title);
    if ([sender.title isEqualToString:@"Facebook"]) {
        
        [self fbShareBtnSelected:_fullgroupimage.image];
        
        
        
    }
    else if ([sender.title isEqualToString:@"Twitter"])
    {
        
        [self twitterShareSelected:_fullgroupimage.image];
        
    }
    else if([sender.title isEqualToString:@"WhatsApp"])
    {
        
        
        [self whatsAppShareSelected:_fullgroupimage.image];
        
    }
    else if ([sender.title isEqualToString:@"Mail"])
    {
        [self mailShareSelected];
    }
    [KxMenu dismissMenu];
}

-(void)dismissMenu
{
    [KxMenu dismissMenu];
}

-(void)fbShareBtnSelected:(UIImage*)ImageData
{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        mySlcomposerView=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        [mySlcomposerView addImage:ImageData];
        __weak typeof(self) weakSelf = self;
        [mySlcomposerView setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch (result)
             {
                 case SLComposeViewControllerResultDone:
                     
                     [weakSelf showAlertWithMessage:@"Posted Successfully." Title:@"GroupsNearMe"];
                     
                     break;
                     
                 case SLComposeViewControllerResultCancelled:
                     //                     [self showAlertWithMessage:@"Post Cancelled." Title:@"iFlicks"];
                     break;
                 default:
                     break;
             }
         }];
        if ([mySlcomposerView respondsToSelector:@selector(popoverPresentationController)])
        {
            // iOS 8+
            [self presentViewController:mySlcomposerView animated:YES completion:nil];
            // if button or change to self.view.
        }
        
        
        
        
        //[mySlcomposerView addURL:[NSURL URLWithString:modal.htmlUrl]];
        
    }
    
    else
    {
        [self showAlertWithMessage:@"You must configure Facebook account for sharing.You can add or create a Facebook/Twitter account in Settings." Title:@"GroupsNearMe"];
    }
    
}
-(void)showAlertWithMessage:(NSString *)message Title:(NSString *)title
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)twitterShareSelected:(UIImage*)ImageData
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        mySlcomposerView=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        
        [mySlcomposerView addImage:ImageData];
        __weak typeof(self) weakSelf = self;
        [mySlcomposerView setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch (result)
             {
                 case SLComposeViewControllerResultDone:
                     
                     [weakSelf showAlertWithMessage:@"Posted Successfully" Title:@"GroupsNearMe"];
                     break;
                     
                 case SLComposeViewControllerResultCancelled:
                     break;
                 default:
                     break;
             }
         }];
        if ([mySlcomposerView respondsToSelector:@selector(popoverPresentationController)])
        {
            // iOS 8+
            [self  presentViewController:mySlcomposerView animated:YES completion:nil];
            // if button or change to self.view.
        }
        
        
        
    }
    else
    {
        [self showAlertWithMessage:@"You must configure Twitter account for sharing.You can add or create a Facebook/Twitter account in Settings." Title:@"GroupsNearMe"];
    }
}



-(void)whatsAppShareSelected:(UIImage*)imageUrl
{
    
    NSLog(@"Whats app Sharing Selected");
    if ([MFMessageComposeViewController canSendText]) {
        if (![WhatsAppKit isWhatsAppInstalled]) {
            [self showAlertWithMessage:@"You must configure WhatsApp account for sharing." Title:@"GroupsNearMe"];
        }
        else
        {
            
            
            NSURL *instagramURL = [NSURL URLWithString:@"whatsapp://app"];
            
            if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                
                
                UIImage *image = imageUrl;
                
                
                
                CGRect contextRect  = CGRectMake(0, 0, 0, 0);// whatever you need
                
                NSData *data = UIImageJPEGRepresentation(image, 0.75);
                NSString  *jpgPath = [NSHomeDirectory()
                                      stringByAppendingPathComponent:@"Documents/image.wai"];
                [data writeToFile:jpgPath atomically:YES];
                
                NSURL *igImageHookFile = [NSURL fileURLWithPath:jpgPath];
                
                self.documentationInteractionController = [self setupControllerWithURL:igImageHookFile
                                                                         usingDelegate:self];
                self.documentationInteractionController=[UIDocumentInteractionController
                                                         interactionControllerWithURL:igImageHookFile];
                self.documentationInteractionController.UTI = @"net.whatsapp.image";
                [self.documentationInteractionController presentOpenInMenuFromRect: contextRect    inView:
                 self.view animated: YES ];
            }
            else
            {
                [self showAlertWithMessage:@"You must configure WhatsApp account for sharing." Title:@"GroupsNearMe"];
            }
            
            
            
            
        }
    }
    else
    {
        [self showAlertWithMessage:@"WhatsApp Feature is not applicable." Title:@"GroupsNearMe"];
    }
}
- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController
                                                              interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

-(void)mailShareSelected
{
    
    [self showComposer:self];
}
-(void)showComposer:(id)sender
{
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil){
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail]){
            [self displayComposerSheet:sender];
        }else{
            [self launchMailAppOnDevice:sender];
        }
    }else{
        [self launchMailAppOnDevice:sender];
    }
}
- (void) displayComposerSheet:(id)body
{
    MFMailComposeViewController *mailAttachment = [[MFMailComposeViewController alloc] init] ;
    [mailAttachment.navigationBar setBarStyle:UIBarStyleBlack];
    [mailAttachment setSubject:@"From Chatterati"];
    mailAttachment.mailComposeDelegate = self;
    
    UIImage *coolImage = _fullgroupimage.image;
    UIImage * tmpImag = [UIImage imageWithCGImage: coolImage.CGImage
                                            scale: coolImage.scale
                                      orientation: coolImage.imageOrientation];
    
    //...do physical rotation, if needed
    
    UIImage *ImgOut = [self scaleAndRotateImage: tmpImag];
    
    //...note orientation is UIImageOrientationUp now
    
    NSData * imageAsNSData = UIImageJPEGRepresentation( ImgOut, 0.9f );
    
    
    
    [mailAttachment addAttachmentData:imageAsNSData mimeType:@"image/png" fileName:@"coolImage.png"];
    
    
    [mailAttachment setMessageBody:[NSString stringWithFormat:@"<br><br><br> <br><br> -- Chatterati"] isHTML:YES];
    
    
    
    
    
    //CHECK SOURCE
    [mailAttachment setToRecipients:[NSArray arrayWithObjects:@"", nil]];
    [self presentViewController:mailAttachment animated:YES completion:nil];
    //[self presentModalViewController:mailAttachment animated:YES];
}
- (UIImage *) scaleAndRotateImage: (UIImage *) imageIn
//...thx: http://blog.logichigh.com/2008/06/05/uiimage-fix/
{
    int kMaxResolution = 3264; // Or whatever
    
    CGImageRef        imgRef    = imageIn.CGImage;
    CGFloat           width     = CGImageGetWidth(imgRef);
    CGFloat           height    = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect            bounds    = CGRectMake( 0, 0, width, height );
    
    if ( width > kMaxResolution || height > kMaxResolution )
    {
        CGFloat ratio = width/height;
        
        if (ratio > 1)
        {
            bounds.size.width  = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else
        {
            bounds.size.height = kMaxResolution;
            bounds.size.width  = bounds.size.height * ratio;
        }
    }
    
    CGFloat            scaleRatio   = bounds.size.width / width;
    CGSize             imageSize    = CGSizeMake( CGImageGetWidth(imgRef),         CGImageGetHeight(imgRef) );
    UIImageOrientation orient       = imageIn.imageOrientation;
    CGFloat            boundHeight;
    
    switch(orient)
    {
        case UIImageOrientationUp:                                        //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:                                //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:                                      //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:                              //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:                              //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:                                      //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:                             //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:                                     //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise: NSInternalInconsistencyException
                        format: @"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext( bounds.size );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( orient == UIImageOrientationRight || orient == UIImageOrientationLeft )
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM( context, transform );
    
    CGContextDrawImage( UIGraphicsGetCurrentContext(), CGRectMake( 0, 0, width, height ), imgRef );
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return( imageCopy );
}
#pragma mark -MFMail View Controller Delegate Methods
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    if (error) {
        [self  dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self  dismissViewControllerAnimated:YES completion:nil];
}



// Launches the Mail application on the device. Workaround
-(void)launchMailAppOnDevice:(NSString *)body{
    NSString *recipients = [NSString stringWithFormat:@"mailto: %@?cc=%@&subject", @"", @""];
    //get file path
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"application.log"];
    
    //read the whole file as a single string
    NSString *contentHistory = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    
    NSString *mailBody = [NSString stringWithFormat:@"&body=%@",contentHistory];
    
    NSString *email = [NSString stringWithFormat:@"%@%@",recipients,mailBody ];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


@end
