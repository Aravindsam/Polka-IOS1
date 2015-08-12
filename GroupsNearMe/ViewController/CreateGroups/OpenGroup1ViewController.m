//
//  OpenGroup1ViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/18/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "OpenGroup1ViewController.h"
#import "OpenGroup2ViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "UIImage+BlurredFrame.h"
#import "Toast+UIView.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface OpenGroup1ViewController ()

@end

@implementation OpenGroup1ViewController
@synthesize groupImageview;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    sharedObj=[Generic sharedMySingleton];
    _headerview.backgroundColor=[Generic colorFromRGBHexString:headerColor];
   // _nextbtn.backgroundColor=[Generic colorFromRGBHexString:headerColor];
    _groupnameTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    next=NO;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        //[locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    
    if (sharedObj.GroupName.length!=0) {
        _groupnameTextfield.text=sharedObj.GroupName;
    }
    if (sharedObj.groupdescription.length!=0) {
        _aboutTextview.text=sharedObj.groupdescription;
    }
      NSUInteger DataLength=[sharedObj.groupimageData length];
    if (DataLength!=0) {
        
        groupImageview.hidden=YES;
        UIImage *image1=[UIImage imageWithData:sharedObj.groupimageData];
        _backgroundImageView.image=image1;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;

    }
    else
    {
        groupImageview.hidden=NO;

    }
    
    
    groupDescription=[[NSString alloc]init];
 
    [_backgroundImageView setUserInteractionEnabled:YES];
    
    _headerview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _headerview.layer.borderWidth=0.5;
    
    _groupnameTextfield.layer.borderWidth=0.5;
    _groupnameTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _groupnameTextfield.layer.cornerRadius = 5;
    _groupnameTextfield.clipsToBounds = YES;
    
    _aboutTextview.editable=YES;
    _aboutTextview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _aboutTextview.layer.borderWidth=0.5;
    _aboutTextview.layer.cornerRadius=5.0;
    _aboutTextview.clipsToBounds = YES;
    


    UITapGestureRecognizer *tapgestur=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseImage)];
    tapgestur.numberOfTapsRequired=1;
    [_backgroundImageView addGestureRecognizer:tapgestur];
    imagePicker = [[UIImagePickerController alloc] init];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSomething)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _publicScrollView.contentSize=CGSizeMake(_publicScrollView.frame.size.width, [self findViewHeight:_publicView.frame]);
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
-(void)getGroupinLocation
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    next=NO;
    _publicScrollView.contentSize=CGSizeMake(_publicScrollView.frame.size.width, [self findViewHeight:_publicView.frame]);
}
-(void)doSomething
{
    _publicScrollView.contentSize=CGSizeMake(_publicScrollView.frame.size.width, [self findViewHeight:_publicView.frame]);
}
#pragma mark - CLLocationManagerDelegate
-(void)keyboardWillShow:(id)sender
{
    
    _publicScrollView.contentSize=CGSizeMake(_publicScrollView.frame.size.width, [self findViewHeight:_publicView.frame]+220);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_publicScrollView setContentOffset:CGPointMake(0, 140)];
}
-(void)keyboardWillHide:(id)sender
{
    _publicScrollView.contentSize=CGSizeMake(_publicScrollView.frame.size.width, [self findViewHeight:_publicView.frame]);
}
-(CGFloat)findViewHeight:(CGRect)sender
{
    CGFloat hgValue = sender.origin.y +sender.size.height;
    return hgValue;
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

     groupImageview.hidden=YES;
    _backgroundImageView.image=croppedImage;
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageView.clipsToBounds = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (_backgroundImageView.image!=nil) {
        groupImageview.hidden=YES;

    }
    else
        groupImageview.hidden=NO;

  
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
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


-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error){
        [self showAlert:@"Failed to save image"];
    }
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

-(void)showAlert:(NSString*)text{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
- (IBAction)back:(id)sender {
    
    sharedObj.groupimageData=nil;
    sharedObj.aboutGroup=nil;
    sharedObj.groupLocation=nil;
    sharedObj.radiusVisibilityVal=0;
    sharedObj.GroupName=nil;
    
    [[self navigationController]popViewControllerAnimated:YES];
}
- (IBAction)nextbtnClicked:(id)sender {
    if (next) {
        return;
    }
    else{
        next=YES;
    }
    groupname=_groupnameTextfield.text;
    groupname=[groupname capitalizedString];
    groupname=[groupname stringByTrimmingCharactersInSet:
               [NSCharacterSet whitespaceCharacterSet]];
    if (groupname == NULL || groupname.length ==0) {
        next=NO;
        [self showAlert:@"Please enter group name"];
        [_groupnameTextfield becomeFirstResponder];
        
        return ;
    }
    sharedObj.GroupName=groupname;
    groupDescription=_aboutTextview.text;
    
    if (groupDescription.length==0) {
         next=NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please write a description for your group"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (_backgroundImageView.image==nil) {
         next=NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please upload a group image"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"GroupName" equalTo:groupname];
    [query whereKey:@"GroupLocation" nearGeoPoint:point withinMiles:0.310686];
    [query whereKey:@"GroupStatus" equalTo:@"Active"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (error) {
        }
        else{
            
            
            if (objects.count!=0) {
                 next=NO;
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
                sharedObj.GroupName=groupname;
                sharedObj.groupdescription=groupDescription;
                sharedObj.groupimageData=groupImageData;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                OpenGroup2ViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"OpenGroup2ViewController"];
                [[self navigationController]pushViewController:settingsViewController animated:YES];
            }
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

@end
