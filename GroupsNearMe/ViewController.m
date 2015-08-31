//
//  ViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "ViewController.h"


#import "GroupModalClass.h"
#import "CreateGroupViewController.h"
#import "CommentViewController.h"

#import "StarViewController.h"
#import "Toast+UIView.h"
#import "InsideGroupViewController.h"
#import "InvitationViewController.h"
@interface ViewController ()
{
  
}

@property(nonatomic,strong) NSArray *menuItems;

@end

@implementation ViewController
@synthesize viewControllers;
@synthesize tabBar;
@synthesize	nearbyTabBarItem;
@synthesize mygroupTabBarItem;
@synthesize selectedViewController;
@synthesize thesearchBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedObj=[Generic sharedMySingleton];
    humanizedType = NSDateHumanizedSuffixAgo;
    thesearchBar.frame=CGRectMake(51, 4.5, 260, 35);
    _headerview.backgroundColor=[Generic colorFromRGBHexString:headerColor];
    _searchView.backgroundColor=[Generic colorFromRGBHexString:headerColor];
    
    mygroupIDArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    sharedObj.profileImage=[[NSUserDefaults standardUserDefaults]objectForKey:@"ProfilePicture"];

    currentdate=[[NSString alloc]init];
    thesearchBar.layer.cornerRadius=5.0;
    thesearchBar.clipsToBounds=YES;
    tempnearbyArray=[[NSMutableArray alloc]init];
    resultArray=[[NSMutableArray alloc]init];
    
    
    _indicationlbl.layer.cornerRadius=4.0;
    _indicationlbl.clipsToBounds=YES;
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

   
    
    //Customise UiTabbar
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"NearbyViewController"];
    [sharedObj setNearByViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    profileViewController.view.frame=CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height);
    
    postViewController = [storyboard instantiateViewControllerWithIdentifier:@"MyGroupViewController"];
    [sharedObj setMyGroupViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    postViewController.view.frame=CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height);
    
    
    NSArray *array = [[NSArray alloc] initWithObjects:profileViewController, postViewController ,nil];
    self.viewControllers = array;
    
    _searchView.hidden=YES;
    _headerview.hidden=NO;
    [nearbyTabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Lato-Medium" size:14.0],
                                               NSForegroundColorAttributeName : [Generic colorFromRGBHexString:@"#A4D7FA"]
                                               } forState:UIControlStateNormal];
    [nearbyTabBarItem setTitleTextAttributes:@{NSFontAttributeName :[UIFont fontWithName:@"Lato-Medium" size:14.0],
                                               NSForegroundColorAttributeName : [UIColor whiteColor]
                                               } forState:UIControlStateSelected];
    nearbyTabBarItem.tag=11;
    mygroupTabBarItem.tag=22;
    
    
    [mygroupTabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Lato-Medium" size:14.0],
                                                NSForegroundColorAttributeName : [Generic colorFromRGBHexString:@"#A4D7FA"]
                                                } forState:UIControlStateNormal];
    [mygroupTabBarItem setTitleTextAttributes:@{NSFontAttributeName :[UIFont fontWithName:@"Lato-Medium" size:14.0],
                                                NSForegroundColorAttributeName : [UIColor whiteColor]
                                                } forState:UIControlStateSelected];
    
    
    mygroupTabBarItem.selectedImage=[[UIImage imageNamed:@"selected-right.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mygroupTabBarItem.image=[[UIImage imageNamed:@"unselectedtab.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mygroupTabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    nearbyTabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    nearbyTabBarItem.selectedImage=[[UIImage imageNamed:@"selected-left.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nearbyTabBarItem.image=[[UIImage imageNamed:@"unselectedtab.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBar.layer.borderWidth = 1.0;
    self.tabBar.layer.borderColor =[Generic colorFromRGBHexString:headerColor].CGColor;
    self.tabBar.clipsToBounds=YES;

    
    BOOL internetconnect=[sharedObj connected];
    
    if (internetconnect) {

        PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
        [myquery whereKey:@"objectId" containedIn:mygroupIDArray];
        [myquery whereKey:@"GroupStatus" equalTo:@"Active"];
        [myquery orderByDescending:@"updatedAt"];
        [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"error in geo query!"); // todo why is this ever happening?
            } else {
                
                [PFObject unpinAllObjectsInBackgroundWithName:@"MYGROUP"];
                [PFObject pinAllInBackground:objects withName:@"MYGROUP"];                           }
        }];
        [self CallMyService];
       
    }
  
    if (sharedObj.newUser) {
        [self.tabview addSubview:profileViewController.view];
        self.selectedViewController = profileViewController;
        tabBar.selectedItem = nearbyTabBarItem;
    }
    else{
     
            [self.tabview addSubview:postViewController.view];
            self.selectedViewController = postViewController;
            tabBar.selectedItem = mygroupTabBarItem;
        
    }
   _indicationlbl.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSomething)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movetonearby) name:@"MOVETONEARBY" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shownotification) name:@"NOTIFICATION" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movetoMy) name:@"setdefault" object:nil];
  

}
-(void)shownotification
{
    _indicationlbl.hidden=NO;
}
-(void)CallMyService
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
    [query getObjectInBackgroundWithId:sharedObj.userId block:^(PFObject *object, NSError *error) {
  
        if (error) {
        }
        else{
            [PFObject unpinAllObjectsInBackgroundWithName:@"USERDETAILS"];
            [object pinInBackgroundWithName:@"USERDETAILS"];
            PFFile *imageFile =[object objectForKey:@"ProfilePicture"];
            [[NSUserDefaults standardUserDefaults]setObject:imageFile.url forKey:@"ProfilePicture"];
            [[NSUserDefaults standardUserDefaults]setObject:object[@"GroupInvitation"] forKey:@"GroupInvite"];
            [[NSUserDefaults standardUserDefaults]setObject:object[@"MyGroupArray"] forKey:@"MyGroup"];
            
        }
        
    }];
 
}

-(void)doSomething
{
   
    

    [sharedObj setNearByViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    [sharedObj setMyGroupViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
  
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _indicationlbl.hidden=YES;

    [sharedObj setNearByViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    [sharedObj setMyGroupViewFrame:CGRectMake(0, 0, _tabview.frame.size.width,  _tabview.frame.size.height)];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH" object:nil];

    }
-(void)movetoMy
{
    NSLog(@"ENTERED");
    if (tabBar.selectedItem==mygroupTabBarItem) {
        
    }
    else
    {
        UIViewController *moreViewController = [viewControllers objectAtIndex:1];
        [self.selectedViewController.view removeFromSuperview];
        [self.tabview addSubview:moreViewController.view];
        self.selectedViewController = moreViewController;
         tabBar.selectedItem = mygroupTabBarItem;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)movetonearby
{
    UINavigationController *navController;

    [[NSNotificationCenter defaultCenter]postNotificationName:@"NEARBYSEARCH" object:nil];
    UIViewController *fabViewController = [viewControllers objectAtIndex:0];
    [self.selectedViewController.view removeFromSuperview];
    [self.tabview addSubview:fabViewController.view];
    self.selectedViewController = fabViewController;
    tabBar.selectedItem = nearbyTabBarItem;
    navController =[self.tabBarController.viewControllers objectAtIndex:0];
    [navController viewWillAppear:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    UINavigationController *navController;
    [thesearchBar resignFirstResponder];
    sharedObj.search=NO;
       thesearchBar.text=@"";
    _searchView.hidden=YES;
    _headerview.hidden=NO;
    if (item == nearbyTabBarItem) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NEARBYSEARCH" object:nil];
        UIViewController *fabViewController = [viewControllers objectAtIndex:0];
        [self.selectedViewController.view removeFromSuperview];
        [self.tabview addSubview:fabViewController.view];
        self.selectedViewController = fabViewController;
        navController =[self.tabBarController.viewControllers objectAtIndex:0];
        [navController viewWillAppear:YES];
        
    } else if (item == mygroupTabBarItem) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"MYGROUPSEARCH" object:nil];
        UIViewController *moreViewController = [viewControllers objectAtIndex:1];
        [self.selectedViewController.view removeFromSuperview];
        [self.tabview addSubview:moreViewController.view];
        self.selectedViewController = moreViewController;
        navController =[self.tabBarController.viewControllers objectAtIndex:1];
        [navController viewWillAppear:YES];
    }
   }
- (IBAction)showMenu:(id)sender {
   
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATE PROFILE" object:nil];

    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];

}



- (IBAction)notificationbtnAction:(id)sender {
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NotificationViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    [self.navigationController pushViewController:settingsViewController animated:YES];
    
   
}

- (IBAction)searchbtnAction:(id)sender {

    _searchView.hidden=NO;
    _headerview.hidden=YES;
      [self.thesearchBar becomeFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
     // NSLog(@"%d",tabBar.selectedItem.tag);
    if([searchText isEqualToString:@""] || searchText==nil) {
        // Nothing to search, empty result.
        sharedObj.search=NO;
        if (tabBar.selectedItem.tag==11) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NEARBYSEARCH" object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MYGROUPSEARCH" object:nil];
        }
        

    }
    else
    {
        GroupModalClass *modal;
        sharedObj.search=YES;
        if (tabBar.selectedItem.tag==11) {
            
            [sharedObj.searchNearby removeAllObjects];
            [resultArray removeAllObjects];
            [tempnearbyArray removeAllObjects];
            for (int i=0; i<sharedObj.NearByGroupArray.count; i++) {
                modal = [sharedObj.NearByGroupArray objectAtIndex:i];
                [tempnearbyArray addObject: modal.groupName];
            }
            
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"SELF contains[cd] %@",
                                            searchBar.text];
            
            resultArray = [NSMutableArray arrayWithArray:[tempnearbyArray filteredArrayUsingPredicate:resultPredicate]];
            for (int j=0; j< resultArray.count; j++) {
                arrayindex=(int)[tempnearbyArray indexOfObject:resultArray[j]] ;
                [sharedObj.searchNearby addObject:[sharedObj.NearByGroupArray objectAtIndex:arrayindex]];
            }
           
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NEARBYSEARCH" object:nil];
        }
        else
        {
            [sharedObj.searchmygroup removeAllObjects];
            [resultArray removeAllObjects];
            [tempnearbyArray removeAllObjects];
            for (int i=0; i<sharedObj.MyGroupArray.count; i++) {
                modal = [sharedObj.MyGroupArray objectAtIndex:i];
                [tempnearbyArray addObject: modal.groupName];
            }
            
            NSPredicate *resultPredicate = [NSPredicate
                                            predicateWithFormat:@"SELF contains[cd] %@",
                                            searchBar.text];
            
            resultArray = [NSMutableArray arrayWithArray:[tempnearbyArray filteredArrayUsingPredicate:resultPredicate]];
            for (int j=0; j< resultArray.count; j++) {
                arrayindex= (int)[tempnearbyArray indexOfObject:resultArray[j]];
                [sharedObj.searchmygroup addObject:[sharedObj.MyGroupArray objectAtIndex:arrayindex]];
            }
       
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MYGROUPSEARCH" object:nil];
        }
        

    }

   }

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // searchBarTextDidBeginEditing is called whenever
    // focus is given to the UISearchBar
    // call our activate method so that we can do some
    // additional things when the UISearchBar shows.
    
      }

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the
    // UISearchBar loses focus
    // We don't need to do anything here.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
     // NSLog(@"%d",tabBar.selectedItem.tag);
    GroupModalClass *modal;
    
    [thesearchBar resignFirstResponder];
     sharedObj.search=YES;
    if (tabBar.selectedItem.tag==11) {
      
        [sharedObj.searchNearby removeAllObjects];
        [resultArray removeAllObjects];
        [tempnearbyArray removeAllObjects];
        for (int i=0; i<sharedObj.NearByGroupArray.count; i++) {
            modal = [sharedObj.NearByGroupArray objectAtIndex:i];
            [tempnearbyArray addObject: modal.groupName];
        }
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF contains[cd] %@",
                                        searchBar.text];
        
        resultArray = [NSMutableArray arrayWithArray:[tempnearbyArray filteredArrayUsingPredicate:resultPredicate]];
        for (int j=0; j< resultArray.count; j++) {
            arrayindex=(int)[tempnearbyArray indexOfObject:resultArray[j]] ;
            [sharedObj.searchNearby addObject:[sharedObj.NearByGroupArray objectAtIndex:arrayindex]];
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NEARBYSEARCH" object:nil];
    }
    else
    {
        [sharedObj.searchmygroup removeAllObjects];
        [resultArray removeAllObjects];
        [tempnearbyArray removeAllObjects];
        for (int i=0; i<sharedObj.MyGroupArray.count; i++) {
            modal = [sharedObj.MyGroupArray objectAtIndex:i];
            [tempnearbyArray addObject: modal.groupName];
        }
        
        NSPredicate *resultPredicate = [NSPredicate
                                        predicateWithFormat:@"SELF contains[cd] %@",
                                        searchBar.text];
        
        resultArray = [NSMutableArray arrayWithArray:[tempnearbyArray filteredArrayUsingPredicate:resultPredicate]];
        for (int j=0; j< resultArray.count; j++) {
            arrayindex= (int)[tempnearbyArray indexOfObject:resultArray[j]];
            [sharedObj.searchmygroup addObject:[sharedObj.MyGroupArray objectAtIndex:arrayindex]];
        }
       
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MYGROUPSEARCH" object:nil];
    }
    

}
- (IBAction)userbadgeBtnAction:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StarViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"StarViewController"];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"CANCEL");
    searchBar.text=@"";
     sharedObj.search=NO;
}

- (IBAction)backsearch:(id)sender
{
    [thesearchBar resignFirstResponder];
     sharedObj.search=NO;
    if (tabBar.selectedItem.tag==11) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NEARBYSEARCH" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MYGROUPSEARCH" object:nil];
    }
    
    _searchView.hidden=YES;
    _headerview.hidden=NO;
}

@end
