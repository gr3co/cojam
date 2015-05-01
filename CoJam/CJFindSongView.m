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
#import "CJColors.h"

static NSString* const CJSearchResultTableViewCellIdentifier = @"CJSearchResultTableViewCell";

@implementation CJFindSongView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,frame.size.width,50)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"Enter a song, artist, or album...";
        _searchBar.showsCancelButton = YES;
        _searchBar.barTintColor = [CJColors backgroundColorA];
        _searchBar.tintColor = [CJColors altColorB];
        
        [_tableView registerClass:[CJSearchResultTableViewCell class]
           forCellReuseIdentifier:CJSearchResultTableViewCellIdentifier];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50,
                                                                   frame.size.width,
                                                                   frame.size.height - 50)];
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_delegate removeSearchView];
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
    cell.artists.text = [CJSpotifyHelper getArtistStringForArtistList:track.artists];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate didSelectSong:_results[indexPath.row]];
}

@end
