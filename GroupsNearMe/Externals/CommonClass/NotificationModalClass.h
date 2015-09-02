//
//  NotificationModalClass.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 9/1/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface NotificationModalClass : NSObject
@property(nonatomic, retain) NSString *userImageurl;
@property(nonatomic, retain) NSString *message;
@property(nonatomic, retain) NSDate *time;
@property(nonatomic, retain) NSString *feedId;
@property(nonatomic, retain) NSString *groupId;
@property(nonatomic, retain) NSString *type;
@property(nonatomic,retain)PFObject *objVal;
@end
