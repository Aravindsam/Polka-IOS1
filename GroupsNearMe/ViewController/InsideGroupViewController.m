//
//  InsideGroupViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/19/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "InsideGroupViewController.h"
#import "FeedViewController.h"
#import "PhotoViewController.h"
#import "GroupInfoViewController.h"
#import <ImageIO/ImageIO.h>
#import "SVProgressHUD.h"
@interface InsideGroupViewController ()

@end

@implementation InsideGroupViewController
@synthesize groupTypeVal;
@synthesize viewControllers;
@synthesize tabBar;
@synthesize	feedTabBarItem;
@synthesize hotTabBarItem;

@synthesize selectedViewController;
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    tap=NO;
    currentdate=[[NSString alloc]init];
    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    ownerNumber=[[NSString alloc]init];
        _grouptitleLabel.text=sharedObj.GroupName;
         [_grouptitleLabel sizeToFit];
    
    _groupImageview.file=sharedObj.groupimageurl;
    [_groupImageview loadInBackground];
    BOOL internetconnect=[sharedObj connected];
    if (internetconnect) {
        PFQuery *member=[PFQuery queryWithClassName:@"MembersDetails"];
        [member whereKey:@"GroupId" equalTo:sharedObj.GroupId];
        [member whereKey:@"MemberNo" equalTo:sharedObj.AccountNumber];
        [member whereKey:@"MemberStatus" equalTo:@"Active"];
        [member includeKey:@"UserId"];

        [member findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *memobj in objects) {
                memobj[@"UnreadMsgCount"]=[NSNumber numberWithInt:0];
                if (internetconnect) {
                    [memobj saveInBackground];
                }
                else
                    [memobj saveEventually];
            }
        }];
    }
//    imagetap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showGroupinfo)];
//    imagetap.numberOfTapsRequired=1;
//    _grouptitleLabel.userInteractionEnabled=YES;
//    _groupImageview.userInteractionEnabled=YES;
//    [_groupImageview addGestureRecognizer:imagetap];
    
    labeltap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showGroupinfo)];
    labeltap.numberOfTapsRequired=1;
    [_headerView addGestureRecognizer:labeltap];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSomething)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    
    [sharedObj setFeedViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    [sharedObj setHotViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"FeedViewController"];
    profileViewController.view.frame=CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height);
   


    PhotoViewController *postViewController = [storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
    postViewController.view.frame=CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height);
   

   
    
    NSArray *array = [[NSArray alloc] initWithObjects:profileViewController, postViewController ,nil];
    self.viewControllers = array;
    
    [self.tabview addSubview:profileViewController.view];
    self.selectedViewController = profileViewController;
    tabBar.selectedItem = feedTabBarItem;
    
    if ([sharedObj.groupType isEqualToString:@"Public"]) {
        NSMutableArray *items = [tabBar.items mutableCopy];
        [items removeObject:hotTabBarItem];
        tabBar.items = items;
        [feedTabBarItem setTitle:@"TEXT ONLY & ANONYMOUS POSTING"];
         feedTabBarItem.selectedImage=[[UIImage imageNamed:@"selected_tab.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        feedTabBarItem.selectedImage=[[UIImage imageNamed:@"selected-left.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        feedTabBarItem.image=[[UIImage imageNamed:@"unselectedtab.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        feedTabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
        hotTabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
        hotTabBarItem.selectedImage=[[UIImage imageNamed:@"selected-right.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        hotTabBarItem.image=[[UIImage imageNamed:@"unselectedtab.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    }
    
    [feedTabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Lato-Medium" size:13.0],
                                                NSForegroundColorAttributeName : [Generic colorFromRGBHexString:@"#A4D7FA"]
                                                } forState:UIControlStateNormal];
    [feedTabBarItem setTitleTextAttributes:@{NSFontAttributeName :[UIFont fontWithName:@"Lato-Medium" size:13.0],
                                                NSForegroundColorAttributeName : [UIColor whiteColor]
                                                } forState:UIControlStateSelected];
    
    
    [hotTabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Lato-Medium" size:13.0],
                                              NSForegroundColorAttributeName :[Generic colorFromRGBHexString:@"#A4D7FA"]
                                              } forState:UIControlStateNormal];
    [hotTabBarItem setTitleTextAttributes:@{NSFontAttributeName :[UIFont fontWithName:@"Lato-Medium" size:13.0],
                                              NSForegroundColorAttributeName : [UIColor whiteColor]
                                              } forState:UIControlStateSelected];
    
    self.tabBar.layer.borderWidth = 1.0;
    self.tabBar.layer.borderColor =[Generic colorFromRGBHexString:headerColor].CGColor;
    self.tabBar.clipsToBounds=YES;
   

    // Do any additional setup after loading the view.
}
- (CGSize)sizeOfImageAtURL:(NSURL *)imageURL
{
    // With CGImageSource we avoid loading the whole image into memory
    CGSize imageSize = CGSizeZero;
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)imageURL, NULL);
    if (source) {
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCGImageSourceShouldCache];
        CFDictionaryRef properties = CFBridgingRetain((__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, 0, (CFDictionaryRef)options));
        if (properties) {
            NSNumber *width = [(__bridge NSDictionary *)properties objectForKey:(NSString *)kCGImagePropertyPixelWidth];
            NSNumber *height = [(__bridge NSDictionary *)properties objectForKey:(NSString *)kCGImagePropertyPixelHeight];
            if ((width != nil) && (height != nil))
                imageSize = CGSizeMake(width.floatValue, height.floatValue);
            CFRelease(properties);
        }
        CFRelease(source);
    }
    return imageSize;
}
- (void)swipe:(UISwipeGestureRecognizer *)swipeRecogniser
{
    //UINavigationController *navController;
    if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"Left");
        if (tabBar.selectedItem==hotTabBarItem) {
            
        }
        else
        {
            UIViewController *moreViewController = [viewControllers objectAtIndex:1];
            [self.selectedViewController.view removeFromSuperview];
            [self.tabview addSubview:moreViewController.view];
            self.selectedViewController = moreViewController;
            tabBar.selectedItem = hotTabBarItem;
        }
    }
    else if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"Right");
        if (tabBar.selectedItem==feedTabBarItem) {
            
        }
        else
        {
            UIViewController *moreViewController = [viewControllers objectAtIndex:0];
            [self.selectedViewController.view removeFromSuperview];
            [self.tabview addSubview:moreViewController.view];
            self.selectedViewController = moreViewController;
            tabBar.selectedItem = feedTabBarItem;
        }
    }
}

-(void)doSomething
{
    [sharedObj setFeedViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    [sharedObj setHotViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _grouptitleLabel.text=sharedObj.GroupName;
    [_grouptitleLabel sizeToFit];
    tap=NO;
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query getObjectInBackgroundWithId:sharedObj.GroupId block:^(PFObject *object, NSError *error) {
        sharedObj.currentgroupAccess=[object[@"MembershipApproval"]boolValue];
        
        sharedObj.currentGroupLocation=object[@"GroupLocation"];
        
    }];
    _groupImageview.file=sharedObj.groupimageurl;
    [_groupImageview loadInBackground];
    [sharedObj setFeedViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    [sharedObj setHotViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH" object:nil];

}


-(void)showGroupinfo
{
    if (tap) {
        return;
    }
    else
    {
        tap=YES;
    }
     [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DISMISSFLAG" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DISMISSMENU" object:nil];
   
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GroupInfoViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"GroupInfoViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
   

   
}
- (void)tabBar:(UITabBar *)tabBar1 didSelectItem:(UITabBarItem *)item
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DISMISSFLAG" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DISMISSMENU" object:nil];

    if (item == feedTabBarItem) {
        
        UIViewController *fabViewController = [viewControllers objectAtIndex:0];
        [self.selectedViewController.view removeFromSuperview];
        [self.tabview addSubview:fabViewController.view];
        self.selectedViewController = fabViewController;
        
    } else if (item == hotTabBarItem) {
       
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"TAPPHOTO" object:nil];
        
        UIViewController *moreViewController = [viewControllers objectAtIndex:1];
        [self.selectedViewController.view removeFromSuperview];
        [self.tabview addSubview:moreViewController.view];
        self.selectedViewController = moreViewController;
    }
    }


- (IBAction)back:(id)sender {
    if (tap) {
        return;    }
    
    [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DISMISSFLAG" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DISMISSMENU" object:nil];
        sharedObj.search=NO;
       [[NSNotificationCenter defaultCenter]postNotificationName:@"SERVICEREFRESH" object:nil];
        if (sharedObj.frommygroup) {
            [[self navigationController]popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MYGROUPSEARCH" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NEARBYSEARCH" object:nil];
        }
        else{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CALLHOME" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setdefault" object:nil];

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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"PostCreated" object:nil];
}

@end
