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
                                target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItem = addSong;

}

- (void) refresh {
    
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
