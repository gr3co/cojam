//
//  CJUser.m
//  CoJam
//
//  Created by Stephen Greco on 4/24/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation CJUser

@dynamic spotifyAccessToken;
@dynamic spotifyUsername;
@dynamic spotifyRefreshToken;
@dynamic spotifyExpirationDate;
@dynamic spotifyDisplayName;
@dynamic spotifyEmailAddress;

+ (void)load {
    [self registerSubclass];
}

@end
