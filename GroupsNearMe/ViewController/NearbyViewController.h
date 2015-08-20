//
//  NearbyViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/13/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Generic.h"
#import <Parse/Parse.h>
#import "NSDate+HumanizedTime.h"

@interface NearbyViewController : UIViewController<CLLocationManagerDelegate,UIGestureRecognizerDelegate>
{
    Generic *sharedobj;
    CLLocationManager *locationManager;
    CLLocation *_currentLocation;
    NSMutableArray *myGroupIdArray;
    NSMutableArray *QueryArray;
    NSMutableArray*invitationArray,*ownerGroup,*groupMembers,*unquieArray,*mygroup;
    NSMutableArray*invitationarray;
    NSString*inviationId;
    UITapGestureRecognizer*tapgesture;
    int indexpathvalue,previousIndex;
    UILabel*label;
    int groupvisiblityradius;
    CLLocationDistance distancefromgroup;
    CLLocation *grouplocation,*userlocation;
    BOOL joinClicked;

    NSString*currentdate;
    NSDateHumanizedType humanizedType;

}
@property (strong, nonatomic) IBOutlet UIView *noresultLabel;
@property (strong, nonatomic) IBOutlet UILabel *tapLabel;

@property (strong, nonatomic)PFGeoPoint *point;
-(void)joinbuttonPressed:(int)indexval;
@property (strong, nonatomic) IBOutlet UITableView *nearbyTableview;

@end
