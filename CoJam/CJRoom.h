//
//  CJRoom.h
//  CoJam
//
//  Created by Stephen Greco on 4/24/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import <Parse/Parse.h>
#import "CJUser.h"

@interface CJRoom : PFObject<PFSubclassing>

@property (strong, nonatomic) CJUser *creator;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *idNumber;
@property (strong, nonatomic, readonly) PFRelation *members;
@property (strong, nonatomic) NSMutableArray *queue;

@end
