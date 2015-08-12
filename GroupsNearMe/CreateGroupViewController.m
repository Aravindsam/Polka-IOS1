//
//  CreateGroupViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/9/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "OpenGroup1ViewController.h"
#import "PrivateGroup1ViewController.h"
#import "SecretGrpViewController.h"
#import "CreateGroupTableViewCell.h"
#import "Toast+UIView.h"
@interface CreateGroupViewController ()
{
     CreateGroupTableViewCell *previousCell;
}
@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    _headerView.backgroundColor=[Generic colorFromRGBHexString:headerColor];
   self.createtableView.backgroundColor=[UIColor whiteColor];
    _headerView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _headerView.layer.borderWidth=0.5;
    
    self.createtableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    grouptype=[[NSMutableArray alloc]initWithObjects:@" OPEN GROUP",@" PRIVATE GROUP",@" SECRET GROUP", nil];
    groupdetailArray=[[NSMutableArray alloc]initWithObjects:@"Anyone nearby can find the group and join without approval",@"Anyone nearby can find the group but joining needs invitation or approval",@"No one can find this group.Join only by invitation", nil ];
    grouptypeimg=[[NSMutableArray alloc]initWithObjects:@"open.png",@"private.png",@"secret.png", nil];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ return grouptype.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CreateGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[CreateGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.namelabel.text=[grouptype objectAtIndex:indexPath.row];
    cell.namelabel.textColor=[UIColor blackColor];
    cell.grouptypeimageview.image=[UIImage imageNamed:[grouptypeimg objectAtIndex:indexPath.row]];
    cell.detaillabel.text=[groupdetailArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor whiteColor];
    if(cell.selected || indexPath.row == selectedIndex)
    {
        cell.selectimageview.image=[UIImage imageNamed:@"selected.png"];
    }
    else
    {
        cell.selectimageview.image=[UIImage imageNamed:@"unselected.png"];
    }
    
    if (indexPath.row==0) {
        cell.grouptypeimageview.frame=CGRectMake(0,8, 48, 48);

    }
    else if (indexPath.row==1)
    {
        cell.grouptypeimageview.frame=CGRectMake(0, 8, 48, 37);

    }
    else if (indexPath.row==2)
    {
        cell.grouptypeimageview.frame=CGRectMake(0, 8, 48, 37);

    }
    
    
    UIImageView* separatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99.5, 320, 0.5)];/// change size as you need.
    separatorLineView.image=[UIImage imageNamed:@"line.png"];
    // you
    
       [cell.contentView addSubview:separatorLineView];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
  
    selectedIndex=(int)indexPath.row;
    
   
    [_createtableView reloadData];
}


- (IBAction)back:(id)sender {
   [[NSNotificationCenter defaultCenter]postNotificationName:@"CALLHOME" object:nil];
    
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

- (IBAction)movetocreate:(id)sender {
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
    sharedObj.groupimageData=nil;
    sharedObj.aboutGroup=nil;
    sharedObj.groupdescription=nil;
    sharedObj.groupLocation=nil;
    sharedObj.radiusVisibilityVal=50;
    sharedObj.openEntryVal=0;
    sharedObj.GroupName=nil;
    sharedObj.inviteNo=nil;
    sharedObj.otherText=nil;
    sharedObj.AdditionalInfotext=nil;
    sharedObj.greenchannelArray=nil;
    sharedObj.selectedIdArray=nil;
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (selectedIndex==0) {
        OpenGroup1ViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"OpenGroup1ViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
    }
    else if (selectedIndex==1)
    {
        PrivateGroup1ViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"PrivateGroup1ViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];
    }
    else if (selectedIndex==2)
    {
        SecretGrpViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"SecretGrpViewController"];
        [[self navigationController]pushViewController:settingsViewController animated:YES];

    }
    }
}
@end
