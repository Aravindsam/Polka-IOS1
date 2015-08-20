//
//  PrivateGroup2ViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/18/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "Generic.h"
#import "NSDate+HumanizedTime.h"

@interface PrivateGroup2ViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    Annotation *dropPin;
    PFGeoPoint *pointVal;
    int radiusVisibilty,tapCount;
    NSMutableArray*members;
    NSString*groupId;
    PFFile*groupimgurl;
    NSMutableArray*mygroup;
    Generic *sharedObj;
    CLLocationCoordinate2D centre;
    BOOL create;
    NSString*currentdate,*timestamp;
    NSDateHumanizedType humanizedType;

}
@property (strong, nonatomic) IBOutlet UILabel *visibilitylabel;
@property (strong, nonatomic) IBOutlet UIView *privateview;
@property (strong, nonatomic) IBOutlet UIScrollView *privateScrollview;
@property (weak, nonatomic) IBOutlet UIButton *userHeadingBtn;
@property (nonatomic, strong) CLLocationManager *locationManager;
- (IBAction)dragendRadius:(id)sender;

@property (strong, nonatomic) IBOutlet UISlider *radiusSlider;

- (IBAction)radiusChange:(id)sender;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *headerview;
- (IBAction)nextbtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property (strong, nonatomic) IBOutlet UIButton *nextbtn;
@end
