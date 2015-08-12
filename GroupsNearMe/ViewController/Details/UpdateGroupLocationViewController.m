//
//  UpdateGroupLocationViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/20/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "UpdateGroupLocationViewController.h"
#import "GroupModalClass.h"
#include <math.h>
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#define DEG2RAD(degrees) (degrees * 0.01745329251)
#define RADIUS_OF_EARTH 6371000.0
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface UpdateGroupLocationViewController ()
@property (nonatomic, strong) MKCircle *circleOverlay;
@end

@implementation UpdateGroupLocationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    currentdate=[[NSString alloc]init];
    _locationManager = [[CLLocationManager alloc] init];
    mygroup=[[NSMutableArray alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    if(IS_OS_8_OR_LATER) {
        [_locationManager requestWhenInUseAuthorization];
        //[_locationManager requestAlwaysAuthorization];
    }
    [_locationManager startUpdatingLocation];
    
    [self.mapview setDelegate:self];
 
    
    //Configure the button
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    gr.numberOfTapsRequired=1;
    [self.radiusSlider addGestureRecognizer:gr];
    self.radiusSlider.value=sharedObj.currentgroupradius;
    _visibilitylabel.text=[NSString stringWithFormat:@"%d",sharedObj.currentgroupradius];
       sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
 
    
    if ([sharedObj.currentGroupAdminArray containsObject:sharedObj.AccountNumber]) {
        _createbtn.hidden=NO;
          _mapview.userInteractionEnabled=NO;
        _radiusSlider.hidden=NO;
      
          _lb1.hidden=NO;
        
          _lb5.hidden=NO;
          _groupvislibilitylabel.hidden=NO;
          _visibilitylabel.hidden=NO;
        _mapview.frame=CGRectMake(0, 70, 320, 330);
_gvlbl.hidden=NO;
        textlabel.text=@"";
        
    }
    else
    {
        _createbtn.hidden=YES;
        textlabel.text=[NSString stringWithFormat:@"Visibility Radius : %d meters",sharedObj.currentgroupradius];
        _mapview.userInteractionEnabled=NO;
        _mapview.frame=CGRectMake(0, 70, 320, 478);

        _radiusSlider.hidden=YES;
      
        _lb1.hidden=YES;
        
        _lb5.hidden=YES;
        _groupvislibilitylabel.hidden=YES;
        _gvlbl.hidden=YES;
        _visibilitylabel.hidden=YES;
    }
    [self performSelector:@selector(showUserLocation)
               withObject:nil
               afterDelay:0.5];
    // Do any additional setup after loading the view.
}
- (void) showUserLocation {
    
    
   
    centre.latitude=sharedObj.currentGroupLocation.latitude;
    centre.longitude=sharedObj.currentGroupLocation.longitude;
    MKCoordinateRegion region ;
    region.center.latitude = sharedObj.currentGroupLocation.latitude ;
    region.center.longitude = sharedObj.currentGroupLocation.longitude;
    region.span.longitudeDelta = 0.01f;
    region.span.latitudeDelta = 0.01f;
    [_mapview setRegion:region animated:TRUE];
    dropPin = [[Annotation alloc] initWithTitle:@"" location:centre];
    //[self.mapview setCenterCoordinate:zoomLocation animated:YES];
    [self.mapview addAnnotation:dropPin];
    
    // Annotation image.
    CGFloat width = 64;
    CGFloat height = 64;
    CGFloat margiX = self.mapview.center.x - (width / 2);
    CGFloat margiY = self.mapview.center.y - (height / 2) - 32;
    // 32 is half size for navigationbar and status bar height to set exact location for image.
    tapCount = 0;
    _annotationImage = [[UIImageView alloc] initWithFrame:CGRectMake(margiX, margiY, width, height)];
    [self.annotationImage setImage:[UIImage imageNamed:@"mapannotation.png"]];
    
    _mapview.zoomEnabled=YES;
    radiusVisibilty=sharedObj.currentgroupradius;
    [self fitthemap:sharedObj.currentgroupradius];
    
}

- (void)addBounceAnnimationToView:(UIView *)view {
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.values = @[@(0.05), @(1.1), @(0.9), @(1)];
    
    bounceAnimation.duration = 0.6;
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
    for (NSUInteger i = 0; i < bounceAnimation.values.count; i++) {
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    [bounceAnimation setTimingFunctions:timingFunctions.copy];
    bounceAnimation.removedOnCompletion = NO;
    
    [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

//---------------------------------------------------------------

#pragma mark
#pragma mark MKMapView delegate methods

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (UIView *view in views) {
        [self addBounceAnnimationToView:view];
    }
}

//---------------------------------------------------------------

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[Annotation class]]) {
        Annotation *customAnnotation = (Annotation *) annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        
        if (annotationView == nil)
            annotationView = customAnnotation.annotationView;
        else
            annotationView.annotation = annotation;
        [self addBounceAnnimationToView:annotationView];
        
        return annotationView;
    } else
        return nil;
}

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"Region will changed...");
    [self.mapview removeAnnotation:dropPin];
    [self.mapview addSubview:self.annotationImage];
    
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"Region did changed...");
    centre = [mapView centerCoordinate];
    
    
    [self.annotationImage removeFromSuperview];
    
    dropPin.coordinate = centre;
    [self.mapview addAnnotation:dropPin];
    [self zoomMapview:radiusVisibilty];
    
    
}
-(void)delayedMapViewRegionDidChangeAnimated:(NSArray *)args
{
    //    MKMapView *mapView = [args objectAtIndex:0];
    //    BOOL animated = [[args objectAtIndex:1] boolValue];
    
    // do what you would have done in mapView:regionDidChangeAnimated: here
}

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (userLocation.location == nil)
        return;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self.locationManager stopUpdatingLocation];
}



- (IBAction)back:(id)sender {
    
    [[self navigationController]popViewControllerAnimated:YES];
}
- (IBAction)radiusSlider:(id)sender {
    
    radiusVisibilty =(int)self.radiusSlider.value;
    [self fitthemap:radiusVisibilty];
    
    _visibilitylabel.text=[NSString stringWithFormat:@"%d",radiusVisibilty];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [self.view makeToast:@"Unable to get your location" duration:3.0 position:@"bottom"];

}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    
}
- (void)sliderTapped:(UIGestureRecognizer *)g
{
    /////////////// For TapCount////////////
    
    tapCount = tapCount + 1;
    NSLog(@"Tap Count -- %d",tapCount);
    
    /////////////// For TapCount////////////
    
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return; // tap on thumb, let slider deal with it
    CGPoint pt = [g locationInView: s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
    radiusVisibilty =(int)self.radiusSlider.value;
    [self fitthemap:radiusVisibilty];
    
    
    
    _visibilitylabel.text=[NSString stringWithFormat:@"%d",radiusVisibilty];
    
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:self.circleOverlay];
        [circleRenderer setFillColor:[[UIColor colorWithRed:3.0/255.0 green:169.0/255.0 blue:244.0/255.0 alpha:1.0] colorWithAlphaComponent:0.2f]];
        [circleRenderer setStrokeColor:[[UIColor colorWithRed:3.0/255.0 green:169.0/255.0 blue:244.0/255.0 alpha:1.0] colorWithAlphaComponent:1.0f]];
        [circleRenderer setLineWidth:1.0f];
        return circleRenderer;
    }
    return nil;
}
-(void)fitthemap:(int)diameter
{
    //    if (previousradius!=0) {
    //
    //        if (previousradius>diameter) {
    MKCoordinateRegion region;
    //Set Zoom level using Span
    MKCoordinateSpan span;
    region.center=centre;
    span.latitudeDelta=0.01;
    span.longitudeDelta=0.01;
    region.span=span;
    [_mapview setRegion:region animated:TRUE];
    //        }
    //        else
    //        {
    //            MKCoordinateRegion region;
    //            //Set Zoom level using Span
    //            MKCoordinateSpan span;
    //            region.center=centre;
    //
    //            span.latitudeDelta=0.02;
    //            span.longitudeDelta=0.02;
    //            region.span=span;
    //            [_mapview setRegion:region animated:TRUE];
    //        }
    //    }
    //    else{
    //        MKCoordinateRegion region;
    //        //Set Zoom level using Span
    //        MKCoordinateSpan span;
    //        region.center=centre;
    //
    //        span.latitudeDelta=0.02;
    //        span.longitudeDelta=0.02;
    //        region.span=span;
    //        [_mapview setRegion:region animated:TRUE];
    //    }
    
    
    previousradius=diameter;
    [self zoomMapview:radiusVisibilty];
    
}
-(void)zoomMapview:(int)radius
{
    
    if (self.circleOverlay != nil) {
        [self.mapview removeOverlay:self.circleOverlay];
        self.circleOverlay = nil;
    }
    self.circleOverlay = [MKCircle circleWithCenterCoordinate:centre radius:radiusVisibilty];
    [self.mapview addOverlay:self.circleOverlay];
    
    ;
}
- (IBAction)dragexit:(id)sender {
    radiusVisibilty =(int)self.radiusSlider.value;
    [self fitthemap:radiusVisibilty];
     _visibilitylabel.text=[NSString stringWithFormat:@"%d",radiusVisibilty];
}
- (IBAction)updatebtnClicked:(id)sender
{
    BOOL internetconnect=[sharedObj connected];
    
    if (!internetconnect) {
        [self.view makeToast:@"No Internet Connection" duration:3.0 position:@"bottom"];
        
    }
    else{
    
    [SVProgressHUD showWithStatus:@"Updating Group Location..." maskType:SVProgressHUDMaskTypeBlack];
        sharedObj.currentgroupradius=radiusVisibilty;
        PFQuery*groupQuery=[PFQuery queryWithClassName:@"Group"];
        [groupQuery whereKey:@"objectId" equalTo:sharedObj.GroupId];
        [groupQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                object[@"GroupLocation"]=sharedObj.currentGroupLocation;
                object[@"VisibiltyRadius"]= [NSNumber numberWithInt:sharedObj.currentgroupradius];
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
     [SVProgressHUD showWithStatus:@" Group Location Updated Sucessfully" maskType:SVProgressHUDMaskTypeBlack];
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

@end
