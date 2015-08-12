//
//  SettingViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/30/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "Generic.h"
@interface SettingViewController : UIViewController
{
      BOOL push,sound;
    Generic *sharedObj;
    NSString*ProfileId;
}
@property (strong, nonatomic) IBOutlet UIButton *savebtn;
@property (strong, nonatomic) IBOutlet UIView *headerview;
@property (strong, nonatomic) IBOutlet UISwitch *soundswitchbtn;
@property (strong, nonatomic) IBOutlet UISwitch *pushswitchbtn;
- (IBAction)soundswitch:(id)sender;
- (IBAction)pushswitch:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;
@end
