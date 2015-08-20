//
//  PendingInviteViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/2/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "PendingInviteViewController.h"
#import "GroupModalClass.h"
#import "SVPullToRefresh.h"
#import "InvitesTableViewCell.h"
#import "Toast+UIView.h"
#import "SVProgressHUD.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface PendingInviteViewController ()

@end

@implementation PendingInviteViewController
@synthesize point;
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    humanizedType = NSDateHumanizedSuffixAgo;
    _headerView.backgroundColor=[Generic colorFromRGBHexString:headerColor];
    
    currentdate=[[NSString alloc]init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        // [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
  

    myGroupIdArray=[[NSMutableArray alloc]init];
     groupMembers=[[NSMutableArray alloc]init];
    invitesIdArray=[[NSMutableArray alloc]init];
    ownerGroup=[[NSMutableArray alloc]init];
    
    sharedObj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    self.invitationtableview.separatorColor = [UIColor clearColor];
    _invitationtableview.backgroundColor=[UIColor clearColor];
 
    
    [ownerGroup removeAllObjects];
    PFQuery *query1 = [PFQuery queryWithClassName:@"Group"];
    [query1 whereKey:@"MobileNo" equalTo:sharedObj.AccountNumber];
    [query1 whereKey:@"CountryName" equalTo:sharedObj.AccountCountry];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count!=0) {
                for (PFObject*owner in objects) {
                    [ownerGroup addObject:owner.objectId];
                }
            }
        }
        
    }];
    
    [_invitationtableview setHidden:YES];
    [_noresultView setHidden:YES];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"Can't Connect" duration:3.0 position:@"bottom"];
        
    }
    else{
        [SVProgressHUD show];
    [invitesIdArray removeAllObjects];
    PFQuery *invitesquery=[PFQuery queryWithClassName:@"Invitation"];
    [invitesquery whereKey:@"ToUser" equalTo:sharedObj.AccountNumber];
    [invitesquery whereKey:@"InvitationStatus" equalTo:@"Active"];
    [invitesquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        for (PFObject*inviteobj in objects) {
            [invitesIdArray addObject:inviteobj[@"GroupId"]];
        }
        
        if (invitesIdArray.count!=0) {
            [self callInvites];
        }
        else
        {
            [SVProgressHUD dismiss];
            [sharedObj.MyinvitesArray removeAllObjects];
            if (sharedObj.MyinvitesArray.count!=0) {
                [_invitationtableview setHidden:NO];
                [_noresultView setHidden:YES];
                [_invitationtableview reloadData];
            }
            else
            {
                [_invitationtableview setHidden:YES];
                 [_noresultView setHidden:NO];
            }
            
            
        }

    }];
    }

    [locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate

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

-(void)callInvites
{
    [sharedObj.MyinvitesArray removeAllObjects];
    PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
    [myquery whereKey:@"objectId" containedIn:invitesIdArray];
    [myquery whereKey:@"GroupStatus" equalTo:@"Active"];
    [myquery orderByDescending:@"updatedAt"];
    [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            
            if(objects.count!=0){
                
                [sharedObj.MyinvitesArray removeAllObjects];
                for (PFObject *group in objects) {
                    GroupModalClass *modal =  [[GroupModalClass alloc]init];
                    [modal setGroupId:group.objectId];
                     [modal setGroupAdminArray:[group objectForKey:@"AdminArray"]];
                    [modal setGroupOwner:[group objectForKey:@"MobileNo"]];
                    [modal setGroupName:[group objectForKey:@"GroupName"]];
                    [modal setGroupType:[group objectForKey:@"GroupType"]];
                    [modal setGroupDescription:[group objectForKey:@"GroupDescription"]];
                    [modal setMemberCount:[[group objectForKey:@"MemberCount"]intValue]];
                      [modal setGroupMemberArray:[group objectForKey:@"GroupMembers"]];
                   
                    NSString *timestamp = [[group createdAt] stringWithHumanizedTimeDifference:humanizedType withFullString:YES];
                    [modal setTimeVal:timestamp];
                    [modal setFeedcount:[[group objectForKey:@"NewsFeedCount"]intValue]];
                    [modal setGroupChannelArray:[group objectForKey:@"GreenChannel"]];
                    [modal setAddInfoRequired:[[group objectForKey:@"AdditionalInfoRequired"]boolValue]];
                    [modal setAddinfoString:[group objectForKey:@"InfoRequired"]];
                    PFFile *imageFile=[group objectForKey:@"GroupPicture"];
                    [modal setGroupImageData:imageFile];
                    [modal setSecretCode:[group objectForKey:@"SecretCode"]];
                    [sharedObj.MyinvitesArray addObject:modal];
                    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
                    //        [us setObject:tempDate forKey:@"LASTUPDATED"];
                    [us setObject:[NSDate date] forKey:@"LASTUPDATED"];
                    
                    [us synchronize];
                    
                    [self.invitationtableview.pullToRefreshView setLastUpdatedDate:[us objectForKey:@"LASTUPDATED"]];
                }
             
                if (sharedObj.MyinvitesArray.count!=0) {
                    [_invitationtableview setHidden:NO];
                    [_noresultView setHidden:YES];
                    [_invitationtableview reloadData];
                }
                else
                {
                    [_invitationtableview setHidden:YES];
                    [_noresultView setHidden:NO];
                }
                
                   [SVProgressHUD dismiss];
                
            }
            else
            {[SVProgressHUD dismiss];
                
                [sharedObj.MyinvitesArray removeAllObjects];
                if (sharedObj.MyinvitesArray.count!=0) {
                    [_invitationtableview setHidden:NO];
                    [_noresultView setHidden:YES];
                    [_invitationtableview reloadData];
                }
                else
                {
                    [_invitationtableview setHidden:YES];
                    [_noresultView setHidden:NO];
                }
                
            }
        }
    }];
    
    
    
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sharedObj.MyinvitesArray.count;
    
    
}
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    InvitesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[InvitesTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    [cell setDidinviteselectDelegate:self];
    cell.backgroundColor=[UIColor clearColor];

    [cell.acceptbtn setImage:[UIImage imageNamed:@"approve.png"] forState:UIControlStateNormal];
    [cell.rejectbtn setImage:[UIImage imageNamed:@"Reject.png"] forState:UIControlStateNormal];
    if (sharedObj.MyinvitesArray.count!=0) {
        GroupModalClass *modal = [sharedObj.MyinvitesArray objectAtIndex:indexPath.row];
        
        cell.groupImageview.file=modal.groupImageData;
        [cell.groupImageview loadInBackground];
        cell.groupnamelbl.text=modal.groupName;
      
        if (modal.memberCount==1) {
            cell.memberlabel.text=[NSString stringWithFormat:@"%d",modal.memberCount];
        }
        
        else
            cell.memberlabel.text=[NSString stringWithFormat:@"%d",modal.memberCount];
        
    }
    cell.acceptbtn.tag=indexPath.row;
    cell.rejectbtn.tag=indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
-(void)acceptAction:(int)index
{
    GroupModalClass *modal;
    indexval=index;
    modal = [sharedObj.MyinvitesArray objectAtIndex:index];
    myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    unquieArray=[NSMutableArray arrayWithArray:myGroupIdArray];
    [unquieArray removeObjectsInArray:ownerGroup];
    
    [SVProgressHUD show];
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query getObjectInBackgroundWithId:modal.groupId block:^(PFObject *userStats, NSError *error) {
        if (error) {
            NSLog(@"Data not available insert userdetails");
            [SVProgressHUD dismiss];
  
        } else {
            groupMembers=userStats[@"GroupMembers"];
            PFGeoPoint *grouploc=[userStats objectForKey:@"GroupLocation"];
            grouplocation=[[CLLocation alloc]initWithLatitude:grouploc.latitude longitude:grouploc.longitude];
            userlocation=[[CLLocation alloc]initWithLatitude:point.latitude longitude:point.longitude];
            distancefromgroup=[userlocation distanceFromLocation:grouplocation];

            if ([groupMembers containsObject:sharedObj.AccountNumber]) {
                PFQuery *invite=[PFQuery queryWithClassName:@"Invitation"];
                [invite whereKey:@"ToUser" equalTo:sharedObj.AccountNumber];
                [invite whereKey:@"GroupId" equalTo:modal.groupId];
                [invite getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                object[@"InvitationStatus"]=@"InActive";
                [object saveInBackground];
                    
                           [invitesIdArray removeAllObjects];
                            PFQuery *invitesquery=[PFQuery queryWithClassName:@"Invitation"];
                            [invitesquery whereKey:@"ToUser" equalTo:sharedObj.AccountNumber];
                            [invitesquery whereKey:@"InvitationStatus" equalTo:@"Active"];
                            [invitesquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                               
                                for (PFObject*inviteobj in objects) {
                                    [invitesIdArray addObject:inviteobj[@"GroupId"]];
                                }
                                
                                if (invitesIdArray.count!=0) {
                                    [self callInvites];
                                }
                                else
                                {
                                    [sharedObj.MyinvitesArray removeAllObjects];
                                     [SVProgressHUD dismiss];
                                    if (sharedObj.MyinvitesArray.count!=0) {
                                        [_invitationtableview setHidden:NO];
                                        [_noresultView setHidden:YES];
                                        [_invitationtableview reloadData];
                                    }
                                    else
                                    {
                                        [_invitationtableview setHidden:YES];
                                         [_noresultView setHidden:NO];
                                    }
                                    
                                    
                                }
                                
                               
                                
                                
                                
                            }];
                            
                            
                }];
                
            }
            else
            {
                
                
                if (distancefromgroup <= 500) {
                PFObject *member=[PFObject objectWithClassName:@"MembersDetails"];
                member[@"GroupId"]=modal.groupId;
                member[@"MemberNo"]=sharedObj.AccountNumber;
                member[@"JoinedDate"]=[NSDate date];
                member[@"AdditionalInfoProvided"]=@"";
                member[@"GroupAdmin"]=[NSNumber numberWithBool:NO];
                member[@"UnreadMsgCount"]=[NSNumber numberWithInt:0];
                member[@"ExitGroup"]=[NSNumber numberWithBool:NO];
                member[@"LeaveDate"]=[NSDate date];
                member[@"MemberStatus"]=@"Active";
                member[@"ExitedBy"]=@"";
                PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                    
                member[@"UserId"]=pointer;
                [member saveInBackground];
                
                
              [userStats incrementKey:@"MemberCount" byAmount:[NSNumber numberWithInt:1]];
              [groupMembers addObject:sharedObj.AccountNumber];
              userStats[@"GroupMembers"]=groupMembers;
              [userStats saveInBackground];
              
            
                    
                    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
                    [query getObjectInBackgroundWithId:sharedObj.userId block:^(PFObject *object, NSError *error) {
                        if (error) {
                            NSLog(@"Data not available insert userdetails");
                            
                            
                        } else {
                            if (unquieArray.count==0) {
                                [object incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:1000]];
                            }
                            else{
                                [object incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:100]];
                            }
                            mygroup=object[@"MyGroupArray"];
                            [mygroup addObject:modal.groupId];
                            object[@"MyGroupArray"]=mygroup;
                             [self CallMyService];
                            [[NSUserDefaults standardUserDefaults]setObject:mygroup forKey:@"MyGroup"];
                            object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                            object[@"UpdateName"]=[NSNumber numberWithBool:NO];
                            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (!error) {
                                    PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
                                    testObject[@"PostStatus"]=@"Active";
                                    
                                    testObject[@"GroupId"]=modal.groupId;
                                    testObject[@"MobileNo"]=sharedObj.AccountNumber;
                                    testObject[@"PostType"]=@"Member";
                                    testObject[@"PostText"]=[NSString stringWithFormat:@"%@ - newly joined  this group",sharedObj.AccountName];
                                    testObject[@"CommentCount"]=[NSNumber numberWithInt:0];
                                    testObject[@"PostPoint"]=[NSNumber numberWithInt:0];
                                    testObject[@"FlagCount"]=[NSNumber numberWithInt:0];
                                    testObject[@"LikeUserArray"]=[[NSMutableArray alloc]init];
                                    testObject[@"DisLikeUserArray"]=[[NSMutableArray alloc]init];
                                    testObject[@"FlagArray"]=[[NSMutableArray alloc]init];
                                    testObject[@"FeedLocation"]=point;
                                    PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                                    testObject[@"UserId"]=pointer;
                                    testObject[@"FeedupdatedAt"]=[NSDate date];
                                    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        
                                      
                                    }];
                                    
                                   
                                   
                                    
                                    
                                }
                            }];
                            
                        }
                    }];
                    
                    
                    NSString*countstring=[NSString stringWithFormat:@"%@",userStats[@"MemberCount"]];
                    if ([countstring isEqualToString:@"20"]) {
                        PFQuery *query1 = [PFQuery queryWithClassName:@"UserDetails"];
                        [query1 whereKey:@"MobileNo" containedIn:modal.groupAdminArray];
                        
                        [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            for (PFObject *userStats in objects) {
                                
                                [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:1000]];
                                userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                [userStats saveInBackground];
                            }
                            
                            
                        }];
                        
                    }
                    else if([countstring isEqualToString:@"50"])
                    {PFQuery *query1 = [PFQuery queryWithClassName:@"UserDetails"];
                        [query1 whereKey:@"MobileNo" containedIn:modal.groupAdminArray];
                        
                        [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            for (PFObject *userStats in objects) {
                                
                                [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:2000]];
                                userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                [userStats saveInBackground];
                            }
                            
                            
                        }];
                        
                    }
                    

               
                    
                }
           
            
      
                
                else
                {
                    [SVProgressHUD dismiss];
                  
                     [self.view makeToast:@"You need to be within the groups visibility range to part of this group. Once you are in range you will be part of this group.." duration:3.0 position:@"bottom"];
                }
            }
            
    }
        
    }];

}
-(void)CallMyService
{
    myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
    [myquery whereKey:@"objectId" containedIn:myGroupIdArray];
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

    GroupModalClass *modal;
    modal = [sharedObj.MyinvitesArray objectAtIndex:indexval];
    
                PFQuery *invite=[PFQuery queryWithClassName:@"Invitation"];
                [invite whereKey:@"ToUser" equalTo:sharedObj.AccountNumber];
                [invite whereKey:@"GroupId" equalTo:modal.groupId];
                [invite getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    
                    object[@"InvitationStatus"]=@"InActive";
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            
                            PFQuery *invitesquery=[PFQuery queryWithClassName:@"Invitation"];
                            [invitesquery whereKey:@"ToUser" equalTo:sharedObj.AccountNumber];
                            [invitesquery whereKey:@"InvitationStatus" equalTo:@"Active"];
                            [invitesquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                [invitesIdArray removeAllObjects];
                                for (PFObject*inviteobj in objects) {
                                    [invitesIdArray addObject:inviteobj[@"GroupId"]];
                                }
                                
                                if (invitesIdArray.count!=0) {
                                    [self callInvites];
                                }
                                else
                                {
                                    [sharedObj.MyinvitesArray removeAllObjects];
                                     [SVProgressHUD dismiss];
                                    if (sharedObj.MyinvitesArray.count!=0) {
                                        [_invitationtableview setHidden:NO];
                                        [_noresultView setHidden:YES];
                                        [_invitationtableview reloadData];
                                    }
                                    else
                                    {
                                        [_invitationtableview setHidden:YES];
                                         [_noresultView setHidden:NO];
                                    }
                                    
                                    
                                }
                                
                                PFQuery *act=[PFQuery queryWithClassName:@"InvitationActivity"];
                                [act whereKey:@"ByUser" equalTo:sharedObj.AccountNumber];
                                [act whereKey:@"GroupId" equalTo:modal.groupId];
                                [act findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    
                                    if (!error) {
                                        
                                        if (objects.count!=0) {
                                        
                                        for (PFObject *object in objects) {
                                            object[@"Accept"]=[NSNumber numberWithBool:YES];
                                            object[@"ActivityLocation"]=point;
                                            [object saveInBackground];

                                        }
                                        }
                                        else
                                        {
                                            PFObject*activity=[PFObject objectWithClassName:@"InvitationActivity"];
                                            activity[@"ByUser"]=sharedObj.AccountNumber;
                                            activity[@"ToUser"]=sharedObj.AccountNumber;
                                            activity[@"InvitationType"]=@"Invites";
                                            activity[@"GroupId"]=modal.groupId;
                                            activity[@"Accept"]=[NSNumber numberWithBool:YES];
                                            activity[@"ActivityLocation"]=point;
                                            [activity saveInBackground];
                                        }
                                    }
                                    else
                                    {
                                        PFObject*activity=[PFObject objectWithClassName:@"InvitationActivity"];
                                        activity[@"ByUser"]=sharedObj.AccountNumber;
                                         activity[@"ToUser"]=sharedObj.AccountNumber;
                                        activity[@"InvitationType"]=@"Invites";
                                        activity[@"GroupId"]=modal.groupId;
                                        activity[@"Accept"]=[NSNumber numberWithBool:YES];
                                        activity[@"ActivityLocation"]=point;
                                        [activity saveInBackground];
                                    }
                                    
                                }];
                                
                                
                                
                            }];
                            
                            
                        }
                    }];
                }];
                 
    
    
}

-(void)rejectAction:(int)index
{
    [SVProgressHUD show];
    GroupModalClass*modal=[sharedObj.MyinvitesArray objectAtIndex:index];
    PFQuery *invite=[PFQuery queryWithClassName:@"Invitation"];
    [invite whereKey:@"ToUser" equalTo:sharedObj.AccountNumber];
    [invite whereKey:@"GroupId" equalTo:modal.groupId];
    [invite getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        object[@"InvitationStatus"]=@"InActive";
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                 [invitesIdArray removeAllObjects];
                PFQuery *invitesquery=[PFQuery queryWithClassName:@"Invitation"];
                [invitesquery whereKey:@"ToUser" equalTo:sharedObj.AccountNumber];
                [invitesquery whereKey:@"InvitationStatus" equalTo:@"Active"];
                [invitesquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                   
                    for (PFObject*inviteobj in objects) {
                        [invitesIdArray addObject:inviteobj[@"GroupId"]];
                    }
                    
                    if (invitesIdArray.count!=0) {
                        [self callInvites];
                    }
                    else
                    {
                        [sharedObj.MyinvitesArray removeAllObjects];
                        [SVProgressHUD dismiss];
                        if (sharedObj.MyinvitesArray.count!=0) {
                            [_invitationtableview setHidden:NO];
                            [_noresultView setHidden:YES];
                            [_invitationtableview reloadData];
                        }
                        else
                        {
                            [_invitationtableview setHidden:YES];
                             [_noresultView setHidden:NO];
                        }
                        
                        
                    }
                    
                    PFQuery *act=[PFQuery queryWithClassName:@"InvitationActivity"];
                    [act whereKey:@"ByUser" equalTo:sharedObj.AccountNumber];
                    [act whereKey:@"GroupId" equalTo:modal.groupId];
                    [act findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        
                        if (!error) {
                            for (PFObject *object in objects) {
                                object[@"Accept"]=[NSNumber numberWithBool:YES];
                                object[@"ActivityLocation"]=point;
                                [object saveInBackground];
                                
                            }
                        }
                        else
                        {
                      
                    PFObject*activity=[PFObject objectWithClassName:@"InvitationActivity"];
                    activity[@"ByUser"]=sharedObj.AccountNumber;
                    activity[@"GroupId"]=modal.groupId;
                     activity[@"ToUser"]=sharedObj.AccountNumber;
                    activity[@"InvitationType"]=@"Invites";
                    activity[@"Accept"]=[NSNumber numberWithBool:NO];
                    activity[@"ActivityLocation"]=point;
                    [activity saveInBackground];
                        }
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
   [[NSNotificationCenter defaultCenter]postNotificationName:@"CALLHOME" object:nil];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"SERVICEREFRESH" object:nil];
    
}
@end
