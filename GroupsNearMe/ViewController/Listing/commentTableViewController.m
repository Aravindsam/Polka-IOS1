//
//  commentTableViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/27/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "commentTableViewController.h"
#import "WhatsAppKit.h"
#import "SVProgressHUD.h"
#import "PAPLoadMoreCell.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "KxMenu.h"
#import "CommentTableViewCell.h"
#import "PublicDetailTableViewCell.h"
#import "UIImage+ResizeAdditions.h"
#import "MemberDetailViewController.h"

#import "Toast+UIView.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface commentTableViewController ()
{

}
@property (nonatomic, strong) UIButton *noDataButton;

@end

@implementation commentTableViewController
@synthesize point;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    humanizedType = NSDateHumanizedSuffixAgo;

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        // [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];

    
     currentuserMobileNo=[[NSString alloc]init];
    likeArray=[[NSMutableArray alloc]init];
    dislikeArray=[[NSMutableArray alloc]init];
    flagUserArray=[[NSMutableArray alloc]init];
    flagArray=[[NSMutableArray alloc]initWithObjects:@"Offensive Content",@"This post targets someone",@"Spam", nil];
    self.view.frame=CGRectMake(0, 0, sharedObj.commentViewFrame.size.width, sharedObj.commentViewFrame.size.height);
    self.parseClassName = @"Activity";
    self.pullToRefreshEnabled = YES;
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
    self.tableView.allowsSelection=NO;
    // The number of comments to show per page
    self.objectsPerPage = 20;
    // The key of the PFObject to display in the label of the default cell style
    self.textKey = @"PostText";
    //self.view.backgroundColor=[UIColor clearColor];
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setFlagValue) name:@"FLAGACTION1" object:nil];
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadValue) name:@"ADDCOMMENT" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSomething)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    self.tableView.separatorColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor colorWithRed:118.0f/255.0f green:117.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
    self.view.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
        // Do any additional setup after loading the view.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [KxMenu dismissMenu];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    
}

#pragma mark PFQueryTableViewController
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
   // const CGRect bounds = self.view.bounds;
    
 
}

- (void)objectsWillLoad {
    

    [super objectsWillLoad];
 
  
    
    // This method is called before a PFQuery is fired to get more objects
}
-(void)doSomething
{
    self.view.frame=CGRectMake(0, 0, sharedObj.commentViewFrame.size.width, sharedObj.commentViewFrame.size.height);
}
-(void)viewWillAppear:(BOOL)animated
{[super viewWillAppear:animated];
    
     self.view.frame=CGRectMake(0, 0, sharedObj.commentViewFrame.size.width, sharedObj.commentViewFrame.size.height);
    

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
- (void)postWasCreated {
    
   [self checkUpdates];
    

}
- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    if (self.objects.count > 0) {

        dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: self.objects.count+1 inSection: 0];
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
        });

    }
    

  if (self.objects.count==0) {
        [self checkUpdates];

    }
   
}
-(void)checkUpdates
{
    sharedObj=[Generic sharedMySingleton];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        //  query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    query.limit=100;
    // Query for posts near our current location.
    
    // Get our current location:
    
    // And set the query to look by location
    [query whereKey:@"FeedId" equalTo:[Generic sharedMySingleton].FeedId];
    [query whereKey:@"FeedType" equalTo:@"Comment"];
     [query includeKey:@"UserId"];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *feedobjects, NSError *error) {
        if (feedobjects.count!=0) {
            [PFObject unpinAllObjectsInBackgroundWithName:sharedObj.FeedId];
            [PFObject pinAllInBackground:feedobjects withName:sharedObj.FeedId block:^(BOOL succeeded, NSError *error) {
       
            if (succeeded) {
                //NSLog(@"Pinned OK");
                
                  self.noDataButton.hidden = YES;
                [self loadObjects];
                                            }else{
                NSLog(@"Erro: %@", error.localizedDescription);
            }
        }];
        }
        else
        {
            self.noDataButton.hidden =NO;

        }
    }
     ];

}
- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{

        if (indexPath.row < 2) {
            return nil;
        } else if (indexPath.row > (self.objects.count + 2)) {
            return nil;
        } else {
            return [super objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:indexPath.section]];
        }
   
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    // call super because we're a custom subclass.
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self loadNextPage];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object1 {
   
       if(indexPath.row == 0){
         static NSString *CellIdentifier = @"Cell";
           likeArray=sharedObj.feedObject[@"LikeUserArray"];
           dislikeArray=sharedObj.feedObject[@"DisLikeUserArray"];
           flagUserArray=sharedObj.feedObject[@"FlagArray"];

           if ([sharedObj.groupType isEqualToString:@"Public"]) {
//               self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
//               [_timeIntervalFormatter setLocale:[NSLocale currentLocale]];
//
//               NSTimeInterval timeInterval = [[sharedObj.feedObject createdAt] timeIntervalSinceNow];
//               NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
               NSString*timestamp=[[sharedObj.feedObject createdAt] stringWithHumanizedTimeDifference:humanizedType withFullString:YES];


               PublicDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
               cell = [[PublicDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
               
               [cell setDidselectDelegate:self];
            
               [cell.flagbtn setImage:[UIImage imageNamed:@"flag.png"] forState:UIControlStateNormal];
             
               [cell.deletebtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
              // [cell.sharebtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
             
               cell.deletebtn.hidden=YES;
               cell.flagbtn.hidden=YES;
               cell.profileimageview.hidden=YES;
               cell.profilenamelabel.hidden=YES;
             
                   
                   currentuserMobileNo=sharedObj.feedObject[@"UserId"][@"MobileNo"];
                   if ([sharedObj.AccountNumber isEqualToString:currentuserMobileNo]) {
                       if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Invitation"]||[sharedObj.feedObject[@"PostType"] isEqualToString:@"Member"])
                       {
                           cell.deletebtn.hidden=YES;
                           cell.flagbtn.hidden=NO;
                       }
                       else
                       {
                           cell.deletebtn.hidden=NO;
                           cell.flagbtn.hidden=YES;
                           
                       }
                   }
                   else
                   {
                       cell.deletebtn.hidden=YES;
                       cell.flagbtn.hidden=NO;
                   }
              
               
               
               if ([likeArray containsObject:sharedObj.AccountNumber]) {
                   [cell.downvotebtn setEnabled:NO];
                   [cell.upvotebtn setEnabled:YES];
                   [cell.upvotebtn setImage:[UIImage imageNamed:@"upvote.png"] forState:UIControlStateNormal];
                   [cell.downvotebtn setImage:[UIImage imageNamed:@"down1.png"] forState:UIControlStateNormal];
               }
               
               else if ([dislikeArray containsObject:sharedObj.AccountNumber]) {
                   [cell.upvotebtn setEnabled:NO];
                   [cell.downvotebtn setEnabled:YES];
                   [cell.upvotebtn setImage:[UIImage imageNamed:@"up1.png"] forState:UIControlStateNormal];
                   [cell.downvotebtn setImage:[UIImage imageNamed:@"downvote.png"] forState:UIControlStateNormal];
               }
               else
               {
                   [cell.upvotebtn setEnabled:YES];
                   [cell.downvotebtn setEnabled:YES];
                   [cell.upvotebtn setImage:[UIImage imageNamed:@"up1.png"] forState:UIControlStateNormal];
                   [cell.downvotebtn setImage:[UIImage imageNamed:@"down1.png"] forState:UIControlStateNormal];
               }

               
               
               if ([flagUserArray containsObject:sharedObj.AccountNumber]) {
                   [cell.flagbtn setEnabled:NO];
                   cell.flagbtn.alpha=0.5;
               }
               else
               {
                   [cell.flagbtn setEnabled:YES];
                   cell.flagbtn.alpha=1;
               }
               
               
               
               
               if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Text"]) {
                   cell.textvalLabel.text=sharedObj.feedObject[@"PostText"];
                   cell.timelabel.text=timestamp;
                   cell.pointlabel.text= [NSString stringWithFormat:@"%@ Points . %@ Replies",sharedObj.feedObject[@"PostPoint"],sharedObj.feedObject[@"CommentCount"]];
                   cell.textvalLabel.hidden=NO;
                   cell.postImageview.hidden=YES;
                   [cell.textvalLabel sizeToFit];
                   cell.textvalLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
                       // Open URLs
                       
                       [self attemptOpenURL:[NSURL URLWithString:string]];
                       
                       
                   };
                   
                   
               }
               else if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Image"])
               {
                   cell.textvalLabel.text=sharedObj.feedObject[@"ImageCaption"];
                   cell.timelabel.text=timestamp;
                   cell.pointlabel.text= [NSString stringWithFormat:@"%@ Points . %@ Replies",sharedObj.feedObject[@"PostPoint"],sharedObj.feedObject[@"CommentCount"]];
                   cell.postImageview.hidden=NO;
                   NSString *animal = sharedObj.feedObject[@"ImageCaption"];
                   animal=[animal stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
                   if (animal == NULL || animal.length ==0) {
                       cell.textvalLabel.hidden=YES;
                   }
                   else
                   {
                       cell.textvalLabel.hidden=NO;
                   }
                   cell.postImageview.hidden=NO;
                   
                   [cell.textvalLabel sizeToFit];
                   PFFile *imageFile =[sharedObj.feedObject objectForKey:@"Postimage"];
                   cell.postImageview.file=imageFile;
                   [cell.postImageview loadInBackground];
                    

                   cell.postImageview.backgroundColor=[UIColor whiteColor];
                   
                   cell.textvalLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
                       // Open URLs
                       
                       [self attemptOpenURL:[NSURL URLWithString:string]];
                       
                       
                   };
                   
               }
               
               cell.upvotebtn.tag=indexPath.row;
               cell.downvotebtn.tag=indexPath.row;
              // cell.sharebtn.tag=indexPath.row;
               cell.deletebtn.tag=indexPath.row;
               cell.flagbtn.tag=indexPath.row;
                cell.postImageview.tag=indexPath.row;
               cell.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
               cell.layer.cornerRadius=5.0;
               cell.clipsToBounds=YES;
               return cell;

           }
           else
           {
               PublicDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
               cell = [[PublicDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                [cell setDidselectDelegate:self];
               
               
               [cell.flagbtn setImage:[UIImage imageNamed:@"flag.png"] forState:UIControlStateNormal];
             
               [cell.deletebtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
               //[cell.sharebtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
              
               cell.deletebtn.hidden=YES;
               cell.flagbtn.hidden=YES;
               cell.profileimageview.hidden=NO;
               cell.profilenamelabel.hidden=NO;
             
                   cell.profilenamelabel.text=sharedObj.feedObject[@"UserId"][@"UserName"];
                   PFFile*imagefile=sharedObj.feedObject[@"UserId"][@"ThumbnailPicture"];
                   cell.profileimageview.file=imagefile;
               [cell.profileimageview loadInBackground];
                   currentuserMobileNo=sharedObj.feedObject[@"UserId"][@"MobileNo"];
                   if ([sharedObj.AccountNumber isEqualToString:currentuserMobileNo]) {
                       if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Invitation"]||[sharedObj.feedObject[@"PostType"] isEqualToString:@"Member"])
                       {
                           cell.deletebtn.hidden=YES;
                           cell.flagbtn.hidden=NO;
                       }
                       else
                       {
                           cell.deletebtn.hidden=NO;
                           cell.flagbtn.hidden=YES;
                           
                       }
                   }
                   else
                   {
                       cell.deletebtn.hidden=YES;
                       cell.flagbtn.hidden=NO;
                   }
                   
               
               
               if ([likeArray containsObject:sharedObj.AccountNumber]) {
                   [cell.downvotebtn setEnabled:NO];
                   [cell.upvotebtn setEnabled:YES];
                   [cell.upvotebtn setImage:[UIImage imageNamed:@"upvote.png"] forState:UIControlStateNormal];
                   [cell.downvotebtn setImage:[UIImage imageNamed:@"down1.png"] forState:UIControlStateNormal];
               }
               
               else if ([dislikeArray containsObject:sharedObj.AccountNumber]) {
                   [cell.upvotebtn setEnabled:NO];
                   [cell.downvotebtn setEnabled:YES];
                   [cell.upvotebtn setImage:[UIImage imageNamed:@"up1.png"] forState:UIControlStateNormal];
                   [cell.downvotebtn setImage:[UIImage imageNamed:@"downvote.png"] forState:UIControlStateNormal];
               }
               else
               {
                   [cell.upvotebtn setEnabled:YES];
                   [cell.downvotebtn setEnabled:YES];
                   [cell.upvotebtn setImage:[UIImage imageNamed:@"up1.png"] forState:UIControlStateNormal];
                   [cell.downvotebtn setImage:[UIImage imageNamed:@"down1.png"] forState:UIControlStateNormal];
               }
               
               
               if ([flagUserArray containsObject:sharedObj.AccountNumber]) {
                   [cell.flagbtn setEnabled:NO];
                   cell.flagbtn.alpha=0.5;
               }
               else
               {
                   [cell.flagbtn setEnabled:YES];
                   cell.flagbtn.alpha=1;
               }
               
                  NSString*timestamp=[[sharedObj.feedObject createdAt] stringWithHumanizedTimeDifference:humanizedType withFullString:YES];
               if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Text"]) {
                   //            cell.textvalLabel.attributedText=[self filterLinkWithContent:object[@"PostText"]];
                   cell.textvalLabel.text=sharedObj.feedObject[@"PostText"];
                   cell.timelabel.text=timestamp;
                   cell.pointlabel.text= [NSString stringWithFormat:@"%@ Points . %@ Replies",sharedObj.feedObject[@"PostPoint"],sharedObj.feedObject[@"CommentCount"]];
                   //[cell.textvalLabel sizeToFit];
                   cell.postImageview.hidden=YES;
                   
                   cell.textvalLabel.hidden=NO;
                   cell.textvalLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
                       // Open URLs
                       
                       [self attemptOpenURL:[NSURL URLWithString:string]];
                       
                       
                   };
               }
               else if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Image"])
               {
                   
                   NSString *animal = sharedObj.feedObject[@"ImageCaption"];
                   animal=[animal stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
                   if (animal == NULL || animal.length ==0) {
                       cell.textvalLabel.hidden=YES;
                   }
                   else
                   {
                       cell.textvalLabel.hidden=NO;
                   }
                   
                   cell.textvalLabel.text=sharedObj.feedObject[@"ImageCaption"];
                   cell.timelabel.text=timestamp;
                   cell.pointlabel.text= [NSString stringWithFormat:@"%@ Points . %@ Replies",sharedObj.feedObject[@"PostPoint"],sharedObj.feedObject[@"CommentCount"]];
                   cell.postImageview.hidden=NO;
                   
                 PFFile *imageFile =[sharedObj.feedObject objectForKey:@"Postimage"];
//                   
//                   
                   cell.postImageview.file=imageFile;
                   [cell.postImageview loadInBackground];


                   cell.postImageview.backgroundColor=[UIColor whiteColor];

                   
                   
                   cell.textvalLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
                       // Open URLs
                       
                       [self attemptOpenURL:[NSURL URLWithString:string]];
                       
                       
                   };
                   
               }
               cell.upvotebtn.tag=indexPath.row;
               cell.downvotebtn.tag=indexPath.row;
              // cell.sharebtn.tag=indexPath.row;
               cell.flagbtn.tag=indexPath.row;
               cell.postImageview.tag=indexPath.row;
               cell.deletebtn.tag=indexPath.row;
               cell.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
               cell.layer.cornerRadius=5.0;
               cell.clipsToBounds=YES;
               return cell;
               

           }

    }
    else if(indexPath.row==1)
    {
        static NSString *cellIdentifier = @"Cell Identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
           
        }
        cell.textLabel.text=@"Comments";
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    else{
         static NSString *CellIdentifier = @"Cell";
      
        
           NSString*timestamp=[object1[@"createdAt"]  stringWithHumanizedTimeDifference:humanizedType withFullString:YES];
        CommentTableViewCell *cell = (CommentTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setDidcommentselectDelegate:self];
        if ([sharedObj.groupType isEqualToString:@"Public"]) {
            
                    cell.commentLabel.text=[NSString stringWithFormat:@"%@",object1[@"Commenttext"]];
        }
        else{
            cell.namelabel.text=object1[@"UserId"][@"UserName"];
        cell.commentLabel.text=object1[@"Commenttext"];
            

                PFFile*imagefile=object1[@"UserId"][@"ThumbnailPicture"];
                cell.profileimage.file=imagefile;
                [cell.profileimage loadInBackground];

        }
        cell.profileimage.tag=indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timelabel.text=timestamp;
        cell.backgroundColor=[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
    
         return cell;
        
    }
    
    return nil;
    
}
-(void)Profiletap:(int)index8
{
    PFObject *feed = [self.objects objectAtIndex:index8-2];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MemberDetailViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"MemberDetailViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    
 
    PFFile*imagefile=feed[@"UserId"][@"ThumbnailPicture"];
    settingsViewController.MemberimageUrl=imagefile;
    settingsViewController.memberNo=feed[@"UserId"][@"MobileNo"];
    settingsViewController.memberName=feed[@"UserId"][@"UserName"];
    settingsViewController.fromFeed=NO;
        settingsViewController.fromComment=YES;
   [self presentViewController:navController animated:YES completion:nil];
   
}
- (void)attemptOpenURL:(NSURL *)url
{
    BOOL safariCompatible = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"];
    
    if (safariCompatible && [[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",url]]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Account for the load more cell at the bottom of the tableview if we hit the pagination limit:
    if (indexPath.row==0) {
        
        if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Text"]) {
            label=[[UILabel alloc]init];
            [label setFrame:CGRectMake(0,5, self.view.frame.size.width-40, 1000)];
            label.numberOfLines=0;
            label.font=[UIFont fontWithName:@"Lato-regular" size:16.0];
            NSString *animal = sharedObj.feedObject[@"PostText"];
            [label setText:animal];
            [self findFrameFromString:label.text andCorrespondingLabel:label];
            if ([sharedObj.groupType isEqualToString:@"Public"]) {
                tableHeight=  label.frame.size.height+155;
            }
            else
                tableHeight=  label.frame.size.height+165;
        }
        else if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Image"])
        {
            NSString *animal = sharedObj.feedObject[@"ImageCaption"];
            
            label=[[UILabel alloc]init];
            [label setFrame:CGRectMake(0,5, self.view.frame.size.width-40, 1000)];
            label.numberOfLines=0;
            label.font=[UIFont fontWithName:@"Lato-regular" size:16.0];
            
            [label setText:animal];
            [self findFrameFromString:label.text andCorrespondingLabel:label];
            int widthimg=[sharedObj.feedObject[@"ImageWidth"] intValue];
            int heightimg=[sharedObj.feedObject[@"ImageHeight"]intValue];

           

           
            double aspectratio=(double)heightimg/widthimg;
            double difference=aspectratio*(self.tableView.frame.size.width-24);

                         tableHeight= label.frame.size.height+145+difference;
            
           

        }
    }
    else if (indexPath.row==1)
    {
        return 35;
    }
   else if (indexPath.row-2 < self.objects.count) {
      PFObject *object = [self.objects objectAtIndex:indexPath.row-2];
       label=[[UILabel alloc]init];
        [label setFrame:CGRectMake(0,5, 275, 1000)];
       label.numberOfLines=0;
       label.font=[UIFont fontWithName:@"Lato-Medium" size:15.0];
       NSString *animal =[NSString stringWithFormat:@"%@",object[@"Commenttext"]];
       [label setText:animal];
       [self findFrameFromString:label.text andCorrespondingLabel:label];
       tableHeight= label.frame.size.height+75;
    }
    else
        tableHeight= 44.0f;
    
    return tableHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.objects.count>0) {
        return self.objects.count +2 ;
    }
    else
    {
        return self.objects.count + 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
-(void)imageAction:(int)index
{
       
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SHOWIMAGE" object:nil];
    
  
    
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
-(CGFloat)findViewHeight:(CGRect)sender
{
    CGFloat hgValue = sender.origin.y +sender.size.height;
    return hgValue;
}

- (PFQuery *)queryForTable {
   
    
    sharedObj=[Generic sharedMySingleton];
    
   PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"FeedId" equalTo:[Generic sharedMySingleton].FeedId];
    [query whereKey:@"FeedType" equalTo:@"Comment"];
    [query includeKey:@"UserId"];
   [query fromLocalDatastore];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
      //  query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    query.limit=100;
    // Query for posts near our current location.
    
    // Get our current location:
    
    // And set the query to look by location
    
   
  
    [query orderByAscending:@"createdAt"];

   
    return query;
}
-(void)upvoteAction:(int)index
{
    PFObject *feed = sharedObj.feedObject;
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
    [query whereKey:@"FeedId" equalTo:feed.objectId];
    [query whereKey:@"FeedType" equalTo:@"Like"];
    [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if (object[@"upVote"]) {
                object[@"upVote"]=[NSNumber numberWithBool:NO];
                object[@"ActivityLocation"]=point;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                    }
                    if (succeeded) {
                        PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
                        [query whereKey:@"objectId" equalTo:feed.objectId];
                        [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
                        [query whereKey:@"PostStatus" equalTo:@"Active"];
                        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                            if (error) {
                            }
                            else{
                                likeArray=object[@"LikeUserArray"];
                                if ([likeArray containsObject:sharedObj.AccountNumber]) {
                                    [likeArray removeObject:sharedObj.AccountNumber];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    object[@"LikeUserArray"]=likeArray;
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-50]];
                                    
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];

                                        //[self Callrefreshtable];
                                    }];
                                    
                                }
                                else{
                                    [likeArray addObject:sharedObj.AccountNumber];
                                    object[@"LikeUserArray"]=likeArray;
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:50]];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];

                                      //  [self Callrefreshtable];
                                    }];
                                }
                            }
                        }];
                    }
                }];
                
            }
            else
            {
                object[@"upVote"]=[NSNumber numberWithBool:YES];
                object[@"ActivityLocation"]=point;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                    }
                    if (succeeded) {
                        PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
                        [query whereKey:@"objectId" equalTo:feed.objectId];
                        [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
                        [query whereKey:@"PostStatus" equalTo:@"Active"];
                        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                            if (error) {
                            }
                            else{
                                
                                likeArray=object[@"LikeUserArray"];
                                
                                if ([likeArray containsObject:sharedObj.AccountNumber]) {
                                    [likeArray addObject:sharedObj.AccountNumber];
                                  object[@"LikeUserArray"]=likeArray;
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:50]];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                        //[self Callrefreshtable];
                                    }];
                                    
                                }
                                else
                                {
                                    [likeArray removeObject:sharedObj.AccountNumber];
                                    object[@"LikeUserArray"]=likeArray;
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-50]];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                        //[self Callrefreshtable];
                                    }];
                                    
                                    
                                }
                                
                            }
                        }];
                    }
                }];
                
            }
            
            
        }
        else
        {
            PFObject *likeObject=[PFObject objectWithClassName:@"Activity"];
            likeObject[@"GroupId"]=feed[@"GroupId"];
            likeObject[@"FeedId"]=feed.objectId;
            likeObject[@"FeedType"]=@"Like";
            likeObject[@"Commenttext"]=@"";
            likeObject[@"UserName"]=sharedObj.AccountName;
            likeObject[@"MobileNo"]=sharedObj.AccountNumber;
            likeObject[@"upVote"]=[NSNumber numberWithBool:YES];
            likeObject[@"downVote"]=[NSNumber numberWithBool:NO];
            likeObject[@"FlagValue"]=@"";
            likeObject[@"ActivityLocation"]=point;
            PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
            likeObject[@"UserId"]=pointer;
            [likeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Couldn't save!");
                    NSLog(@"%@", error);
                }
                if (succeeded) {
                    PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
                    [query whereKey:@"objectId" equalTo:feed.objectId];
                    [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
                    [query whereKey:@"PostStatus" equalTo:@"Active"];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                        if (error) {
                        }
                        else{
                            likeArray=object[@"LikeUserArray"];
                            [likeArray addObject:sharedObj.AccountNumber];

                            object[@"LikeUserArray"]=likeArray;
                            [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:50]];
                            NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                            [self.tableView beginUpdates];
                            [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                            [self.tableView endUpdates];
                            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                object[@"FeedupdatedAt"]=object.updatedAt;
                                [object saveInBackground];
                                //[self Callrefreshtable];
                            }];
                        }
                    }];
                }
            }];
            
        }
    }];
    
    
    
    
    
}

-(void)downvoteAction:(int)index1
{
    
    PFObject *feed = sharedObj.feedObject;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
    [query whereKey:@"FeedId" equalTo:feed.objectId];
    [query whereKey:@"FeedType" equalTo:@"Like"];
    [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            
            if (object[@"downVote"]) {
                object[@"downVote"]=[NSNumber numberWithBool:NO];
                object[@"ActivityLocation"]=point;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                    }
                    if (succeeded) {
                        PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
                        [query whereKey:@"objectId" equalTo:object[@"FeedId"]];
                        [query whereKey:@"GroupId" equalTo:object[@"GroupId"]];
                        [query whereKey:@"PostStatus" equalTo:@"Active"];
                        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                            if (error) {
                            }
                            else{
                                dislikeArray=object[@"DisLikeUserArray"];

                                if ([dislikeArray containsObject:sharedObj.AccountNumber]) {
                                    [dislikeArray removeObject:sharedObj.AccountNumber];
                                    object[@"DisLikeUserArray"]=dislikeArray;
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:50]];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                        //[self Callrefreshtable];
                                    }];
                                    
                                }
                                else{
                                    [dislikeArray addObject:sharedObj.AccountNumber];
                                    object[@"DisLikeUserArray"]=dislikeArray;
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-50]];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                        //[self Callrefreshtable];
                                    }];
                                }
                            }
                        }];
                    }
                }];
                
                
            }
            else
            {
                
                object[@"downVote"]=[NSNumber numberWithBool:YES];
                object[@"ActivityLocation"]=point;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                    }
                    if (succeeded) {
                        PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
                        [query whereKey:@"objectId" equalTo:object[@"FeedId"]];
                        [query whereKey:@"GroupId" equalTo:object[@"GroupId"]];
                        [query whereKey:@"PostStatus" equalTo:@"Active"];
                        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                            if (error) {
                            }
                            else{
                                dislikeArray=object[@"DisLikeUserArray"];

                                if ([dislikeArray containsObject:sharedObj.AccountNumber]) {
                                    [dislikeArray addObject:sharedObj.AccountNumber];
                                    object[@"DisLikeUserArray"]=dislikeArray;
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-50]];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                       // [self Callrefreshtable];
                                    }];
                                    
                                }
                                else
                                {
                                    [dislikeArray removeObject:sharedObj.AccountNumber];
                                    object[@"DisLikeUserArray"]=dislikeArray;
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:50]];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                        //[self Callrefreshtable];
                                    }];
                                    
                                    
                                }
                            }
                        }];
                    }
                }];
                
                
            }
            
            
        }
        else
        {
            PFObject *likeObject=[PFObject objectWithClassName:@"Activity"];
            likeObject[@"GroupId"]=feed[@"GroupId"];
            likeObject[@"FeedId"]=feed.objectId;
            likeObject[@"FeedType"]=@"Like";
            likeObject[@"Commenttext"]=@"";
            likeObject[@"UserName"]=sharedObj.AccountName;
            likeObject[@"MobileNo"]=sharedObj.AccountNumber;
            likeObject[@"upVote"]=[NSNumber numberWithBool:NO];
            likeObject[@"downVote"]=[NSNumber numberWithBool:YES];
            likeObject[@"FlagValue"]=@"";
            likeObject[@"ActivityLocation"]=point;
            PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
            likeObject[@"UserId"]=pointer;
            [likeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Couldn't save!");
                    NSLog(@"%@", error);
                    
                }
                if (succeeded) {
                    PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
                    [query whereKey:@"objectId" equalTo:feed.objectId];
                    [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
                    [query whereKey:@"PostStatus" equalTo:@"Active"];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                        if (error) {
                        }
                        else{
                            dislikeArray=object[@"DisLikeUserArray"];

                            [dislikeArray addObject:sharedObj.AccountNumber];
                            object[@"DisLikeUserArray"]=dislikeArray;
                            NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                            [self.tableView beginUpdates];
                            [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                            [self.tableView endUpdates];
                            [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-50]];
                            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                object[@"FeedupdatedAt"]=object.updatedAt;
                                [object saveInBackground];
                                //[self Callrefreshtable];
                            }];
                        }
                    }];
                }
            }];
        }
    }];
    
    
    
    
}
-(void)flagAction:(int)index2
{
   // PFObject *feed = sharedObj.feedObject;
    flagindex=index2;
//    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
//    [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
//    [query whereKey:@"FeedId" equalTo:feed.objectId];
//    [query whereKey:@"FeedType" equalTo:@"Flag"];
//    [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        if (!error) {
//        }
//        else
//        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SHOWFLAG1" object:nil];

//        }
//    }];
    
    
    
    
}

-(void)deleteAction:(int)index7
{
    deleteindex=index7;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Are you sure you want to delete this post?"
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
    [alertView show];
    return;
    

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        PFObject *feed = sharedObj.feedObject;
        PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
        [query whereKey:@"PostStatus" equalTo:@"Active"];
        [query getObjectInBackgroundWithId:feed.objectId
                                     block:
         ^(PFObject *object, NSError *error) {
             [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (succeeded) {
                  
                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"DELETEPOST" object:nil];
                                  PFQuery *activityQuery=[PFQuery queryWithClassName:@"Activity"];
                                  [activityQuery whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
                                  [activityQuery whereKey:@"FeedId" equalTo:feed.objectId];
                                  [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                      if (objects.count!=0) {
                                          [PFObject deleteAllInBackground:objects];
                                          
                                      }
                                  }];
                              }
                          }];
                      }
                      ];
                     
                 }
            }

-(void)setFlagValue
{
    PFObject *feed = sharedObj.feedObject;
    PFObject *likeObject=[PFObject objectWithClassName:@"Activity"];
    likeObject[@"GroupId"]=feed[@"GroupId"];
    likeObject[@"FeedId"]=feed.objectId;
    likeObject[@"FeedType"]=@"Flag";
    likeObject[@"Commenttext"]=@"";
    likeObject[@"UserName"]=sharedObj.AccountName;
    likeObject[@"MobileNo"]=sharedObj.AccountNumber;
    likeObject[@"upVote"]=[NSNumber numberWithBool:NO];
    likeObject[@"downVote"]=[NSNumber numberWithBool:NO];
    likeObject[@"FlagValue"]=sharedObj.flagValue;
    likeObject[@"ActivityLocation"]=point;
    PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
    likeObject[@"UserId"]=pointer;
    [likeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Couldn't save!");
            NSLog(@"%@", error);
            [self.view makeToast:@"Couldn't Connect.Try later" duration:3.0 position:@"bottom"];
                   }
        if (succeeded) {
            PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
            [query whereKey:@"objectId" equalTo:feed.objectId];
            [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
            [query whereKey:@"PostStatus" equalTo:@"Active"];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                if (error) {
                }
                else{
                    flagcount=[object[@"FlagCount"]intValue];
                    
                    if (flagcount==2) {
                        
                        object[@"PostStatus"]=@"InActive";
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                [self loadObjects];
                                                                PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
                                [user whereKey:@"MobileNo" equalTo:object[@"UserId"][@"MobileNo"]];
                                [user getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                    userflagcount= [object[@"PostFlagCount"]intValue];
                                    if (userflagcount==3) {
                                        object[@"Suspended"]=[NSNumber numberWithBool:YES];
                                        object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                        object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                        [object saveInBackground];
                                    }else
                                    {
                                        [object incrementKey:@"PostFlagCount" byAmount:[NSNumber numberWithInt:1]];
                                        object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                        object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                        [object saveInBackground];
                                    }
                                    
                                }];
                            }
                        }];
                    }else{
                        
                        object[@"FeedupdatedAt"]=object.updatedAt;

                        [object incrementKey:@"FlagCount" byAmount:[NSNumber numberWithInt:1]];
                        flagUserArray=object[@"FlagArray"];
                        [flagUserArray addObject:sharedObj.AccountNumber];
                        object[@"FlagArray"]=flagUserArray;
                        NSIndexPath *row=[NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView beginUpdates];
                        [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView endUpdates];
                        [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-200]];
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            //[self Callrefreshtable];
                        }];
                    }
                }
            }];
        }
    }];
    

    
    
}
-(void)shareAction:(int)index3 :(UIButton*)sender
{
   
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

-(void)dismissMenu
{
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
                         
                 
                           [self.view makeToast:@"Posted Successfully" duration:3.0 position:@"bottom"];
                         
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
            
            
        }
        
        
        //[mySlcomposerView addURL:[NSURL URLWithString:modal.htmlUrl]];
        
    }
    
    else
    {
          [self.view makeToast:@"You must configure Facebook account for sharing.You can add or create a Facebook/Twitter account in Settings." duration:3.0 position:@"bottom"];
    }
    
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
        
    }
    else
    {
          [self.view makeToast:@"You must configure Twitter account for sharing.You can add or create a Facebook/Twitter account in Settings" duration:3.0 position:@"bottom"];
    }
}



-(void)whatsAppShareSelected:(NSString*)imageUrl
{
    
    NSLog(@"Whats app Sharing Selected");
    if ([MFMessageComposeViewController canSendText]) {
        if (![WhatsAppKit isWhatsAppInstalled]) {
           
              [self.view makeToast:@"You must configure WhatsApp account for sharing" duration:3.0 position:@"bottom"];
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
                    
                      [self.view makeToast:@"You must configure WhatsApp account for sharing" duration:3.0 position:@"bottom"];
                }
                
                
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
