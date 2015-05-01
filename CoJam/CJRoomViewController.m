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

@interface CJRoomViewController ()

@property CJFindSongView *findSongView;

@end

@implementation CJRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [self.view addSubview: _tableView];
    
    //[_tableView registerClass:[CJRoomListTableViewCell class]
    //       forCellReuseIdentifier:CJRoomListTableViewCellIdentifier];
    
    //CJSpotifyHelper *helper = [CJSpotifyHelper defaultHelper];
    
    [self initNavbar];
    
    self.view.backgroundColor = [CJColors backgroundColorA];
    _tableView.backgroundColor = [UIColor whiteColor];

}

- (void) initNavbar {
    
    UIBarButtonItem *addSong = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self action:@selector(showSearchView)];
    self.navigationItem.rightBarButtonItem = addSong;

}

- (void) refresh {
    
}

- (void) didSelectSong:(SPTPartialTrack *)song {
    [_room addObject:song.uri.absoluteString forKey:@"queue"];
    [_room saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
        }
        [UIView animateWithDuration:.25
                         animations:^{
                             _findSongView.frame = CGRectOffset(self.view.frame,
                                                                0, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             [_findSongView removeFromSuperview];
                             [self refresh];
                         }];
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
