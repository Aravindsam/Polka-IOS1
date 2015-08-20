//
//  GroupInfoViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/20/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "UpdateGroupProfileViewController.h"
#import "UpdateGroupLocationViewController.h"
#import "UpdateAccessPermissionViewController.h"
#import "InvitationViewController.h"
#import "InviteViewController.h"
#import "PrivateInviteViewController.h"
#import "MembersViewController.h"
#import "Toast+UIView.h"
#define MENU_ITEM_HEIGHT        44
@interface GroupInfoViewController ()

@end

@implementation GroupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    exit=NO;
    currentdate=[[NSString alloc]init];
    memberArray=[[NSMutableArray alloc]init];
    adminArray=[[NSMutableArray alloc]init];
    _groupinfotableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    mygroupArray=[[NSMutableArray alloc]init];
    if ([sharedObj.groupType isEqualToString:@"Open"]) {
         groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP LOCATION",@"GROUP MEMBERS",@"INVITE MEMBERS",@"EXIT GROUP" ,nil];
    }
    else if ([sharedObj.groupType isEqualToString:@"Public"])
    {
         groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP LOCATION",@"INVITE MEMBERS",@"EXIT GROUP" ,nil];
    }
    else{
    
        if ([sharedObj.groupType isEqualToString:@"Secret"]) {
            if (  [sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
                groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP MEMBERS",@"INVITE MEMBERS",@"EXIT GROUP" ,nil];
            }
            else{
                
                if (sharedObj.currentgroupAccess) {
                    groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP MEMBERS",@"INVITE MEMBERS",@"EXIT GROUP" ,nil];
                }
                else
                {
                    groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP MEMBERS",@"INVITE MEMBERS",@"EXIT GROUP" ,nil];
                }
            }
        }
        else{
        
   if (  [sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber])  {
        groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP LOCATION",@"GROUP MEMBERS",@"ACCESS PERMISSIONS",@"INVITE MEMBERS",@"PENDING APPROVALS",@"EXIT GROUP", nil];
    }
    else{
    
    if (sharedObj.currentgroupAccess) {
        groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP LOCATION",@"GROUP MEMBERS",@"INVITE MEMBERS",@"EXIT GROUP", nil];
    }
    else
    {
        groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP LOCATION",@"GROUP MEMBERS",@"INVITE MEMBERS",@"PENDING APPROVALS",@"EXIT GROUP", nil];
    }
    }
        }
    }
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"GroupFeed"];
    [query1 whereKey:@"GroupId" equalTo:sharedObj.GroupId];
    [query1 whereKey:@"PostType" equalTo:@"Invitation"];
    [query1 whereKey:@"PostStatus" equalTo:@"Active"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        invitationcount=(int)objects.count;
    }];

    _grouptitleLabel.text=sharedObj.GroupName;
    //[_grouptitleLabel sizeToFit];
    _groupinfotableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _groupinfotableview.backgroundColor=[UIColor whiteColor];

    _groupImageview.file=sharedObj.groupimageurl;
    [_groupImageview loadInBackground];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([sharedObj.groupType isEqualToString:@"Open"]) {
        groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP LOCATION",@"GROUP MEMBERS",@"INVITE MEMBERS",@"EXIT GROUP" ,nil];
    }
    else if ([sharedObj.groupType isEqualToString:@"Public"])
    {
        groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP LOCATION",@"INVITE MEMBERS",@"EXIT GROUP" ,nil];
    }
    else{
        
        if ([sharedObj.groupType isEqualToString:@"Secret"]) {
            if (  [sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
                groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP MEMBERS",@"INVITE MEMBERS",@"EXIT GROUP" ,nil];
            }
            else{
                
                if (sharedObj.currentgroupAccess) {
                    groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP MEMBERS",@"INVITE MEMBERS",@"EXIT GROUP" ,nil];
                }
                else
                {
                    groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP MEMBERS",@"INVITE MEMBERS",@"EXIT GROUP" ,nil];
                }
            }
        }
        else{
            
            if (  [sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber])  {
                groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP LOCATION",@"GROUP MEMBERS",@"ACCESS PERMISSIONS",@"INVITE MEMBERS",@"PENDING APPROVALS",@"EXIT GROUP", nil];
            }
            else{
                
                if (sharedObj.currentgroupAccess) {
                    groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP LOCATION",@"GROUP MEMBERS",@"INVITE MEMBERS",@"EXIT GROUP", nil];
                }
                else
                {
                    groupInfoArray=[[NSMutableArray alloc]initWithObjects:@"GROUP PROFILE",@"GROUP LOCATION",@"GROUP MEMBERS",@"INVITE MEMBERS",@"PENDING APPROVALS",@"EXIT GROUP", nil];
                }
            }
        }
    }

    _grouptitleLabel.text=sharedObj.GroupName;
     //  [_grouptitleLabel sizeToFit];
    _groupImageview.file=sharedObj.groupimageurl;
    [_groupImageview loadInBackground];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [groupInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 320, 50)];
        titlelabel.tag=111;

        [cell.contentView addSubview:titlelabel];
        UIImageView* separatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49.5, 320, 0.5)];/// change size as you need.
        separatorLineView.image=[UIImage imageNamed:@"line.png"];
        // you
        
        [cell.contentView addSubview:separatorLineView];
    }
   titlelabel= (UILabel *)[cell viewWithTag:111];
    
    titlelabel.text=[NSString stringWithFormat:@" %@",[groupInfoArray objectAtIndex:indexPath.row]];
    titlelabel.font=[UIFont fontWithName:@"Lato-Regular" size:15];
    titlelabel.backgroundColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:111];
    NSString *str = label.text;
    if ([str isEqualToString:@" GROUP PROFILE"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UpdateGroupProfileViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"UpdateGroupProfileViewController"];
        settingsViewController.Fromnearby=NO;

        [[self navigationController]pushViewController:settingsViewController animated:YES];
    }
    else if ([str isEqualToString:@" GROUP LOCATION"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UpdateGroupLocationViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"UpdateGroupLocationViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
    }
    
    else if ([str isEqualToString:@" GROUP MEMBERS"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MembersViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"MembersViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
    }
    else if ([str isEqualToString:@" PENDING APPROVALS"])
    {
        if (invitationcount>0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InvitationViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"InvitationViewController"];
            [self.navigationController pushViewController:settingsViewController animated:YES];
        }
        else{
            [self.view makeToast:@"No Pending Approvals" duration:3.0 position:@"bottom"];
        }
        
    
    }
    else if ([str isEqualToString:@" ACCESS PERMISSIONS"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UpdateAccessPermissionViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"UpdateAccessPermissionViewController"];
        [self.navigationController pushViewController:settingsViewController animated:YES];
        }
    else if ([str isEqualToString:@" INVITE MEMBERS"])
    {
        if ([sharedObj.groupType isEqualToString:@"Private"]) {
            if ([sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                PrivateInviteViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"PrivateInviteViewController"];
                [self.navigationController pushViewController:settingsViewController animated:YES];
            }
            else
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                InviteViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
                [self.navigationController pushViewController:settingsViewController animated:YES];
                
            }
        }
        else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InviteViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
            [self.navigationController pushViewController:settingsViewController animated:YES];
        }
    }
    else if ([str isEqualToString:@" EXIT GROUP"])
    {
        BOOL internetconnect=[sharedObj connected];
        
        if (!internetconnect) {
            [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
            
        }
        else{
        if (exit) {
            return;
        }
        else
        {
            
        PFQuery *groupquery=[PFQuery queryWithClassName:@"Group"];
        [groupquery getObjectInBackgroundWithId:sharedObj.GroupId block:^(PFObject *object, NSError *error) {
             memberCount=[object[@"MemberCount"]intValue];
            if ([sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
                //exit group will delete the group
                if (memberCount ==1) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"Exiting the group will result in this group being deleted permanently. Are you sure you want to exit?"
                                                                       delegate:self
                                                              cancelButtonTitle:@"NO"
                                                              otherButtonTitles:@"YES", nil];
                    alertView.tag=11;
                    [alertView show];
                    return;
                }
                else{
                
                if (sharedObj.currentGroupAdminArray.count>1) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"Are you sure you wish to exit this group?"
                                                                       delegate:self
                                                              cancelButtonTitle:@"NO"
                                                              otherButtonTitles:@"YES", nil];
                    [alertView show];
                    return;
                }
                else{
                
                exit=NO;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"You cannot exit this group as you are the only admin. Make someone else the admin and then try again."
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
                }
                }
            }
            else{
                
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Are you sure you wish to exit this group?"
                                                           delegate:self
                                                  cancelButtonTitle:@"NO"
                                                  otherButtonTitles:@"YES", nil];
        [alertView show];
        return;
            }
        }];
        }
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==11) {
          if (buttonIndex==1) {
        PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
        [user whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
        [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject*userobj=[objects objectAtIndex:0];
            
            mygroupArray=userobj[@"MyGroupArray"];
            [mygroupArray removeObject:sharedObj.GroupId];
            userobj[@"MyGroupArray"]=mygroupArray;
            [[NSUserDefaults standardUserDefaults]setObject:mygroupArray forKey:@"MyGroup"];
            [self CallMyService];
            userobj[@"UpdateImage"]=[NSNumber numberWithBool:NO];
            userobj[@"UpdateName"]=[NSNumber numberWithBool:NO];
            [userobj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                [detailsquery whereKey:@"MemberNo" equalTo:sharedObj.AccountNumber];
                [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    PFQuery*group=[PFQuery queryWithClassName:@"Group"];
                    [group getObjectInBackgroundWithId:sharedObj.GroupId block:^(PFObject *object, NSError *error) {
                        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            PFObject *obj=[objects objectAtIndex:0];
                            obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                            obj[@"ExitedBy"]=@"Own";
                            obj[@"LeaveDate"]=[NSDate date];
                            obj[@"MemberStatus"]=@"InActive";
                            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                
                                PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                                [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                [feedquery whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                                
                                [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    if (objects.count!=0) {
                                        for (PFObject *feedobject in objects) {
                                            feedobject[@"PostStatus"]=@"InActive";
                                            [feedobject saveInBackground];
                                        }
                                        
                                    }
                                    
                                }];
                            }];
                        }];
                    }];
                    
                 
                }];
                
            }];
            
        }];
          }
    }
    else{
    if (buttonIndex==1) {
        exit=YES;
        if ([sharedObj.GroupId isEqualToString:@"Public"]) {
            PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
            [user whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
            [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                PFObject*userobj=[objects objectAtIndex:0];
                
                mygroupArray=userobj[@"MyGroupArray"];
                [mygroupArray removeObject:sharedObj.GroupId];
                userobj[@"MyGroupArray"]=mygroupArray;
                [[NSUserDefaults standardUserDefaults]setObject:mygroupArray forKey:@"MyGroup"];
                [self CallMyService];
                userobj[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                userobj[@"UpdateName"]=[NSNumber numberWithBool:NO];
                [userobj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                    [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                    [detailsquery whereKey:@"MemberNo" equalTo:sharedObj.AccountNumber];
                    [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        PFObject *obj=[objects objectAtIndex:0];
                        obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                        obj[@"ExitedBy"]=@"Own";
                        obj[@"LeaveDate"]=[NSDate date];
                        obj[@"MemberStatus"]=@"InActive";
                        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                            [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                            [feedquery whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                            
                            [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                if (objects.count!=0) {
                                    for (PFObject *feedobject in objects) {
                                        feedobject[@"PostStatus"]=@"InActive";
                                        [feedobject saveInBackground];
                                    }
                                    
                                }
                                
                            }];
                        }];
                    }];
                    
                }];
                
            }];
        
  
        }
        else{
            
            if ([sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
                PFQuery *groupquery=[PFQuery queryWithClassName:@"Group"];
                [groupquery getObjectInBackgroundWithId:sharedObj.GroupId block:^(PFObject *object, NSError *error) {
                    memberCount=[object[@"MemberCount"]intValue];
                    memberArray=object[@"GroupMembers"];
                    [object incrementKey:@"MemberCount" byAmount:[NSNumber numberWithInt:-1]];
                    [memberArray removeObject:sharedObj.AccountNumber];
                    object[@"GroupMembers"]=memberArray;
                    adminArray=object[@"AdminArray"];
                    [adminArray removeObject:sharedObj.AccountNumber];
                    object[@"AdminArray"]=adminArray;
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (memberCount==20) {
                            
                             PFQuery *ownerquery=[PFQuery queryWithClassName:@"UserDetails"];
                            [ownerquery whereKey:@"MobileNo" containedIn:adminArray];
                            [ownerquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                for (PFObject *admin in objects) {
                                    [admin incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:-1000]];
                                    admin[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                    admin[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                    [admin saveInBackground];
                                    
                                }
                                PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
                                [user whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                                [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    PFObject*userobj=[objects objectAtIndex:0];
                                    
                                    mygroupArray=userobj[@"MyGroupArray"];
                                    [mygroupArray removeObject:sharedObj.GroupId];
                                    userobj[@"MyGroupArray"]=mygroupArray;
                                    [[NSUserDefaults standardUserDefaults]setObject:mygroupArray forKey:@"MyGroup"];
                                    [self CallMyService];
                                    userobj[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                    userobj[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                    [userobj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                                        [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                        [detailsquery whereKey:@"MemberNo" equalTo:sharedObj.AccountNumber];
                                        [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                            PFObject *obj=[objects objectAtIndex:0];
                                            obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                                            obj[@"ExitedBy"]=@"Own";
                                            obj[@"LeaveDate"]=[NSDate date];
                                            obj[@"MemberStatus"]=@"InActive";
                                            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                                                [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                                [feedquery whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                                                
                                                [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                                    if (objects.count!=0) {
                                                        for (PFObject *feedobject in objects) {
                                                            feedobject[@"PostStatus"]=@"InActive";
                                                            [feedobject saveInBackground];
                                                        }
                                                        
                                                    }
                                                    
                                                }];
                                            }];
                                        }];
                                        
                                    }];
                                    
                                }];
                            }];
                        }
                        else if(memberCount==50)
                        {
                            PFQuery *ownerquery=[PFQuery queryWithClassName:@"UserDetails"];
                            [ownerquery whereKey:@"MobileNo" containedIn:adminArray];
                            [ownerquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                for (PFObject *admin in objects) {
                                    [admin incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:-2000]];
                                    admin[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                    admin[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                    [admin saveInBackground];
                                    
                                }
                                PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
                                [user whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                                [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    PFObject*userobj=[objects objectAtIndex:0];
                                    
                                    mygroupArray=userobj[@"MyGroupArray"];
                                    [mygroupArray removeObject:sharedObj.GroupId];
                                    userobj[@"MyGroupArray"]=mygroupArray;
                                    [[NSUserDefaults standardUserDefaults]setObject:mygroupArray forKey:@"MyGroup"];
                                    [self CallMyService];
                                    userobj[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                    userobj[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                    [userobj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                                        [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                        [detailsquery whereKey:@"MemberNo" equalTo:sharedObj.AccountNumber];
                                        [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                            PFObject *obj=[objects objectAtIndex:0];
                                            obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                                            obj[@"ExitedBy"]=@"Own";
                                            obj[@"LeaveDate"]=[NSDate date];
                                            obj[@"MemberStatus"]=@"InActive";
                                            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                                                [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                                [feedquery whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                                                
                                                [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                                    if (objects.count!=0) {
                                                        for (PFObject *feedobject in objects) {
                                                            feedobject[@"PostStatus"]=@"InActive";
                                                            [feedobject saveInBackground];
                                                        }
                                                        
                                                    }
                                                    
                                                }];
                                            }];
                                        }];
                                        
                                    }];
                                    
                                }];
                            }];
                        }
                        else
                        {
                            PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
                            [user whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                            [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                PFObject*userobj=[objects objectAtIndex:0];
                                
                                mygroupArray=userobj[@"MyGroupArray"];
                                [mygroupArray removeObject:sharedObj.GroupId];
                                userobj[@"MyGroupArray"]=mygroupArray;
                                [[NSUserDefaults standardUserDefaults]setObject:mygroupArray forKey:@"MyGroup"];
                                [self CallMyService];
                                userobj[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                userobj[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                [userobj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                                    [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                    [detailsquery whereKey:@"MemberNo" equalTo:sharedObj.AccountNumber];
                                    [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                        PFObject *obj=[objects objectAtIndex:0];
                                        obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                                        obj[@"ExitedBy"]=@"Own";
                                        obj[@"LeaveDate"]=[NSDate date];
                                        obj[@"MemberStatus"]=@"InActive";
                                        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                            PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                                            [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                            [feedquery whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                                            
                                            [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                                if (objects.count!=0) {
                                                    for (PFObject *feedobject in objects) {
                                                        feedobject[@"PostStatus"]=@"InActive";
                                                        [feedobject saveInBackground];
                                                    }
                                                    
                                                }
                                                
                                            }];
                                        }];
                                    }];
                                    
                                }];
                                
                            }];
                        }
                    }];
                }];
                
            }else{
        PFQuery *groupquery=[PFQuery queryWithClassName:@"Group"];
        [groupquery getObjectInBackgroundWithId:sharedObj.GroupId block:^(PFObject *object, NSError *error) {
             adminArray=object[@"AdminArray"];
                memberCount=[object[@"MemberCount"]intValue];
                memberArray=object[@"GroupMembers"];
                [object incrementKey:@"MemberCount" byAmount:[NSNumber numberWithInt:-1]];
                [memberArray removeObject:sharedObj.AccountNumber];
                object[@"GroupMembers"]=memberArray;
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (memberCount==20) {
                    
                    PFQuery *ownerquery=[PFQuery queryWithClassName:@"UserDetails"];
                    [ownerquery whereKey:@"MobileNo" containedIn:adminArray];
                    [ownerquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        for (PFObject *admin in objects) {
                            [admin incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:-1000]];
                            admin[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                            admin[@"UpdateName"]=[NSNumber numberWithBool:NO];
                            [admin saveInBackground];
                            
                        }
                        PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
                        [user whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                        [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            PFObject*userobj=[objects objectAtIndex:0];
                            
                            mygroupArray=userobj[@"MyGroupArray"];
                            [mygroupArray removeObject:sharedObj.GroupId];
                            userobj[@"MyGroupArray"]=mygroupArray;
                            [[NSUserDefaults standardUserDefaults]setObject:mygroupArray forKey:@"MyGroup"];
                            [self CallMyService];
                            userobj[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                            userobj[@"UpdateName"]=[NSNumber numberWithBool:NO];
                            [userobj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                                [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                [detailsquery whereKey:@"MemberNo" equalTo:sharedObj.AccountNumber];
                                [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    PFObject *obj=[objects objectAtIndex:0];
                                    obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                                    obj[@"ExitedBy"]=@"Own";
                                    obj[@"LeaveDate"]=[NSDate date];
                                    obj[@"MemberStatus"]=@"InActive";
                                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                                        [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                        [feedquery whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                                        
                                        [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                            if (objects.count!=0) {
                                                for (PFObject *feedobject in objects) {
                                                    feedobject[@"PostStatus"]=@"InActive";
                                                    [feedobject saveInBackground];
                                                }
                                                
                                            }
                                            
                                        }];
                                    }];
                                }];
                                
                            }];
                            
                        }];
                    }];
                }
                else if(memberCount==50)
                {
                    PFQuery *ownerquery=[PFQuery queryWithClassName:@"UserDetails"];
                    [ownerquery whereKey:@"MobileNo" containedIn:adminArray];
                    [ownerquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        for (PFObject *admin in objects) {
                            [admin incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:-2000]];
                            admin[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                            admin[@"UpdateName"]=[NSNumber numberWithBool:NO];
                            [admin saveInBackground];
                            
                        }
                        PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
                        [user whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                        [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            PFObject*userobj=[objects objectAtIndex:0];
                            
                            mygroupArray=userobj[@"MyGroupArray"];
                            [mygroupArray removeObject:sharedObj.GroupId];
                            userobj[@"MyGroupArray"]=mygroupArray;
                            [[NSUserDefaults standardUserDefaults]setObject:mygroupArray forKey:@"MyGroup"];
                            [self CallMyService];
                            userobj[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                            userobj[@"UpdateName"]=[NSNumber numberWithBool:NO];
                            [userobj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                                [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                [detailsquery whereKey:@"MemberNo" equalTo:sharedObj.AccountNumber];
                                [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    PFObject *obj=[objects objectAtIndex:0];
                                    obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                                    obj[@"ExitedBy"]=@"Own";
                                    obj[@"LeaveDate"]=[NSDate date];
                                    obj[@"MemberStatus"]=@"InActive";
                                    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                                        [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                        [feedquery whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                                        
                                        [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                            if (objects.count!=0) {
                                                for (PFObject *feedobject in objects) {
                                                    feedobject[@"PostStatus"]=@"InActive";
                                                    [feedobject saveInBackground];
                                                }
                                                
                                            }
                                            
                                        }];
                                    }];
                                }];
                                
                            }];
                            
                        }];
                    }];
                }
                else
                {
                    PFQuery *user=[PFQuery queryWithClassName:@"UserDetails"];
                    [user whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                    [user findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        PFObject*userobj=[objects objectAtIndex:0];
                        
                        mygroupArray=userobj[@"MyGroupArray"];
                        [mygroupArray removeObject:sharedObj.GroupId];
                        userobj[@"MyGroupArray"]=mygroupArray;
                        [[NSUserDefaults standardUserDefaults]setObject:mygroupArray forKey:@"MyGroup"];
                        [self CallMyService];
                        userobj[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                        userobj[@"UpdateName"]=[NSNumber numberWithBool:NO];
                        [userobj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            PFQuery *detailsquery=[PFQuery queryWithClassName:@"MembersDetails"];
                            [detailsquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                            [detailsquery whereKey:@"MemberNo" equalTo:sharedObj.AccountNumber];
                            [detailsquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                PFObject *obj=[objects objectAtIndex:0];
                                obj[@"ExitGroup"]=[NSNumber numberWithBool:YES];
                                obj[@"ExitedBy"]=@"Own";
                                obj[@"LeaveDate"]=[NSDate date];
                                obj[@"MemberStatus"]=@"InActive";
                                [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    PFQuery*feedquery=[PFQuery queryWithClassName:@"GroupFeed"];
                                    [feedquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                    [feedquery whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
                                    
                                    [feedquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                        if (objects.count!=0) {
                                            for (PFObject *feedobject in objects) {
                                                feedobject[@"PostStatus"]=@"InActive";
                                                [feedobject saveInBackground];
                                            }
                                            
                                        }
                                        
                                    }];
                                }];
                            }];
                            
                        }];
                        
                    }];
                }
                }];
        }];
                
    }
        }
    }
    else
    {
        exit=NO;
    }
    }
}
-(void)CallMyService
{
    
    mygroupArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
    [myquery whereKey:@"objectId" containedIn:mygroupArray];
    [myquery whereKey:@"GroupStatus" equalTo:@"Active"];
    [myquery orderByDescending:@"updatedAt"];
    [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            
            [PFObject unpinAllObjectsInBackgroundWithName:@"MYGROUP"];
            [PFObject pinAllInBackground:objects withName:@"MYGROUP"];
        }
    }];

                if ([sharedObj.Starting isEqualToString:@"1"]) {
                    [[self navigationController]popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                }
                else
                {
                    if ([sharedObj.Starting isEqualToString:@"2"]) {
                        [[self navigationController]popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
                    }
                    else if ([sharedObj.Starting isEqualToString:@"3"]){
                        [[self navigationController]popToViewController:[self.navigationController.viewControllers objectAtIndex:4] animated:YES];
                    }
                    
                }
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH" object:nil];
                
//            }
//        }
//    }];
    
    
    
}

- (IBAction)back:(id)sender
{
    if (exit) {
        return;
    }
    else
    {
        exit=NO;
    [[self navigationController]popViewControllerAnimated:YES];
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
