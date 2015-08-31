//
//  RegisterViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "TermsViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    _headerlabel.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    humanizedType = NSDateHumanizedSuffixAgo;

    _nameTextfield.autocapitalizationType=UITextAutocapitalizationTypeWords;
    sharedObj=[Generic sharedMySingleton];
    name=[[NSString alloc]init];
    gender=[[NSString alloc]init];
    email=[[NSString alloc]init];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    _nameTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    _emailTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);

    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Terms of Service"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    _termlabel.attributedText = [attributeString copy];
    _termlabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *singletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(termService)];
    singletap.numberOfTapsRequired=1.0;
    [_termlabel addGestureRecognizer:singletap];
 
    
    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:@"Privacy Policy"];
    [attributeString1 addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString1 length]}];
    _privacylabel.attributedText = [attributeString1 copy];
    _privacylabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *singletap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(privacyPolicy)];
    singletap1.numberOfTapsRequired=1.0;
    [_privacylabel addGestureRecognizer:singletap1];
    
    
  
    [_backgroundimageview setUserInteractionEnabled:YES];
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    

    
    _nameTextfield.layer.cornerRadius = 5;
    _nameTextfield.clipsToBounds = YES;
    
    _nameTextfield.layer.borderWidth=1.0;
    _nameTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    
    _emailTextfield.layer.cornerRadius = 5;
    _emailTextfield.clipsToBounds = YES;
    
    _emailTextfield.layer.borderWidth=1.0;
    _emailTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    imagePicker = [[UIImagePickerController alloc] init];
  
    
    UITapGestureRecognizer *tapgestur1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseImage)];
    tapgestur1.numberOfTapsRequired=1;
    [_backgroundimageview addGestureRecognizer:tapgestur1];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _registerScrollView.contentSize=CGSizeMake(_registerScrollView.frame.size.width, [self findViewHeight:_donebtn.frame]);

    // Do any additional setup after loading the view.
}
-(void)termService
{
    sharedObj.fromRegister=YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    TermsViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    settingsViewController.headerTitle=@"Terms of Service";
    settingsViewController.UrlString=@"http://groupsnearme.com/Registration/TermsOfUseMobile";
    [[self navigationController]pushViewController:settingsViewController animated:YES];
}
-(void)privacyPolicy
{
    sharedObj.fromRegister=YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
    settingsViewController.headerTitle=@"Privacy Policy";
    settingsViewController.UrlString=@"http://groupsnearme.com/Registration/PrivacyPolicyMobile";
    [[self navigationController]pushViewController:settingsViewController animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{[super viewWillAppear:animated];
       _registerScrollView.contentSize=CGSizeMake(_registerScrollView.frame.size.width, [self findViewHeight:_donebtn.frame]);
}
-(CGFloat)findViewHeight:(CGRect)sender
{
    CGFloat hgValue = sender.origin.y +sender.size.height;
    return hgValue;
}
-(void)keyboardWillShow:(id)sender
{
    
    _registerScrollView.contentSize=CGSizeMake(_registerScrollView.frame.size.width, [self findViewHeight:_donebtn.frame]+250);
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField==_nameTextfield) {
        [_registerScrollView setContentOffset:CGPointMake(0, 100) animated:YES];
        
    }
    if (textField==_emailTextfield) {
        [_registerScrollView setContentOffset:CGPointMake(0, 120) animated:YES];
        
    }
}
-(void)keyboardWillHide:(id)sender
{
       _registerScrollView.contentSize=CGSizeMake(_registerScrollView.frame.size.width, [self findViewHeight:_donebtn.frame]);
}
-(void)chooseImage
{
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
    else
    {
       
        
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
    _profileImageview.hidden=YES;
    _backgroundimageview.image=croppedImage;
    _backgroundimageview.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundimageview.clipsToBounds = YES;

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (_backgroundimageview.image!=nil) {
        _profileImageview.hidden=YES;
        
    }
    else
        _profileImageview.hidden=NO;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}




-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
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
    
    if (textField== _nameTextfield) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length>20) {
            return NO;
        }
        
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        return YES;
    }
    
    return NO;
}
- (IBAction)gotowelcome:(id)sender {
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{

    name=_nameTextfield.text;
    name=[name capitalizedString];
    name=[name stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceCharacterSet]];
    gender=[gender stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceCharacterSet]];
    email=_emailTextfield.text;
    email=[email stringByTrimmingCharactersInSet:
           [NSCharacterSet whitespaceCharacterSet]];
   

    if (name == NULL || name.length ==0) {
        [SVProgressHUD dismiss];
        //[self showAlert:@"Please enter your name"];
         [self.view makeToast:@"Please enter your name" duration:3.0 position:@"bottom"];
        [_nameTextfield becomeFirstResponder];
        return ;
    }
    if (gender == NULL || gender.length ==0) {
        [SVProgressHUD dismiss];
        //[self showAlert:@"Choose your Gender"];
         [self.view makeToast:@"Choose your Gender" duration:3.0 position:@"bottom"];
        return ;
    }
    if (email == NULL || email.length ==0) {
       // [self showAlert:@"Please enter a valid email address"];
         [self.view makeToast:@"Please enter a valid email address" duration:3.0 position:@"bottom"];
        [_emailTextfield becomeFirstResponder];
        return ;
    }
    if (![self validateEmailWithString:email]) {
       // [self showAlert:@"Invalid email address"];
         [self.view makeToast:@"Invalid email address" duration:3.0 position:@"bottom"];
        [_emailTextfield becomeFirstResponder];
        return ;
    }
    if (_backgroundimageview.image==nil) {
        
        
         [self.view makeToast:@"Please upload a User image" duration:3.0 position:@"bottom"];
            return;
            
        }

    [SVProgressHUD showWithStatus:@"Please wait Registering..." maskType:SVProgressHUDMaskTypeBlack];
   NSData *imageData1 = [[NSData alloc] initWithData:UIImageJPEGRepresentation((_backgroundimageview.image), 1.0)];
    int imageSize = (int)imageData1.length;

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

     NSData* data = UIImageJPEGRepresentation(_backgroundimageview.image, compressionQuality);
    
        PFFile *imageFile = [PFFile fileWithName:@"Profile.jpg" data:data];
        UIImage *image1 = [UIImage imageWithData:data];
        
        PFFile *imgFile=[PFFile fileWithName:@"thumbuser.jpg" data:[self compressImage:image1]];
            PFObject *bigObject = [PFObject objectWithClassName:@"UserDetails"];
            bigObject[@"UserName"] = name;
            bigObject[@"CountryName"]=sharedObj.AccountCountry;
            bigObject[@"MobileNo"] = sharedObj.AccountNumber;
            bigObject[@"Gender"]=gender;
            bigObject[@"EmailId"]=email;
            bigObject[@"ProfilePicture"]=imageFile;
            bigObject[@"ThumbnailPicture"]=imgFile;

            bigObject[@"NameChangeCount"]=[NSNumber numberWithInt:0];
            bigObject[@"Badgepoint"]=[NSNumber numberWithInt:0];
            bigObject[@"UserState"]=@"Active";
            bigObject[@"PushNotification"]=[NSNumber numberWithBool:YES];
            bigObject[@"NotificationSound"]=[NSNumber numberWithBool:YES];
            bigObject[@"GroupInvitation"]=[[NSMutableArray alloc]init];
            bigObject[@"MyGroupArray"]=[[NSMutableArray alloc]init];
            bigObject[@"PostFlagCount"]=[NSNumber numberWithInt:0];
            bigObject[@"Suspended"]=[NSNumber numberWithBool:NO];
            bigObject[@"MuteGroupArray"]=[[NSMutableArray alloc]init];
            bigObject[@"UpdateImage"]=[NSNumber numberWithBool:NO];
            bigObject[@"UpdateName"]=[NSNumber numberWithBool:NO];
            //bigObject[@"Userthumbnail"]=thumbfile;
            [bigObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Saved");
                      [PFObject unpinAllObjectsInBackgroundWithName:@"USERDETAILS"];
                    [bigObject pinInBackgroundWithName:@"USERDETAILS"];
                   
                    [[NSUserDefaults standardUserDefaults]setObject:sharedObj.AccountNumber forKey:@"MobileNo"];
                    [[NSUserDefaults standardUserDefaults]setObject:sharedObj.AccountCountry forKey:@"Country"];
                    [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"UserName"];
                    [[NSUserDefaults standardUserDefaults]setObject:imageFile.url forKey:@"ProfilePicture"];
                    [[NSUserDefaults standardUserDefaults]setObject:0 forKey:@"NameCount"];
                    [[NSUserDefaults standardUserDefaults]setObject:0 forKey:@"BadgePoint"];
                    [[NSUserDefaults standardUserDefaults]setObject:@"Active" forKey:@"UserState"];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"PushNotification"];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotificationGrp"];
                    [[NSUserDefaults standardUserDefaults]setObject:[[NSMutableArray alloc]init] forKey:@"GroupInvite"];
                    [[NSUserDefaults standardUserDefaults]setObject:[[NSMutableArray alloc]init] forKey:@"MyGroup"];
                    [[NSUserDefaults standardUserDefaults]setObject:bigObject.objectId forKey:@"USERID"];
                    [SVProgressHUD dismiss];
                    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"Login"];
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    [currentInstallation setDeviceTokenFromData:sharedObj.deviceToken];
                    currentInstallation[@"MobileNo"]=sharedObj.AccountNumber;
                    [currentInstallation saveInBackground];
                   
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATE PROFILE" object:nil];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                    [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"Start"];
                    sharedObj.Starting=[[NSUserDefaults standardUserDefaults]objectForKey:@"Start"];
                    sharedObj.newUser=YES;
                    [[self navigationController]pushViewController:settingsViewController animated:YES];
                }
                else{
                    // Error
                    [SVProgressHUD dismiss];
               
                    [self.view makeToast:@"Account cannot be created.Please try again later" duration:3.0 position:@"bottom"];
                    return ;
                    
                }
            }];
        

    }
  
    
}
-(NSData *)compressImage:(UIImage *)imagedata{
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
    
    
    
    
    CGRect rect = CGRectMake(0.0, 0.0, 300.0, 300.0);
    UIGraphicsBeginImageContext(rect.size);
    [imagedata drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    return imageData;
}


- (BOOL)validateEmailWithString:(NSString*)emailstring
{     BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailstring];
    
 
}


- (IBAction)femalebtnClicked:(id)sender {
    [_nameTextfield resignFirstResponder];
    [_malebtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [_femalebtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];

    gender=@"Female";
}

- (IBAction)malebtnClicked:(id)sender {
      [_nameTextfield resignFirstResponder];
    [_malebtn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    [_femalebtn setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    gender=@"Male";
}
@end
