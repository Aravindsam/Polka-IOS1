//
//  MemberDetailViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/8/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "MemberModalclass.h"
#import "SVProgressHUD.h"
#import "WhatsAppKit.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "KxMenu.h"
#import "Toast+UIView.h"
@interface MemberDetailViewController ()

@end

@implementation MemberDetailViewController
@synthesize indexValue,memberNo,MemberimageUrl,memberName,fromComment;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    sharedObj=[Generic sharedMySingleton];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    _fullimgview.hidden=YES;
    
    adminArray=[[NSMutableArray alloc]init];
    memberArray=[[NSMutableArray alloc]init];
            _adminBtn.hidden=YES;
        _removeMemberbtn.hidden=YES;
    singletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showmemberimage)];
    singletap.numberOfTapsRequired=1.0;
    [_backgroundImageview addGestureRecognizer:singletap];
    _backgroundImageview.userInteractionEnabled=YES;
    
    
    if (_fromFeed||fromComment){
     
     PFQuery *memberquery=[PFQuery queryWithClassName:@"MembersDetails"];
     [memberquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
     [memberquery whereKey:@"MemberNo" equalTo:memberNo];
     [memberquery whereKey:@"MemberStatus" notEqualTo:@"InActive"];
     
     [memberquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         if (error) {
             NSLog(@"error in geo query!"); // todo why is this ever happening?
         } else {
             
             if(objects.count!=0){
                 for (PFObject *memberobj in objects) {
                     
                     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                     [dateFormatter setDateFormat:@"MMMM dd,yyyy"];
                     
                     NSString *string = [dateFormatter stringFromDate:[memberobj objectForKey:@"JoinedDate"]];
                     if ([[memberobj objectForKey:@"AdditionalInfoProvided"] isEqualToString:@"No Information Available"]||[[memberobj objectForKey:@"AdditionalInfoProvided"] isEqualToString:@"No Information Availables"]||[[memberobj objectForKey:@"AdditionalInfoProvided"] isEqualToString:@"No Informations Available"]) {
                         _addinfolbel.text=@"";
                     }
                     else
                     {
                         _addinfolbel.text=[memberobj objectForKey:@"AdditionalInfoProvided"];
                     }
                     MemberAdmin=[[memberobj objectForKey:@"GroupAdmin"]boolValue];
                     
                     _joindatelbl.text=[NSString stringWithFormat:@"Joined : %@",string ];
                 }
             }
         }
     }];
     _namelabel.text=[NSString stringWithFormat:@"%@",memberName];
     _backgroundImageview.file=MemberimageUrl;
     _fullmemberimage.file=MemberimageUrl;
     [_backgroundImageview loadInBackground];

 }
 else{
    MemberModalclass *modal ;
    if (sharedObj.membersearch) {
        modal = [sharedObj.searchMemberArray objectAtIndex:indexValue];
        
    }
    else
    {
        modal = [sharedObj.MemberArray objectAtIndex:indexValue];
        
    }

                       if ([modal.userAddinfo isEqualToString:@"No Information Available"]||[modal.userAddinfo isEqualToString:@"No Information Availables"]||[modal.userAddinfo isEqualToString:@"No Informations Available"]) {
                        _addinfolbel.text=@"";
                    }
                    else
                    {
                        _addinfolbel.text=modal.userAddinfo;
                    }
                    MemberAdmin=modal.Admin;
                   
                    _joindatelbl.text=[NSString stringWithFormat:@"Joined : %@",modal.userjoindate ];
     _namelabel.text=[NSString stringWithFormat:@"%@",modal.userName];
     
     
     
     
     _backgroundImageview.file=modal.userImageurl;
     _fullmemberimage.file=modal.userImageurl;
     [_backgroundImageview loadInBackground];
 }
                    if (_fromFeed||fromComment) {
                        _adminBtn.hidden=YES;
                        _removeMemberbtn.hidden=YES;
                    }
                    else
                    {
                    if (MemberAdmin) {
                        _adminBtn.hidden=YES;
                        _removeMemberbtn.hidden=YES;
                    }
                    else
                    {
                        if (  [sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
                            _adminBtn.hidden=NO;
                            _removeMemberbtn.hidden=NO;
                        }
                        else
                        {
                            _adminBtn.hidden=YES;
                            _removeMemberbtn.hidden=YES;
                            
                        }
                    }
                    }

    
    
    mygroupArray=[[NSMutableArray alloc]init];
  
    _backgroundImageview.contentMode=UIViewContentModeScaleAspectFill;
    _backgroundImageview.clipsToBounds=YES;
    // Do any additional setup after loading the view.
}
-(void)showmemberimage
{
    _fullimgview.hidden=NO;
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
    if (_fromFeed) {
         [self.navigationController popViewControllerAnimated:YES];
    }
    else if (fromComment)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
    sharedObj.membersearch=NO;
    [[self navigationController]popViewControllerAnimated:YES];
    }
}
- (IBAction)makeAdmin:(id)sender {
    _adminBtn.hidden=YES;
    _removeMemberbtn.hidden=YES;
      [SVProgressHUD showWithStatus:@"Made Admin Successfully" maskType:SVProgressHUDMaskTypeBlack];
   
    PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
    [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
    [detailsquery whereKey:@"MemberNo" equalTo:memberNo];
    [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         PFObject *obj=[objects objectAtIndex:0];
        obj[@"GroupAdmin"]=[NSNumber numberWithBool:YES];
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                PFQuery*group=[PFQuery queryWithClassName:@"Group"];
                [group getObjectInBackgroundWithId:sharedObj.GroupId block:^(PFObject *object, NSError *error) {
                    adminArray=object[@"AdminArray"];
                    [adminArray addObject:memberNo];
                    object[@"AdminArray"]=adminArray;
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                   [SVProgressHUD dismiss];
                        
                    }];
                    
                }];
            }
            else
            {
                [SVProgressHUD dismiss];
            }
        }];
    }];
}

- (IBAction)removeMemberAction:(id)sender {
    [SVProgressHUD showWithStatus:@"Removing Member from group...." maskType:SVProgressHUDMaskTypeBlack];
    
    PFQuery *groupquery=[PFQuery queryWithClassName:@"Group"];
    [groupquery getObjectInBackgroundWithId:sharedObj.GroupId block:^(PFObject *object, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
        }
        else
        {
        memberCount=[object[@"MemberCount"]intValue];
        memberArray=object[@"GroupMembers"];
        [object incrementKey:@"MemberCount" byAmount:[NSNumber numberWithInt:-1]];
        [memberArray removeObject:memberNo];
        object[@"GroupMembers"]=memberArray;
        sharedObj.currentGroupmemberArray=memberArray;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (error) {
                [SVProgressHUD dismiss];
            }
            else{
        if (memberCount==20) {
            PFQuery *ownerquery=[PFQuery queryWithClassName:@"UserDetails"];
            [ownerquery whereKey:@"MobileNo" equalTo:object[@"MobileNo"]];
            [ownerquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (PFObject*ownerobject in objects) {
                    if (objects.count==0) {
                        [SVProgressHUD dismiss];
                    }
                    else
                    {
                [ownerobject incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:-1000]];
                        ownerobject[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                        ownerobject[@"UpdateName"]=[NSNumber numberWithBool:NO];
                [ownerobject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        
                        PFQuery *memberquery=[PFQuery queryWithClassName:@"UserDetails"];
                        [memberquery whereKey:@"MobileNo" equalTo:memberNo];
                        [memberquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            PFObject *object=[objects objectAtIndex:0];
                                mygroupArray=object[@"MyGroupArray"];
                                [mygroupArray removeObject:sharedObj.GroupId];
                                object[@"MyGroupArray"]=mygroupArray;
                            object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                            object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                             [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         
                                 PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                                 [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                 [detailsquery whereKey:@"MemberNo" equalTo:memberNo];
                                 [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                     PFObject *obj=[objects objectAtIndex:0];
                                     obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                                     obj[@"ExitedBy"]=@"Admin";
                                     obj[@"LeaveDate"]=[NSDate date];
                                     obj[@"MemberStatus"]=@"InActive";
                                     [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                                         [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                         [feedquery whereKey:@"MobileNo" equalTo:memberNo];
                                         
                                         [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                             if (objects.count!=0) {
                                                 for (PFObject *feedobject in objects) {
                                                     feedobject[@"PostStatus"]=@"InActive";
                                                     [feedobject saveInBackground];
                                                 }
                                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"RELOADMEMBER" object:nil];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                                 
                                             }
                                             
                                         }];

                                     }];
                                 }];

                                                   }];
                         
                        }];
                    }
                }];
                    }
                    }
                }];
                
        
            
            
            
            
        }
        else if(memberCount==50)
        {
            PFQuery *ownerquery=[PFQuery queryWithClassName:@"UserDetails"];
            [ ownerquery getObjectInBackgroundWithId:object[@"MobileNo"] block:^(PFObject *ownerobject, NSError *error) {
                [ownerobject incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:-2000]];
                [ownerobject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        
                        PFQuery *memberquery=[PFQuery queryWithClassName:@"UserDetails"];
                        [memberquery whereKey:@"MobileNo" equalTo:memberNo];
                        [memberquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            PFObject *object=[objects objectAtIndex:0];
                            mygroupArray=object[@"MyGroupArray"];
                            [mygroupArray removeObject:sharedObj.GroupId];
                            object[@"MyGroupArray"]=mygroupArray;
                            object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                            object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                
                                PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                                [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                [detailsquery whereKey:@"MemberNo" equalTo:memberNo];
                                [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    PFObject *obj=[objects objectAtIndex:0];
                                    obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                                    obj[@"ExitedBy"]=@"Admin";
                                    obj[@"LeaveDate"]=[NSDate date];
                                    obj[@"MemberStatus"]=@"InActive";
                                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                                        [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                        [feedquery whereKey:@"MobileNo" equalTo:memberNo];
                                        
                                        [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                            if (objects.count!=0) {
                                                for (PFObject *feedobject in objects) {
                                                    feedobject[@"PostStatus"]=@"InActive";
                                                    [feedobject saveInBackground];
                                                }
                                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"RELOADMEMBER" object:nil];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                            }
                                            
                                        }];
                                        
                                    }];
                                }];
                                
                            }];
                            
                        }];                    }

                        }];
                        
                        
            }];
            
            
            
        }
        else{
            
           
            PFQuery *memberquery=[PFQuery queryWithClassName:@"UserDetails"];
            [memberquery whereKey:@"MobileNo" equalTo:memberNo];
            [memberquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                PFObject *object=[objects objectAtIndex:0];
                mygroupArray=object[@"MyGroupArray"];
                [mygroupArray removeObject:sharedObj.GroupId];
                object[@"MyGroupArray"]=mygroupArray;
                object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                    [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                    [detailsquery whereKey:@"MemberNo" equalTo:memberNo];
                    [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        PFObject *obj=[objects objectAtIndex:0];
                        obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                        obj[@"ExitedBy"]=@"Admin";
                        obj[@"LeaveDate"]=[NSDate date];
                        obj[@"MemberStatus"]=@"InActive";
                        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                            [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                            [feedquery whereKey:@"MobileNo" equalTo:memberNo];
                            
                            [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                if (objects.count!=0) {
                                    for (PFObject *feedobject in objects) {
                                        feedobject[@"PostStatus"]=@"InActive";
                                        [feedobject saveInBackground];
                                    }
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"RELOADMEMBER" object:nil];
                                     [self.navigationController popViewControllerAnimated:YES];
                                }
                                
                            }];
                            
                        }];
                    }];
                    
                }];
                
            }];
        }
            }
        }];
        }
    }];
}
- (IBAction)close:(id)sender {
      _fullimgview.hidden=YES;
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
        
        [self fbShareBtnSelected:_fullmemberimage.image];
        
        
        
    }
    else if ([sender.title isEqualToString:@"Twitter"])
    {
        
        [self twitterShareSelected:_fullmemberimage.image];
        
    }
    else if([sender.title isEqualToString:@"WhatsApp"])
    {
        
        
        [self whatsAppShareSelected:_fullmemberimage.image];
        
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
                    
                       [weakSelf.view makeToast:@"Posted Successfully" duration:3.0 position:@"bottom"];
                     
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
            [self presentViewController:mySlcomposerView animated:YES completion:nil];
            // if button or change to self.view.
        }
        
        
        
        
        //[mySlcomposerView addURL:[NSURL URLWithString:modal.htmlUrl]];
        
    }
    
    else
    {
        [self.view makeToast:@"You must configure Facebook account for sharing.You can add or create a Facebook/Twitter account in Settings" duration:3.0 position:@"bottom"];
    }
    
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
                     
                   
                     
                     [weakSelf.view makeToast:@"Posted Successfully" duration:3.0 position:@"bottom"];
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
   
        [self.view makeToast:@"You must configure Twitter account for sharing.You can add or create a Facebook/Twitter account in Settings" duration:3.0 position:@"bottom"];
    }
}



-(void)whatsAppShareSelected:(UIImage*)imageUrl
{
    
    NSLog(@"Whats app Sharing Selected");
    if ([MFMessageComposeViewController canSendText]) {
        if (![WhatsAppKit isWhatsAppInstalled]) {
           
                [self.view makeToast:@"You must configure WhatsApp account for sharing" duration:3.0 position:@"bottom"];
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
          
                  [self.view makeToast:@"You must configure WhatsApp account for sharing" duration:3.0 position:@"bottom"];
            }
            
            
            
            
        }
    }
    else
    {
        [self.view makeToast:@"WhatsApp Feature is not applicable" duration:3.0 position:@"bottom"];
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
    
    UIImage *coolImage = _fullmemberimage.image;
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
