//
//  MemberModalclass.m
//  GroupsNearMe
//
//  Created by Jannath Begum on 6/8/15.
//  Copyright (c) 2015 Vishwak. All rights reserved.
//

#import "MemberModalclass.h"

@implementation MemberModalclass
@synthesize userAddinfo,userImageurl,userjoindate,userName,Admin,userNo;
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:userName forKey:@"userName"];
    [coder encodeObject:userjoindate forKey:@"userjoindate"];
      [coder encodeObject:userImageurl forKey:@"userImageurl"];
    [coder encodeObject:userAddinfo forKey:@"userAddinfo"];
    [coder encodeObject:userNo forKey:@"userNo"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[MemberModalclass alloc] init];
    if (self != nil)
    {
        userNo=[coder decodeObjectForKey:@"userNo"];

         userAddinfo=[coder decodeObjectForKey:@"userAddinfo"];
         userName=[coder decodeObjectForKey:@"userName"];
        userjoindate=[coder decodeObjectForKey:@"userjoindate"];
        userImageurl=[coder decodeObjectForKey:@"userImageurl"];
    }
    return self;
}
@end
