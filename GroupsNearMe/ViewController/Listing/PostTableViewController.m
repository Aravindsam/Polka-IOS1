//
//  PostTableViewController.m
//  LBG
//
//  Created by Jannath Begum on 3/24/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "PostTableViewController.h"
#import "PublicDetailTableViewCell.h"
#import "WhatsAppKit.h"
#import "SVProgressHUD.h"
#import "PAPLoadMoreCell.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "MemberTableViewCell.h"
#import "CommentViewController.h"
#import "TextTableViewCell.h"
#import "UIImage+ResizeAdditions.h"
#import "MemberDetailViewController.h"
#import "InvitationTableViewCell.h"
#import "KxMenu.h"
#import "Toast+UIView.h"
#import "InviteViewController.h"
#import "PrivateInviteViewController.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface PostTableViewController ()
{
    SLComposeViewController *mySlcomposerView;
    UITapGestureRecognizer *invitetap;

}
@property (nonatomic, strong) UIView *noDataButton;
@property(nonatomic,strong)UIImageView *placeholderImageview;
@property(nonatomic,strong)UILabel*textlabel,*bottomlinelabel;
@property(nonatomic,strong)UILabel *hyperlink,*remainingtext;
@end

@implementation PostTableViewController
@synthesize point;
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        // [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    humanizedType = NSDateHumanizedSuffixAgo;

    mySlcomposerView = [[SLComposeViewController alloc] init];
    likeArray=[[NSMutableArray alloc]init];
     groupMembers=[[NSMutableArray alloc]init];
    adminArray=[[NSMutableArray alloc]init];
    mygroup=[[NSMutableArray alloc]init];
    ownergroup=[[NSMutableArray alloc]init];
    dislikeArray=[[NSMutableArray alloc]init];
    inviteArray=[[NSMutableArray alloc]init];
    flagUserArray=[[NSMutableArray alloc]init];
     unquieArray=[[NSMutableArray alloc]init];
    currentuserMobileNo=[[NSString alloc]init];
    flagArray=[[NSMutableArray alloc]initWithObjects:@"Offensive Content",@"This post targets someone",@"Spam", nil];
    objectidval=[[NSString alloc]init];
    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    self.view.frame=CGRectMake(0, 0, sharedObj.feedViewFrame.size.width, sharedObj.feedViewFrame.size.height-48);
    self.parseClassName = @"GroupFeed";
    self.pullToRefreshEnabled = YES;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PostCreated" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postWasCreated:) name:@"PostCreated" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setFlagValue) name:@"FLAGACTION" object:nil];
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
    
    // The number of comments to show per page
    self.objectsPerPage = 20;
    // The key of the PFObject to display in the label of the default cell style
    self.textKey = @"PostText";
    //self.view.backgroundColor=[UIColor clearColor];
    // Whether the built-in pagination is enabled
    self.paginationEnabled = YES;
    
    self.noDataButton = [[UIView alloc]init];
    [self.noDataButton setBackgroundColor:[UIColor clearColor]];
//    [self.noDataButton setTitle:@"Be the first to post in this Group." forState:UIControlStateNormal];
    
    self.placeholderImageview=[[UIImageView alloc]init];
    self.placeholderImageview.image=[UIImage imageNamed:@"grey-logo.png"];
    [self.noDataButton addSubview:self.placeholderImageview];
    
    self.bottomlinelabel=[[UILabel alloc]init];
    [self.bottomlinelabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.noDataButton addSubview:self.bottomlinelabel];
    
    self.textlabel=[[UILabel alloc]init];
    self.textlabel.text=@"Lets get started.Post something interesting or share a photo.";
    self.textlabel.font=[UIFont fontWithName:@"Lato-Regular" size:16.0];
    self.textlabel.numberOfLines=0;
    [self.noDataButton addSubview:self.textlabel];
    
    self.hyperlink=[[UILabel alloc]init];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Invite others"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    self.hyperlink.attributedText=attributeString;
    self.hyperlink.font=[UIFont fontWithName:@"Lato-Regular" size:16.0];
    self.hyperlink.textColor=[Generic colorFromRGBHexString:headerColor];
    [self.noDataButton addSubview:self.hyperlink];
    
    invitetap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inviteMember)];
    invitetap.numberOfTapsRequired=1.0;
    self.hyperlink.userInteractionEnabled=YES;
    [self.hyperlink addGestureRecognizer:invitetap];
    
    self.remainingtext=[[UILabel alloc]init];
    self.remainingtext.text=@"to your group.";
    self.remainingtext.font=[UIFont fontWithName:@"Lato-Regular" size:16.0];
    [self.noDataButton addSubview:self.remainingtext];
    
    self.noDataButton.hidden = YES;
    [self.view addSubview:self.noDataButton];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshtable) name:@"DELETEPOST" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshtable) name:@"COMMENTADD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSomething)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doSomething) name:@"REFRESH" object:nil];
    self.tableView.separatorColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor colorWithRed:118.0f/255.0f green:117.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
     self.view.backgroundColor=[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissMenu) name:@"DISMISSMENU" object:nil];
  
    // Do any additional setup after loading the view.
}
-(void)refreshtable
{
    [self loadObjects];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [KxMenu dismissMenu];
}
-(void)inviteMember
{
    NSLog(@"Invite");
    if ([sharedObj.groupType isEqualToString:@"Private"]) {
        if ([sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PrivateInviteViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"PrivateInviteViewController"];
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate.navigationController pushViewController:settingsViewController animated:YES];
        }
        else
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InviteViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate.navigationController pushViewController:settingsViewController animated:YES];
            
        }
    }
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InviteViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate.navigationController pushViewController:settingsViewController animated:YES];
    }

}
-(void)upvoteAction:(int)index
{

     PFObject *feed = [self.objects objectAtIndex:index];
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
                                    object[@"LikeUserArray"]=likeArray;
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-50]];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:index inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                       
                                   
                                    }];
                                    
                                }
                                else{
                                    [likeArray addObject:sharedObj.AccountNumber];
                                    object[@"LikeUserArray"]=likeArray;

                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:50]];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:index inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                      
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

                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:50]];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:index inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                                                                                                 }];
                                    
                                }
                                else
                                {
                                    [likeArray removeObject:sharedObj.AccountNumber];
                                    object[@"LikeUserArray"]=likeArray;

                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-50]];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:index inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                     
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
                            NSIndexPath *row=[NSIndexPath indexPathForRow:index inSection:0];
                            [self.tableView beginUpdates];
                            [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                            [self.tableView endUpdates];
                            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                object[@"FeedupdatedAt"]=object.updatedAt;
                                [object saveInBackground];
                                                                                         }];
                        }
                    }];
                }
            }];
 
        }
    }];
    
  
    
}
-(void)comment:(int)index4
{
 [SVProgressHUD dismiss];
     sharedObj.feedObject=[self.objects objectAtIndex:index4];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    sharedObj.FeedId=sharedObj.feedObject.objectId;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navigationController presentViewController:settingsViewController animated:YES completion:nil];
}
-(void)downvoteAction:(int)index1
{
    
    PFObject *feed = [self.objects objectAtIndex:index1];
    
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
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:index1 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                                                                                                   }];

                                }
                                else{
                                [dislikeArray addObject:sharedObj.AccountNumber];
                                  object[@"DisLikeUserArray"]=dislikeArray;
                                [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-50]];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:index1 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    object[@"FeedupdatedAt"]=object.updatedAt;
                                    [object saveInBackground];
                                  
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
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-50]];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:index1 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
                                      
                                    }];

                                }
                                else
                                {
                                    [dislikeArray removeObject:sharedObj.AccountNumber];
                                      object[@"DisLikeUserArray"]=dislikeArray;
                                    [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:50]];
                                    NSIndexPath *row=[NSIndexPath indexPathForRow:index1 inSection:0];
                                    [self.tableView beginUpdates];
                                    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        object[@"FeedupdatedAt"]=object.updatedAt;
                                        [object saveInBackground];
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
                            [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-50]];
                            NSIndexPath *row=[NSIndexPath indexPathForRow:index1 inSection:0];
                            [self.tableView beginUpdates];
                            [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationNone];
                            [self.tableView endUpdates];
                            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                object[@"FeedupdatedAt"]=object.updatedAt;
                                [object saveInBackground];
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
    //PFObject *feed = [self.objects objectAtIndex:index2];
    flagindex=index2;
//    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
//    [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
//    [query whereKey:@"FeedId" equalTo:feed.objectId];
//    [query whereKey:@"FeedType" equalTo:@"Flag"];
//    [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
//
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        if (!error) {
//        }
//        else
//        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SHOWFLAG" object:nil];
//            listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 300, 240)];
//            listView.titleName.text = @"Help us keep this place clean and enjoyable for everyone";
//            listView.datasource = self;
//            listView.delegate = self;
//            [listView show];

//        }
//    }];

    
    
  
}

-(void)setFlagValue
{
    PFObject *feed = [self.objects objectAtIndex:flagindex];
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
                     [object incrementKey:@"PostPoint" byAmount:[NSNumber numberWithInt:-200]];
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [self loadObjects];
                       
                    }];
                    }
                }
            }];
        }
    }];

    
}
-(void)shareAction:(int)index3 :(UIButton*)sender
{
    sharefeed = [self.objects objectAtIndex:index3];
//    NSDictionary *userinfo=[[NSDictionary alloc]initWithObjectsAndKeys:feed
//                            ,@"index",sender,@"Sender", nil];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowShare" object:self userInfo:userinfo];*/

        
//        NSDictionary* userInfo = notification.userInfo;
//        UIButton *sender=userInfo[@"Sender"];
//        shareObj=userInfo[@"index"];
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
       
        if([sharefeed[@"PostType"] isEqualToString:@"Text"])
           {
                __weak typeof(self) weakSelf = self;
              [mySlcomposerView setInitialText:[NSString stringWithFormat:@"%@\n - Shared via Chatterati",sharefeed[@"PostText"]]];
               [mySlcomposerView setCompletionHandler:^(SLComposeViewControllerResult result)
                {
                    if (result == SLComposeViewControllerResultDone)
                    {
                        [weakSelf.view makeToast:@"Posted Successfully" duration:3.0 position:@"bottom"];
                    }
                    
                
                    
                }];
               if ([mySlcomposerView respondsToSelector:@selector(popoverPresentationController)])
               {
                   // iOS 8+
                   AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                   [delegate.navigationController  presentViewController:mySlcomposerView animated:YES completion:nil];
                   // if button or change to self.view.
               }

           }
        else if ([sharefeed[@"PostType"] isEqualToString:@"Image"])
        {
           
                    if (![sharefeed[@"ImageCaption"] isEqualToString:@" "]) {
                        [mySlcomposerView setInitialText:[NSString stringWithFormat:@"%@\n -Shared via Chatterati",sharefeed[@"ImageCaption"]]];
                        [mySlcomposerView addURL:[NSURL URLWithString:ImageData]];
                    }
                    else
                    {
                      [mySlcomposerView addURL:[NSURL URLWithString:ImageData]];
                    }
            __weak typeof(self) weakSelf = self;
          
            [mySlcomposerView setCompletionHandler:^(SLComposeViewControllerResult result)
             {
                 if (result == SLComposeViewControllerResultDone)
                 {
                  
                      [weakSelf.view makeToast:@"Posted Successfully" duration:3.0 position:@"bottom"];
                 }
                     
                 
                 
                 
             }];
            if ([mySlcomposerView respondsToSelector:@selector(popoverPresentationController)])
            {
                // iOS 8+
                AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                [delegate.navigationController  presentViewController:mySlcomposerView animated:YES completion:nil];
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
        if([sharefeed[@"PostType"] isEqualToString:@"Text"])
        {
       [mySlcomposerView setInitialText:[NSString stringWithFormat:@"%@\n - Shared via Chatterati",sharefeed[@"PostText"]]];
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
                AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                [delegate.navigationController  presentViewController:mySlcomposerView animated:YES completion:nil];
                // if button or change to self.view.
            }
            
        }
        else if ([sharefeed[@"PostType"] isEqualToString:@"Image"])
        {
            
            if (![sharefeed[@"ImageCaption"] isEqualToString:@" "]) {
                [mySlcomposerView setInitialText:[NSString stringWithFormat:@"%@\n- Shared via Chatterati",sharefeed[@"ImageCaption"]]];
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
                AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                [delegate.navigationController  presentViewController:mySlcomposerView animated:YES completion:nil];
                // if button or change to self.view.
            }

        }

    }
    else
    {
        
        
         [self.view makeToast:@"You must configure Twitter account for sharing.You can add or create a Facebook/Twitter account in Settings" duration:3.0 position:@"bottom"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        PFObject *feed = [self.objects objectAtIndex:deleteindex];
        PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
        [query whereKey:@"PostStatus" equalTo:@"Active"];
        [query getObjectInBackgroundWithId:feed.objectId
                                     block:
         ^(PFObject *object, NSError *error) {
             [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (succeeded) {
                     [self loadObjects];
                     
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
             
             
         }];

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
            if([sharefeed[@"PostType"] isEqualToString:@"Text"])
            {
                [WhatsAppKit launchWhatsAppWithMessage:[NSString stringWithFormat:@"%@ Via Chatterati",sharefeed[@"PostText"]]];
            }
            else if ([sharefeed[@"PostType"] isEqualToString:@"Image"])
            {
                
//                if (![sharefeed[@"ImageCaption"] isEqualToString:@" "]) {
                
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
                        
                         [self.view makeToast:@"You must configure WhatsApp account for sharing." duration:3.0 position:@"bottom"];
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

#pragma mark -
#pragma mark PFQueryTableViewController
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //const CGRect bounds = self.view.bounds;
    
  
    self.noDataButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, 80);
    self.placeholderImageview.frame=CGRectMake(10, 10, 60, 60);
    self.textlabel.frame=CGRectMake(80, 10, self.view.bounds.size.width-90,40);
    self.hyperlink.frame=CGRectMake(80, 50, 90,20);
    self.remainingtext.frame=CGRectMake(170, 50, 100, 20);
    self.bottomlinelabel.frame=CGRectMake(0, 79, self.view.bounds.size.width, 1.0);
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
        // This method is called before a PFQuery is fired to get more objects
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
-(void)doSomething
{
     [locationManager startUpdatingLocation];
    self.view.frame=CGRectMake(0, 0, sharedObj.feedViewFrame.size.width, sharedObj.feedViewFrame.size.height-48);
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];
    self.view.frame=CGRectMake(0, 0, sharedObj.feedViewFrame.size.width, sharedObj.feedViewFrame.size.height-48);
    
  
}
- (void)postWasCreated {
    
    [SVProgressHUD dismiss];
                [self loadObjects];
           
  
        
    if (self.objects.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }


}
- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

        if ([sharedObj connected]) {
            if (self.objects.count==0) {
                [self callService];
            }
            else
             [self checkUpdates];
        }
   
    
}
-(void)checkUpdates
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
    [query whereKey:@"GroupId" equalTo:[Generic sharedMySingleton].GroupId];
     [query includeKey:@"UserId"];
    [query fromLocalDatastore];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
   
    query.limit=100;
    // Query for posts near our current location.
    
    // Get our current location:
    
    // And set the query to look by location
    [query whereKey:@"PostStatus" equalTo:@"Active"];
    
    if ([[Generic sharedMySingleton].groupType isEqualToString:@"Public"]) {
        [query whereKey:@"PostType" notEqualTo:@"Member"];
    }
    
       // [query includeKey:@"UserName"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        oldcount=(int)objects.count;
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"GroupFeed"];
        query1.limit=100;
        [query1 whereKey:@"GroupId" equalTo:[Generic sharedMySingleton].GroupId];
        [query1 whereKey:@"PostStatus" equalTo:@"Active"];
        [query includeKey:@"UserId"];
        if ([[Generic sharedMySingleton].groupType isEqualToString:@"Public"]) {
            [query1 whereKey:@"PostType" notEqualTo:@"Member"];
        }
        
        // [query includeKey:@"UserName"];
        [query1 orderByDescending:@"updatedAt"];
        [query1 findObjectsInBackgroundWithBlock:^(NSArray *feedobjects, NSError *error) {
            updateCount=(int)feedobjects.count;
            NSLog(@"%d",updateCount);
            NSLog(@"%d",oldcount);
            if (updateCount > oldcount) {
                [self showNewPost];
            }
            if (updateCount==0) {
                self.noDataButton.hidden = NO;
                
            }
            else
            {
                self.noDataButton.hidden = YES;
                
            }
        }
         ];

    }];
    
    
    
   }
-(void)showNewPost
{
    int differ=oldcount-updateCount;
   differ= ABS(differ);
    NSDictionary *aDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:   [NSNumber numberWithInt:differ],@"COUNT", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NEWPOST" object:nil userInfo:aDictionary];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
   
    static NSString *CellIdentifier = @"Cell";
    likeArray=object[@"LikeUserArray"];
    dislikeArray=object[@"DisLikeUserArray"];
    flagUserArray=object[@"FlagArray"];
    
    
    if ([sharedObj.groupType isEqualToString:@"Public"]) {
        
        

        NSString *timestamp =  [[object createdAt] stringWithHumanizedTimeDifference:humanizedType withFullString:YES];
            TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell = [[TextTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            [cell setDidtextselectDelegate:self];
            
            [cell.flagbtn setImage:[UIImage imageNamed:@"flag.png"] forState:UIControlStateNormal];
           
            [cell.deletebtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            [cell.replybtn setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
            cell.deletebtn.hidden=YES;
            cell.flagbtn.hidden=YES;
            cell.profileimageview.hidden=YES;
            cell.profilenamelabel.hidden=YES;
         
                
                currentuserMobileNo=object[@"UserId"][@"MobileNo"];
                if ([sharedObj.AccountNumber isEqualToString:currentuserMobileNo]) {
                    if ([object[@"PostType"] isEqualToString:@"Invitation"]||[object[@"PostType"] isEqualToString:@"Member"])
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
        
            
           
            
            if ([object[@"PostType"] isEqualToString:@"Text"]) {
                cell.textvalLabel.text=object[@"PostText"];
                cell.timelabel.text=timestamp;
                cell.pointlabel.text= [NSString stringWithFormat:@"%@ Points . %@ Replies",object[@"PostPoint"],object[@"CommentCount"]];
                 cell.textvalLabel.hidden=NO;
                cell.postImageview.hidden=YES;
               // [cell.textvalLabel sizeToFit];
                cell.textvalLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
                    // Open URLs
                    
                    [self attemptOpenURL:[NSURL URLWithString:string]];
                    
                    
                };
                
                
            }
            else if ([object[@"PostType"] isEqualToString:@"Image"])
            {
                cell.textvalLabel.text=object[@"ImageCaption"];
                cell.timelabel.text=timestamp;
               cell.pointlabel.text= [NSString stringWithFormat:@"%@ Points . %@ Replies",object[@"PostPoint"],object[@"CommentCount"]];
                cell.postImageview.hidden=NO;
                cell.postImageview.backgroundColor=[UIColor whiteColor];
                NSString *animal = object[@"ImageCaption"];
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

                 // [cell.textvalLabel sizeToFit];
                PFFile *imageFile =[object objectForKey:@"Postimage"];
                
                
                cell.postImageview.file=imageFile;
                [cell.postImageview loadInBackground];
                

                cell.postImageview.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
                cell.textvalLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
                    // Open URLs
                    
                    [self attemptOpenURL:[NSURL URLWithString:string]];
                    
                    
                };
                
            }
          cell.selectionStyle=UITableViewCellEditingStyleNone;
            cell.upvotebtn.tag=indexPath.row;
            cell.downvotebtn.tag=indexPath.row;
            //cell.sharebtn.tag=indexPath.row;
            cell.replybtn.tag=indexPath.row;
            cell.deletebtn.tag=indexPath.row;
            cell.flagbtn.tag=indexPath.row;
             cell.postImageview.tag=indexPath.row;
            cell.backgroundColor=[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
            cell.layer.cornerRadius=5.0;
            cell.clipsToBounds=YES;
            return cell;

    }
    else
    {
        

   NSString *timestamp =  [[object createdAt] stringWithHumanizedTimeDifference:humanizedType withFullString:YES];
        if ([object[@"PostType"] isEqualToString:@"Member"])
        {
            MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell = [[MemberTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setDidMemberselectDelegate:self];

                cell.namelbl.text=[NSString stringWithFormat:@"%@  joined this group",object[@"UserId"][@"UserName"]];
                PFFile*imagefile=object[@"UserId"][@"ThumbnailPicture"];
                cell.profileImageView.file=imagefile;
             [cell.profileImageView loadInBackground];
                [cell.namelbl sizeToFit];
               cell.timelbl.frame=CGRectMake(110, [self findViewHeight:cell.namelbl.frame]+5, cell.timelbl.frame.size.width,20);
            cell.profileImageView.tag=indexPath.row;
            cell.timelbl.text=timestamp;
            cell.backgroundColor=[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];            cell.layer.cornerRadius=5.0;
            cell.clipsToBounds=YES;
            return cell;
            
        }
        else if ([object[@"PostType"] isEqualToString:@"Invitation"])
        {
            InvitationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell = [[InvitationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
                cell.namelbl.text=[NSString stringWithFormat:@"Name : %@",object[@"UserId"][@"UserName"]];
                PFFile*imagefile=object[@"UserId"][@"ThumbnailPicture"];
                cell.profileImageView.file=imagefile;
            [cell.profileImageView loadInBackground];
            
                [cell.namelbl sizeToFit];
                 cell.timelbl.frame=CGRectMake(75, [self findViewHeight:cell.namelbl.frame]+5, cell.timelbl.frame.size.width,20);
            
            [cell setDidinviteselectDelegate:self];
            [cell.acceptbtn setImage:[UIImage imageNamed:@"approve.png"] forState:UIControlStateNormal];
            [cell.rejectbtn setImage:[UIImage imageNamed:@"Reject.png"] forState:UIControlStateNormal];
            cell.timelbl.text=timestamp;
            cell.welcomelbl.text=@"Requested to join";
            cell.backgroundColor=[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
            NSString*temp=object[@"PostText"];
            if ([temp isEqualToString:@"No Information Available"] || [temp isEqualToString:@"No Informations Available"]|| temp.length==0) {
                cell.infolabel.hidden=YES;
                cell.verticallabel.hidden=YES;
                
            }
            else
            {        cell.infolabel.text=object[@"PostText"];
                cell.infolabel.hidden=NO;
                cell.verticallabel.hidden=NO;
                
            }

            cell.acceptbtn.tag=indexPath.row;
            cell.rejectbtn.tag=indexPath.row;
            cell.layer.cornerRadius=5.0;
            cell.clipsToBounds=YES;
            return cell;
        }
        else
        {
        TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[TextTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            [cell setDidtextselectDelegate:self];
        
            [cell.flagbtn setImage:[UIImage imageNamed:@"flag.png"] forState:UIControlStateNormal];
           
            [cell.deletebtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            //[cell.sharebtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
            [cell.replybtn setImage:[UIImage imageNamed:@"comment.png"] forState:UIControlStateNormal];
            cell.deletebtn.hidden=YES;
            cell.flagbtn.hidden=YES;
            cell.profileimageview.hidden=NO;
            cell.profilenamelabel.hidden=NO;
            cell.profileimageview.tag=indexPath.row;

            cell.profilenamelabel.text=object[@"UserId"][@"UserName"];
            PFFile*imagefile=object[@"UserId"][@"ThumbnailPicture"];
            cell.profileimageview.file=imagefile;
            [cell.profileimageview loadInBackground];
            
            currentuserMobileNo=object[@"UserId"][@"MobileNo"];
            if ([sharedObj.AccountNumber isEqualToString:currentuserMobileNo]) {
                if ([object[@"PostType"] isEqualToString:@"Invitation"]||[object[@"PostType"] isEqualToString:@"Member"])
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
        
//        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
//            [self.timeIntervalFormatter setLocale:[NSLocale currentLocale]];
//
//        NSTimeInterval timeInterval = [[object createdAt] timeIntervalSinceNow];
//        NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
            
               NSString *timestamp =  [[object createdAt] stringWithHumanizedTimeDifference:humanizedType withFullString:YES];
              if ([object[@"PostType"] isEqualToString:@"Text"]) {
//            cell.textvalLabel.attributedText=[self filterLinkWithContent:object[@"PostText"]];
               cell.textvalLabel.text=object[@"PostText"];
            cell.timelabel.text=timestamp;
            cell.pointlabel.text= [NSString stringWithFormat:@"%@ Points . %@ Replies",object[@"PostPoint"],object[@"CommentCount"]];
                  //[cell.textvalLabel sizeToFit];
            cell.postImageview.hidden=YES;
           
           cell.textvalLabel.hidden=NO;
            cell.textvalLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
                // Open URLs
              
                [self attemptOpenURL:[NSURL URLWithString:string]];
                
                
            };
        }
        else if ([object[@"PostType"] isEqualToString:@"Image"])
        {
        
            NSString *animal = object[@"ImageCaption"];
            animal=[animal stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
           if (animal == NULL || animal.length ==0) {
               cell.textvalLabel.hidden=YES;
            }
            else
            {
                cell.textvalLabel.hidden=NO;
            }
            
            cell.textvalLabel.text=object[@"ImageCaption"];
            cell.timelabel.text=timestamp;
          cell.pointlabel.text= [NSString stringWithFormat:@"%@ Points . %@ Replies",object[@"PostPoint"],object[@"CommentCount"]];
            cell.postImageview.hidden=NO;
            
            PFFile *imageFile =[object objectForKey:@"Postimage"];
            
            
          // cell.postImageview.imageURL=[NSURL URLWithString:imageFile.url];
         cell.postImageview.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];        
            cell.postImageview.file=imageFile;
            [cell.postImageview loadInBackground];
            cell.textvalLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
                // Open URLs
                
                [self attemptOpenURL:[NSURL URLWithString:string]];
                
                
            };
            
          
            
        }
            cell.upvotebtn.tag=indexPath.row;
            cell.downvotebtn.tag=indexPath.row;
           // cell.sharebtn.tag=indexPath.row;
            cell.replybtn.tag=indexPath.row;
            cell.flagbtn.tag=indexPath.row;
            cell.postImageview.tag=indexPath.row;
            cell.deletebtn.tag=indexPath.row;
            cell.backgroundColor=[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
            cell.layer.cornerRadius=5.0;
            cell.clipsToBounds=YES;
            cell.selectionStyle=UITableViewCellEditingStyleNone;
           //  [cell.contentView sizeToFit];
            return cell;

        }
                }
    
    return nil;

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

#pragma mark -
#pragma mark UITableViewDelegate
-(void)imageAction:(int)index
{
    sharedObj.feedObject=[self.objects objectAtIndex:index];
   
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SHOWFEEDIMAGE" object:nil];
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    // call super because we're a custom subclass.
     [SVProgressHUD dismiss];
     if (indexPath.row < self.objects.count) {
         sharedObj.feedObject=[self.objects objectAtIndex:indexPath.row];
         
         if ([sharedObj.feedObject[@"PostType"] isEqualToString:@"Text"]||[sharedObj.feedObject[@"PostType"] isEqualToString:@"Image"]) {
      
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         CommentViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
         sharedObj.FeedId=sharedObj.feedObject.objectId;
         AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
         [delegate.navigationController presentViewController:settingsViewController animated:YES completion:nil];
         }
         else
         {
             [super tableView:tableView didSelectRowAtIndexPath:indexPath];
             [self loadNextPage];
             [tableView deselectRowAtIndexPath:indexPath animated:YES];
         }
     }
     else{
         [super tableView:tableView didSelectRowAtIndexPath:indexPath];
         [self loadNextPage];
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
     }
    
}
-(void)Profiletap:(int)index8
{
    PFObject *feed = [self.objects objectAtIndex:index8];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MemberDetailViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"MemberDetailViewController"];
    
    PFFile*imagefile=feed[@"UserId"][@"ThumbnailPicture"];
    settingsViewController.MemberimageUrl=imagefile;
    settingsViewController.memberNo=feed[@"UserId"][@"MobileNo"];
    settingsViewController.memberName=feed[@"UserId"][@"UserName"];
    settingsViewController.fromFeed=YES;
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navigationController pushViewController:settingsViewController animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Account for the load more cell at the bottom of the tableview if we hit the pagination limit:
    if (indexPath.row < self.objects.count) {
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        if ([object[@"PostType"] isEqualToString:@"Text"]) {
           tableHeight=  250;
        }
        else if ([object[@"PostType"] isEqualToString:@"Image"])
        {
            
            NSString *animal = object[@"ImageCaption"];
            animal=[animal stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
            
            int widthimg=[object[@"ImageWidth"] intValue];
            int heightimg=[object[@"ImageHeight"]intValue];
            

            
            double aspectratio=(double)heightimg/widthimg;
             double difference=aspectratio*(self.tableView.frame.size.width-20);

                if (animal == NULL || animal.length ==0)
                {

                tableHeight= 155+difference;
                }
                else
                {
                    tableHeight= 195+difference;

                }


                    }
        else if ([object[@"PostType"] isEqualToString:@"Invitation"])
        {
            label=[[UILabel alloc]init];
            [label setFrame:CGRectMake(10,5, self.view.frame.size.width-30, 1000)];
            label.numberOfLines=0;
            label.font=[UIFont fontWithName:@"Lato-regular" size:16.0];
             NSString *animal = object[@"PostText"];
            
            [label setText:animal];
            [self findFrameFromString:label.text andCorrespondingLabel:label];
            
            if ([animal isEqualToString:@"No Information Available"] || [animal isEqualToString:@"No Informations Available"]|| animal.length==0) {
                
                tableHeight= 100;
                
            }
            else
                tableHeight=  label.frame.size.height+140;

            
        }
        else if ([object[@"PostType"] isEqualToString:@"Member"])
        {
            tableHeight=100;
        }
        return tableHeight;

    }
    else
    return 44.0f;
}
-(void)findFrameFromString:(NSString*)string andCorrespondingLabel:(UILabel*) label1
{
    CGSize expectedLableSize =[string sizeWithFont:label1.font constrainedToSize:label1.frame.size lineBreakMode:NSLineBreakByCharWrapping];
    CGRect newFrame =  label1.frame;
    newFrame.size.height = expectedLableSize.height;
    label1.frame =newFrame;
    label1.lineBreakMode = NSLineBreakByCharWrapping;
    label1.numberOfLines=0;
    [label1 sizeToFit];
    
}
-(CGFloat)findViewHeight:(CGRect)sender
{
    CGFloat hgValue = sender.origin.y +sender.size.height;
    return hgValue;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark PAWWallViewControllerSelection



-(void)callService
{
    BOOL internetconnect=[sharedObj connected];
    
    if (internetconnect) {
        PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
        query.limit=100;
        [query whereKey:@"GroupId" equalTo:[Generic sharedMySingleton].GroupId];
        [query whereKey:@"PostStatus" equalTo:@"Active"];
         [query includeKey:@"UserId"];
        if ([[Generic sharedMySingleton].groupType isEqualToString:@"Public"]) {
            [query whereKey:@"PostType" notEqualTo:@"Member"];
        }
        
        // [query includeKey:@"UserName"];
        [query orderByDescending:@"updatedAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count!=0) {
                     self.noDataButton.hidden = YES;
            [PFObject unpinAllObjectsInBackgroundWithName:sharedObj.GroupId];
            [PFObject pinAllInBackground:objects withName:sharedObj.GroupId block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Pinned OK");
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"TAPPHOTO" object:nil];
                    [self loadObjects];
                    
                    
                }else{
                    NSLog(@"Erro: %@", error.localizedDescription);
                }
            
            }];
            }
            else
            {
                self.noDataButton.hidden = NO;

            }
            
        }];
    }
    else
    {
        [self loadObjects];
    }
 
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
    [query whereKey:@"GroupId" equalTo:[Generic sharedMySingleton].GroupId];
    [query includeKey:@"UserId"];

   [query fromLocalDatastore];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
       
    }
    query.limit=100;
    // Query for posts near our current location.
    
    // Get our current location:
   
    // And set the query to look by location
     [query whereKey:@"PostStatus" equalTo:@"Active"];
    
    if ([[Generic sharedMySingleton].groupType isEqualToString:@"Public"]) {
        [query whereKey:@"PostType" notEqualTo:@"Member"];
    }

  
   
   // [query includeKey:@"UserName"];
    [query orderByDescending:@"updatedAt"];
    return query;
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
    if ([sharefeed[@"PostType"] isEqualToString:@"Image"])
    {
        PFFile *imageFile =[sharefeed objectForKey:@"Postimage"];
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
        if (![sharefeed[@"ImageCaption"]isEqualToString:@" "]) {
            [mailAttachment setMessageBody:[NSString stringWithFormat:@"<br><br> %@ <br> <br><br> -- Chatterati", sharefeed[@"ImageCaption"]] isHTML:NO];
        }
        else
        {
             [mailAttachment setMessageBody:[NSString stringWithFormat:@"<br><br><br> <br><br> -- Chatterati"] isHTML:NO];
        }
    }
    else
    {
        [mailAttachment setMessageBody:[NSString stringWithFormat:@"<br><br> %@ <br> <br><br> -- Chatterati", sharefeed[@"PostText"]] isHTML:YES];
    }

   
    
    
    //CHECK SOURCE
    [mailAttachment setToRecipients:[NSArray arrayWithObjects:@"", nil]];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navigationController presentViewController:mailAttachment animated:YES completion:nil];
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
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate.navigationController  dismissViewControllerAnimated:YES completion:nil];
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navigationController  dismissViewControllerAnimated:YES completion:nil];
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

-(void)callInvitationArray
{
               
            if (Accept) {
           PFObject *feed = [self.objects objectAtIndex:acceptindex];
            PFQuery *query11 = [PFQuery queryWithClassName:@"Group"];
            [query11 whereKey:@"objectId" equalTo:feed[@"GroupId"]];

            [query11  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                if (error) {
                    NSLog(@"Data not available insert userdetails");
                    [SVProgressHUD dismiss];
                    
                    
                } else {
                    [userStats incrementKey:@"MemberCount" byAmount:[NSNumber numberWithInt:1]];
                    groupMembers=userStats[@"GroupMembers"];
                    [groupMembers addObject:feed[@"UserId"][@"MobileNo"]];
                    userStats[@"GroupMembers"]=groupMembers;
                    [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            NSString*countstring=[NSString stringWithFormat:@"%@",userStats[@"MemberCount"]];
                            if ([countstring isEqualToString:@"20"]) {
                                
                                [sharedObj.invitationObjectArray removeAllObjects];
                                PFQuery *query1 = [PFQuery queryWithClassName:@"GroupFeed"];
                                [query1 whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                [query1 whereKey:@"PostType" equalTo:@"Invitation"];
                                [query1 whereKey:@"PostStatus" equalTo:@"Active"];
                                [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    if (!error) {
                                        sharedObj.invitationObjectArray=[NSMutableArray arrayWithArray:objects];
                                       
                                        
                                    }
                                    
                                    
                                }];

                                PFQuery *query11 = [PFQuery queryWithClassName:@"UserDetails"];
                                [query11 whereKey:@"MobileNo" containedIn:userStats[@"AdminArray"]];
                                
                                [query11 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    for (PFObject *userStats in objects) {
                                        
                                        [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:1000]];
                                        userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                        userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                        [userStats saveInBackground];
                                    }
                                    
                                    
                                }];
                                
                            }
                            else if([countstring isEqualToString:@"50"])
                            {
                                [sharedObj.invitationObjectArray removeAllObjects];
                                PFQuery *query11 = [PFQuery queryWithClassName:@"GroupFeed"];
                                [query11 whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                [query11 whereKey:@"PostType" equalTo:@"Invitation"];
                                [query11 whereKey:@"PostStatus" equalTo:@"Active"];
                                [query11 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    if (!error) {
                                        sharedObj.invitationObjectArray=[NSMutableArray arrayWithArray:objects];
                                        
                                    }
                                    
                                    
                                }];

                                PFQuery *query1 = [PFQuery queryWithClassName:@"UserDetails"];
                                [query1 whereKey:@"MobileNo" containedIn:userStats[@"AdminArray"]];
                                
                                [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    for (PFObject *userStats in objects) {
                                        
                                        [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:2000]];
                                        userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                        userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                        [userStats saveInBackground];
                                        
                                      
                                    }
                                    
                                    
                                }];
                                
                                
                            }
                            else
                            {
                                [sharedObj.invitationObjectArray removeAllObjects];
                                PFQuery *query11 = [PFQuery queryWithClassName:@"GroupFeed"];
                                [query11 whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                [query11 whereKey:@"PostType" equalTo:@"Invitation"];
                                [query11 whereKey:@"PostStatus" equalTo:@"Active"];
                                [query11 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    if (!error) {
                                        sharedObj.invitationObjectArray=[NSMutableArray arrayWithArray:objects];
                                        
                                    }
                                    
                                    
                                }];

                            }
                            
                            
                            
                            
                        }
                    }];
                    
                }
            }];
            
            }
    else
    {
        
        [sharedObj.invitationObjectArray removeAllObjects];
        PFQuery *query1 = [PFQuery queryWithClassName:@"GroupFeed"];
        [query1 whereKey:@"GroupId" equalTo:sharedObj.GroupId];
        [query1 whereKey:@"PostType" equalTo:@"Invitation"];
        [query1 whereKey:@"PostStatus" equalTo:@"Active"];
        [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                sharedObj.invitationObjectArray=[NSMutableArray arrayWithArray:objects];
                [self loadObjects];
                
            }
            
            
        }];

    }
    

    
}
#pragma mark -
#pragma mark Notifications



-(void)acceptAction:(int)index5
{
    PFObject *feed = [self.objects objectAtIndex:index5];
    acceptindex=index5;
    PFQuery *permission =[PFQuery queryWithClassName:@"Group"];
    
    [permission getObjectInBackgroundWithId:feed[@"GroupId"] block:^(PFObject *object, NSError *error) {
        groupMembers=object[@"GroupMembers"];
        
        if ([groupMembers containsObject:feed[@"UserId"][@"MobileNo"]]) {
            PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
            [user whereKey:@"MobileNo" equalTo:feed[@"UserId"][@"MobileNo"]];
            
            [user getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                inviteArray=object[@"GroupInvitation"];
                [inviteArray removeObject:feed[@"GroupId"]];
                object[@"GroupInvitation"]=inviteArray;
                object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [[NSUserDefaults standardUserDefaults]setObject:inviteArray forKey:@"GroupInvite"];
                        [self callInvitationArray];
                    }
                    
                }];
                
            }];
            
        }
        else{
            PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
            [query whereKey:@"MobileNo" equalTo:feed[@"UserId"][@"MobileNo"]];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                if (error) {
                }
                else{

            approval=[object[@"MembershipApproval"]boolValue];
            sharedObj.currentGroupAdminArray=object[@"AdminArray"];
            if (approval) {
                if ([sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
                    [self AcceptLogic];
                }
                else
                {
                    
                     [self.view makeToast:@"You are not authorised to accept the invitation" duration:3.0 position:@"bottom"];
                    return;
                }
            }
            else
            {
                [self AcceptLogic];
                
            }
                     }}];
        }
    }];
    
    
    
    
    
}
-(void)AcceptLogic

{
    Accept=YES;
    [ownergroup removeAllObjects];
    PFObject *feed = [self.objects objectAtIndex:acceptindex];
    PFObject *member=[PFObject objectWithClassName:@"MembersDetails"];
    member[@"GroupId"]=feed[@"GroupId"];
    member[@"MemberNo"]=feed[@"UserId"][@"MobileNo"];
    member[@"MemberImage"]=feed[@"UserId"][@"ThumbnailPicture"];
    member[@"MemberName"]=feed[@"UserId"][@"UserName"];
    member[@"JoinedDate"]=[NSDate date];
    member[@"AdditionalInfoProvided"]=feed[@"PostText"];
    member[@"ExitGroup"]=[NSNumber numberWithBool:NO];
    member[@"GroupAdmin"]=[NSNumber numberWithBool:NO];
    member[@"LeaveDate"]=[NSDate date];
    member[@"MemberStatus"]=@"Active";
     member[@"UnreadMsgCount"]=[NSNumber numberWithInt:0];
    member[@"ExitedBy"]=@"";
    PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
    
    member[@"UserId"]=pointer;
    [member saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            PFQuery *query1 = [PFQuery queryWithClassName:@"Group"];
            [query1 whereKey:@"MobileNo" equalTo:feed[@"UserId"][@"MobileNo"]];
            
            [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (!error) {
                    if (objects.count!=0) {
                        for (PFObject*owner in objects) {
                            [ownergroup addObject:owner.objectId];
                        }
                        PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
                        [query whereKey:@"MobileNo" equalTo:feed[@"UserId"][@"MobileNo"]];
                        
                        [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                            if (error) {
                                NSLog(@"Data not available insert userdetails");
                                
                                
                                
                            } else {
                                
                                
                                PFObject*activity=[PFObject objectWithClassName:@"InvitationActivity"];
                                activity[@"ByUser"]=sharedObj.AccountNumber;
                                activity[@"ToUser"]=feed[@"UserId"][@"MobileNo"];
                                activity[@"GroupId"]=feed[@"GroupId"];
                                activity[@"InvitationType"]=@"Request";
                                activity[@"Accept"]=[NSNumber numberWithBool:YES];
                                activity[@"ActivityLocation"]=point;
                                [activity saveInBackground];
                                
                                mygroup=userStats[@"MyGroupArray"];
                                unquieArray=[NSMutableArray arrayWithArray:mygroup];
                                [unquieArray removeObjectsInArray:ownergroup];
                                
                                if (unquieArray.count==0) {
                                    [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:1000]];
                                }
                                else{
                                    [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:100]];
                                }
                                mygroup=userStats[@"MyGroupArray"];
                                [mygroup addObject:feed[@"GroupId"]];
                                userStats[@"MyGroupArray"]=mygroup;
                                inviteArray=userStats[@"GroupInvitation"];
                                [inviteArray removeObject:feed[@"GroupId"]];
                                userStats[@"GroupInvitation"]=inviteArray;
                                userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        
                                        PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
                                        [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
                                        [query whereKey:@"objectId" equalTo:feed.objectId];
                                        [query getObjectInBackgroundWithId:feed.objectId
                                                                     block:
                                         ^(PFObject *object, NSError *error) {
                                             object[@"PostStatus"]=@"InActive";
                                             [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                 if (succeeded) {
                                                      [self loadObjects];
                                                     PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
                                                     testObject[@"PostStatus"]=@"Active";
                                                     testObject[@"GroupId"]=feed[@"GroupId"];
                                                     testObject[@"FeedLocation"]=point;
                                                   
                                                     
                                                     
                                                     
                                                     testObject[@"MobileNo"]=feed[@"UserId"][@"MobileNo"];
                                                     testObject[@"PostType"]=@"Member";
                                                     testObject[@"PostText"]=[NSString stringWithFormat:@"%@ - newly joined  this group",feed[@"UserId"][@"UserName"]];
                                                     testObject[@"CommentCount"]=[NSNumber numberWithInt:0];
                                                     testObject[@"PostPoint"]=[NSNumber numberWithInt:0];
                                                     testObject[@"FlagCount"]=[NSNumber numberWithInt:0];
                                                     testObject[@"LikeUserArray"]=[[NSMutableArray alloc]init];
                                                     testObject[@"DisLikeUserArray"]=[[NSMutableArray alloc]init];
                                                     PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                                                     
                                                     testObject[@"UserId"]=pointer;
                                                     testObject[@"FlagArray"]=[[NSMutableArray alloc]init];
                                                     [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                         if (succeeded) {
                                                             testObject[@"FeedupdatedAt"]=testObject.updatedAt;
                                                             [testObject saveInBackground];
                                                             [[NSUserDefaults standardUserDefaults]setObject:inviteArray forKey:@"GroupInvite"];
                                                             [self callInvitationArray];
                                                         }
                                                     }];
                                                     
                                                 }
                                                 
                                             }];
                                             
                                         }];
                                    }
                                }];
                                
                            }
                        }];
                        
                    }
                    
                    else
                    {
                        PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
                        [query whereKey:@"MobileNo" equalTo:feed[@"UserId"][@"MobileNo"]];
                        
                        [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                            if (error) {
                                NSLog(@"Data not available insert userdetails");
                                
                                
                                
                            } else {
                                PFObject*activity=[PFObject objectWithClassName:@"InvitationActivity"];
                                activity[@"ByUser"]=sharedObj.AccountNumber;
                                activity[@"GroupId"]=feed[@"GroupId"];
                                activity[@"ToUser"]=feed[@"UserId"][@"MobileNo"];
                                activity[@"InvitationType"]=@"Request";
                                activity[@"Accept"]=[NSNumber numberWithBool:YES];
                                activity[@"ActivityLocation"]=point;
                                [activity saveInBackground];
                                mygroup=userStats[@"MyGroupArray"];
                                unquieArray=[NSMutableArray arrayWithArray:mygroup];
                                [unquieArray removeObjectsInArray:ownergroup];
                                
                                if (unquieArray.count==0) {
                                    [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:1000]];
                                }
                                else{
                                    [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:100]];
                                }
                                mygroup=userStats[@"MyGroupArray"];
                                [mygroup addObject:feed[@"GroupId"]];
                                userStats[@"MyGroupArray"]=mygroup;
                                inviteArray=userStats[@"GroupInvitation"];
                                [inviteArray removeObject:feed[@"GroupId"]];
                                userStats[@"GroupInvitation"]=inviteArray;
                                userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error) {
                                        
                                        PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
                                        [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
                                        [query whereKey:@"objectId" equalTo:feed.objectId];
                                        
                                        [query getObjectInBackgroundWithId:feed.objectId
                                                                     block:
                                         ^(PFObject *object, NSError *error) {
                                             object[@"PostStatus"]=@"InActive";
                                             [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                 if (succeeded) {
                                                      [self loadObjects];
                                                     PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
                                                     testObject[@"PostStatus"]=@"Active";
                                                     testObject[@"GroupId"]=feed[@"GroupId"];
                                                     testObject[@"FeedLocation"]=point;
                                                     testObject[@"MobileNo"]=feed[@"UserId"][@"MobileNo"];
                                                     testObject[@"PostType"]=@"Member";
                                                     testObject[@"PostText"]=[NSString stringWithFormat:@"%@ - newly joined  this group",feed[@"UserId"][@"UserName"]];
                                                     
                                                     testObject[@"CommentCount"]=[NSNumber numberWithInt:0];
                                                     testObject[@"PostPoint"]=[NSNumber numberWithInt:0];
                                                     testObject[@"FlagCount"]=[NSNumber numberWithInt:0];
                                                     testObject[@"LikeUserArray"]=[[NSMutableArray alloc]init];
                                                     PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                                                     
                                                     testObject[@"UserId"]=pointer;testObject[@"DisLikeUserArray"]=[[NSMutableArray alloc]init];
                                                     testObject[@"FlagArray"]=[[NSMutableArray alloc]init];
                                                     [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                         if (succeeded) {
                                                             testObject[@"FeedupdatedAt"]=testObject.updatedAt;
                                                             [testObject saveInBackground];
                                                             [[NSUserDefaults standardUserDefaults]setObject:inviteArray forKey:@"GroupInvite"];
                                                             [self callInvitationArray];
                                                         }
                                                     }];
                                                     
                                                 }
                                                 
                                             }];
                                             
                                         }];
                                    }
                                }];
                                
                            }
                        }];
                        
                    }
                }
                
            }];
            
        }
    }];
    
    
}
-(void)rejectAction:(int)index6
{
    Accept=NO;
    PFObject *feed = [self.objects objectAtIndex:index6];
    
    PFQuery *permission =[PFQuery queryWithClassName:@"Group"];
    
    [permission getObjectInBackgroundWithId:feed[@"GroupId"] block:^(PFObject *object, NSError *error) {
        approval=[object[@"MembershipApproval"]boolValue];
        
        groupMembers=object[@"GroupMembers"];
        
        if ([groupMembers containsObject:feed[@"UserId"][@"MobileNo"]]) {
            PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
            [user whereKey:@"MobileNo" equalTo:feed[@"UserId"][@"MobileNo"]];
            
            [user getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                inviteArray=object[@"GroupInvitation"];
                [inviteArray removeObject:feed[@"GroupId"]];
                object[@"GroupInvitation"]=inviteArray;
                object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [[NSUserDefaults standardUserDefaults]setObject:inviteArray forKey:@"GroupInvite"];
                        [self callInvitationArray];
                    }
                    
                }];
                
            }];
            
        }
        else{
            
            if (approval) {
                if ([sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
                    PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
                    [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
                    [query whereKey:@"objectId" equalTo:feed.objectId];
                    
                    [query getObjectInBackgroundWithId:feed.objectId
                                                 block:
                     ^(PFObject *object, NSError *error) {
                         object[@"PostStatus"]=@"InActive";
                         [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                             if (succeeded) {
                                  [self loadObjects];
                                 PFObject*activity=[PFObject objectWithClassName:@"InvitationActivity"];
                                 activity[@"ByUser"]=sharedObj.AccountNumber;
                                 activity[@"GroupId"]=feed[@"GroupId"];
                                 activity[@"ToUser"]=feed[@"UserId"][@"MobileNo"];
                                 activity[@"InvitationType"]=@"Request";
                                 activity[@"Accept"]=[NSNumber numberWithBool:NO];
                                 activity[@"ActivityLocation"]=point;
                                 [activity saveInBackground];
                                 
                                 PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
                                 [user whereKey:@"MobileNo" equalTo:feed[@"UserId"][@"MobileNo"]];
                                 
                                 [user getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                     inviteArray=object[@"GroupInvitation"];
                                     [inviteArray removeObject:feed[@"GroupId"]];
                                     object[@"GroupInvitation"]=inviteArray;
                                     object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                     object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                     [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (succeeded) {
                                             [[NSUserDefaults standardUserDefaults]setObject:inviteArray forKey:@"GroupInvite"];
                                             [self callInvitationArray];
                                         }
                                         
                                     }];
                                     
                                 }];
                                 
                                 
                                 
                                 
                             }
                         }];
                         
                         
                     }];
                }
                
                else
                {
                   
                    
                     [self.view makeToast:@"You are not authorised to reject the invitation" duration:3.0 position:@"bottom"];
                    return;
                }
            }
            else
            {
                PFQuery *query = [PFQuery queryWithClassName:@"GroupFeed"];
                [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
                [query whereKey:@"objectId" equalTo:feed.objectId];
                
                [query getObjectInBackgroundWithId:feed.objectId
                                             block:
                 ^(PFObject *object, NSError *error) {
                     [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         if (succeeded) {
                             
                             PFObject*activity=[PFObject objectWithClassName:@"InvitationActivity"];
                             activity[@"ByUser"]=sharedObj.AccountNumber;
                             activity[@"ToUser"]=feed[@"UserId"][@"MobileNo"];
                             activity[@"GroupId"]=feed[@"GroupId"];
                             activity[@"InvitationType"]=@"Request";
                             activity[@"Accept"]=[NSNumber numberWithBool:NO];
                             activity[@"ActivityLocation"]=point;
                             [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                     if (succeeded) {
                                         PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
                                         [user whereKey:@"MobileNo" equalTo:feed[@"UserId"][@"MobileNo"]];
                                         
                                         [user getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                             inviteArray=object[@"GroupInvitation"];
                                             [inviteArray removeObject:feed[@"GroupId"]];
                                             object[@"GroupInvitation"]=inviteArray;
                                             object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                             object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                             [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                 if (succeeded) {
                                                     [[NSUserDefaults standardUserDefaults]setObject:inviteArray forKey:@"GroupInvite"];
                                                     [self callInvitationArray];
                                                 }
                                                 
                                             }];
                                             
                                         }];
                                         
                                         
                                         
                                         
                                     }
                                 }];
                                 
                                 
                             
                         }
                     }];
                 }];
                
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
