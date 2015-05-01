//
//  CJUser.h
//  CoJam
//
//  Created by Stephen Greco on 4/24/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import <Parse/Parse.h>

@interface CJUser : PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *spotifyAccessToken;
@property (nonatomic, strong) NSString *spotifyUsername;
@property (nonatomic, strong) NSString *spotifyRefreshToken;
@property (nonatomic, strong) NSString *spotifyDisplayName;
@property (nonatomic, strong) NSString *spotifyEmailAddress;
@property (nonatomic, strong) NSDate *spotifyExpirationDate;

@end
