//
//  CJFindSongView.h
//  CoJam
//
//  Created by Stephen Greco on 4/30/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>

@protocol CJFindSongViewDelegate <NSObject>

@required
- (void) didSelectSong:(SPTPartialTrack*)song;
- (void) removeSearchView;

@end

@interface CJFindSongView : UIView <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property UISearchBar *searchBar;
@property UITableView *tableView;
@property NSArray *results;

@property id<CJFindSongViewDelegate> delegate;

@end
