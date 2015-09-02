//
//  NotificationModalClass.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 9/1/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "NotificationModalClass.h"

@implementation NotificationModalClass
@synthesize groupId,userImageurl,feedId,time,type,message,objVal;
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:groupId forKey:@"GroupId"];
    [coder encodeObject:type forKey:@"Type"];
    [coder encodeObject:feedId forKey:@"FeedId"];
    [coder encodeObject:userImageurl forKey:@"Image"];
    [coder encodeObject:message forKey:@"Text"];
    [coder encodeObject:time forKey:@"Time"];
    [coder encodeObject:objVal forKey:@"ObjectValue"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[NotificationModalClass alloc] init];
    if (self != nil)
    {
        groupId=[coder decodeObjectForKey:@"GroupId"];
        objVal=[coder decodeObjectForKey:@"ObjectValue"];
        type=[coder decodeObjectForKey:@"Type"];
        feedId=[coder decodeObjectForKey:@"FeedId"];
        userImageurl=[coder decodeObjectForKey:@"Image"];
        message=[coder decodeObjectForKey:@"Text"];
        time=[coder decodeObjectForKey:@"Time"];
    }
    return self;
}
@end
