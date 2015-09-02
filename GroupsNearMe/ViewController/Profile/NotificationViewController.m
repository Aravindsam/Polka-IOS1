//
//  NotificationViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 8/26/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "CommentViewController.h"
#import "InsideGroupViewController.h"
#import "InvitationViewController.h"
#import "NotificationModalClass.h"
@interface NotificationViewController ()

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];

    [self loadNotificationList];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNotificationList) name:@"reloadNotification" object:nil];
    
 
    NSLog(@"NOTIFICATION %@",sharedObj.NotificationArray);
    // Do any additional setup after loading the view.
}

-(void)loadNotificationList
{
//    [sharedObj.NotificationArray removeAllObjects];
//    sharedObj.NotificationArray =[[[NSUserDefaults standardUserDefaults]objectForKey:@"NOTIFICATIONLIST"]mutableCopy];
//    [_notificationtableview reloadData];
    PFQuery*myquery=[PFQuery queryWithClassName:@"Notifications"];
    [myquery whereKey:@"PushTo" equalTo:sharedObj.AccountNumber];
    [myquery setLimit:20];
    [myquery orderByDescending:@"updatedAt"];
    [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            
            if(objects.count!=0){
                 [sharedObj.NotificationArray removeAllObjects];
                for (PFObject *notify in objects) {
                    NotificationModalClass *modal =  [[NotificationModalClass alloc]init];
                    [modal setTime:[notify objectForKey:@"Time"]];
                    [modal setType:[notify objectForKey:@"Type"]];
                    [modal setUserImageurl:[notify objectForKey:@"ImageURL"]];
                    [modal setMessage:[notify objectForKey:@"PushMessage"]];
                    [modal setGroupId:[notify objectForKey:@"GroupId"]];
                    [modal setFeedId:[notify objectForKey:@"FeedId"]];
                    [modal setObjVal:[notify objectForKey:@"Objects"]];
                    [sharedObj.NotificationArray addObject:modal];
                    

                }
                [_notificationtableview reloadData];
            }
            else
            {    [sharedObj.NotificationArray removeAllObjects];
                [_notificationtableview reloadData];
                
            }
        }
        }];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNotificationList];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  sharedObj.NotificationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    NotificationModalClass *temp=[sharedObj.NotificationArray objectAtIndex:indexPath.row];
    [cell.iconimageView setImageURL:[NSURL URLWithString:temp.userImageurl]];
    NSString*typenotification =temp.type;
    if ([typenotification isEqualToString:@"FlagDelete"])
    {
        cell.userInteractionEnabled=NO;
    }
    else
    {  cell.userInteractionEnabled=YES;
        
    }
    cell.contentlabel.text=temp.message;
    
    
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [inputDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];    [inputDateFormatter setLocale:[NSLocale systemLocale]];
    NSDate *inputDate=temp.time;
    
////    NSLog(@"TIME %@",[temp objectForKey:@"Time"]);
//    NSLog(@"DATE %@",inputDate);
    
    NSString *timestamp = [inputDate stringWithHumanizedTimeDifference:humanizedType withFullString:YES];
    cell.timelabel.text=timestamp;
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationModalClass *temp=[sharedObj.NotificationArray objectAtIndex:indexPath.row];
    NSString*typenotification =temp.type;
    if ([typenotification isEqualToString:@"Post"]||[typenotification isEqualToString:@"Comment"]||[typenotification isEqualToString:@"Flag"])
    {
        
       
            sharedObj.feedObject=temp.objVal;
             sharedObj.FeedId=sharedObj.feedObject[@"objectId"];
            PFQuery *group=[PFQuery queryWithClassName:@"Group"];
            [group fromLocalDatastore];
            [group getObjectInBackgroundWithId:temp.groupId block:^(PFObject *object, NSError *error) {
                PFFile *groupimg=object[@"GroupPicture"];
                sharedObj.groupimageurl=groupimg;
                sharedObj.GroupName=object[@"GroupName"];
                sharedObj.groupType=[object objectForKey:@"GroupType"];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                CommentViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
               
                [self.navigationController presentViewController:settingsViewController animated:YES completion:nil];
            }];
            
        
        
    }
    else if ([typenotification isEqualToString:@"JoinRequestApprove"])
    {
        
       
          PFObject *group=temp.objVal;
            sharedObj.groupType=[group objectForKey:@"GroupType"];
            sharedObj.GroupId=group.objectId;
            sharedObj.frommygroup=YES;
            PFFile *imageFile=[group objectForKey:@"ThumbnailPicture"];
            
            sharedObj.groupimageurl=imageFile;
            sharedObj.groupMember=[NSString stringWithFormat:@"%@",[group objectForKey:@"MemberCount"]];
            sharedObj.groupdescription=[group objectForKey:@"GroupDescription"];
            sharedObj.GroupName=[group objectForKey:@"GroupName"];
            sharedObj.secretCode=[group objectForKey:@"SecretCode"];
            sharedObj.currentGroupAdminArray=[group objectForKey:@"AdminArray"];
            sharedObj.currentGroupmemberArray=[group objectForKey:@"GroupMembers"];
            NSDate *estabilshed=group.createdAt;
            NSDateFormatter *temp=[[NSDateFormatter alloc]init];
            [temp  setDateFormat:@"MMMM dd, yyyy "];
            NSString *currentdate1=[temp stringFromDate:estabilshed];
            sharedObj.currentgroupEstablished=currentdate1;
            sharedObj.currentgroupAddinfo=[[group objectForKey:@"AdditionalInfoRequired"]boolValue];
            sharedObj.addinfo=[group objectForKey:@"InfoRequired"];
            sharedObj.currentgroupOpenEntry=[[group objectForKey:@"JobHours"]intValue];
            sharedObj.currentgroupradius=[group[@"VisibiltyRadius"]intValue];
            sharedObj.currentgroupSecret=[group[@"SecretStatus"]boolValue];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InsideGroupViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"InsideGroupViewController"];
            // AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [self.navigationController pushViewController:settingsViewController animated:YES];
            
       
    }
    else if ([typenotification isEqualToString:@"JoinRequest"])
    {
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InvitationViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"InvitationViewController"];
        sharedObj.GroupId=temp.groupId;
        [self.navigationController pushViewController:settingsViewController animated:YES];
        
        
    }
    else if ([typenotification isEqualToString:@"Invitation"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"CALLINVITES" object:nil];
        
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (_notificationtableview.frame.size.height/6);
}

- (IBAction)back:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
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
