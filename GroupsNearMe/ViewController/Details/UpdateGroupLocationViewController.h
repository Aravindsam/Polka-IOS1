//
//  UpdateGroupLocationViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/20/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "Generic.h"
@interface UpdateGroupLocationViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    Annotation *dropPin;
    PFGeoPoint *pointVal;
    int radiusVisibilty,tapCount;
    Generic *sharedObj;
    CLLocationCoordinate2D centre;
    UILabel*radiusLabel;
    int previousradius;
    NSMutableArray*members;
    NSString*groupId,*groupimgurl;
    NSMutableArray*mygroup;
    NSString*currentdate;
    
    IBOutlet UILabel *textlabel;
}
- (IBAction)dragexit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *createbtn;


@property (strong, nonatomic) IBOutlet UILabel *lb1;
@property (strong, nonatomic) IBOutlet UILabel *gvlbl;

@property (nonatomic, strong) UIImageView           *annotationImage;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UISlider *radiusSlider;
- (IBAction)radiusSlider:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lb5;
@property (strong, nonatomic) IBOutlet UILabel *groupvislibilitylabel;
@property (strong, nonatomic) IBOutlet UILabel *visibilitylabel;

@property (strong, nonatomic) IBOutlet MKMapView *mapview;
- (IBAction)back:(id)sender;
- (IBAction)updatebtnClicked:(id)sender;


@end
