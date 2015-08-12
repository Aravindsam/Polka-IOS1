//
//  MemberModalclass.h
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/8/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface MemberModalclass : NSObject
@property(nonatomic, retain) PFFile *userImageurl;
@property(nonatomic, retain) NSString *userName;
@property(nonatomic, retain) NSString *userjoindate;
@property(nonatomic, retain) NSString *userAddinfo;
@property(nonatomic, retain) NSString *userNo;
@property(nonatomic,assign)BOOL Admin;
@end
