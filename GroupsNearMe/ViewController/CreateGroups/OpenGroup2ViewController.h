//
//  OpenGroup2ViewController.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/18/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "Generic.h"
#import "NSDate+HumanizedTime.h"
@interface OpenGroup2ViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    Annotation *dropPin;
    PFGeoPoint *pointVal;
    int radiusVisibilty,tapCount;
    Generic *sharedObj;
    CLLocationCoordinate2D centre;
    UILabel*radiusLabel;
    int previousradius;
    NSMutableArray*members;
    NSString*groupId;
    NSMutableArray*mygroup;
    BOOL create;
    NSString*currentdate;
    NSString *timestamp;
    PFFile*groupimgurl;
    NSDateHumanizedType humanizedType;

    
}
@property (strong, nonatomic) IBOutlet UILabel *visibilitylabel;
- (IBAction)dragexit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *createbtn;

@property (weak, nonatomic) IBOutlet UIButton *userHeadingBtn;
@property (strong, nonatomic) IBOutlet UIButton *currentbtn;
@property (nonatomic, strong) UIImageView           *annotationImage;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UISlider *radiusSlider;
- (IBAction)radiusSlider:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *headerview;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
- (IBAction)back:(id)sender;
- (IBAction)createbtnClicked:(id)sender;
- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
@end
