//
//  ContactUsViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/8/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "ContactUsViewController.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    _header.backgroundColor=[Generic colorFromRGBHexString:headerColor];
  
    description=[[NSString alloc]init];
    category=[[NSString alloc]init];
    mobileno=[[NSString alloc]init];
    
    sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    
    categoryArray=[[NSMutableArray alloc]initWithObjects:@"Give us feedback",@"Request a feature",@"Contact us with your question", nil];
    _categorylbl.text=@" Give us feedback";
    
    singletap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showcountry:)];
    singletap.numberOfTapsRequired=1;
    _categorylbl.userInteractionEnabled=YES;
    [_categorylbl addGestureRecognizer:singletap];
    
    _categoryTableView.hidden=YES;
    _backgroundlbl.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _backgroundlbl.layer.borderWidth=0.5;
    _categorylbl.backgroundColor=[UIColor clearColor];
    _categoryTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _categoryTableView.layer.borderWidth=1.0;
    
    _descriptionView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _descriptionView.layer.borderWidth=0.5;
    _descriptionView.layer.cornerRadius=5.0;
    _descriptionView.clipsToBounds=YES;
    
    // Do any additional setup after loading the view.
}
-(void)showcountry:(UIGestureRecognizer*)gesture
{
    [_descriptionView resignFirstResponder];
   
    if (_categoryTableView.hidden) {
         [_arrowImageView setImage:[UIImage imageNamed:@"up_arrow.png"]];
      _categoryTableView.hidden=NO;
    }
    else
    {
         [_arrowImageView setImage:[UIImage imageNamed:@"down_arrow.png"]];
        _categoryTableView.hidden=YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([newString length]>250) {
        return NO;
    }
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [categoryArray count];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[categoryArray objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font=[UIFont fontWithName:@"Lato-Medium" size:15.0];
    cell.textLabel.textColor=[UIColor blackColor];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _categorylbl.text=[NSString stringWithFormat:@" %@ ",[categoryArray objectAtIndex:indexPath.row]];
    _categoryTableView.hidden=YES;
    [_arrowImageView setImage:[UIImage imageNamed:@"down_arrow.png"]];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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

- (IBAction)menu:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CALLHOME" object:nil];

}
- (IBAction)contactUsbtn:(id)sender {
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
//        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
    category=_categorylbl.text;
    category=[category stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceCharacterSet]];
    description=_descriptionView.text;
    description=[description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([category isEqualToString:@"Choose Category"]|| category.length==0||category==NULL) {
       
         [self.view makeToast:@"Please Choose Category" duration:3.0 position:@"bottom"];
        return;
    }
    if (description.length==0||description==NULL) {
          [self.view makeToast:@"Description cannot be empty" duration:3.0 position:@"bottom"];
        return;
    }
    [SVProgressHUD showWithStatus:@"Sending Feedback..." maskType:SVProgressHUDMaskTypeBlack];
    PFObject *postObject = [PFObject objectWithClassName:@"ContactUS"];
    postObject[@"MobileNo"]=sharedObj.AccountNumber;
    postObject[@"Category"]=category;
    postObject[@"Description"]=description;
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showWithStatus:@"Feedback send successfully..." maskType:SVProgressHUDMaskTypeBlack];

            _descriptionView.text=@"";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self tableView:_categoryTableView didSelectRowAtIndexPath:indexPath];
           [SVProgressHUD dismiss];
            
            
        }
        else
        {
            [SVProgressHUD dismiss];
        }
    }];
    

    }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (!_categoryTableView.hidden) {
    
        _categoryTableView.hidden=YES;
    }
       [_arrowImageView setImage:[UIImage imageNamed:@"down_arrow.png"]];
    return YES;
}

@end
