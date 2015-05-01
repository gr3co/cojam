//
//  CJRoomViewController.m
//  CoJam
//
//  Created by Stephen Greco on 4/24/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJRoomViewController.h"
#import "CJColors.h"
#import "CJSpotifyHelper.h"
#import "CJSearchResultTableViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString* const CJSearchResultTableViewCellIdentifier = @"CJSearchResultTableViewCell";

@interface CJRoomViewController ()

@property CJFindSongView *findSongView;

@end

@implementation CJRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [CJColors backgroundColorA];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [self.view addSubview: _tableView];
    
    [_tableView registerClass:[CJSearchResultTableViewCell class]
       forCellReuseIdentifier:CJSearchResultTableViewCellIdentifier];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self initNavbar];
    [self refresh];

}

- (void) initNavbar {
    
    UIBarButtonItem *addSong = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self action:@selector(showSearchView)];
    
    UIBarButtonItem *shareView = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                target:self action:nil];
    
    self.navigationItem.rightBarButtonItems = @[addSong, shareView];

}

- (void) refresh {
    [_room fetchInBackgroundWithBlock:^(PFObject *result, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        [[CJSpotifyHelper defaultHelper]
         getTracksWithURIs:_room.queue
         andBlock:^(NSArray *results, NSError *error) {
             if (error) {
                 NSLog(@"%@", error);
             } else {
                 _queue = results;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [_tableView reloadData];
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 });
             }
        }];
    }];
}

- (void) didSelectSong:(SPTPartialTrack *)song {
    [_room addObject:song.uri.absoluteString forKey:@"queue"];
    [_room saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        }
        [self refresh];
        [self removeSearchView];
    }];
}

- (void) removeSearchView {
    [UIView animateWithDuration:.25
                     animations:^{
                         _findSongView.frame = CGRectOffset(self.view.frame,
                                                            0, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [_findSongView removeFromSuperview];
                     }];
}

- (void) showSearchView {
    
    float width = self.view.frame.size.width;
    float height = self.navigationController.navigationBar.frame.size.height;
    height += [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if (_findSongView == nil) {
        _findSongView = [[CJFindSongView alloc]
                         initWithFrame:CGRectOffset(self.view.frame,
                                                    0, self.view.frame.size.height)];
        _findSongView.delegate = self;
    }
    [self.view addSubview:_findSongView];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         _findSongView.frame = CGRectMake(0, height, width,
                                                          self.view.frame.size.height - height);
                     }
                     completion:^(BOOL finished){
                         // WOOOOOO
                     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_queue count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CJSearchResultTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:
                                         CJSearchResultTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[CJSearchResultTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CJSearchResultTableViewCellIdentifier];
    }
    
    SPTPartialTrack *track = _queue[indexPath.row];
    cell.songTitle.text = track.name;
    cell.artists.text = [CJSpotifyHelper getArtistStringForArtistList:track.artists];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
