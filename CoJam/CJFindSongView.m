//
//  CJFindSongView.m
//  CoJam
//
//  Created by Stephen Greco on 4/30/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJFindSongView.h"
#import "CJSpotifyHelper.h"
#import "CJSearchResultTableViewCell.h"

static NSString* const CJSearchResultTableViewCellIdentifier = @"CJSearchResultTableViewCell";

@implementation CJFindSongView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,frame.size.width,50)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"Enter a song, artist, or album...";
        
        [_tableView registerClass:[CJSearchResultTableViewCell class]
           forCellReuseIdentifier:CJSearchResultTableViewCellIdentifier];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50,
                                                                   frame.size.width,
                                                                   frame.size.height - 150)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self addSubview:_searchBar];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[CJSpotifyHelper defaultHelper] performSearchWithQuery:searchBar.text
                                                   andBlock:^(NSArray *results, NSError *error) {
                                                       _results = results;
                                                       if (results != nil) {
                                                           [_tableView reloadData];   
                                                       }
    }];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CJSearchResultTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:
                                     CJSearchResultTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[CJSearchResultTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CJSearchResultTableViewCellIdentifier];
    }
    
    SPTPartialTrack *track = _results[indexPath.row];
    cell.songTitle.text = track.name;
    cell.artists.text = getArtistString(track.artists);
    
    return cell;
}

static NSString *getArtistString(NSArray *artists) {
    NSMutableArray *artistNames = [[NSMutableArray alloc]
                                   initWithCapacity:[artists count]];
    [artists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [artistNames addObject:((SPTPartialArtist*)obj).name];
    }];
    return [artistNames componentsJoinedByString:@", "];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate didSelectSong:_results[indexPath.row]];
}

@end
