//
//  CJSpotifyHelper.m
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJSpotifyHelper.h"
#import <Parse/Parse.h>
#import "CJUser.h"

static CJSpotifyHelper *defaultHelper;

@implementation CJSpotifyHelper

+ (CJSpotifyHelper*) defaultHelper {
    if (defaultHelper != nil) return defaultHelper;
    else {
        defaultHelper = [[CJSpotifyHelper alloc] init];
        return defaultHelper;
    }
}

+ (NSString *) getArtistStringForArtistList:(NSArray *)artists {
    NSMutableArray *artistNames = [[NSMutableArray alloc]
                                   initWithCapacity:[artists count]];
    [artists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [artistNames addObject:((SPTPartialArtist*)obj).name];
    }];
    return [artistNames componentsJoinedByString:@", "];
}

static NSArray *getURLsFromStrings(NSArray *strings) {
    NSMutableArray *result = [[NSMutableArray alloc]
                              initWithCapacity:[strings count]];
    [strings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:[NSURL URLWithString:(NSString*)obj]];
    }];
    return result;
}

- (void) getTracksWithURIs:(NSArray*)uris
                  andBlock:(void (^)(NSArray *results,
                                     NSError *error)) block {
    
    [SPTTrack tracksWithURIs:getURLsFromStrings(uris)
                     session:_session
                    callback:^(NSError *error, id result) {
        return block((NSArray*)result, error);
    }];
}

- (void) performSearchWithQuery:(NSString *)query
                       andBlock:(void (^)(NSArray *results, NSError *error)) block {
    
    [SPTRequest performSearchWithQuery:query
                             queryType:SPTQueryTypeTrack
                               session:_session
                              callback:^(NSError *error, id result) {
                                  
                                  SPTListPage *page = (SPTListPage*) result;
                                  return block(page.items, error);
                                  
                              }];
    
}

- (void) attemptToReauthenticateWithBlock:(void (^)(BOOL success, NSError *error)) block {
    
    CJUser *user = [CJUser currentUser];
        
    if (user.spotifyAccessToken == nil
        || user.spotifyRefreshToken == nil
        || user.spotifyExpirationDate == nil) {
        return block(NO, nil);
    }

    SPTSession *session = [[SPTSession alloc] initWithUserName:user.spotifyUsername
                                                   accessToken:user.spotifyAccessToken
                                         encryptedRefreshToken:user.spotifyRefreshToken
                                                expirationDate:user.spotifyExpirationDate];
        
    [[SPTAuth defaultInstance] renewSession:session callback:^(NSError *error, SPTSession *newSession) {
            
        if (error != nil) {
            NSLog(@"%@", error);
            return block(NO, error);
        } else {
            _session = newSession;
            user.spotifyAccessToken = _session.accessToken;
            user.spotifyRefreshToken = _session.encryptedRefreshToken;
            user.spotifyExpirationDate = _session.expirationDate;
                
            [user saveInBackgroundWithBlock:block];
        }
        
    }];

}

- (void) authenticationViewController:(SPTAuthViewController *)authenticationViewController
                  didLoginWithSession:(SPTSession *)session {
    
    _session = session;
    
    NSLog(@"Logged in as %@", session.canonicalUsername);
    
    [SPTRequest userInformationForUserInSession:session
                                       callback:^(NSError *error, id object) {
                                           if (error != nil) {
                                               NSLog(@"%@", error);
                                           } else if ([[object class] isSubclassOfClass:[SPTUser class]]) {
                                               
                                               _spotifyUser = object;
                                               
                                               CJUser *user = [CJUser currentUser];
                                               
                                               user.spotifyEmailAddress = _spotifyUser.emailAddress;
                                               user.spotifyAccessToken = _session.accessToken;
                                               user.spotifyExpirationDate = _session.expirationDate;
                                               user.spotifyRefreshToken = _session.encryptedRefreshToken;
                                               user.spotifyUsername = _spotifyUser.canonicalUserName;
                                               user.spotifyDisplayName = _spotifyUser.displayName;
                                               
                                               [user saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                                                   if (error != nil) {
                                                       NSLog(@"%@", error);
                                                   }
                                                   if (success && _delegate != nil) {
                                                       [_delegate refresh];
                                                   }
                                               }];
                                               
                                           }
                                       }];

    
}

- (void) authenticationViewController:(SPTAuthViewController *)authenticationViewController
                       didFailToLogin:(NSError *)error {
    NSLog(@"Failed to login");
}

- (void) authenticationViewControllerDidCancelLogin:(SPTAuthViewController *)authenticationViewController {
    NSLog(@"Cancelled login");
}


@end
