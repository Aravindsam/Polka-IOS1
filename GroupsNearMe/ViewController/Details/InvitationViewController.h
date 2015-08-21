//
//  InvitationViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/5/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Generic.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "NSDate+HumanizedTime.h"
@interface InvitationViewController : UIViewController<CLLocationManagerDelegate>
{
    Generic*sharedObj;
    UILabel*label;
    float tableHeight;
 NSMutableArray*inviteArray,*groupMembers,*unquieArray,*mygroup,*ownergroup,*adminArray;
    BOOL Accept,approval;
    int acceptindex;
    CLLocationManager *locationManager;
    CLLocation *_currentLocation;
    NSDateHumanizedType humanizedType;

}
@property (strong, nonatomic) IBOutlet UILabel *noresultlabel;
@property (strong, nonatomic)PFGeoPoint *point;
@property (strong, nonatomic) IBOutlet UIView *headerview;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *invitationtableview;
-(void)acceptAction:(int)index5;
-(void)rejectAction:(int)index6;
@end
