//
//  FeedViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/20/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "PostTableViewController.h"
#import "UIImage+ResizeAdditions.h"
#import "Toast+UIView.h"
 #import <QuartzCore/QuartzCore.h>
#import "ISO8601DateFormatter.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface FeedViewController ()<PostTableViewControllerDataSource>

@property (nonatomic, strong) PostTableViewController *wallPostsTableViewController;

@end

@implementation FeedViewController
@synthesize point;
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    
     sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
      sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    _flagView.hidden=YES;
    _newpostView.hidden=YES;
    _insideView.layer.cornerRadius=2.5;
    _insideView.clipsToBounds=YES;
    
    _okbtn.layer.cornerRadius=5.0;
    _okbtn.clipsToBounds=YES;
    
    _cancellbtn.layer.cornerRadius=5.0;
    _cancellbtn.clipsToBounds=YES;
    _newpostbtn.userInteractionEnabled=NO;
    _newpostView.backgroundColor=[UIColor clearColor];
  
    
    update=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updatepost)];
    update.numberOfTapsRequired=1;
    [_newpostView addGestureRecognizer:update];
    
//    _newpostbtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    _newpostbtn.layer.shadowOpacity = 0.5;
//    _newpostbtn.layer.shadowRadius = 2;
//    _newpostbtn.layer.shadowOffset = CGSizeMake(0.0f,-1.0f);
   
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        // [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
   
    [self.view setFrame:sharedObj.feedViewFrame];
    [_postView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-48)];
     [_containerView setFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 48)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSomething)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doSomething) name:@"REFRESH" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shownewpost:) name:@"NEWPOST" object:nil] ;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFlag) name:@"SHOWFLAG" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissFlag) name:@"DISMISSFLAG" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postWasCreated:) name:@"PostCreated" object:nil];
 

  
   [self loadWallPostsTableViewController];
   
       // Do any additional setup after loading the view.
}
-(void)showFlag
{
 
        [self.view bringSubviewToFront:_flagView];
        _flagView.hidden=NO;
    
   
}
-(void)dismissFlag
{
    _flagView.hidden=YES;
}
-(void)shownewpost:(NSNotification *) notification
{
    _newpostView.hidden=NO;
  //  NSDictionary *userInfo = notification.userInfo;
  //  NSString* myObject = [[userInfo objectForKey:@"COUNT"]stringValue];
   
         [_newpostbtn setTitle:@"NEW POSTS" forState:UIControlStateNormal];
     
}
-(void)doSomething
{
    [textView1 resignFirstResponder];
    [self.view setFrame:sharedObj.feedViewFrame];
   [_postView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,self.view.frame.size.width, self.view.frame.size.height-48)];
    [_containerView setFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 48)];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];

        [textView1 resignFirstResponder];
    [self.view setFrame:sharedObj.feedViewFrame];
    [_postView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-48)];
     [_containerView setFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 48)];
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
-(void)postWasCreated:(NSNotification *)note {
}

-(void)resignTextView
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DISMISSMENU" object:nil];

    NSString*temptext=textView1.text;
    temptext=[temptext stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceCharacterSet]];
    temptext= [temptext stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (temptext.length!=0) {
        //BOOL internetconnect=[sharedObj connected];
        
//        if (!internetconnect) {
//            [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
//            
//        }
//        else{
            if ([sharedObj.groupType isEqualToString:@"Public"]) {
                NSError *error = nil;
                NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                                           error:&error];
                
                NSUInteger matchCount = [detector numberOfMatchesInString:textView1.text
                                                                  options:0
                                                                    range:NSMakeRange(0, textView1.text.length)];
                if (matchCount>0) {
                    [self.view makeToast:@"You cannot post links in this group" duration:3.0 position:@"bottom"];
                }
                else
                {
                 [self addtextFeed:textView1.text];
                }
            }
            else{
            
        [self addtextFeed:textView1.text];
            }
        textView1.text=@"";
        }
//    }
    textView1.text=@"";
   [textView1 resignFirstResponder];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DISMISSMENU" object:nil];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.postView convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = _containerView.frame;
    containerFrame.origin.y = self.postView.bounds.size.height - keyboardBounds.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _containerView.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
    
      _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, [self findViewHeight:_scrollView.frame]+200);
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = _containerView.frame;
    containerFrame.origin.y = self.postView.bounds.size.height ;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, [self findViewHeight:_scrollView.frame]-20);
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = _containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    _containerView.frame = r;
}


- (void)loadWallPostsTableViewController {
    // Add the wall posts tableview as a subview with view containment (new in iOS 5.0):
    internetConnected =  [sharedObj connected];
    self.wallPostsTableViewController = [[PostTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    
    self.wallPostsTableViewController.dataSource = self;
    [self.postView addSubview:self.wallPostsTableViewController.view];
    [self addChildViewController:self.wallPostsTableViewController];
    [self.wallPostsTableViewController didMoveToParentViewController:self];
    
    
    
    
   
    
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if ([sharedObj.groupType isEqualToString:@"Public"]) {
        textView1 = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 8, 230, 40)];
         doneBtn.frame = CGRectMake(245,11, 60, 28);
    }
    else{
        textView1 = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(42, 8, 200, 40)];
        
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(5, 11, 30, 30);
        [cameraBtn addTarget:self action:@selector(choosePicture) forControlEvents:UIControlEventTouchUpInside];
        [cameraBtn setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
        cameraBtn.alpha=0.6;
        [_containerView addSubview:cameraBtn];
         doneBtn.frame = CGRectMake(250,11, 60, 28);
    }
   
    textView1.isScrollable = NO;
    textView1.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView1.minNumberOfLines = 1;
    textView1.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView1.returnKeyType = UIReturnKeyDefault; //just as an example
    textView1.font = [UIFont systemFontOfSize:15.0f];
    textView1.delegate = self;
    textView1.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView1.textColor=[UIColor lightGrayColor];
    textView1.backgroundColor = [UIColor whiteColor];
    textView1.placeholder = @"Write your message here...";
    textView1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textView1.layer.borderWidth=0.5;
    textView1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    textView1.editable=YES;
    
    [_containerView addSubview:textView1];
    [doneBtn setTitle:@"POST" forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14.0f];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:[UIColor colorWithRed:2.0/255.0 green:105/255.0 blue:153/255.0 alpha:1.0]];
    [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    
    [_containerView addSubview:doneBtn];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
-(void)choosePicture
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DISMISSMENU" object:nil];
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{

    UIAlertView *ImageAlert = [[UIAlertView alloc]
                               initWithTitle:@"Choose Picture From"
                               message:@""
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:@"Photo Gallery", @"Take Photo", nil];
    ImageAlert.tag=11;
    [ImageAlert show];
    }
}
-(void)getimagefromgallery{
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    }
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;

        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate.navigationController presentViewController:cameraUI animated:YES completion:nil];
    }
-(void)getimagefromcamera{
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;

        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate.navigationController presentViewController:cameraUI animated:YES completion:nil];
        newMedia = YES;
   
    
    
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate.navigationController dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
   
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
       feedimage = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
//        UIImage *resizedImage = [feedimage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(feedimage,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
        
        viewcontroller = [[UIViewController alloc]init];
        [viewcontroller.view setBackgroundColor:[UIColor blackColor]];
    
    
        
//        addCaption.placeholder=@"Add caption to the image...";
        
        //CGSize imagesize=image.size;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, viewcontroller.view.frame.size.width,viewcontroller.view.frame.size.height-20)];
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor =[UIColor blackColor];
        [viewcontroller.view  addSubview: self.scrollView];
        
        photoImageView = [[UIImageView alloc] init];
      
        if (feedimage.size.height > feedimage.size.width) {
             photoImageView.frame=CGRectMake(0.0f, 0.0f, self.scrollView.frame.size.width,self.scrollView.frame.size.height-60);
        }
        else if (feedimage.size.height == feedimage.size.width)
        {
          photoImageView.frame=CGRectMake(0.0f,((self.scrollView.frame.size.height-60)/2) -160, self.scrollView.frame.size.width,320);
        }
        else
        {
             photoImageView.frame=CGRectMake(0.0f,((self.scrollView.frame.size.height-60)/2) -140, self.scrollView.frame.size.width,280);
        }
       
        
        [photoImageView setBackgroundColor:[UIColor clearColor]];
        [photoImageView setImage:feedimage];
       // [photoImageView setContentMode:UIViewContentModeScaleAspectFill];
        
        [self.scrollView addSubview:photoImageView];
        
        backgroundview=[[UIView alloc]init];
        backgroundview.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        backgroundview.frame=CGRectMake(0, self.scrollView.frame.size.height-220 , self.scrollView.frame.size.width, 220);
        [self.scrollView addSubview:backgroundview];
        
        addCaption=[[UITextView alloc]initWithFrame:CGRectMake(10,self.scrollView.frame.size.height-180 , self.scrollView.frame.size.width-20, 100)];
        addCaption.textColor=[UIColor whiteColor];
        addCaption.layer.borderColor=[UIColor clearColor].CGColor;
        addCaption.layer.borderWidth=0.5;
        addCaption.backgroundColor=[UIColor clearColor];
         addCaption.tintColor=[UIColor whiteColor];
        addCaption.textAlignment=NSTextAlignmentLeft;
        addCaption.font=[UIFont fontWithName:@"Lato-Medium" size:16.0];
        addCaption.layer.cornerRadius=5;
        [addCaption setReturnKeyType:UIReturnKeyDone];
        [addCaption setText:@"Say something about this photo..."];
        [addCaption setClipsToBounds:YES];
        addCaption.delegate=self;
        [addCaption.layer addSublayer:[self addBottomBorderWithBorderHeight:1 atHeight:addCaption.frame.size.height withBorderWidth:addCaption.frame.size.width withColor:@"black"]];
        
//        [addCaption.layer addSublayer:[self addLeftBorderWithWidth:1 andHeight:addCaption.frame.size.height withColor:@"black"]];
//        
//        [addCaption.layer addSublayer:[self addRightBorderWithWidth:1 atWidth:addCaption.frame.size.width borderHeight:addCaption.frame.size.height withColor:@"black"]];
        [self.scrollView addSubview:addCaption];

        cancelbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        cancelbtn.frame=CGRectMake(10, self.scrollView.frame.size.height-50, 40, 40);
        [cancelbtn setImage:[UIImage imageNamed:@"new_cross.png"] forState:UIControlStateNormal];
       

        [self.scrollView addSubview:cancelbtn];
        
        sendbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sendbtn.frame=CGRectMake(self.scrollView.frame.size.width-50, self.scrollView.frame.size.height-50,40, 40);
        [sendbtn setImage:[UIImage imageNamed:@"new_tick.png"] forState:UIControlStateNormal];
        [sendbtn addTarget:self action:@selector(sendPost) forControlEvents:UIControlEventTouchUpInside];
       
        [self.scrollView addSubview:sendbtn];
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
       
         [delegate.navigationController presentViewController:viewcontroller animated:YES completion:^{
            
        }];
    }


    
}

#pragma mark - Border Created Methods

- (CALayer*)addBottomBorderWithBorderHeight:(CGFloat) borderHeight atHeight:(CGFloat)atHeight withBorderWidth:(CGFloat)borderwidth withColor:(NSString *)colorString
{
    CALayer *border = [CALayer layer];
    //    border.backgroundColor = [UIColor colorWithRed:107/255.0 green:193/255.0 blue:211/255.0 alpha:1].CGColor;
    
    border.backgroundColor= [UIColor whiteColor].CGColor;
        border.shadowColor = [UIColor whiteColor].CGColor;
        border.frame = CGRectMake(0, 99, borderwidth, borderHeight);
   
    
    
    
    //    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:border.bounds];
    //    border.masksToBounds = NO;
    //
    //    border.shadowOffset = CGSizeMake(0.0f, 1.0f);
    //    border.shadowOpacity = 0.5f;
    //    border.shadowPath = shadowPath.CGPath;
    
    return border;
}

- (CALayer *)addLeftBorderWithWidth:(CGFloat)borderWidth andHeight:(CGFloat)borderHeight withColor:(NSString *)colorString
{
    CALayer *border = [CALayer layer];
   
    border.backgroundColor=[Generic colorFromRGBHexString:headerColor].CGColor;
        border.frame = CGRectMake(0,borderHeight-20, 1, 20);
   
    
    return border;
    //    [self.layer addSublayer:border];
}

- (CALayer*)addRightBorderWithWidth:(CGFloat)borderWidth atWidth:(CGFloat)atWidth borderHeight:(CGFloat)borderHeight withColor:(NSString *)colorString
{
    CALayer *border = [CALayer layer];
    //    border.backgroundColor = [UIColor colorWithRed:107/255.0 green:193/255.0 blue:211/255.0 alpha:1].CGColor;
 
    border.backgroundColor=[Generic colorFromRGBHexString:headerColor].CGColor;
        border.frame = CGRectMake(atWidth-borderWidth, borderHeight-20, borderWidth, 20);
    
    
    return border;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Say something about this photo...";
        [textView resignFirstResponder];
    }
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (addCaption.textColor == [UIColor lightGrayColor]) {
        addCaption.text = @"";
        addCaption.textColor = [UIColor whiteColor];
    }
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text=@"";
    [_scrollView setContentOffset:CGPointMake(0, 170)];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(textView.text.length == 0){
            textView.textColor = [UIColor lightGrayColor];
            textView.text = @"Say something about this photo...";
            [textView resignFirstResponder];
        }
        return NO;
    }
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([newString length]>100) {
        return NO;
    }
    
    return YES;
}

-(CGFloat)findViewHeight:(CGRect)sender
{
    CGFloat hgValue = sender.origin.y +sender.size.height;
    return hgValue;
}
-(void)cancel
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    [delegate.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}
-(void)sendPost
{

   
  
    NSData* data = [self compressImage:feedimage];
  

    if ([addCaption.text isEqualToString:@"Say something about this photo..."]) {
          [self addFeed:data:@"" :@""];
    }
    else
    [self addFeed:data:addCaption.text :@""];
       
}

-(NSData *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    
    NSData *imageData1 = [[NSData alloc] initWithData:UIImageJPEGRepresentation((image), 1.0)];
    
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
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
     return  imageData;
}
-(NSData *)compressImage1:(UIImage *)imagedata{
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
    float actualHeight = imagedata.size.height;
    float actualWidth = imagedata.size.width;
    float maxHeight = 300.0;
    float maxWidth = 500.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    
    
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
    return imageData;
}

-(void)addtextFeed:(NSString*)textPost
{
    BOOL connected=[sharedObj connected];
    
    if (connected) {
        // [self.view makeToast:@"Posting" duration:3.0 position:@"bottom"];
[SVProgressHUD showWithStatus:@"Posting"];
    PFObject *postObject = [PFObject objectWithClassName:@"GroupFeed"];
    postObject[@"GroupId"]=sharedObj.GroupId;
    postObject[@"MobileNo"]=sharedObj.AccountNumber;
    postObject[@"PostType"]=@"Text";
    postObject[@"ImageWidth"]=[NSNumber numberWithInt:0];
    postObject[@"ImageHeight"]=[NSNumber numberWithInt:0];
    postObject[@"PostText"]=textPost;
    postObject[@"CommentCount"]=[NSNumber numberWithInt:0];
    postObject[@"PostPoint"]=[NSNumber numberWithInt:100];
    postObject[@"FlagCount"]=[NSNumber numberWithInt:0];
    postObject[@"LikeUserArray"]=[[NSMutableArray alloc]init];
    postObject[@"DisLikeUserArray"]=[[NSMutableArray alloc]init];
    postObject[@"FlagArray"]=[[NSMutableArray alloc]init];
    postObject[@"PostStatus"]=@"Active";
    postObject[@"FeedLocation"]=point;
        PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
         postObject[@"FeedupdatedAt"]=[NSDate date];
        postObject[@"UserId"]=pointer;
       
      


    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Couldn't save!");
            NSLog(@"%@", error);
                       [SVProgressHUD dismiss];
           [self.view makeToast:@"Unable to connect with server.Try again later" duration:3.0 position:@"bottom"];        }
        if (succeeded) {
            NSLog(@"ENTERED");
           
            //[postObject saveInBackground];
            NSArray *temp=[[NSArray alloc]initWithObjects:postObject, nil];
            [PFObject pinAllInBackground:temp withName:sharedObj.GroupId block:^(BOOL succeeded, NSError *error) {
                
                [self.wallPostsTableViewController postWasCreated];
                }];
            PFQuery *ownerquery=[PFQuery queryWithClassName:@"UserDetails"];
            [ownerquery whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
            [ownerquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (PFObject *admin in objects) {
                    [admin incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:100]];
                    admin[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                    admin[@"UpdateName"]=[NSNumber numberWithBool:NO];
                    [admin saveInBackground];
                    
                }
            }];
        }
        
    }];
            
    }
    else
    {
        [self.view makeToast:@"Unable to connect with server.Try again later" duration:3.0 position:@"bottom"];
       
            }
       

    


}

-(void)addFeed:(NSData*)imageloadstring :(NSString*)Caption :(NSString*)textPost
{
    
  NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imageloadstring length]);
      // [self.view makeToast:@"Posting" duration:4.0 position:@"bottom"];
    
    [SVProgressHUD showWithStatus:@"Posting"];
    PFFile *imageFile = [PFFile fileWithName:@"Feedimage.jpg" data:imageloadstring];
    UIImage *image1 = [UIImage imageWithData:imageloadstring];
    
    PFFile *imgFile=[PFFile fileWithName:@"thumbfeed.jpg" data:[self compressImage1:image1]];
    
    UIImage *tempimag=[UIImage imageWithData:imageloadstring];
//    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
            // Stitch together a postObject and send this async to Parse
            PFObject *postObject = [PFObject objectWithClassName:@"GroupFeed"];
            postObject[@"GroupId"]=sharedObj.GroupId;
            postObject[@"MobileNo"]=sharedObj.AccountNumber;
            if (textPost.length!=0) {
            postObject[@"PostType"]=@"Text";
                postObject[@"ImageWidth"]=[NSNumber numberWithInt:0];
                postObject[@"ImageHeight"]=[NSNumber numberWithInt:0];
            }
            else
            {
                postObject[@"PostType"]=@"Image";
                postObject[@"ImageWidth"]=[NSNumber numberWithInt:tempimag.size.width];
                postObject[@"ImageHeight"]=[NSNumber numberWithInt:tempimag.size.height];

            }
            postObject[@"PostText"]=textPost;
            postObject[@"Postimage"]=imageFile;
            postObject[@"ThumbnailPicture"]=imgFile;
            postObject[@"CommentCount"]=[NSNumber numberWithInt:0];
            postObject[@"PostPoint"]=[NSNumber numberWithInt:100];
            postObject[@"FlagCount"]=[NSNumber numberWithInt:0];
          
            
            postObject[@"ImageCaption"]=Caption;
            postObject[@"LikeUserArray"]=[[NSMutableArray alloc]init];
            postObject[@"DisLikeUserArray"]=[[NSMutableArray alloc]init];
             postObject[@"FlagArray"]=[[NSMutableArray alloc]init];
            postObject[@"PostStatus"]=@"Active";
            postObject[@"FeedLocation"]=point;
    PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
    
    postObject[@"UserId"]=pointer;
    postObject[@"FeedupdatedAt"]=[NSDate date];
            [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Couldn't save!");
                    NSLog(@"%@", error);
                    [SVProgressHUD dismiss];
                    [self.view makeToast:@"Unable to connect with server.Try again later" duration:3.0 position:@"bottom"];        }
                if (succeeded) {
                    NSArray *temp=[[NSArray alloc]initWithObjects:postObject, nil];
                    [PFObject pinAllInBackground:temp withName:sharedObj.GroupId block:^(BOOL succeeded, NSError *error) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"TAPPHOTO" object:nil];
                        [self.wallPostsTableViewController postWasCreated];
                    
                    }];
                    
                    PFQuery *ownerquery=[PFQuery queryWithClassName:@"UserDetails"];
                    [ownerquery whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                    [ownerquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        for (PFObject *admin in objects) {
                            [admin incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:100]];
                            admin[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                            admin[@"UpdateName"]=[NSNumber numberWithBool:NO];
                            [admin saveInBackground];
                            
                        }
                    }];
                    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                    [delegate.navigationController dismissViewControllerAnimated:YES completion:nil];
                          
                                           }
                
                    
                }];
    

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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



- (IBAction)flag:(id)sender {
    UIButton *flagbtn=(UIButton*)sender;
    int index=(int)flagbtn.tag;
    if (index==11) {
        sharedObj.flagValue=@"Offensive Content";
        [_b1 setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        [_b2 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_b3 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_b4 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    }
    else if (index==12)
    {
        sharedObj.flagValue=@"This post targets someone";
        [_b1 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_b2 setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        [_b3 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_b4 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    }
    else if (index==13)
    {
        sharedObj.flagValue=@"Spam";
        [_b1 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_b2 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_b3 setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
        [_b4 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    }
    else if (index==14)
    {
        sharedObj.flagValue=@"Other";
        [_b1 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_b2 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_b3 setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
        [_b4 setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)cancelFalg:(id)sender {
    _flagView.hidden=YES;
}

- (IBAction)okFlag:(id)sender {
       _flagView.hidden=YES;
     [[NSNotificationCenter defaultCenter]postNotificationName:@"FLAGACTION" object:nil];
}
-(void)updatepost
{
    _newpostView.hidden=YES;
    
    [self.wallPostsTableViewController callService ];
}
- (IBAction)updatepost:(id)sender {
 
}
@end
