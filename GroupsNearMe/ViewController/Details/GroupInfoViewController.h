//
//  GroupInfoViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/20/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import <ParseUI/PFImageView.h>

@interface GroupInfoViewController : UIViewController
{
     Generic *sharedObj;
     NSMutableArray*groupInfoArray;
    NSMutableArray *memberArray,*mygroupArray,*adminArray;
    int memberCount;
    BOOL exit;
    NSString*currentdate;
    UILabel * titlelabel;
    int invitationcount;
}

@property (strong, nonatomic) IBOutlet PFImageView *groupImageview;
@property (strong, nonatomic) IBOutlet UILabel *grouptitleLabel;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *groupinfotableview;
@end
