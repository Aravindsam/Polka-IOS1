//
//  GroupModalClass.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 4/18/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "GroupModalClass.h"

@implementation GroupModalClass
@synthesize groupChannelArray,groupDescription,groupId,groupImageData,groupName,groupType,feedcount,memberCount,addInfoRequired,addinfoString,timeVal,groupPost,groupOwner,secretCode,openEntry,groupAdminArray,messagecount,groupMemberArray,visibiltyradius,SecretStatus;
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:groupId forKey:@"groupId"];
    [coder encodeObject:groupName forKey:@"groupName"];
    [coder encodeObject:groupChannelArray forKey:@"groupChannelArray"];
    [coder encodeObject:groupDescription forKey:@"groupDescription"];
    [coder encodeObject:groupImageData forKey:@"groupImageData"];
    [coder encodeObject:groupType forKey:@"groupType"];
    [coder encodeObject:addinfoString forKey:@"addinfoString"];
    [coder encodeObject:timeVal forKey:@"timeVal"];
    [coder encodeObject:groupPost forKey:@"groupPost"];
    [coder encodeObject:groupOwner forKey:@"groupOwner"];
    [coder encodeObject:secretCode forKey:@"secretCode"];
    [coder encodeObject:groupAdminArray forKey:@"groupAdminArray"];
    [coder encodeObject:groupMemberArray forKey:@"groupMemberArray"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[GroupModalClass alloc] init];
    if (self != nil)
    {
        
        groupId=[coder decodeObjectForKey:@"groupId"];
        groupName=[coder decodeObjectForKey:@"groupName"];
        groupChannelArray=[coder decodeObjectForKey:@"groupChannelArray"];
        groupDescription=[coder decodeObjectForKey:@"groupDescription"];
        groupImageData=[coder decodeObjectForKey:@"groupImageData"];
        groupType=[coder decodeObjectForKey:@"groupType"];
        addinfoString=[coder decodeObjectForKey:@"addinfoString"];
        timeVal=[coder decodeObjectForKey:@"timeVal"];
        groupPost=[coder decodeObjectForKey:@"groupPost"];
        groupOwner=[coder decodeObjectForKey:@"groupOwner"];
         secretCode=[coder decodeObjectForKey:@"secretCode"];
        groupAdminArray=[coder decodeObjectForKey:@"groupAdminArray"];
        groupMemberArray=[coder decodeObjectForKey:@"groupMemberArray"];
    }
    return self;
}
@end
