//
//  UpdateAccessPermissionViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/20/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "UpdateAccessPermissionViewController.h"
#import "GroupModalClass.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#define kOFFSET_FOR_KEYBOARD 80.0
@interface UpdateAccessPermissionViewController ()

@end

@implementation UpdateAccessPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    sharedObj=[Generic sharedMySingleton];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    _addinfoTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    currentdate=[[NSString alloc]init];
    _passcodetextfield.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);

    _passcodetextfield.layer.cornerRadius=5.0;
    [_passcodetextfield setClipsToBounds:YES];
    _passcodetextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _passcodetextfield.layer.borderWidth=1.0;
    mygroup=[[NSMutableArray alloc]init];
    
  
    
    
    
   
    

    addinfostring=[[NSString alloc]init];
    secretcode=[[NSString alloc]init];
    
    
    _addinfoTextfield.layer.cornerRadius=5.0;
    [_addinfoTextfield setClipsToBounds:YES];
    _addinfoTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _addinfoTextfield.layer.borderWidth=1.0;
    
    [self setFrame];
    
    // Do any additional setup after loading the view.
}
-(void)setFrame
{
    if (sharedObj.currentgroupSecret) {
        _addinfoView.hidden=YES;
        _passcodeView.hidden=NO;
       
        [_passcodeSwitch setOn:YES animated:NO];
        [_addinfoSwitch setOn:NO animated:NO];
        
    }
    else if (sharedObj.currentgroupAddinfo)
    {
      
        _addinfoView.hidden=NO;
        _passcodeView.hidden=YES;
       
        [_passcodeSwitch setOn:NO animated:NO];
        [_addinfoSwitch setOn:YES animated:NO];
    }
    else
    {
       
        _addinfoView.hidden=YES;
        _passcodeView.hidden=YES;
        
        [_passcodeSwitch setOn:NO animated:NO];
        [_addinfoSwitch setOn:NO animated:NO];
    }
    _addinfoTextfield.text=sharedObj.addinfo;
    _passcodetextfield.text=sharedObj.secretCode;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField==_addinfoTextfield) {
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        
    }
}
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
-(void)findFrameFromString:(NSString*)string andCorrespondingLabel:(UILabel*) label1
{
    CGSize expectedLableSize =[string sizeWithFont:label1.font constrainedToSize:label1.frame.size lineBreakMode:NSLineBreakByCharWrapping];
    CGRect newFrame =  label1.frame;
    newFrame.size.height = expectedLableSize.height;
    label1.frame =newFrame;
    label1.lineBreakMode = NSLineBreakByCharWrapping;
    label1.numberOfLines=0;
    [label1 sizeToFit];
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField==_addinfoTextfield) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length>20) {
            return NO;
        }
        
    }
    else if (textField==_passcodetextfield)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length>5) {
            return NO;
        }
    }
    return YES;
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_addinfoTextfield) {
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            [self setViewMovedUp:NO];
        }
    }
   
    [textField resignFirstResponder];
    
    return YES;
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
    [[self navigationController]popViewControllerAnimated:YES];
}
- (IBAction)passcode:(id)sender {
    
    if ([sender isOn]) {
        secret=YES;
        _passcodeView.hidden=NO;
        _addinfoView.hidden=YES;
        
        if (addinfo) {
            addinfo=NO;
        }
        [self.addinfoSwitch setOn:NO animated:YES];
        [self.passcodeSwitch setOn:YES animated:YES];
        
    }
    else
    {
        secret=NO;
        _passcodeView.hidden=YES;
        _addinfoView.hidden=YES;
        
        [self.passcodeSwitch setOn:NO animated:YES];
        
        
    }
    _addinfoTextfield.text=sharedObj.addinfo;
    _passcodetextfield.text=sharedObj.secretCode;
}

- (IBAction)addinfo:(id)sender {
   
    if ([sender isOn]) {
        addinfo=YES;
        _addinfoView.hidden=NO;
        _passcodeView.hidden=YES;
        
        if (secret) {
            secret=NO;
        }
        [self.passcodeSwitch setOn:NO animated:YES];
        [self.addinfoSwitch setOn:YES animated:YES];
        
    }
    else
    {
        addinfo=NO;
        _addinfoView.hidden=YES;
        _passcodeView.hidden=YES;
        [self.addinfoSwitch setOn:NO animated:YES];
        
        
    }
    _addinfoTextfield.text=sharedObj.addinfo;
    _passcodetextfield.text=sharedObj.secretCode;
}

- (IBAction)donebtnClicked:(id)sender {
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
    [SVProgressHUD showWithStatus:@"Updating Group Access Permission ..." maskType:SVProgressHUDMaskTypeBlack];
    if (_passcodeView.hidden&&_addinfoView.hidden) {
        sharedObj.currentgroupSecret=NO;
        sharedObj.currentgroupAddinfo=NO;
        sharedObj.addinfo=@"";
        sharedObj.secretCode=@"";
    }
   else if (_passcodeView.hidden) {
        sharedObj.currentgroupSecret=NO;
        sharedObj.currentgroupAddinfo=YES;
        sharedObj.addinfo=_addinfoTextfield.text;
        sharedObj.addinfo=[sharedObj.addinfo stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceCharacterSet]];
        sharedObj.secretCode=@"";
        if (sharedObj.addinfo.length==0) {
            [SVProgressHUD dismiss];
          
             [self.view makeToast:@"Enter question or information you seek from new users that apply to join this group" duration:3.0 position:@"bottom"];
            return;
        }

    }
    else if (_addinfoView.hidden) {

       sharedObj.currentgroupSecret=YES;
        sharedObj.currentgroupAddinfo=NO;
        sharedObj.addinfo=@"";
        sharedObj.secretCode=_passcodetextfield.text;
        sharedObj.secretCode=[sharedObj.secretCode stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
        if (sharedObj.secretCode.length==0) {
             [SVProgressHUD dismiss];
          
             [self.view makeToast:@"Enter the passcode to join this group" duration:3.0 position:@"bottom"];
            return;
        }

    }
  
    PFQuery*groupQuery=[PFQuery queryWithClassName:@"Group"];
    [groupQuery whereKey:@"objectId" equalTo:sharedObj.GroupId];
    [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            object[@"AdditionalInfoRequired"]=[NSNumber numberWithBool:sharedObj.currentgroupAddinfo];
            object[@"InfoRequired"]=sharedObj.addinfo;
            object[@"SecretStatus"]=[NSNumber numberWithBool:sharedObj.currentgroupSecret];
            object[@"SecretCode"]= sharedObj.secretCode;
            [object saveInBackground];
            [self CallMyService];
        }
        else
        {
             [SVProgressHUD dismiss];
        }
    }];

    }
}
-(void)CallMyService
{
     [SVProgressHUD showWithStatus:@"Group Access Permission Updated Successfully" maskType:SVProgressHUDMaskTypeBlack];
    mygroup=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
    PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
    [myquery whereKey:@"objectId" containedIn:mygroup];
    [myquery whereKey:@"GroupStatus" equalTo:@"Active"];
    [myquery orderByDescending:@"updatedAt"];
    [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
            [SVProgressHUD dismiss];
        } else {
            
            [PFObject unpinAllObjectsInBackgroundWithName:@"MYGROUP"];
            [PFObject pinAllInBackground:objects withName:@"MYGROUP"];
            [SVProgressHUD dismiss];
        }
    }];

    
    
       
    
    
}
@end
