//
//  MenuListViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/24/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "MenuListViewController.h"
#import "MenuTableViewCell.h"
#import "ViewController.h"
#import "SettingViewController.h"
#import "TermsViewController.h"
#import "ContactUsViewController.h"
#import "PendingInviteViewController.h"
#import "Generic.h"
#define MENU_ITEM_HEIGHT        44
@interface MenuListViewController ()
{
    Generic *sharedObj;
}
@end

@implementation MenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    _headerView.backgroundColor=[Generic colorFromRGBHexString:headerColor];
//    _profileimageview.layer.cornerRadius=40;
//    _profileimageview.clipsToBounds=YES;
    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    _Menulist_tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    menuimageArray=[NSArray arrayWithObjects:@"profile.png",@"create.png",@"pending.png",@"settings.png",@"",@"",@"",@"", nil];
    menuArray=[NSArray arrayWithObjects:@"My Profile",@"Create Group",@"Pending Invites",@"Settings",@"Terms of Service",@"Privacy Policy",@"Policies and Guidelines",@"Contact Us", nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateprof) name:@"UPDATE PROFILE" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callHomeMethod) name:@"CALLHOME" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callcreateMethod) name:@"CALLCREATE" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callinvitesMethod) name:@"CALLINVITES" object:nil];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)updateprof
{
    _namelabel.text=sharedObj.AccountName;
    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
    [query whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
    [query whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
    [query fromLocalDatastore];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error) {
        }
        else{
            PFFile *imageFile =[object objectForKey:@"ProfilePicture"];
       
    _profileimageview.file=imageFile;
    [_profileimageview loadInBackground];
        }
    }];
}
-(void)callcreateMethod
{
    [self.Menulist_tableview.delegate tableView:self.Menulist_tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    [self.Menulist_tableview.delegate tableView:self.Menulist_tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [self.Menulist_tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}
-(void)callinvitesMethod
{
    [self.Menulist_tableview.delegate tableView:self.Menulist_tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    [self.Menulist_tableview.delegate tableView:self.Menulist_tableview didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [self.Menulist_tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}
-(void)callHomeMethod
{
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [[self navigationController]pushViewController:settingsViewController animated:YES];
    NSArray *controllers = [NSArray arrayWithObject:settingsViewController];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell Identifier";
    
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [cell.titleLabel setTextColor:[UIColor blackColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
    }
    
    [cell setBackgroundColor:[UIColor whiteColor]];
//    if (indexPath.row==0) {
//       cell.menuImageview.frame=CGRectMake(10, 14.5, 16,14);
//        cell.titleLabel.frame=CGRectMake(40, 0, 320, 45);
//
////        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, 320, 0.5)];/// change size as you need.
////        separatorLineView.backgroundColor = [UIColor lightGrayColor];// you can also put image here
////        separatorLineView.alpha=0.6;
////
////        [cell.contentView addSubview:separatorLineView];
//        cell.titleLabel.textColor=[UIColor blackColor];
//
//
//    }
     if(indexPath.row==0)
    {
        cell.menuImageview.frame=CGRectMake(10, 14.5,16, 16);
        cell.titleLabel.frame=CGRectMake(40, 0, 320, 45);
        cell.titleLabel.textColor=[UIColor blackColor];


    }
    else if(indexPath.row==1)
    {
        cell.menuImageview.frame=CGRectMake(10, 14.5, 16, 16);
        cell.titleLabel.frame=CGRectMake(40, 0, 320, 45);
        cell.titleLabel.textColor=[UIColor blackColor];


    }
    else if(indexPath.row==2)
    {
        cell.menuImageview.frame=CGRectMake(10, 14.5, 16, 16);
        cell.titleLabel.frame=CGRectMake(40, 0, 320, 45);
        cell.titleLabel.textColor=[UIColor blackColor];


    }
    else if(indexPath.row==3)
    {
        cell.menuImageview.frame=CGRectMake(10, 14.5, 16, 16);
        cell.titleLabel.frame=CGRectMake(40, 0, 320, 45);

        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, 320, 0.5)];/// change size as you need.
        separatorLineView.backgroundColor = [UIColor lightGrayColor];// you can also put image here
        separatorLineView.alpha=0.6;
        [cell.contentView addSubview:separatorLineView];
          cell.titleLabel.textColor=[UIColor blackColor];
    }
    else
    {
        cell.titleLabel.frame=CGRectMake(10, 0, 320, 45);
           cell.titleLabel.textColor=[UIColor lightGrayColor];
    }
    
    cell.titleLabel.text = [menuArray objectAtIndex:indexPath.row];
 
    cell.titleLabel.font=[UIFont fontWithName:@"Lato-Regular" size:15];
        cell.menuImageview.image=[UIImage imageNamed:[menuimageArray objectAtIndex:indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   
    
    cell.menuImageview.backgroundColor=[UIColor whiteColor];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   if (indexPath.row==0)
    {
        
        ProfileViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
        NSArray *controllers = [NSArray arrayWithObject:settingsViewController];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
   else  if (indexPath.row==1) {
    
        CreateGroupViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CreateGroupViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
        NSArray *controllers = [NSArray arrayWithObject:settingsViewController];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

    }
   
    
    else if (indexPath.row==2) {
        

  
     
        PendingInviteViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"PendingInviteViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
        NSArray *controllers = [NSArray arrayWithObject:settingsViewController];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if(indexPath.row==3)
    {
        SettingViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
        NSArray *controllers = [NSArray arrayWithObject:settingsViewController];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if (indexPath.row==4 )
    {
    sharedObj.fromRegister=NO;
        TermsViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
        settingsViewController.headerTitle=@"Terms of Service";
        settingsViewController.UrlString=@"http://groupsnearme.com/Registration/TermsOfUseMobile";
        [[self navigationController]pushViewController:settingsViewController animated:YES];
        NSArray *controllers = [NSArray arrayWithObject:settingsViewController];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else if (indexPath.row==5)
    {
      sharedObj.fromRegister=NO;
        TermsViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
        settingsViewController.headerTitle=@"Privacy Policy";
        settingsViewController.UrlString=@"http://groupsnearme.com/Registration/PrivacyPolicyMobile";
        [[self navigationController]pushViewController:settingsViewController animated:YES];
        NSArray *controllers = [NSArray arrayWithObject:settingsViewController];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];    }
    else if (indexPath.row==6)
    {
        sharedObj.fromRegister=NO;
        TermsViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"TermsViewController"];
        settingsViewController.headerTitle=@"Policies and Guidelines";
        settingsViewController.UrlString=@"http://groupsnearme.com/Registration/RulesMobile";
        [[self navigationController]pushViewController:settingsViewController animated:YES];
        NSArray *controllers = [NSArray arrayWithObject:settingsViewController];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
    else if (indexPath.row==7)
    {
      
        ContactUsViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
        NSArray *controllers = [NSArray arrayWithObject:settingsViewController];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
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


@end
