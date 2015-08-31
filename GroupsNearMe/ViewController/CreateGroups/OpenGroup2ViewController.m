//
//  OpenGroup2ViewController.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 5/18/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "OpenGroup2ViewController.h"
#import "InsideGroupViewController.h"
#import "GroupModalClass.h"
#import "Toast+UIView.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface OpenGroup2ViewController ()
@property (nonatomic, strong) MKCircle *circleOverlay;

@end

@implementation OpenGroup2ViewController
@synthesize userHeadingBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    sharedObj=[Generic sharedMySingleton];
    _headerview.backgroundColor=[Generic colorFromRGBHexString:headerColor];
    create=NO;
    humanizedType = NSDateHumanizedSuffixAgo;


    timestamp=[[NSString alloc]init];
    groupId=[[NSString alloc]init];
    groupimgurl=[[PFFile alloc]init];
    mygroup=[[NSMutableArray alloc]init];
    currentdate=[[NSString alloc]init];
    
    sharedObj.AccountNumber=[[NSUserDefaults standardUserDefaults]objectForKey:@"MobileNo"];
    sharedObj.AccountCountry=[[NSUserDefaults standardUserDefaults]objectForKey:@"CountryName"];
    sharedObj.userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
  
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    if(IS_OS_8_OR_LATER) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
    
    [self.mapview setDelegate:self];
    [self.mapview setShowsUserLocation:YES];
    
    UIImage *buttonImage = [UIImage imageNamed:@"greyButtonHighlight.png"];
    UIImage *buttonImageHighlight = [UIImage imageNamed:@"greyButton.png"];
    UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
    
    //Configure the button
    userHeadingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [userHeadingBtn addTarget:self action:@selector(startShowingUserHeading:) forControlEvents:UIControlEventTouchUpInside];
    //Add state images
    [userHeadingBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [userHeadingBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [userHeadingBtn setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    
    //Position and Shadow
    
    //userHeadingBtn.frame = CGRectMake(5,screenBounds.size.height-145,39,30);
    userHeadingBtn.frame = CGRectMake(5,10,39,30);
    userHeadingBtn.layer.cornerRadius = 8.0f;
    userHeadingBtn.layer.masksToBounds = NO;
    userHeadingBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    userHeadingBtn.layer.shadowOpacity = 0.8;
    userHeadingBtn.layer.shadowRadius = 1;
    userHeadingBtn.layer.shadowOffset = CGSizeMake(0, 1.0f);
    
    [self.mapview addSubview:userHeadingBtn];
    
   
    self.radiusSlider.value=sharedObj.radiusVisibilityVal;

    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    gr.numberOfTapsRequired=1;
    [self.radiusSlider addGestureRecognizer:gr];
    
    radiusVisibilty =(int)self.radiusSlider.value;
    _visibilitylabel.text=[NSString stringWithFormat:@"%d",radiusVisibilty];
    
    [self showUserLocation];

    // Do any additional setup after loading the view.
}
- (IBAction) startShowingUserHeading:(id)sender{
    
    if(self.mapview.userTrackingMode == 0){
        [self.mapview setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
        
        //Turn on the position arrow
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationBlue.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
        
    }
    else if(self.mapview.userTrackingMode == 1){
        [self.mapview setUserTrackingMode: MKUserTrackingModeFollowWithHeading animated: YES];
        
        //Change it to heading angle
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationHeadingBlue"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    else if(self.mapview.userTrackingMode == 2){
        [self.mapview setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    
    
}
- (void) showUserLocation {
    
    [self.mapview setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
    
    dropPin = [[Annotation alloc] initWithTitle:@"" location:self.mapview.userLocation.coordinate];
    dropPin.annotationView.image=[UIImage imageNamed:@""];
    [self.mapview addAnnotation:dropPin];
    
  
    tapCount = 0;
    
    _mapview.zoomEnabled=YES;
    [self fitthemap:radiusVisibilty];
    
}
//---------------------------------------------------------------

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
        annotationView.image=[UIImage imageNamed:@""];

        return annotationView;
    } else
        return nil;
}

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"Region will changed...");
    [self.mapview removeAnnotation:dropPin];
    
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"Region did changed...");
    centre = [mapView centerCoordinate];
    dropPin.coordinate = centre;
    [self.mapview addAnnotation:dropPin];
    [self zoomMapview:radiusVisibilty];
    
    
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


- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated{
    if(self.mapview.userTrackingMode == 0){
        [self.mapview setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    
}
- (IBAction)back:(id)sender {
    if (create) {
        return;
    }
    else
    {
        create=NO;
        sharedObj.radiusVisibilityVal=(int)self.radiusSlider.value;

    [[self navigationController]popViewControllerAnimated:YES];
    }
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
   
    MKCoordinateRegion region;
    //Set Zoom level using Span
    MKCoordinateSpan span;
    region.center=centre;
    span.latitudeDelta=0.01;
    span.longitudeDelta=0.01;
    region.span=span;
    [_mapview setRegion:region animated:TRUE];
    
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
-(NSData *)compressImage:(UIImage *)imagedata{
    NSData *imageData1 = [[NSData alloc] initWithData:UIImageJPEGRepresentation((imagedata), 1.0)];
    
    int imageSize = (int)imageData1.length;
    NSLog(@"SIZE OF IMAGE: %i ", imageSize);
    float compressionQuality;//50 percent compression
    
    if (imageSize < 200000) {
        compressionQuality=1.0;
    }
    else if (imageSize < 500000 && imageSize > 200000)
    {
        compressionQuality=0.9;
    }
    else if (imageSize < 1000000 && imageSize > 500000)
    {
        compressionQuality=0.8;
    }
    else if (imageSize < 5000000 && imageSize>2000000)
    {
        compressionQuality=0.6;
    }
    else if (imageSize < 6000000 && imageSize>5000000)
    {
        compressionQuality=0.4;
        
    }
    else if (imageSize>6000000)
    {
        compressionQuality=0.3;
    }
    else
    {
        compressionQuality=0.5;
    }
    
    
    
    
    CGRect rect = CGRectMake(0.0, 0.0, 300.0, 300.0);
    UIGraphicsBeginImageContext(rect.size);
    [imagedata drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    return imageData;
}
- (IBAction)createbtnClicked:(id)sender
{
    if (create) {
        return;
    }
    else
    {
        create=YES;
    }
    [SVProgressHUD showWithStatus:@"Creating Group...." maskType:SVProgressHUDMaskTypeBlack];

    pointVal = [PFGeoPoint geoPointWithLatitude:centre.latitude longitude:centre.longitude];
    sharedObj.radiusVisibilityVal=radiusVisibilty;
    PFFile *imageFile = [PFFile fileWithName:@"groupImage.jpg" data:sharedObj.groupimageData];
    UIImage *image = [UIImage imageWithData:sharedObj.groupimageData];
    
    PFFile *imgFile=[PFFile fileWithName:@"thumbgroup.jpg" data:[self compressImage:image]];
    groupimgurl=imageFile;
    
    PFObject *testObject = [PFObject objectWithClassName:@"Group"];
    testObject[@"MobileNo"]=sharedObj.AccountNumber;
    testObject[@"CountryName"]=sharedObj.AccountCountry;
    testObject[@"GroupName"]=sharedObj.GroupName;
    testObject[@"GroupPicture"]=imageFile;
    testObject[@"ThumbnailPicture"]=imgFile;
    testObject[@"GroupDescription"]=sharedObj.groupdescription;
    testObject[@"GroupType"]=@"Open";
    testObject[@"GroupLocation"]=pointVal;
    testObject[@"MemberCount"]=[NSNumber numberWithInt:1];
    testObject[@"NewsFeedCount"]=[NSNumber numberWithInt:0];
    testObject[@"MemberInvitation"]=[NSNumber numberWithBool:NO];
    testObject[@"GreenChannel"]=[[NSMutableArray alloc]init];
    testObject[@"MembershipApproval"]=[NSNumber numberWithBool:NO];
    testObject[@"JobScheduled"]=[NSNumber numberWithBool:NO];
    testObject[@"JobHours"]=[NSNumber numberWithInt:0];
    testObject[@"GroupStatus"]=@"Active";
    testObject[@"GroupMembers"]=[[NSMutableArray alloc]initWithObjects:sharedObj.AccountNumber, nil];
    testObject[@"AdminArray"]=[[NSMutableArray alloc]initWithObjects:sharedObj.AccountNumber, nil];
    testObject[@"AdditionalInfoRequired"]=[NSNumber numberWithBool:NO];
    testObject[@"InfoRequired"]=@"";
    testObject[@"VisibiltyRadius"]=[NSNumber numberWithInt:sharedObj.radiusVisibilityVal];
    testObject[@"SecretStatus"]=[NSNumber numberWithBool:NO];
    testObject[@"SecretCode"]=@"";
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (!error) {
        timestamp = [[testObject createdAt] stringWithHumanizedTimeDifference:humanizedType withFullString:YES];
        groupId=testObject.objectId;

                    PFObject *member=[PFObject objectWithClassName:@"MembersDetails"];
                    member[@"GroupId"]=groupId;
                    member[@"MemberNo"]=sharedObj.AccountNumber;
                    member[@"JoinedDate"]=[NSDate date];
                    member[@"AdditionalInfoProvided"]=@"";
                    member[@"ExitGroup"]=[NSNumber numberWithBool:NO];
                    member[@"GroupAdmin"]=[NSNumber numberWithBool:YES];
                    member[@"UnreadMsgCount"]=[NSNumber numberWithInt:0];
                    member[@"LeaveDate"]=[NSDate date];
                    member[@"MemberStatus"]=@"Active";
                    member[@"ExitedBy"]=@"";
                    PFObject *pointer = [PFObject objectWithoutDataWithClassName:@"UserDetails" objectId:sharedObj.userId];
                    member[@"UserId"]=pointer;
                   [member saveInBackground];
        
        
                    PFQuery *query = [PFQuery queryWithClassName:@"UserDetails"];
                    [query getObjectInBackgroundWithId:sharedObj.userId block:^(PFObject *userStats, NSError *error) {
                                if (error) {
                                    NSLog(@"Data not available insert userdetails");
                                    [SVProgressHUD dismiss];
                                    
                                } else {
                                    mygroup=userStats[@"MyGroupArray"];
                                    [mygroup addObject:testObject.objectId];
                                    userStats[@"MyGroupArray"]=mygroup;
                                    [userStats incrementKey:@"Badgepoint" byAmount:[NSNumber numberWithInt:1000]];
                                    userStats[@"UpdateImage"]=[NSNumber numberWithBool:NO];
                                    userStats[@"UpdateName"]=[NSNumber numberWithBool:NO];
                                    [userStats saveInBackground];
                                    [[NSUserDefaults standardUserDefaults]setObject:mygroup forKey:@"MyGroup"];
                                    
                                    mygroup=[[NSUserDefaults standardUserDefaults]objectForKey:@"MyGroup"];
                                    
                                    [self CallMyService];
                                    
                                }
                            }];

                        }
                        else{
                            // Error
                            [SVProgressHUD dismiss];
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        }
                    }];
    
}
-(void)CallMyService
{
    
    [SVProgressHUD showWithStatus:@"Group Created Successfully...." maskType:SVProgressHUDMaskTypeBlack];

    [SVProgressHUD dismiss];
              
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InsideGroupViewController *settingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"InsideGroupViewController"];
    sharedObj.groupType=@"Open";
    sharedObj.GroupId=groupId;
    sharedObj.frommygroup=NO;
    sharedObj.groupimageurl=groupimgurl;
    sharedObj.groupMember=@"1";
    sharedObj.GroupName=sharedObj.GroupName;
    sharedObj.groupdescription=sharedObj.groupdescription;
    sharedObj.secretCode=@"";
    sharedObj.currentGroupAdminArray=[[NSMutableArray alloc]initWithObjects:sharedObj.AccountNumber, nil];
    sharedObj.currentGroupmemberArray=[[NSMutableArray alloc]initWithObjects:sharedObj.AccountNumber, nil];
    sharedObj.currentgroupEstablished=timestamp;
    sharedObj.currentgroupAddinfo=NO;
    sharedObj.addinfo=@"";
    sharedObj.currentgroupOpenEntry=0;
    sharedObj.currentgroupradius=sharedObj.radiusVisibilityVal;
    sharedObj.currentgroupSecret=NO;
    [self.navigationController pushViewController:settingsViewController animated:YES];
    
    PFQuery*myquery=[PFQuery queryWithClassName:@"Group"];
    [myquery whereKey:@"objectId" containedIn:mygroup];
    [myquery whereKey:@"GroupStatus" equalTo:@"Active"];
    [myquery orderByDescending:@"updatedAt"];
    [myquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            
            [PFObject unpinAllObjectsInBackgroundWithName:@"MYGROUP"];
            [PFObject pinAllInBackground:objects withName:@"MYGROUP"];
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
