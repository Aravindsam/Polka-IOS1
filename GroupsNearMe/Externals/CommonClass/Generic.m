//
//  Generic.m
//  FFlipThanthi
//
//  Created by Jannath Begum on 8/28/13.
//  Copyright (c) 2013 Vishwak. All rights reserved.
//

#import "Generic.h"
#import <Reachability/Reachability.h>
@implementation Generic
@synthesize AccountName,AccountNumber,GroupName;
@synthesize Login,fromfeatured,frommygroup,fromnearby,PublicGroup,AccountCountry,aboutGroup,otherText,AdditionalInfotext,greenchannelArray,selectedIdArray,Starting,NameCount,FeedId,groupType,groupdescription,groupimageurl,groupMember,galleryObjectArray,secretCode,nearByViewFrame,profileViewFrame,myGroupViewFrame,hotViewFrame,feedViewFrame,commentViewFrame,searchNearby,currentgroupAccess,currentgroupOwner,currentGroupLocation,addinfo,currentgroupAddinfo,currentgroupSecret,currentloc,currentgroupradius,currentgreenchannelId,feedimageurl,currentgroupOpenEntry,currentGroupAdminArray,membersearch,NotificationArray,deviceToken,userId;
@synthesize feedObject,invitationObjectArray,searchmygroup,AboutHeight,currentgroupEstablished;
@synthesize groupimageData;
@synthesize groupLocation;
@synthesize MemberApproval;
@synthesize inviteNo,flagValue;
@synthesize galleryArray;
@synthesize AccountGender,profileImage,pushnotificaion,soundnotification;
@synthesize GroupId;
@synthesize reputationPoint;
@synthesize openEntryVal,radiusVisibilityVal;
@synthesize NearByGroupArray,MyGroupArray,photoObjectArray,MyinvitesArray,MemberArray,searchMemberArray;
@synthesize search,fromRegister;
@synthesize currentGroupmemberArray;
static Generic* _sharedGeneric = nil;
+(Generic*)sharedMySingleton
{
	@synchronized([Generic class])
	{
		if (!_sharedGeneric){
			[[self alloc] init];
            
        }
		return _sharedGeneric;
	}
	return nil;
}
+(id)alloc
{
	@synchronized([Generic class])
	{
		NSAssert(_sharedGeneric == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedGeneric = [super alloc];
		return _sharedGeneric;
	}
    
	return nil;
}
#pragma mark - CHECKING FOR INTERNET CONNECTION
+(UIColor *)colorFromRGBHexString:(NSString *)colorString {
    if(colorString.length == 7) {
        const char *colorUTF8String = [colorString UTF8String];
        int r, g, b;
        sscanf(colorUTF8String, "#%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0];
    }
    return nil;
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
-(BOOL)checkNetwrk_Cellular_Wifi
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    return    [reachability isReachableViaWiFi];
    
}

#pragma mark - INTERNET CONNECTION ERROR MSG
-(void)internetErrorMsg
{
    NSLog(@"INTERNET NOT CONNECTED");
    UIAlertView *alertInternet = [[UIAlertView alloc]initWithTitle:@"No Network Connection" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertInternet show];

    return;
}
-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
        AccountNumber=[[NSString alloc]init];
        userId=[[NSString alloc]init];
         addinfo=[[NSString alloc]init];
        flagValue=[[NSString alloc]init];
        feedimageurl=[[NSString alloc]init];
        FeedId=[[NSString alloc]init];
        secretCode=[[NSString alloc]init];
        GroupId=[[NSString alloc]init];
        currentgroupEstablished=[[NSString alloc]init];
        AccountName=[[NSString alloc]init];
        otherText=[[NSString alloc]init];
        AdditionalInfotext=[[NSString alloc]init];
        GroupName=[[NSString alloc]init];
        greenchannelArray=[[NSMutableArray alloc]init];
        NotificationArray=[[NSMutableArray alloc]init];
        searchMemberArray=[[NSMutableArray alloc]init];
        NearByGroupArray=[[NSMutableArray alloc]init];
        currentGroupAdminArray=[[NSMutableArray alloc]init];
        searchNearby=[[NSMutableArray alloc]init];
        MemberArray=[[NSMutableArray alloc]init];
        MyinvitesArray=[[NSMutableArray alloc]init ];
        MyGroupArray=[[NSMutableArray alloc]init];
        galleryObjectArray=[[NSMutableArray alloc]init];
        galleryArray=[[NSMutableArray alloc]init];
        selectedIdArray=[[NSMutableArray alloc]init];
        currentGroupmemberArray=[[NSMutableArray alloc]init];
        currentgreenchannelId=[[NSMutableArray alloc]init];
        inviteNo=[[NSString alloc]init];
        AccountCountry=[[NSString alloc]init];
        Starting=[[NSString alloc]init];
        groupimageData=[[NSData alloc]init];
        deviceToken=[[NSData alloc]init];
        groupLocation=[[PFGeoPoint alloc]init];
        currentGroupLocation=[[PFGeoPoint alloc]init];
        profileImage=[[NSString alloc]init];
        groupType=[[NSString alloc]init];
        AccountGender=[[NSString alloc]init];
        NameCount=[[NSNumber alloc]init];
        groupMember=[[NSString alloc]init];
        groupimageurl=[[PFFile alloc]init];
        groupdescription=[[NSString alloc]init];
        invitationObjectArray=[[NSMutableArray alloc]init];
        searchmygroup=[[NSMutableArray alloc]init];
        photoObjectArray=[[NSMutableArray alloc]init];
        currentloc=[[PFGeoPoint alloc]init];
        fromnearby=NO;
        frommygroup=NO;
        fromfeatured=NO;
        PublicGroup=YES;
        MemberApproval=NO;
        
	}
	return self;
}

@end
