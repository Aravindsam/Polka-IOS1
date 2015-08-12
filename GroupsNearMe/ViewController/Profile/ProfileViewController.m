//
//  ProfileViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/13/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "UIImage+BlurredFrame.h"
#import "SVProgressHud.h"
#import "Toast+UIView.h"
#import "WhatsAppKit.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "KxMenu.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    ProfileId=[[NSString alloc]init];
    _fullimageview.hidden=YES;
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    _headerview.backgroundColor=[Generic colorFromRGBHexString:headerColor];
   // _updatebtn.backgroundColor=[Generic colorFromRGBHexString:headerColor];
    _nameTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _nameTextfield.layer.borderWidth=0.5;
    _nameTextfield.layer.cornerRadius=2.0;
    _nameTextfield.clipsToBounds=YES;
    _nameTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);

    [_ProfileImageview setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapgestur=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showfullImage)];
    tapgestur.numberOfTapsRequired=1;
    [_ProfileImageview addGestureRecognizer:tapgestur];
    
    
    genderval=[[NSString alloc]init];
    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    sharedObj.AccountGender=[[NSUserDefaults standardUserDefaults]objectForKey:@"Gender"];
    sharedObj.profileImage=[[NSUserDefaults standardUserDefaults]objectForKey:@"ProfilePicture"];
    sharedObj.NameCount=[[NSUserDefaults standardUserDefaults]objectForKey:@"NameCount"];
    sharedObj.pushnotificaion=[[NSUserDefaults standardUserDefaults]boolForKey:@"PushNotification"];
    sharedObj.soundnotification=[[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationGrp"];
    
    /*UIGraphicsBeginImageContext(CGSizeMake(320, 35));
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
    
    _footerlabel.backgroundColor = [UIColor colorWithPatternImage:resultingImage];*/
    
        PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
        [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
        [query fromLocalDatastore];
        [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if (error) {
            }
            else{
                ProfileId=object.objectId;
                imageFile =[object objectForKey:@"ProfilePicture"];
                
                [[NSUserDefaults standardUserDefaults]setObject:imageFile.url forKey:@"ProfilePicture"];
                
                _ProfileImageview.file=imageFile;
                _profilefullimgview.file=imageFile;
                [_ProfileImageview loadInBackground];
                _ProfileImageview.contentMode = UIViewContentModeScaleAspectFill;
                _ProfileImageview.clipsToBounds = YES;
                
                
                _nameTextfield.text=[object objectForKey:@"UserName"];
                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"UserName"] forKey:@"UserName"];
                
                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"CountryName"] forKey:@"CountryName"];
                
                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"MobileNo"] forKey:@"MobileNo"];
                
                
                
                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"Gender"]  forKey:@"Gender"];
                               genderval=[[NSUserDefaults standardUserDefaults]objectForKey:@"Gender"];
                int countval=3-[[object objectForKey:@"NameChangeCount"]intValue];
                _nameCountLabel.text=[NSString stringWithFormat:@"Name can be changed only 3 times \nYou have %d attempts left",countval];
                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"NameChangeCount"] forKey:@"NameCount"];
                
              
                push=[[object objectForKey:@"PushNotification"]boolValue];
                
                sound=[[object objectForKey:@"NotificationSound"]boolValue];
                
                [[NSUserDefaults standardUserDefaults]setBool:sound forKey:@"NotificationGrp"];
                [[NSUserDefaults standardUserDefaults]setBool:push forKey:@"PushNotification"];
                if ([[object objectForKey:@"NameChangeCount"]integerValue]>=3) {
                    _nameTextfield.userInteractionEnabled=NO;
                }
                else
                {
                    _nameTextfield.userInteractionEnabled=YES;
                }
                sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
                sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
                sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
                sharedObj.AccountGender=[[NSUserDefaults standardUserDefaults]objectForKey:@"Gender"];
                sharedObj.profileImage=[[NSUserDefaults standardUserDefaults]objectForKey:@"ProfilePicture"];
                sharedObj.NameCount=[[NSUserDefaults standardUserDefaults]objectForKey:@"NameCount"];
                sharedObj.pushnotificaion=[[NSUserDefaults standardUserDefaults]boolForKey:@"PushNotification"];
                sharedObj.soundnotification=[[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationGrp"];
                
               
                
                
             
               
          
                

                
            }
        }];
        
        
        // Do any additional setup after loading the view.
}
-(void)showfullImage
{
    NSLog(@"DISPLAY");
    _fullimageview.hidden=NO;
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


-(void)getimagefromgallery{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]==YES)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}
-(void)getimagefromcamera{
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]==YES)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        imagePicker.showsCameraControls = YES;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
        newMedia = YES;
    }
    
    
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
   
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
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
    image = croppedImage;
    _ProfileImageview.image = croppedImage;
    _profilefullimgview.image=croppedImage;
    
    
    
   
      [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [controller dismissViewControllerAnimated:YES completion:NULL];
   
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    _ProfileImageview.image = image;
    _profilefullimgview.image=image;
   

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}




-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
}
-(void)showAlert:(NSString*)text{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (IBAction)updateProfile:(id)sender {
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
    profilename=_nameTextfield.text;
    profilename=[profilename capitalizedString];
    profilename=[profilename stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceCharacterSet]];
    if (profilename == NULL || profilename.length ==0) {
        [self showAlert:@"Enter your name "];
        [_nameTextfield becomeFirstResponder];
        return ;
    }
    _nameTextfield.text=profilename;

    
    
    [SVProgressHUD showWithStatus:@"Updating Profile ....." maskType:SVProgressHUDMaskTypeBlack];
    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:ProfileId block:^(PFObject *gameScore, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
        }
        else
        {
              NSData* data = UIImageJPEGRepresentation(_ProfileImageview.image, 0.8f);
             PFFile *imageFile1 = [PFFile fileWithName:@"profile.png" data:data];
    
            
                if ([profilename isEqualToString:sharedObj.AccountName]) {
                    gameScore[@"NameChangeCount"]=sharedObj.NameCount;
                    gameScore[@"UpdateName"]=[NSNumber numberWithBool:NO];

                }
                else
                {
                    [gameScore incrementKey:@"NameChangeCount" byAmount:[NSNumber numberWithInt:1]];
                    gameScore[@"UpdateName"]=[NSNumber numberWithBool:YES];

                }
                gameScore[@"UpdateImage"]=[NSNumber numberWithBool:YES];

                gameScore[@"ProfilePicture"] = imageFile1;
                gameScore[@"UserName"]=profilename;
                [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                     
                         [SVProgressHUD showWithStatus:@"Profile Updated Successfully ....." maskType:SVProgressHUDMaskTypeBlack];
                        PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
                        [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                        [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
                        
                        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                            if (error) {
                                [SVProgressHUD dismiss];
                            }
                            else{
                                  [SVProgressHUD dismiss];
                                  [PFObject unpinAllObjectsInBackgroundWithName:@"USERDETAILS"];
                                [object pinInBackgroundWithName:@"USERDETAILS"];
                                ProfileId=object.objectId;
                                imageFile =[object objectForKey:@"ProfilePicture"];
                                
                                _ProfileImageview.file=imageFile;
                                _profilefullimgview.file=imageFile;
                                [_ProfileImageview loadInBackground];
                                [[NSUserDefaults standardUserDefaults]setObject:imageFile.url forKey:@"ProfilePicture"];
                                
                                _nameTextfield.text=[object objectForKey:@"UserName"];
                                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"UserName"] forKey:@"UserName"];
                                
                                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"CountryName"] forKey:@"CountryName"];
                                
                                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"MobileNo"] forKey:@"MobileNo"];
                                
                                
                                
                                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"Gender"]  forKey:@"Gender"];
                                genderval=[[NSUserDefaults standardUserDefaults]objectForKey:@"Gender"];
                                
                                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"NameChangeCount"] forKey:@"NameCount"];
                                [[NSUserDefaults standardUserDefaults]setObject:object[@"Badgepoint"] forKey:@"BadgePoint"];
                                [[NSUserDefaults standardUserDefaults]setObject:object[@"UserState"] forKey:@"UserState"];
                                                               push=[[object objectForKey:@"PushNotification"]boolValue];
                                
                                sound=[[object objectForKey:@"NotificationSound"]boolValue];
                                [[NSUserDefaults standardUserDefaults]setObject:object[@"GroupInvitation"] forKey:@"GroupInvite"];
                                [[NSUserDefaults standardUserDefaults]setObject:object[@"MyGroupArray"] forKey:@"MyGroup"];
                                [[NSUserDefaults standardUserDefaults]setObject:object[@"MuteGroupArray"] forKey:@"MuteGroup"];
                                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"NotificationSound"] forKey:@"NotificationGrp"];
                                [[NSUserDefaults standardUserDefaults]setObject:[object objectForKey:@"PushNotification"] forKey:@"PushNotification"];
                                if ([[object objectForKey:@"NameChangeCount"]integerValue]>=3) {
                                    _nameTextfield.userInteractionEnabled=NO;
                                }
                                else
                                {
                                    _nameTextfield.userInteractionEnabled=YES;
                                }
                                int countval=3-[[object objectForKey:@"NameChangeCount"]intValue];
                                _nameCountLabel.text=[NSString stringWithFormat:@"Name can be changed only 3 times. \nYou have %d attempts left",countval];
                                sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
                                sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
                                sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
                                sharedObj.AccountGender=[[NSUserDefaults standardUserDefaults]objectForKey:@"Gender"];
                                sharedObj.profileImage=[[NSUserDefaults standardUserDefaults]objectForKey:@"ProfilePicture"];
                                sharedObj.NameCount=[[NSUserDefaults standardUserDefaults]objectForKey:@"NameCount"];
                                sharedObj.pushnotificaion=[[NSUserDefaults standardUserDefaults]boolForKey:@"PushNotification"];
                                sharedObj.soundnotification=[[NSUserDefaults standardUserDefaults]boolForKey:@"NotificationGrp"];
                                
                            }
                           
                        }];

                        
                    }
                    else
                    {
                           [SVProgressHUD dismiss];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Service unavailable please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                        return;
                    }
                    
                }];
            
        }
    }];
        }
        
    
    
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
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)back:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CALLHOME" object:nil];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATE PROFILE" object:nil];
//
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

- (IBAction)uploadimg:(id)sender {
    [self chooseImage];
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
        
            [self fbShareBtnSelected:_profilefullimgview.image];
            
       
        
    }
    else if ([sender.title isEqualToString:@"Twitter"])
    {
        
            [self twitterShareSelected:_profilefullimgview.image];
        
    }
    else if([sender.title isEqualToString:@"WhatsApp"])
    {
        
        
            [self whatsAppShareSelected:_profilefullimgview.image];
       
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
    
        UIImage *coolImage = _profilefullimgview.image;
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



- (IBAction)close:(id)sender {
     _fullimageview.hidden=YES;
}
@end
