//
//  NearbyViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/13/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "NearbyViewController.h"
#import "SVProgressHUD.h"
#import "NearByTableViewCell.h"
#import "GroupModalClass.h"
#import "InsideGroupViewController.h"
#import "AppDelegate.h"
#import "SVPullToRefresh.h"
#import "UpdateGroupProfileViewController.h"
#import "Toast+UIView.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface NearbyViewController ()
{
    NearByTableViewCell *previousCell;
   // int selectedIndex;
}
@end

@implementation NearbyViewController
@synthesize point;
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedobj=[Generic sharedMySingleton];
       sharedobj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    previousIndex=-1;
    currentdate=[[NSString alloc]init];
    humanizedType = NSDateHumanizedSuffixAgo;
 sharedobj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    _nearbyTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    invitationArray=[[NSMutableArray alloc]init];
    ownerGroup=[[NSMutableArray alloc]init];
    groupMembers=[[NSMutableArray alloc]init];
    unquieArray=[[NSMutableArray alloc]init];
    invitationarray=[[NSMutableArray alloc]init];
    mygroup=[[NSMutableArray alloc]init];
    inviationId=[[NSString alloc]init];
    myGroupIdArray=[[NSMutableArray alloc]init];
    QueryArray=[[NSMutableArray alloc]init];
    myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    invitationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"GroupInvite"];
    sharedobj.AccountName=[[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    sharedobj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedobj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"create a group here."];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    _tapLabel.font=[UIFont fontWithName:@"Lato-Regular" size:15.0];
    _tapLabel.textColor=[Generic colorFromRGBHexString:headerColor];
    _tapLabel.attributedText=attributeString;
    tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshserviceData)];
    tapgesture.numberOfTapsRequired=1;
    _tapLabel.userInteractionEnabled=YES;
    [_tapLabel addGestureRecognizer:tapgesture];
    
    [self.view setFrame:sharedobj.nearByViewFrame];
    [_nearbyTableview setFrame:self.view.frame];
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"MobileNo" equalTo:sharedobj.AccountNumber];
    [query whereKey:@"CountryName" equalTo:sharedobj.AccountCountry];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            if (objects.count!=0) {
                for (PFObject*owner in objects) {
                    [ownerGroup addObject:owner.objectId];
                }
            }
        }
    
    }];
  
    //Call Location
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
       // [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
  
 
    
   
   
    PFQuery *query11 = [PFQuery queryWithClassName:@"UserDetails"];
    [query11 whereKey:@"MobileNo" equalTo:sharedobj.AccountNumber];
    [query11 whereKey:@"CountryName" equalTo:sharedobj.AccountCountry];
    [query11 fromLocalDatastore];
    [query11 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
    if (!error) {
     
        [[NSUserDefaults standardUserDefaults]setObject:object[@"GroupInvitation"] forKey:@"GroupInvite"];
        [[NSUserDefaults standardUserDefaults]setObject:object[@"MyGroupArray"] forKey:@"MyGroup"];
        userimage =[object objectForKey:@"ThumbnailPicture"];
                           
                }
    }];
    
    
    //Notification Call
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSomething)
    name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doSomething) name:@"REFRESH" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableview) name:@"NEARBYSEARCH" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableview) name:@"SERVICEREFRESH" object:nil];
    
    
    //Pull to refresh
    __weak NearbyViewController *weakSelf = self;
    [self.nearbyTableview addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.nearbyTableview beginUpdates];

            
            [weakSelf refreshservice:YES];
            
            [weakSelf.nearbyTableview endUpdates];
            [weakSelf.nearbyTableview.pullToRefreshView stopAnimating];
        });
    }];

    if (sharedobj.NearByGroupArray.count!=0) {
        [_nearbyTableview setHidden:NO];
        [_noresultLabel setHidden:YES];
        [_tapLabel setHidden:YES];
        [_nearbyTableview reloadData];
    }
    else
    {
        [_nearbyTableview setHidden:NO];
        [_noresultLabel setHidden:NO];
        [_tapLabel setHidden:NO];
    }
    

    // Do any additional setup after loading the view.
}
-(void)refreshserviceData
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CALLCREATE" object:nil];

}
-(void)refreshservice:(BOOL)connection
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
    [query whereKey:@"MobileNo" equalTo:sharedobj.AccountNumber];
    [query whereKey:@"CountryName" equalTo:sharedobj.AccountCountry];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error) {
            [SVProgressHUD dismiss];
        }
        else{
            [[NSUserDefaults standardUserDefaults]setObject:object[@"MyGroupArray"] forKey:@"MyGroup"];
            BOOL internetconnect=[sharedobj connected];
            
            if (internetconnect) {
          

    [self CallMyService:point];
            }
            else
            {
                if (connection) {
                    
                
                 [self.view makeToast:@"Can’t connect" duration:3.0 position:@"bottom"];
                }
            }
        }
    }];

}
-(void)reloadTableview
{
  
    [_nearbyTableview reloadData];
}
-(void)doSomething
{
      previousIndex=-1;
    
    [locationManager startUpdatingLocation];
    [_nearbyTableview reloadData];

    myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];

    [self.view setFrame:sharedobj.nearByViewFrame];
    [_nearbyTableview setFrame:self.view.frame];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [locationManager startUpdatingLocation];
    myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    previousIndex=-1;
    [_nearbyTableview reloadData];
    [self.view setFrame:sharedobj.nearByViewFrame];
    [_nearbyTableview setFrame:self.view.frame];
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
    
    BOOL internetconnect=[sharedobj connected];
    
    if (internetconnect) {
        
        
        [self CallMyService:point];
    }


    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
      [locationManager stopUpdatingLocation];
}
-(void)CallMyService:(PFGeoPoint*)currentLocation
{
    invitationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"GroupInvite"];
    myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"GroupLocation" nearGeoPoint:currentLocation withinMiles:0.310686];
    [query whereKey:@"GroupType" notEqualTo:@"Secret"];
    [query whereKey:@"GroupStatus" equalTo:@"Active"];
    [query whereKey:@"objectId" notContainedIn:myGroupIdArray];
    [query orderByDescending:@"updatedAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            
            if (objects.count!=0) {
                [sharedobj.NearByGroupArray removeAllObjects];
                for (PFObject *group in objects) {
                    groupvisiblityradius=[[group objectForKey:@"VisibiltyRadius"]intValue];
                    PFGeoPoint *grouploc=[group objectForKey:@"GroupLocation"];
                    grouplocation=[[CLLocation alloc]initWithLatitude:grouploc.latitude longitude:grouploc.longitude];
                    userlocation=[[CLLocation alloc]initWithLatitude:point.latitude longitude:point.longitude];
                    distancefromgroup=[userlocation distanceFromLocation:grouplocation];
                    if (distancefromgroup <= groupvisiblityradius) {
               
                    
                    GroupModalClass *modal =  [[GroupModalClass alloc]init];
                    [modal setGroupId:group.objectId];
                    [modal setGroupOwner:[group objectForKey:@"MobileNo"]];
                    [modal setGroupAdminArray:[group objectForKey:@"AdminArray"]];
                    [modal setGroupName:[group objectForKey:@"GroupName"]];
                    [modal setGroupPost:[group objectForKey:@"LatestPost"]];
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
                    [modal setOpenEntry:[[group objectForKey:@"JobHours"]intValue]];
                    [modal setSecretCode:[group objectForKey:@"SecretCode"]];
                    PFFile *imageFile=[group objectForKey:@"ThumbnailPicture"];
                    [modal setGroupImageData:imageFile];
                    [sharedobj.NearByGroupArray addObject:modal];
                    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
                    //        [us setObject:tempDate forKey:@"LASTUPDATED"];
                    [us setObject:[NSDate date] forKey:@"LASTUPDATED"];
                     [modal setSecretCode:[group objectForKey:@"SecretCode"]];
                    [us synchronize];
                    
                    [self.nearbyTableview.pullToRefreshView setLastUpdatedDate:[us objectForKey:@"LASTUPDATED"]];
                    }
                }
                [SVProgressHUD dismiss];
                
                if (sharedobj.NearByGroupArray.count!=0) {
                    [_nearbyTableview setHidden:NO];
                    [_noresultLabel setHidden:YES];
                    [_tapLabel setHidden:YES];
                    [_nearbyTableview reloadData];
                }
                else
                {
                    [_nearbyTableview setHidden:NO];
                    [_noresultLabel setHidden:NO];
                    [_tapLabel setHidden:NO];
                }
                
            }
            else
            {
                [SVProgressHUD dismiss];
                [sharedobj.NearByGroupArray removeAllObjects];
                if (sharedobj.NearByGroupArray.count!=0) {
                    [_nearbyTableview setHidden:NO];
                    [_noresultLabel setHidden:YES];
                    [_tapLabel setHidden:YES];
                    [_nearbyTableview reloadData];
                }
                else
                {
                    
                    [_nearbyTableview setHidden:NO];
                    [_noresultLabel setHidden:NO];
                    [_tapLabel setHidden:NO];
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
    if (sharedobj.search) {
        return [sharedobj.searchNearby count];
        
    } else {
    
        return sharedobj.NearByGroupArray.count ;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NearByTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[NearByTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    [cell setDidselectDelegate:self];
    if (sharedobj.search) {
        
        if (sharedobj.searchNearby.count!=0) {
            GroupModalClass *modal = [sharedobj.searchNearby objectAtIndex:indexPath.row];
 cell.groupImageview.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];            if ([modal.groupType isEqualToString:@"Private"]) {
                cell.grouptypelbl.text=@"PRIVATE";
                if ([invitationArray containsObject:modal.groupId]) {
                    cell.joinbtn.hidden=YES;
                    cell.requestlabel.text=@"PENDING";
                     cell.requestlabel.hidden=NO;
                }
                else
                {
                    cell.joinbtn.hidden=NO;
                    
                    cell.requestlabel.hidden=YES;
                    
                }
                 [cell.joinbtn setTitle:@"JOIN" forState:UIControlStateNormal];
            }
            else if ([modal.groupType isEqualToString:@"Public"]) {
                
                cell.grouptypelbl.text=@"CHATTER";
                  cell.requestlabel.hidden=YES;
                  [cell.joinbtn setTitle:@"JOIN" forState:UIControlStateNormal];
            }
            else
            {
                cell.grouptypelbl.text=@"OPEN";

                cell.requestlabel.hidden=YES;
                [cell.joinbtn setTitle:@"JOIN" forState:UIControlStateNormal];
            }
             cell.aboutLabel.text=modal.groupDescription;
          
            cell.groupImageview.file=modal.groupImageData;
            [cell.groupImageview loadInBackground];

            cell.groupnamelbl.text=modal.groupName;
           
                cell.memberlabel.text=[NSString stringWithFormat:@"%d",modal.memberCount];
           
            
            cell.joinbtn.tag=indexPath.row;
             cell.aboutLabel.hidden=YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

    }
    else
    {
    if (sharedobj.NearByGroupArray.count!=0) {
    GroupModalClass *modal = [sharedobj.NearByGroupArray objectAtIndex:indexPath.row];
 cell.groupImageview.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];         if ([modal.groupType isEqualToString:@"Private"]) {
            cell.grouptypelbl.text=@"PRIVATE";
            if ([invitationArray containsObject:modal.groupId]) {
                cell.joinbtn.hidden=YES;
                cell.requestlabel.text=@"PENDING";
                cell.requestlabel.hidden=NO;
                
            }
            else
            {
                cell.joinbtn.hidden=NO;
                
                cell.requestlabel.hidden=YES;
                
            }
            [cell.joinbtn setTitle:@"JOIN" forState:UIControlStateNormal];
        }
        else if ([modal.groupType isEqualToString:@"Public"]) {
            
            cell.grouptypelbl.text=@"CHATTER";
              cell.requestlabel.hidden=YES;
            [cell.joinbtn setTitle:@"JOIN" forState:UIControlStateNormal];
        }
        else
        {
            cell.grouptypelbl.text=@"OPEN";

            cell.requestlabel.hidden=YES;
              [cell.joinbtn setTitle:@"JOIN" forState:UIControlStateNormal];
        }
         cell.aboutLabel.text=modal.groupDescription;
        cell.groupImageview.file=modal.groupImageData;
        [cell.groupImageview loadInBackground];

        cell.groupnamelbl.text=modal.groupName;
      
        cell.memberlabel.text=[NSString stringWithFormat:@"%d",modal.memberCount];
        
        cell.joinbtn.tag=indexPath.row;
        cell.aboutLabel.hidden=YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;


           }
    }
 
    
   
    cell.joinbtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupModalClass *modal ;
    if (sharedobj.search) {
        modal = [sharedobj.searchNearby objectAtIndex:indexPath.row];
        
    }
    else
    {
        modal = [sharedobj.NearByGroupArray objectAtIndex:indexPath.row];
        
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UpdateGroupProfileViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"UpdateGroupProfileViewController"];
    settingsViewController.Fromnearby=YES;
    settingsViewController.indexval=(int)indexPath.row;
    sharedobj.groupType=modal.groupType;
    sharedobj.GroupId=modal.groupId;
    sharedobj.frommygroup=YES;
    sharedobj.groupimageurl=modal.groupImageData;
    sharedobj.groupMember=[NSString stringWithFormat:@"%d",modal.memberCount];
    sharedobj.groupdescription=modal.groupDescription;
    sharedobj.GroupName=modal.groupName;
    sharedobj.secretCode=modal.secretCode;
    sharedobj.currentGroupAdminArray=modal.groupAdminArray;
    sharedobj.currentGroupmemberArray=modal.groupMemberArray;
    sharedobj.currentgroupEstablished=modal.timeVal;
    sharedobj.currentgroupAddinfo=modal.addInfoRequired;
    sharedobj.addinfo=modal.addinfoString;
    sharedobj.currentgroupOpenEntry=modal.openEntry;
    sharedobj.currentgroupradius=modal.visibiltyradius;
    sharedobj.currentgroupSecret=modal.SecretStatus;
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navigationController pushViewController:settingsViewController animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (_nearbyTableview.frame.size.height/6);
    
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
-(void)joinbuttonPressed:(int)indexval
{
    BOOL internetconnect=[sharedobj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
   myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    if (indexval==previousIndex) {
        return;
    }
    previousIndex=indexval;
    
    GroupModalClass *modal;
    indexpathvalue=indexval;
    if (sharedobj.search) {
        modal = [sharedobj.searchNearby objectAtIndex:indexval];

    }
    else{
        modal = [sharedobj.NearByGroupArray objectAtIndex:indexval];

    }
   
        if ([modal.groupType isEqualToString:@"Private"]) {
            if (modal.openEntry>0) {
                [self joinfree:indexval];
  
            }
            else{
             if (modal.groupChannelArray.count!=0) {
                NSMutableSet *intersection = [NSMutableSet setWithArray:modal.groupChannelArray];
                [intersection intersectSet:[NSSet setWithArray:myGroupIdArray]];
                NSArray *array4 = [intersection allObjects];
                if (array4.count!=0) {
                    [self joinfree:indexval];
                }
                else
                {
                    if (modal.addInfoRequired) {
                         inviationId=modal.groupId;
                        
                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Additional Information" message:[NSString stringWithFormat:@"Enter %@",modal.addinfoString] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                        [alert addButtonWithTitle:@"Join"];
                        [alert setTag:33];
                        [alert show];
                       
                    }
                    else if (modal.secretCode.length!=0) {
                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Verification" message:@"Please enter passcode to join this group" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                        [alert addButtonWithTitle:@"Join"];
                        [alert setTag:44];
                        [alert show];
                        
                    }
                    else
                    {
                       inviationId=modal.groupId;
                       PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
                        testObject[@"PostStatus"]=@"Active";
                        testObject[@"GroupId"]=modal.groupId;
                        testObject[@"MemberName"]=sharedobj.AccountName;
                        testObject[@"MobileNo"]=sharedobj.AccountNumber;
                        testObject[@"PostType"]=@"Invitation";
                        testObject[@"FeedLocation"]=point;
                        testObject[@"PostText"]=@"No Information Available";
                         testObject[@"MemberImage"]=userimage;
                        PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedobj.userId];
                        
                        testObject[@"UserId"]=pointer;
                        [testObject saveInBackground];
                        
                        PFQuery *query = [PFQuery queryWithClassName:@"Group"];
                        [query whereKey:@"objectId" equalTo:modal.groupId];

                        [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                            if (error) {
                                NSLog(@"Data not available insert userdetails");
                                [SVProgressHUD dismiss];
                                
                                
                            } else {
                                userStats[@"LatestPost"]=[NSString stringWithFormat:@"No Additional Information Available"];
                              
                                [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        [self sendinginvitation];
                                    }
                                }];
                            }
                        }];

                    
                    }
                }
            }
             else if (modal.secretCode.length!=0) {
                    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Verification" message:@"Please enter passcode to join this group" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    [alert addButtonWithTitle:@"Join"];
                    [alert setTag:44];
                    [alert show];
                    
                }
               
               else if (modal.addInfoRequired) {
                     inviationId=modal.groupId;
              
                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Additional Information" message:[NSString stringWithFormat:@"Enter %@",modal.addinfoString] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                        [alert addButtonWithTitle:@"Join"];
                        [alert setTag:33];
                        [alert show];
                   

                }
                else
                {
                    inviationId=modal.groupId;
                    PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
                    testObject[@"PostStatus"]=@"Active";
                    testObject[@"GroupId"]=modal.groupId;
                    testObject[@"MemberName"]=sharedobj.AccountName;
                    testObject[@"MobileNo"]=sharedobj.AccountNumber;
                    testObject[@"PostType"]=@"Invitation";
                    testObject[@"MemberImage"]=userimage;

                    testObject[@"FeedLocation"]=point;
                    testObject[@"PostText"]=@"No Information Available";
                    PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedobj.userId];
                    
                    testObject[@"UserId"]=pointer;
                    [testObject saveInBackground];
                    
                    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
                    [query whereKey:@"objectId" equalTo:modal.groupId];

                    [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                        if (error) {
                            NSLog(@"Data not available insert userdetails");
                            [SVProgressHUD dismiss];
                            
                            
                        } else {
                            userStats[@"LatestPost"]=[NSString stringWithFormat:@"No Additional Information Available"];
                           
                            [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    [self sendinginvitation];
                                    
                                }
                            }];
                        }
                    }];
                }
            }

        }
        else
        {
            [self joinfree:indexval];
                 }
    }
}
-(void)joinfree:(int)index
{
       myGroupIdArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    unquieArray=[NSMutableArray arrayWithArray:myGroupIdArray];
    [unquieArray removeObjectsInArray:ownerGroup];
    
    GroupModalClass *modal;
    if (sharedobj.search) {
        modal = [sharedobj.searchNearby objectAtIndex:index];
        
    }
    else{
        modal = [sharedobj.NearByGroupArray objectAtIndex:index];
        
    }
    
    PFObject *member=[PFObject objectWithClassName:@"MembersDetails"];
    member[@"GroupId"]=modal.groupId;
    member[@"MemberNo"]=sharedobj.AccountNumber;
    member[@"MemberImage"]=userimage;
    member[@"MemberName"]=sharedobj.AccountName;
    member[@"JoinedDate"]=[NSDate date];
    member[@"AdditionalInfoProvided"]=@"";
    member[@"GroupAdmin"]=[NSNumber numberWithBool:NO];
    member[@"UnreadMsgCount"]=[NSNumber numberWithInt:0];
    member[@"ExitGroup"]=[NSNumber numberWithBool:NO];
    member[@"LeaveDate"]=[NSDate date];
    member[@"MemberStatus"]=@"Active";
    member[@"ExitedBy"]=@"";
    PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedobj.userId];
    
    member[@"UserId"]=pointer;
    [member saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

     PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"objectId" equalTo:modal.groupId];

    [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (error) {
            NSLog(@"Data not available insert userdetails");
            [SVProgressHUD dismiss];
            
            
        } else {
            [userStats incrementKey:@"MemberCount" byAmount:[NSNumber numberWithInt:1]];
            groupMembers=userStats[@"GroupMembers"];
            [groupMembers addObject:sharedobj.AccountNumber];
            userStats[@"GroupMembers"]=groupMembers;
            [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
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
                        
                    
                    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
                    [query whereKey:@"MobileNo" equalTo:sharedobj.AccountNumber];

                    [query whereKey:@"CountryName" equalTo:sharedobj.AccountCountry];
                    [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                        if (error) {
                            NSLog(@"Data not available insert userdetails");
                            [SVProgressHUD dismiss];
                            
                            
                        } else {
                            if (unquieArray.count==0) {
                                [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:1000]];
                            }
                            else{
                                [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:100]];
                            }
                            mygroup=userStats[@"MyGroupArray"];
                            [mygroup addObject:modal.groupId];
                            userStats[@"MyGroupArray"]=mygroup;
                            userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                            userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                            [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (!error) {
                                    [SVProgressHUD dismiss];
                                    [self godetailsScreen];

                                    
                                }
                            }];
                            
                        }
                    }];

                }
            }];
            
        }
    }];

        }
    }];
}
-(void)godetailsScreen
{

    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
    [query whereKey:@"MobileNo" equalTo:sharedobj.AccountNumber];
    [query whereKey:@"CountryName" equalTo:sharedobj.AccountCountry];

    [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (error) {
            NSLog(@"Data not available insert userdetails");
            [SVProgressHUD dismiss];
        } else {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"Login"];
            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"GroupInvitation"] forKey:@"GroupInvite"];
            [[NSUserDefaults standardUserDefaults]setObject:userStats[@"MyGroupArray"] forKey:@"MyGroup"];
            GroupModalClass *modal;
            if (sharedobj.search) {
                modal = [sharedobj.searchNearby objectAtIndex:indexpathvalue];
                
            }
            else{
                modal = [sharedobj.NearByGroupArray objectAtIndex:indexpathvalue];
                
            }
                PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
            testObject[@"PostStatus"]=@"Active";

            testObject[@"GroupId"]=modal.groupId;
            testObject[@"MemberName"]=sharedobj.AccountName;
            testObject[@"MobileNo"]=sharedobj.AccountNumber;
            testObject[@"PostType"]=@"Member";
            testObject[@"MemberImage"]=userimage;

            testObject[@"PostText"]=[NSString stringWithFormat:@"%@ - newly joined  this group",sharedobj.AccountName];
            testObject[@"CommentCount"]=[NSNumber numberWithInt:0];
            testObject[@"PostPoint"]=[NSNumber numberWithInt:0];
            testObject[@"FlagCount"]=[NSNumber numberWithInt:0];
            testObject[@"LikeUserArray"]=[[NSMutableArray alloc]init];
            testObject[@"DisLikeUserArray"]=[[NSMutableArray alloc]init];
            testObject[@"FlagArray"]=[[NSMutableArray alloc]init];
            testObject[@"FeedLocation"]=point;
            PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedobj.userId];
            
            testObject[@"UserId"]=pointer;
            [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                testObject[@"FeedupdatedAt"]=testObject.updatedAt;
                [testObject saveInBackground];
            }];
            
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
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            InsideGroupViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"InsideGroupViewController"];
                            sharedobj.groupType=modal.groupType;
                            sharedobj.GroupId=modal.groupId;
                            sharedobj.frommygroup=YES;
                            sharedobj.groupimageurl=modal.groupImageData;
                            sharedobj.groupMember=[NSString stringWithFormat:@"%d",modal.memberCount];
                            sharedobj.groupdescription=modal.groupDescription;
                            sharedobj.GroupName=modal.groupName;
                            sharedobj.secretCode=modal.secretCode;
                            sharedobj.currentGroupAdminArray=modal.groupAdminArray;
                            sharedobj.currentGroupmemberArray=modal.groupMemberArray;
                            sharedobj.currentgroupEstablished=modal.timeVal;
                            sharedobj.currentgroupAddinfo=modal.addInfoRequired;
                            sharedobj.addinfo=modal.addinfoString;
                            sharedobj.currentgroupOpenEntry=modal.openEntry;
                            sharedobj.currentgroupradius=modal.visibiltyradius;
                            sharedobj.currentgroupSecret=modal.SecretStatus;
                            
                            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                            [delegate.navigationController pushViewController:settingsViewController animated:YES];
                }}];
                }
            }];
            
            
            
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 
    
    
 if (alertView.tag==33)
    {
        if (buttonIndex == 1)
        {
            
            GroupModalClass *modal;
            if (sharedobj.search) {
                modal = [sharedobj.searchNearby objectAtIndex:indexpathvalue];
                
            }
            else{
                modal = [sharedobj.NearByGroupArray objectAtIndex:indexpathvalue];
                
            }
            UITextField *Additioninfo = [alertView textFieldAtIndex:0];
            if (Additioninfo.text.length!=0) {
                PFObject *testObject = [PFObject objectWithClassName:@"GroupFeed"];
                testObject[@"PostStatus"]=@"Active";

                testObject[@"GroupId"]=modal.groupId;
                testObject[@"MemberName"]=sharedobj.AccountName;
                testObject[@"MobileNo"]=sharedobj.AccountNumber;
                testObject[@"PostType"]=@"Invitation";
                testObject[@"MemberImage"]=userimage;

                testObject[@"FeedLocation"]=point;
                testObject[@"PostText"]=[NSString stringWithFormat:@"%@ - %@",modal.addinfoString,Additioninfo.text];
                PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedobj.userId];
                
                testObject[@"UserId"]=pointer;
                [testObject saveInBackground];
                
                PFQuery *query = [PFQuery queryWithClassName:@"Group"];
                [query whereKey:@"objectId" equalTo:modal.groupId];

                [query  getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                    if (error) {
                        NSLog(@"Data not available insert userdetails");
                        [SVProgressHUD dismiss];
                        
                        
                    } else {
                        userStats[@"LatestPost"]=[NSString stringWithFormat:@"%@ - %@",modal.addinfoString,Additioninfo.text];
                     
                        [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                [self sendinginvitation];
                                
                            }
                        }];
                    }
                }];
                
                
 
            }
        }
        else
        {
            previousIndex=-1;
        }
        
    }
    
    else if(alertView.tag==44)
    {
        if (buttonIndex == 1)
        {

            GroupModalClass *modal;
            if (sharedobj.search) {
                modal = [sharedobj.searchNearby objectAtIndex:indexpathvalue];
                
            }
            else{
                modal = [sharedobj.NearByGroupArray objectAtIndex:indexpathvalue];
                
            }
        UITextField *Additioninfo = [alertView textFieldAtIndex:0];
        
        if ([Additioninfo.text isEqualToString:modal.secretCode]) {
            [self joinfree:indexpathvalue];
        }
        else
        {
            previousIndex=-1;
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Error" message:@"Incorrect Passcode entered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            errorAlert.tag=111;
            [errorAlert show];
            
        }
        }
        else
        {
            previousIndex=-1;
        }
    }
    
    
}
-(void)sendinginvitation
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
    [query whereKey:@"MobileNo" equalTo:sharedobj.AccountNumber];
    [query whereKey:@"CountryName" equalTo:sharedobj.AccountCountry];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error) {
            [SVProgressHUD dismiss];
        }
        else{
           
            invitationarray=object[@"GroupInvitation"];
            [invitationarray addObject:inviationId];
            object[@"GroupInvitation"]=invitationarray;
            object[@"UpdateImage"]=[NSNumber numberWithBool:NO];
            object[@"UpdateName"]=[NSNumber numberWithBool:NO];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    
                    [[NSUserDefaults standardUserDefaults]setObject:invitationarray forKey:@"GroupInvite"];
                    invitationArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"GroupInvite"
                                     ];
                    BOOL internetconnect=[sharedobj connected];
                    
                    if (internetconnect) {
                        
                        
                        [self CallMyService:point];
                    }
                }
            }];
            
            
            
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

- (IBAction)createGroup:(id)sender {
}
@end
