//
//  PendingInviteViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/2/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MFSideMenu.h"
#import "Generic.h"
#import <CoreLocation/CoreLocation.h>
#import "NSDate+HumanizedTime.h"

@interface PendingInviteViewController : UIViewController<CLLocationManagerDelegate>
{
    Generic *sharedObj;
    NSMutableArray*invitesIdArray;
    NSDate *lastupdate;
    NSMutableArray *myGroupIdArray;
    NSMutableArray*ownerGroup,*groupMembers,*unquieArray,*mygroup;
    CLLocationManager *locationManager;
    CLLocation *_currentLocation;
    int indexval;
    CLLocationDistance distancefromgroup;
    CLLocation *grouplocation,*userlocation;
    NSString*currentdate;
    NSDateHumanizedType humanizedType;

}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *noresultView;
- (IBAction)back:(id)sender;
@property (strong, nonatomic)PFGeoPoint *point;

@property (strong, nonatomic) IBOutlet UITableView *invitationtableview;

-(void)acceptAction:(int)index;
-(void)rejectAction:(int)index;
@end
