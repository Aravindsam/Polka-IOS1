
//
//  Generic.h
//  FFlipThanthi
//
//  Created by Jannath Begum on 8/28/13.
//  Copyright (c) 2013 Vishwak. All rights reserved.
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface Generic : NSObject<NSURLConnectionDataDelegate>
{
    
}
@property(nonatomic,retain)PFObject*feedObject;
@property(nonatomic,retain)NSMutableArray *greenchannelArray,*selectedIdArray,*galleryArray,*photoObjectArray;
@property(nonatomic,retain)NSMutableArray *NearByGroupArray,*MyGroupArray,*MemberArray,*galleryObjectArray,*MyinvitesArray,*invitationObjectArray,*searchNearby,*searchmygroup,*currentgreenchannelId,*currentGroupmemberArray,*currentGroupAdminArray,*searchMemberArray,*NotificationArray;
@property(nonatomic,retain)NSString* GroupId,*FeedId,*groupType;
@property(nonatomic,retain)NSString*groupMember,*groupdescription,*flagValue,*feedimageurl;
@property(nonatomic,retain)PFFile*groupimageurl;
@property(nonatomic,retain)NSString*AdditionalInfotext;
@property(nonatomic,retain)NSString *otherText;
@property(nonatomic,retain)NSString *AccountName,*secretCode,*addinfo;
@property(nonatomic,retain)NSString *AccountNumber,*userId;
@property(nonatomic,retain)NSString *AccountCountry;
@property(nonatomic,retain)NSString *AccountGender;
@property(nonatomic)BOOL pushnotificaion,soundnotification;
@property(nonatomic,retain)NSString *profileImage;
@property(nonatomic,retain)NSNumber *NameCount;
@property(nonatomic,retain)NSString *inviteNo;
@property(nonatomic,retain)NSString *Starting;
@property(nonatomic,retain)NSString *GroupName,*aboutGroup,*currentgroupEstablished;
@property(nonatomic,retain)NSData *groupimageData,*deviceToken;
@property(nonatomic,retain)PFGeoPoint *groupLocation,*currentGroupLocation,*currentloc;
@property(nonatomic,assign)int openEntryVal,radiusVisibilityVal,currentgroupradius;
@property(nonatomic)BOOL Login;
@property(nonatomic)BOOL MemberApproval;
@property(nonatomic)BOOL fromnearby,search,membersearch,fromRegister;
@property(nonatomic)BOOL frommygroup,newUser;
@property(nonatomic)BOOL fromfeatured,PublicGroup;
@property(nonatomic,assign)int reputationPoint,currentgroupOpenEntry;
@property(nonatomic,assign)float AboutHeight;
@property(nonatomic,readwrite)CGRect nearByViewFrame,myGroupViewFrame,profileViewFrame,hotViewFrame,feedViewFrame,commentViewFrame;
@property(nonatomic,assign)BOOL currentgroupOwner,currentgroupAccess,currentgroupSecret,currentgroupAddinfo;

+(Generic*)sharedMySingleton;
-(BOOL)connected;
-(void)internetErrorMsg;
-(BOOL)checkNetwrk_Cellular_Wifi;
+(UIColor *)colorFromRGBHexString:(NSString *)colorString;
@end
