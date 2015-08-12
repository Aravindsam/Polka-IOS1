//
//  GroupModalClass.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/18/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface GroupModalClass : NSObject
@property(nonatomic, retain) NSString *groupId;
@property(nonatomic, retain) NSString *groupName;
@property(nonatomic, retain) NSString *groupType;
@property(nonatomic, retain) NSString *groupDescription;
@property(nonatomic, retain)NSString *timeVal;
@property(nonatomic, retain)NSString *groupPost;
@property(nonatomic, retain)NSMutableArray *groupChannelArray;
@property(nonatomic, retain)NSMutableArray *groupAdminArray;
@property(nonatomic, retain)NSMutableArray *groupMemberArray;
@property(nonatomic,retain)NSString *addinfoString;
@property(nonatomic,assign)BOOL addInfoRequired,SecretStatus;
@property(nonatomic,assign)int memberCount;
@property(nonatomic,assign)int feedcount;
@property(nonatomic,retain)PFFile *groupImageData;
@property(nonatomic,retain)NSString*groupOwner;
@property(nonatomic,retain)NSString*secretCode;
@property(nonatomic,assign)int messagecount;
@property(nonatomic,assign)int openEntry;
@property(nonatomic,assign)int visibiltyradius;
@end
