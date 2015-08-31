//
//  InvitationViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/5/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "InvitationViewController.h"
#import "InvitationTableViewCell.h"
#import "SVPullToRefresh.h"
#import "Toast+UIView.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface InvitationViewController ()

@end

@implementation InvitationViewController
@synthesize point;
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    humanizedType = NSDateHumanizedSuffixAgo;
    sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];

    groupMembers=[[NSMutableArray alloc]init];
    adminArray=[[NSMutableArray alloc]init];
    mygroup=[[NSMutableArray alloc]init];
    ownergroup=[[NSMutableArray alloc]init];
    inviteArray=[[NSMutableArray alloc]init];
    unquieArray=[[NSMutableArray alloc]init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        // [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
  

    [sharedObj.invitationObjectArray removeAllObjects];
    [self refreshService];
    __weak InvitationViewController *weakSelf = self;
    [_invitationtableview addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.invitationtableview beginUpdates];
            
                            [weakSelf refreshService];
            
            [weakSelf.invitationtableview endUpdates];
            [weakSelf.invitationtableview.pullToRefreshView stopAnimating];
        });
    }];
    _invitationtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}
-(void)refreshService
{
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"Can't Connect" duration:3.0 position:@"bottom"];
        
    }
    else{
    PFQuery *query1 = [PFQuery queryWithClassName:@"GroupFeed"];
        [query1 includeKey:@"UserId"];

    [query1 whereKey:@"GroupId" equalTo:sharedObj.GroupId];
    [query1 whereKey:@"PostType" equalTo:@"Invitation"];
    [query1 whereKey:@"PostStatus" equalTo:@"Active"];
         [query1 includeKey:@"UserId"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        sharedObj.invitationObjectArray=[NSMutableArray arrayWithArray:objects];
        NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
        //        [us setObject:tempDate forKey:@"LASTUPDATED"];
        [us setObject:[NSDate date] forKey:@"LASTUPDATED"];
        
        [us synchronize];
        
        [self.invitationtableview.pullToRefreshView setLastUpdatedDate:[us objectForKey:@"LASTUPDATED"]];
        if (sharedObj.invitationObjectArray.count==0) {
            _invitationtableview.hidden=YES;
            _noresultlabel.hidden=NO;
        }
        else
        {
            _invitationtableview.hidden=NO;
            _noresultlabel.hidden=YES;
            
        }
        [_invitationtableview reloadData];

    }];
    }
 
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return sharedObj.invitationObjectArray.count;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
   
    
    InvitationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[InvitationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    PFObject*inviteobj=[sharedObj.invitationObjectArray objectAtIndex:indexPath.row];
   
        cell.namelbl.text=[NSString stringWithFormat:@"%@",inviteobj[@"UserId"][@"UserName"]];
        PFFile*imagefile=inviteobj[@"UserId"][@"ThumbnailPicture"];
        cell.profileImageView.file=imagefile;
    [cell.profileImageView loadInBackground];
        [cell.namelbl sizeToFit];
        cell.timelbl.frame=CGRectMake(75, [self findViewHeight:cell.namelbl.frame]+5, cell.timelbl.frame.size.width,20);
    
    [cell setDidinviteselectDelegate:self];

    NSString *timestamp =[[inviteobj createdAt] stringWithHumanizedTimeDifference:humanizedType withFullString:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell.acceptbtn setImage:[UIImage imageNamed:@"approve.png"] forState:UIControlStateNormal];
    [cell.rejectbtn setImage:[UIImage imageNamed:@"Reject.png"] forState:UIControlStateNormal];
    cell.timelbl.text=timestamp;
//    [cell.timelbl sizeToFit];
    cell.welcomelbl.text=@"Requested to join";
    cell.backgroundColor=[UIColor clearColor];
    //cell.additionallabel.text=@"Additional Info";
    NSString*temp=inviteobj[@"PostText"];
    if ([temp isEqualToString:@"No Information Available"] || [temp isEqualToString:@"No Informations Available"]|| temp.length==0) {
        cell.infolabel.hidden=YES;
        cell.verticallabel.hidden=YES;

    }
    else
    {        cell.infolabel.text=inviteobj[@"PostText"];
        cell.infolabel.hidden=NO;
        cell.verticallabel.hidden=NO;
       
    }
    cell.acceptbtn.tag=indexPath.row;
    cell.rejectbtn.tag=indexPath.row;
    cell.layer.cornerRadius=5.0;
    cell.clipsToBounds=YES;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject*object=[sharedObj.invitationObjectArray objectAtIndex:indexPath.row];
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

    return tableHeight;

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)acceptAction:(int)index5
{
    PFObject *feed = [sharedObj.invitationObjectArray objectAtIndex:index5];
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
    PFObject *feed = [sharedObj.invitationObjectArray objectAtIndex:acceptindex];
    
    
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
    member[@"ExitedBy"]=@"";
    member[@"UnreadMsgCount"]=[NSNumber numberWithInt:0];
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
                                [query includeKey:@"UserId"];

                                [query whereKey:@"GroupId" equalTo:feed[@"GroupId"]];
                                [query whereKey:@"objectId" equalTo:feed.objectId];
                                [query getObjectInBackgroundWithId:feed.objectId
                                                             block:
                                 ^(PFObject *object, NSError *error) {
                                     object[@"PostStatus"]=@"InActive";
                                     [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (succeeded) {
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
                                             testObject[@"FlagArray"]=[[NSMutableArray alloc]init];
                                             PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                                             
                                             testObject[@"UserId"]=pointer;
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
                                [query includeKey:@"UserId"];

                                [query whereKey:@"objectId" equalTo:feed.objectId];
                                
                                [query getObjectInBackgroundWithId:feed.objectId
                                                             block:
                                 ^(PFObject *object, NSError *error) {
                                     object[@"PostStatus"]=@"InActive";
                                     [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (succeeded) {
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
                                             testObject[@"FlagArray"]=[[NSMutableArray alloc]init];
                                             PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                                             
                                             testObject[@"UserId"]=pointer;
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
    PFObject *feed = [sharedObj.invitationObjectArray objectAtIndex:index6];
    
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
                [query includeKey:@"UserId"];

                [query getObjectInBackgroundWithId:feed.objectId
                                             block:
                 ^(PFObject *object, NSError *error) {
                     object[@"PostStatus"]=@"InActive";
                     [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         if (succeeded) {
                             
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
            [query includeKey:@"UserId"];

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
                         [activity  saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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

-(void)callInvitationArray
{
    
  
            
            if (Accept) {
                PFObject *feed = [sharedObj.invitationObjectArray objectAtIndex:acceptindex];
                PFQuery *query11 = [PFQuery queryWithClassName:@"Group"];
                [query11 whereKey:@"objectId" equalTo:feed[@"GroupId"]];

                [query11  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                    if (error) {
                        NSLog(@"Data not available insert userdetails");
                        
                        
                    } else {
                        [userStats incrementKey:@"MemberCount" byAmount:[NSNumber numberWithInt:1]];
                        groupMembers=userStats[@"GroupMembers"];
                        adminArray=userStats[@"AdminArray"];
                        [groupMembers addObject:feed[@"UserId"][@"MobileNo"]];
                        userStats[@"GroupMembers"]=groupMembers;
                        [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                NSString*countstring=[NSString stringWithFormat:@"%@",userStats[@"MemberCount"]];
                                if ([countstring isEqualToString:@"20"]) {
                                    [sharedObj.invitationObjectArray removeAllObjects];
                                    PFQuery *query1 = [PFQuery queryWithClassName:@"GroupFeed"];
                                    [query1 whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                    [query1 includeKey:@"UserId"];

                                    [query1 whereKey:@"PostType" equalTo:@"Invitation"];
                                    [query1 whereKey:@"PostStatus" equalTo:@"Active"];
                                    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                        if (!error) {
                                            sharedObj.invitationObjectArray=[NSMutableArray arrayWithArray:objects];
                                            if (sharedObj.invitationObjectArray.count==0) {
                                                _invitationtableview.hidden=YES;
                                                _noresultlabel.hidden=NO;
                                            }
                                            else
                                            {
                                                _invitationtableview.hidden=NO;
                                                _noresultlabel.hidden=YES;
                                                
                                            }
                                            [_invitationtableview reloadData];
                                        }
                                        
                                        
                                    }];
                                    

                                    PFQuery *ownerquery=[PFQuery queryWithClassName:@"UserDetails"];
                                    [ownerquery whereKey:@"MobileNo" containedIn:adminArray];
                                    [ownerquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                        for (PFObject *admin in objects) {
                                            [admin incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:-1000]];
                                            admin[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                            admin[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                            [admin saveInBackground];
                                                                                   }
                                    }];
                                    
                                }
                                else if([countstring isEqualToString:@"50"])
                                {
                                    [sharedObj.invitationObjectArray removeAllObjects];
                                    PFQuery *query1 = [PFQuery queryWithClassName:@"GroupFeed"];
                                    [query1 whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                    [query1 includeKey:@"UserId"];

                                    [query1 whereKey:@"PostType" equalTo:@"Invitation"];
                                    [query1 whereKey:@"PostStatus" equalTo:@"Active"];
                                    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                        if (!error) {
                                            sharedObj.invitationObjectArray=[NSMutableArray arrayWithArray:objects];
                                            if (sharedObj.invitationObjectArray.count==0) {
                                                _invitationtableview.hidden=YES;
                                                _noresultlabel.hidden=NO;
                                            }
                                            else
                                            {
                                                _invitationtableview.hidden=NO;
                                                _noresultlabel.hidden=YES;
                                                
                                            }
                                            [_invitationtableview reloadData];
                                        }
                                        
                                        
                                    }];

                                    PFQuery *ownerquery=[PFQuery queryWithClassName:@"UserDetails"];
                                    [ownerquery whereKey:@"MobileNo" containedIn:adminArray];
                                    [ownerquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                        for (PFObject *admin in objects) {
                                            [admin incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:-1000]];
                                            admin[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                            admin[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                            [admin saveInBackground];
                                            
                                        }
                                    }];
                                    
                                    
                                }
                                else
                                {
                                    [sharedObj.invitationObjectArray removeAllObjects];
                                    PFQuery *query1 = [PFQuery queryWithClassName:@"GroupFeed"];
                                    [query1 whereKey:@"GroupId" equalTo:sharedObj.GroupId];
                                    [query1 includeKey:@"UserId"];

                                    [query1 whereKey:@"PostType" equalTo:@"Invitation"];
                                    [query1 whereKey:@"PostStatus" equalTo:@"Active"];
                                    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                        if (!error) {
                                            sharedObj.invitationObjectArray=[NSMutableArray arrayWithArray:objects];
                                            if (sharedObj.invitationObjectArray.count==0) {
                                                _invitationtableview.hidden=YES;
                                                _noresultlabel.hidden=NO;
                                            }
                                            else
                                            {
                                                _invitationtableview.hidden=NO;
                                                _noresultlabel.hidden=YES;
                                                
                                            }
                                            [_invitationtableview reloadData];
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
        [query1 includeKey:@"UserId"];

        [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                sharedObj.invitationObjectArray=[NSMutableArray arrayWithArray:objects];
                if (sharedObj.invitationObjectArray.count==0) {
                    _invitationtableview.hidden=YES;
                    _noresultlabel.hidden=NO;
                }
                else
                {
                    _invitationtableview.hidden=NO;
                    _noresultlabel.hidden=YES;
                    
                }
                [_invitationtableview reloadData];
            }
            
            
        }];
    }
    
    
    
    
}


- (IBAction)back:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
}
@end
