//
//  CJRoom.m
//  CoJam
//
//  Created by Stephen Greco on 4/24/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJRoom.h"
#import <Parse/PFObject+Subclass.h>

@implementation CJRoom
@dynamic creator;
@dynamic displayName;
@dynamic idNumber;
@dynamic members;
@dynamic queue;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *) parseClassName {
    return @"Room";
}

@end
