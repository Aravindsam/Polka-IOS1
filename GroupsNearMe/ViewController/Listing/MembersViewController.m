//
//  MembersViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/4/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "MembersViewController.h"
#import<Parse/Parse.h>
#import "MemberModalclass.h"
#import "GroupMemberTableViewCell.h"
#import "MemberDetailViewController.h"
#import "SVPullToRefresh.h"
@interface MembersViewController ()

@end

@implementation MembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    [sharedObj.MemberArray removeAllObjects];
    [sharedObj.searchMemberArray removeAllObjects];
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    tempsearchArray= [[NSMutableArray alloc]init];
    resultArray=[[NSMutableArray alloc]init];
     [self callService];
    _thesearchbar.layer.borderColor=[UIColor whiteColor].CGColor;
    __weak MembersViewController *weakSelf = self;
    [self.membertableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.membertableView beginUpdates];
            
           
                [weakSelf callService];
            
            
            [weakSelf.membertableView endUpdates];
            [weakSelf.membertableView.pullToRefreshView stopAnimating];
        });
    }];
    _thesearchbar.layer.borderWidth=1.0;
    _thesearchbar.layer.borderColor=[UIColor whiteColor].CGColor;
    _thesearchbar.clipsToBounds=YES;
    _membertableView.separatorStyle=UITableViewCellSeparatorStyleNone;
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callService) name:@"RELOADMEMBER" object:nil];
        // Do any additional setup after loading the view.
}
- (void) dismissKeyboard
{
    // add self
    [self.thesearchbar resignFirstResponder];
}
-(void)callService
{
    
    PFQuery *userquery=[PFQuery queryWithClassName:@"MembersDetails"];
    [userquery whereKey:@"MemberNo" containedIn:sharedObj.currentGroupmemberArray];
    [userquery whereKey:@"GroupId" equalTo:sharedObj.GroupId];
    [userquery whereKey:@"MemberStatus" equalTo:@"Active"];
    [userquery includeKey:@"UserId"];
    [userquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            if(objects.count!=0){
                [sharedObj.MemberArray removeAllObjects];
                [sharedObj.searchMemberArray removeAllObjects];
            for (PFObject *object in objects)
            {
                 MemberModalclass *member=[[MemberModalclass alloc]init];
                PFFile*userimg=object[@"UserId"][@"ThumbnailPicture"];
                [member setUserImageurl:userimg];
                [member setUserName:object[@"UserId"][@"UserName"]];
                [member setUserNo:object[@"UserId"][@"MobileNo"]];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMMM dd,yyyy"];
                
                NSString *string = [dateFormatter stringFromDate:[object objectForKey:@"JoinedDate"]];
                [member setUserjoindate:string];
                [member setUserAddinfo:object[@"AdditionalInfoProvided"]];
                [member setAdmin:[[object objectForKey:@"GroupAdmin"]boolValue]];
                [sharedObj.MemberArray addObject:member];
            }
                if (sharedObj.MemberArray.count!=0) {
                    [_membertableView reloadData];
                    
                }
            
        }
            else
            {
                [sharedObj.MemberArray removeAllObjects];
                if (sharedObj.MemberArray.count!=0) {
                    [_membertableView reloadData];
                    
                }
            }

        }
    }];

    
    
   }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (sharedObj.membersearch) {
        return [sharedObj.searchMemberArray count];
        
    } else {
    return sharedObj.MemberArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    GroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[GroupMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    MemberModalclass *modal ;
    if (sharedObj.membersearch) {
        modal = [sharedObj.searchMemberArray objectAtIndex:indexPath.row];

    }
    else
    {
        modal = [sharedObj.MemberArray objectAtIndex:indexPath.row];
 
    }
    cell.namelbl.text=modal.userName;
//    NSURL *url = [NSURL URLWithString:modal.userImageurl];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    
//
    cell.profileImageView.file=modal.userImageurl;
    [cell.profileImageView loadInBackground];
    if ([sharedObj.currentGroupAdminArray containsObject:modal.userNo]) {
        cell.adminlbl.hidden=NO;
    }
    else
    {
      cell.adminlbl.hidden=YES;
    }
    [cell.namelbl sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor=[UIColor whiteColor];
    
    
    
    
    return cell;
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_thesearchbar resignFirstResponder];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [_thesearchbar resignFirstResponder];
    _thesearchbar.text=@"";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MemberDetailViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"MemberDetailViewController"];
    settingsViewController.indexValue=(int)indexPath.row;
    settingsViewController.fromFeed=NO;

    [self.navigationController pushViewController:settingsViewController animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (_membertableView.frame.size.height/7);
}


- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    if([searchText isEqualToString:@""] || searchText==nil) {
        sharedObj.membersearch=NO;
        [_thesearchbar resignFirstResponder];

        [_membertableView reloadData];
    }
    else
    {   sharedObj.membersearch=YES;
        MemberModalclass *modal;
        
        [tempsearchArray removeAllObjects];
        [resultArray removeAllObjects];
        [sharedObj.searchMemberArray removeAllObjects];
        for (int i=0; i<sharedObj.MemberArray.count; i++) {
            modal = [sharedObj.MemberArray objectAtIndex:i];
            [tempsearchArray addObject:modal.userName];
        }
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", _thesearchbar.text];
        resultArray = [NSMutableArray arrayWithArray:[tempsearchArray filteredArrayUsingPredicate:resultPredicate]];
        for (int j=0; j< resultArray.count; j++) {
            arrayindex= (int)[tempsearchArray indexOfObject:resultArray[j]];
            [sharedObj.searchMemberArray addObject:[sharedObj.MemberArray objectAtIndex:arrayindex]];
        }
          [_membertableView reloadData];

    }
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
 
    if([searchBar.text isEqualToString:@""] || searchBar.text==nil) {
        sharedObj.membersearch=NO;
        [_thesearchbar resignFirstResponder];
        [_membertableView reloadData];
    }
    else
    {
         [_thesearchbar resignFirstResponder];
           sharedObj.membersearch=YES;
        MemberModalclass *modal;
        [resultArray removeAllObjects];
        [tempsearchArray removeAllObjects];
        [sharedObj.searchMemberArray removeAllObjects];
        for (int i=0; i<sharedObj.MemberArray.count; i++) {
            modal = [sharedObj.MemberArray objectAtIndex:i];
            [tempsearchArray addObject: modal.userName];
        }
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", _thesearchbar.text];
        resultArray = [NSMutableArray arrayWithArray:[tempsearchArray filteredArrayUsingPredicate:resultPredicate]];
        for (int j=0; j< resultArray.count; j++) {
            arrayindex= (int)[tempsearchArray indexOfObject:resultArray[j]];
            [sharedObj.searchMemberArray addObject:[sharedObj.MemberArray objectAtIndex:arrayindex]];
          
        }
     
          [_membertableView reloadData];
        
    }

}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"CANCEL");
    searchBar.text=@"";
   sharedObj.membersearch=NO;
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

- (IBAction)back:(id)sender {
     [_thesearchbar resignFirstResponder];
    [[self navigationController]popViewControllerAnimated:YES];
}
@end
