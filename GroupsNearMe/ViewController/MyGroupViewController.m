//
//  MyGroupViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "MyGroupViewController.h"
#import "MyGroupTableViewCell.h"

#import "InsideGroupViewController.h"
#import "GroupModalClass.h"
#import "SVPullToRefresh.h"
#import "Toast+UIView.h"
@interface MyGroupViewController ()

@end

@implementation MyGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedobj=[Generic sharedMySingleton];
    humanizedType = NSDateHumanizedSuffixAgo;

    _mygroupTableview.hidden=YES;
    sharedobj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    lastupdate=[[NSUserDefaults standardUserDefaults] objectForKey:@"LASTUPDATED"];
    mygroupIDArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];

    currentdate=[[NSString alloc]init];
    self.mygroupTableview.separatorStyle=UITableViewCellSeparatorStyleNone;

    NSDateFormatter *sdateFormatter = [[NSDateFormatter alloc] init];
    [sdateFormatter setDateFormat:@"MMM dd,yyyy ,hh:mm"];

    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"groups nearby"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    self.switchtotab.font=[UIFont fontWithName:@"Lato-Regular" size:14.0];
    self.switchtotab.textColor=[Generic colorFromRGBHexString:headerColor];
    self.switchtotab.attributedText=attributeString;
    switchtap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchtab)];
    switchtap.numberOfTapsRequired=1.0;
    self.switchtotab.userInteractionEnabled=YES;
    [self.switchtotab addGestureRecognizer:switchtap];
    [self.view setFrame:sharedobj.myGroupViewFrame];
    [_mygroupTableview setFrame:self.view.frame];
    _mygroupTableview.backgroundColor=[UIColor clearColor];
    
    [self CallMyService:YES];
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    __weak MyGroupViewController *weakSelf = self;
      BOOL internetconnect=[sharedobj connected];
    [self.mygroupTableview addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
            if (internetconnect) {
            [weakSelf.mygroupTableview beginUpdates];
            
            
                [weakSelf refreshService:YES];
            
            
            [weakSelf.mygroupTableview endUpdates];
            [weakSelf.mygroupTableview.pullToRefreshView stopAnimating];
            }
        });
    }];
   
    _noresultView.hidden=YES;
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doSomething)
                                                 name:UIApplicationDidChangeStatusBarFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doSomething) name:@"REFRESH" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableview) name:@"MYGROUPSEARCH" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshServiceData) name:@"SERVICEREFRESH" object:nil];

    // Do any additional setup after loading the view.
}

-(void)switchtab
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MOVETONEARBY" object:nil];
}
-(void)reloadTableview
{
    [self.mygroupTableview reloadData];
}
-(void)doSomething
{
    
    [self.view setFrame:sharedobj.myGroupViewFrame];
    [_mygroupTableview setFrame:self.view.frame];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setFrame:sharedobj.myGroupViewFrame];
    [_mygroupTableview setFrame:self.view.frame];
}
-(void)refreshServiceData
{
    [self refreshService:NO];
}
-(void)refreshService:(BOOL)connection
{
    BOOL internetconnect=[sharedobj connected];
    
    if (!internetconnect) {
        if (connection) {
            [self.view makeToast:@"Can’t connect" duration:3.0 position:@"bottom"];
        }
        
        
    }
    else{
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
  
   [query getObjectInBackgroundWithId:sharedobj.userId block:^(PFObject *object, NSError *error) {

        if (error) {
        }
        else{
            [[NSUserDefaults standardUserDefaults]setObject:object[@"MyGroupArray"] forKey:@"MyGroup"];
             mygroupIDArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
            PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
            [myquery whereKey:@"objectId" containedIn:mygroupIDArray];
            [myquery whereKey:@"GroupStatus" equalTo:@"Active"];
            [myquery orderByDescending:@"updatedAt"];
            [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error) {
                    NSLog(@"error in geo query!"); // todo why is this ever happening?
                } else {
                    [PFObject unpinAllObjectsInBackgroundWithName:@"MYGROUP"];
                    [PFObject pinAllInBackground:objects withName:@"MYGROUP"];
                      [self CallMyService:NO];
                }
            }];
    
        }
    }];
    }
}

-(void)updateunreadmsg
{
    BOOL internetconnect=[sharedobj connected];
    
    if (internetconnect) {
    for (int i=0; i< sharedobj.MyGroupArray.count; i++) {
        GroupModalClass *modal=[sharedobj.MyGroupArray objectAtIndex:i];
        PFQuery*message=[PFQuery queryWithClassName:@"MembersDetails"];
        [message whereKey:@"GroupId" equalTo:modal.groupId];
        [message whereKey:@"MemberNo" equalTo:sharedobj.AccountNumber];
        [message whereKey:@"MemberStatus" equalTo:@"Active"];
        [message includeKey:@"UserId"];

        [message findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"error in geo query!"); // todo why is this ever happening?
            } else {
                if (objects.count==0) {
                    [modal setMessagecount:0];
                }
                else{
                    for (PFObject *member in objects) {
                        
                        [modal setMessagecount:[[member objectForKey:@"UnreadMsgCount"]intValue]];
                    }
                    
                   
                }
                if (i == sharedobj.MyGroupArray.count-1) {
               
                if (sharedobj.MyGroupArray.count!=0) {
                    [_mygroupTableview setHidden:NO];
                    [_noresultView setHidden:YES];
                    
                }
                else
                {
                    [_mygroupTableview setHidden:NO];
                    [_noresultView setHidden:NO];
                }
                    [self.mygroupTableview reloadData];

                }
            }
        }];
    }
        

    }
    else
    {
        for (int i=0; i< sharedobj.MyGroupArray.count; i++) {
            GroupModalClass *modal=[sharedobj.MyGroupArray objectAtIndex:i];
            [modal setMessagecount:0];
            
            if (i == sharedobj.MyGroupArray.count-1) {
                
                if (sharedobj.MyGroupArray.count!=0) {
                    [_mygroupTableview setHidden:NO];
                    [_noresultView setHidden:YES];
                   
                }
                else
                {
                    [_mygroupTableview setHidden:NO];
                    [_noresultView setHidden:NO];
                }
                 [self.mygroupTableview reloadData];
            }
        }
       
    }
}
-(void)CallMyService:(BOOL)update
{
   // _mygroupTableview.hidden=YES;
    mygroupIDArray=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
    [myquery whereKey:@"objectId" containedIn:mygroupIDArray];
    [myquery whereKey:@"GroupStatus" equalTo:@"Active"];
    [myquery orderByDescending:@"updatedAt"];
    [myquery fromLocalDatastore];
    [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            
            if(objects.count!=0){
                
                 [sharedobj.MyGroupArray removeAllObjects];
                for (PFObject *group in objects) {
                    GroupModalClass *modal =  [[GroupModalClass alloc]init];
                    [modal setGroupId:group.objectId];
                    [modal setGroupOwner:[group objectForKey:@"MobileNo"]];
                    [modal setGroupName:[group objectForKey:@"GroupName"]];
                    [modal setGroupType:[group objectForKey:@"GroupType"]];
                    [modal setGroupAdminArray:[group objectForKey:@"AdminArray"]];
                    [modal setGroupDescription:[group objectForKey:@"GroupDescription"]];
                    [modal setMemberCount:[[group objectForKey:@"MemberCount"]intValue]];
                    [modal setGroupMemberArray:[group objectForKey:@"GroupMembers"]];
                    [modal setVisibiltyradius:[group[@"VisibiltyRadius"]intValue]];
                  [modal setSecretStatus:[group[@"SecretStatus"]boolValue]];
                    NSDate *estabilshed=group.createdAt;
                    NSDateFormatter *temp=[[NSDateFormatter alloc]init];
                    [temp  setDateFormat:@"MMMM dd, yyyy "];
                    currentdate=[temp stringFromDate:estabilshed];
                    [modal setTimeVal:currentdate];
                    [modal setFeedcount:[[group objectForKey:@"NewsFeedCount"]intValue]];
                    [modal setGroupChannelArray:[group objectForKey:@"GreenChannel"]];
                    [modal setAddInfoRequired:[[group objectForKey:@"AdditionalInfoRequired"]boolValue]];
                    [modal setAddinfoString:[group objectForKey:@"InfoRequired"]];
                    PFFile *imageFile=[group objectForKey:@"ThumbnailPicture"];
                    [modal setGroupImageData:imageFile];
                    [modal setSecretCode:[group objectForKey:@"SecretCode"]];
                    [modal setOpenEntry:[[group objectForKey:@"JobHours"]intValue]];
                    [sharedobj.MyGroupArray addObject:modal];
                    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
                    //        [us setObject:tempDate forKey:@"LASTUPDATED"];
                    [us setObject:[NSDate date] forKey:@"LASTUPDATED"];
                    
                    [us synchronize];

                     [self.mygroupTableview.pullToRefreshView setLastUpdatedDate:[us objectForKey:@"LASTUPDATED"]];
                    
                                   }
                if (sharedobj.MyGroupArray.count!=0) {
//                    [_mygroupTableview setHidden:NO];
                    [_noresultView setHidden:YES];

                   
                }
                else
                {
                    [_mygroupTableview setHidden:NO];
                    [_noresultView setHidden:NO];
                }
                [self.mygroupTableview reloadData];

                 _mygroupTableview.hidden=NO;
                [self updateunreadmsg];
              
                

                
            }
            else
            {
                
                [sharedobj.MyGroupArray removeAllObjects];
                if (sharedobj.MyGroupArray.count!=0) {

                    [_mygroupTableview setHidden:NO];
                    [_noresultView setHidden:YES];
                }
                else
                {
                    [_mygroupTableview setHidden:NO];
                    [_noresultView setHidden:NO];
                }
                [self.mygroupTableview reloadData];
                _mygroupTableview.hidden=NO;

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
    if (sharedobj.MyGroupArray.count==0) {
        return 1;
    }
    else{
    if (sharedobj.search) {
        return sharedobj.searchmygroup.count;
    }
    else
    return sharedobj.MyGroupArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     if (sharedobj.MyGroupArray.count==0) {
         static NSString *CellIdentifier = @"Cell";
         
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         if (cell == nil) {
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
         }
         [cell.contentView addSubview:_noresultView];
         return cell;
     }
     else{
    static NSString *CellIdentifier = @"Cell";
    
    MyGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
           cell = [[MyGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
 
 
     if (sharedobj.search) {
         if (sharedobj.searchmygroup.count!=0) {
             GroupModalClass *modal = [sharedobj.searchmygroup objectAtIndex:indexPath.row];
       cell.groupImageview.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
             cell.groupImageview.file=modal.groupImageData;
             [cell.groupImageview loadInBackground];
             if (modal.messagecount!=0) {
                 cell.messagecountlabel.hidden=NO;
                 cell.messagecountlabel.text=[NSString stringWithFormat:@"%d",modal.messagecount];
             }
             else
             {
                 cell.messagecountlabel.hidden=YES;
             }
             cell.groupnamelbl.text=modal.groupName;
             if ([modal.groupType isEqualToString:@"Private"]) {
                 
                 cell.grouptypelbl.text=@"PRIVATE";
             }
            else if ([modal.groupType isEqualToString:@"Public"]) {
                 
                 cell.grouptypelbl.text=@"CHATTER";
             }
            else if ([modal.groupType isEqualToString:@"Secret"]) {
                
                cell.grouptypelbl.text=@"SECRET";
            }
             else
             {
              cell.grouptypelbl.text=@"OPEN";
                 
             }
             
             if ([modal.groupAdminArray containsObject:sharedobj.AccountNumber]) {
                 cell.adminlbl.hidden=NO;
                 
             }
             else
             {
                 cell.adminlbl.hidden=YES;
             }
             
            
                  cell.memberlabel.text=[NSString stringWithFormat:@"%d",modal.memberCount];
             
             
         }

     }
     else{
    if (sharedobj.MyGroupArray.count!=0) {
        GroupModalClass *modal = [sharedobj.MyGroupArray objectAtIndex:indexPath.row];
 cell.groupImageview.backgroundColor=[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
        cell.groupImageview.file=modal.groupImageData;
        [cell.groupImageview loadInBackground];

        cell.groupnamelbl.text=modal.groupName;
        if (modal.messagecount!=0) {
              cell.messagecountlabel.hidden=NO;
             cell.messagecountlabel.text=[NSString stringWithFormat:@"%d",modal.messagecount];
        }
        else
        {
            cell.messagecountlabel.hidden=YES;
        }
       
        if ([modal.groupType isEqualToString:@"Private"]) {
            
            cell.grouptypelbl.text=@"PRIVATE";
        }
        else if ([modal.groupType isEqualToString:@"Public"]) {
            
            cell.grouptypelbl.text=@"CHATTER";
        }
        else if ([modal.groupType isEqualToString:@"Secret"]) {
            
            cell.grouptypelbl.text=@"SECRET";
        }
        else
        {
           cell.grouptypelbl.text=@"OPEN";
        }
        if ([modal.groupAdminArray containsObject:sharedobj.AccountNumber]) {
            cell.adminlbl.hidden=NO;
                    }
        else
        {
            cell.adminlbl.hidden=YES;
        }

      
            cell.memberlabel.text=[NSString stringWithFormat:@"%d ",modal.memberCount];
       
       
    }
     }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    cell.backgroundColor=[UIColor whiteColor];
    
    
    
    
    return cell;
     }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sharedobj.MyGroupArray.count==0) {
    }
    else{
       GroupModalClass *modal ;
    if (sharedobj.search) {
           modal = [sharedobj.searchmygroup objectAtIndex:indexPath.row];

       }
       else
       {
           modal = [sharedobj.MyGroupArray objectAtIndex:indexPath.row];

       }
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
      
    }
 
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sharedobj.MyGroupArray.count==0) {
        return 80;
    }
    else
    return (_mygroupTableview.frame.size.height/6);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
