//
//  CJSpotifyHelper.h
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Spotify/Spotify.h>
#import "CJUser.h"

@protocol CJSpotifyHelperDelegate <NSObject>

@optional
- (void) refresh;

@end


@interface CJSpotifyHelper : NSObject <SPTAuthViewDelegate>

@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (nonatomic, strong) SPTUser *spotifyUser;

@property id<CJSpotifyHelperDelegate> delegate;

+ (CJSpotifyHelper *) defaultHelper;

+ (NSString *) getArtistStringForArtistList:(NSArray *)artists;

- (void) attemptToReauthenticateWithBlock:(void (^)(BOOL success,
                                                    NSError *error)) block;

- (void) performSearchWithQuery:(NSString *)query
                       andBlock:(void (^)(NSArray *results,
                                          NSError *error)) block;

- (void) getTracksWithURIs:(NSArray*)uris
                  andBlock:(void (^)(NSArray *results,
                                     NSError *error)) block;



@end
