//
//  CommentViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/24/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "CommentViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "commentTableViewController.h"
#import "Toast+UIView.h"
#import "KxMenu.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface CommentViewController ()<commentTableViewControllerDataSource>
@property (nonatomic, strong) commentTableViewController *wallPostsTableViewController;

@end

@implementation CommentViewController
@synthesize point;
- (void)viewDidLoad {
    [super viewDidLoad];
  
    _headerview.backgroundColor=[Generic colorFromRGBHexString:headerColor];
    sharedObj=[Generic sharedMySingleton];
    _flagView.hidden=YES;
    _insideView.layer.cornerRadius=5.0;
    _insideView.clipsToBounds=YES;
    _okbtn.layer.cornerRadius=5.0;
    _okbtn.clipsToBounds=YES;
    
    _cancelbtn.layer.cornerRadius=5.0;
    _cancelbtn.clipsToBounds=YES;

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        // [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
        _FullimageView.hidden=YES;
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
    [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
    [query fromLocalDatastore];
    [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error) {
        }
        else{
            userimage =[object objectForKey:@"ThumbnailPicture"];
        }}];
           PFFile *imageFile =[sharedObj.feedObject objectForKey:@"Postimage"];
    _fullimgView.file=imageFile;
    [_fullimgView loadInBackground];
    _groupimageview.file=sharedObj.groupimageurl;
    [_groupimageview loadInBackground];
    _groupnamelabel.text=sharedObj.GroupName;
    sharedObj.commentViewFrame=_postView.frame;
    [_containerView setFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 48)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSomething)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFlag) name:@"SHOWFLAG1" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissFlag) name:@"DISMISSFLAG" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showimage) name:@"SHOWIMAGE" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissView) name:@"DELETEPOST" object:nil];
  [self loadWallPostsTableViewController];
    // Do any additional setup after loading the view.
}
-(void)showFlag
{
    
    [self.view bringSubviewToFront:_flagView];
    _flagView.hidden=NO;
    
    
}
-(void)showimage
{
    _FullimageView.hidden=NO;
    _FullimageView.backgroundColor=[UIColor blackColor];
 
   
    
    int widthimg=[sharedObj.feedObject[@"ImageWidth"] intValue];
    int heightimg=[sharedObj.feedObject[@"ImageHeight"]intValue];
//    int difference=heightimg-widthimg;
//    int height=320+difference;
//    
  
    
    float hfactor = widthimg /self.fullimageScrollview.frame.size.width;
    float vfactor = heightimg/ self.fullimageScrollview.frame.size.height;
    
    float factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    //float newWidth = widthimg / factor;
    float newHeight = heightimg / factor;
    int height=newHeight;
      int difference = widthimg / factor;;
    if(heightimg>widthimg)
    {
//         difference=((self.fullimageScrollview.frame.size.height)*widthimg)/heightimg;
//         height=(widthimg*heightimg)/widthimg;
        _fullimgView.frame=CGRectMake((self.fullimageScrollview.frame.size.width-difference)/2,(self.fullimageScrollview.frame.size.height-height)/2, difference, height);
    }
    else if(heightimg==widthimg)
    {
//           difference=((self.fullimageScrollview.frame.size.width)*heightimg)/widthimg;
//        height=difference;
        _fullimgView.frame=CGRectMake(0, (self.fullimageScrollview.frame.size.height-difference)/2, difference, height);

    }
    else
    {
//         height=((self.fullimageScrollview.frame.size.width)*heightimg)/widthimg;
//        difference=320;
        _fullimgView.frame=CGRectMake(0, (self.fullimageScrollview.frame.size.height-difference)/2, 320, height);
    }
    _fullimageScrollview.contentSize=CGSizeMake(difference,height );
}

-(void)dismissFlag
{
    _flagView.hidden=YES;
}

-(void)resignTextView
{
    NSString*temptext=textView.text;
    temptext=[temptext stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceCharacterSet]];
    temptext= [temptext stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (temptext.length!=0 ) {
        [self addComment:textView.text];
        textView.text=@"";
    }
    textView.text=@"";
    [textView resignFirstResponder];
}
-(void)doSomething
{
    [textView resignFirstResponder];
    sharedObj.commentViewFrame=_postView.frame;
    [_containerView setFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 48)];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    sharedObj.commentViewFrame=_postView.frame;
    [_containerView setFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 48)];
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

-(void)addComment:(NSString*)commentText
{
     PFObject *likeObject=[PFObject objectWithClassName:@"Activity"];
    likeObject[@"GroupId"]=sharedObj.GroupId;
    likeObject[@"FeedId"]=sharedObj.FeedId;
    likeObject[@"FeedType"]=@"Comment";
    likeObject[@"Commenttext"]=commentText;
    likeObject[@"UserName"]=sharedObj.AccountName;
    likeObject[@"MobileNo"]=sharedObj.AccountNumber;
    likeObject[@"UserPicture"]=userimage;
    likeObject[@"upVote"]=[NSNumber numberWithBool:NO];
    likeObject[@"downVote"]=[NSNumber numberWithBool:NO];
    likeObject[@"FlagValue"]=@"";
    likeObject[@"ActivityLocation"]=point;
     PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
    likeObject[@"UserId"]=pointer;
    [likeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
                  [self.wallPostsTableViewController postWasCreated];
            PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
            [query whereKey:@"GroupId" equalTo:sharedObj.GroupId];
            
        
                    [query getObjectInBackgroundWithId:sharedObj.FeedId block:^(PFObject *gameScore, NSError *error) {
                        [gameScore incrementKey:@"CommentCount" byAmount:[NSNumber numberWithInt:1]];
                        [gameScore incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:50]];
                        gameScore[@"FeedupdatedAt"]=gameScore.updatedAt;
                        
                        [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
                            [user whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                            [user getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                [object incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:50]];
                                object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"COMMENTADD" object:nil];
                                }];
                            }];
                        }];
                       
                    }];
                    
                }
            }];
         
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
    containerFrame.origin.y = self.postView.bounds.size.height - keyboardBounds.size.height+70;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _containerView.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = _containerView.frame;
    containerFrame.origin.y = self.postView.bounds.size.height+70 ;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
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
    
    self.wallPostsTableViewController = [[commentTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    
    self.wallPostsTableViewController.dataSource = self;
    [self.postView addSubview:self.wallPostsTableViewController.view];
    [self addChildViewController:self.wallPostsTableViewController];
    [self.wallPostsTableViewController didMoveToParentViewController:self];
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 8, 235, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.textColor=[UIColor lightGrayColor];
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Comment on the post…";
    textView.layer.borderColor=[UIColor whiteColor].CGColor;
    textView.layer.borderWidth=0.5;
    textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    [_containerView addSubview:textView];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    doneBtn.frame = CGRectMake(250,11, 60, 28);
    
    [doneBtn setTitle:@"COMMENT" forState:UIControlStateNormal];
   
    doneBtn.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10.0f];
    doneBtn.layer.borderWidth=1.0;
    doneBtn.layer.cornerRadius = 2;
    doneBtn.clipsToBounds = YES;

    doneBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundColor:[UIColor colorWithRed:2.0/255.0 green:105/255.0 blue:153/255.0 alpha:1.0]];
    [_containerView addSubview:doneBtn];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)flag:(id)sender {
    UIButton *flagbtn=(UIButton*)sender;
    int index=flagbtn.tag;
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"FLAGACTION1" object:nil];
}

-(void)dismissView
{
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)back:(id)sender {
      
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)shareImage:(id)sender {
    sharefeed = sharedObj.feedObject;
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
        if ([sharefeed[@"PostType"] isEqualToString:@"Image"])
        {
            PFFile *imageFile =[sharefeed objectForKey:@"Postimage"];
            
            
            [self fbShareBtnSelected:imageFile.url];
            
        }
        else
            
        {
            [self fbShareBtnSelected:@""];
        }
        
    }
    else if ([sender.title isEqualToString:@"Twitter"])
    {
        if ([sharefeed[@"PostType"] isEqualToString:@"Image"])
        {
            PFFile *imageFile =[sharefeed objectForKey:@"Postimage"];
            
            
            [self twitterShareSelected:imageFile.url];
        }
        else
        {
            [self twitterShareSelected:@""];
        }
    }
    else if([sender.title isEqualToString:@"WhatsApp"])
    {
        if ([sharefeed[@"PostType"] isEqualToString:@"Image"])
        {
            PFFile *imageFile =[sharefeed objectForKey:@"Postimage"];
            [self whatsAppShareSelected:imageFile.url];
        }
        else
        {
            [self whatsAppShareSelected:@""];
        }
    }
    else if ([sender.title isEqualToString:@"Mail"])
    {
        [self mailShareSelected];
    }
    [KxMenu dismissMenu];
}
-(void)fbShareBtnSelected:(NSString*)ImageData
{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        mySlcomposerView=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        if([sharedObj.feedObject[@"PostType"] isEqualToString:@"Text"])
        {
            [mySlcomposerView setInitialText:[NSString stringWithFormat:@"%@\n - Shared via Chatterati",sharedObj.feedObject[@"PostText"]]];
            [mySlcomposerView setCompletionHandler:^(SLComposeViewControllerResult result)
             {
                 switch (result)
                 {
                     case SLComposeViewControllerResultDone:
                         
                         [self showAlertWithMessage:@"Posted Successfully." Title:@"GroupsNearMe"];
                         
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
                
                [self  presentViewController:mySlcomposerView animated:YES completion:nil];
                // if button or change to self.view.
            }
            
        }
        else if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Image"])
        {
            
            if (![sharedObj.feedObject[@"ImageCaption"] isEqualToString:@" "]) {
                [mySlcomposerView setInitialText:[NSString stringWithFormat:@"%@\n -Shared via Chatterati",sharedObj.feedObject[@"ImageCaption"]]];
                [mySlcomposerView addURL:[NSURL URLWithString:ImageData]];
            }
            else
            {
                [mySlcomposerView addURL:[NSURL URLWithString:ImageData]];
            }
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
-(void)twitterShareSelected:(NSString*)ImageData
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        mySlcomposerView=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if([sharedObj.feedObject[@"PostType"] isEqualToString:@"Text"])
        {
            [mySlcomposerView setInitialText:[NSString stringWithFormat:@"%@\n - Shared via Chatterati",sharedObj.feedObject[@"PostText"]]];
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
        else if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Image"])
        {
            
            if (![sharedObj.feedObject[@"ImageCaption"] isEqualToString:@" "]) {
                [mySlcomposerView setInitialText:[NSString stringWithFormat:@"%@\n- Shared via Chatterati",sharedObj.feedObject[@"ImageCaption"]]];
                [mySlcomposerView addURL:[NSURL URLWithString:ImageData]];
            }
            else
            {
                [mySlcomposerView addURL:[NSURL URLWithString:ImageData]];
            }
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
        
    }
    else
    {
        [self showAlertWithMessage:@"You must configure Twitter account for sharing.You can add or create a Facebook/Twitter account in Settings." Title:@"GroupsNearMe"];
    }
}



-(void)whatsAppShareSelected:(NSString*)imageUrl
{
    
    NSLog(@"Whats app Sharing Selected");
    if ([MFMessageComposeViewController canSendText]) {
        if (![WhatsAppKit isWhatsAppInstalled]) {
            [self showAlertWithMessage:@"You must configure WhatsApp account for sharing." Title:@"GroupsNearMe"];
        }
        else
        {
            if([sharedObj.feedObject[@"PostType"] isEqualToString:@"Text"])
            {
                [WhatsAppKit launchWhatsAppWithMessage:[NSString stringWithFormat:@"%@ Via Chatterati",sharedObj.feedObject[@"PostText"]]];
            }
            else if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Image"])
            {
                
                NSURL *instagramURL = [NSURL URLWithString:@"whatsapp://app"];
                
                if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                    
                    NSURL*imageURL=[NSURL URLWithString:imageUrl];
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    
                    
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
    NSString*imageurl;
    if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Image"])
    {
        PFFile *imageFile =[sharedObj.feedObject objectForKey:@"Postimage"];
        imageurl=imageFile.url;
        UIImage *coolImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]]];
        UIImage * tmpImag = [UIImage imageWithCGImage: coolImage.CGImage
                                                scale: coolImage.scale
                                          orientation: coolImage.imageOrientation];
        
        //...do physical rotation, if needed
        
        UIImage *ImgOut = [self scaleAndRotateImage: tmpImag];
        
        //...note orientation is UIImageOrientationUp now
        
        NSData * imageAsNSData = UIImageJPEGRepresentation( ImgOut, 0.9f );
        
        
        
        [mailAttachment addAttachmentData:imageAsNSData mimeType:@"image/png" fileName:@"coolImage.png"];
        
        if (![sharedObj.feedObject[@"ImageCaption"]isEqualToString:@" "]) {
            [mailAttachment setMessageBody:[NSString stringWithFormat:@"<br><br> %@ <br> <br><br> -- Chatterati", sharedObj.feedObject[@"ImageCaption"]] isHTML:YES];
        }
        else
        {
            [mailAttachment setMessageBody:[NSString stringWithFormat:@"<br><br><br> <br><br> -- Chatterati"] isHTML:YES];
        }
    }
    else
    {
        [mailAttachment setMessageBody:[NSString stringWithFormat:@"<br><br> %@ <br> <br><br> -- Chatterati", sharedObj.feedObject[@"PostText"]] isHTML:YES];
    }
    
    
    
    
    //CHECK SOURCE
    [mailAttachment setToRecipients:[NSArray arrayWithObjects:@"", nil]];
    [self presentViewController:mailAttachment animated:YES completion:nil];
    //[self presentModalViewController:mailAttachment animated:YES];
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

-(void)dismissMenu
{
    [KxMenu dismissMenu];
}


- (IBAction)closeview:(id)sender {
        _FullimageView.hidden=YES;
}
@end
