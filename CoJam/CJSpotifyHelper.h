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
#import "CJRoom.h"

@protocol CJSpotifyHelperDelegate <NSObject>

@optional
- (void) refresh;
- (void) openRoomView:(CJRoom*) room;

@end


@interface CJSpotifyHelper : NSObject <SPTAuthViewDelegate, SPTAudioStreamingPlaybackDelegate>

@property (nonatomic, strong) SPTSession *session;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (nonatomic, strong) SPTUser *spotifyUser;
@property CJRoom *currentRoom;
@property NSString *spotifyClientId;

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

- (BOOL) handleURL:(NSURL *) url;

- (void) playTracksFromRoom:(CJRoom *) room;

@end
