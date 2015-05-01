//
//  CJLoginViewController.m
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJLoginViewController.h"
#import "CJColors.h"

#import "CJSpotifyHelper.h"

@interface CJLoginViewController ()
    @property UIButton *loginButton;
@end

@implementation CJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [CJColors backgroundColorA];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(width / 2 - 200,
                                                              height * 3 / 4 - 25,
                                                              400, 50)];
    _loginButton.backgroundColor = [CJColors spotifyColor];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setTitle:@"Log in with Spotify" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(authorizeLogin)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_loginButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)authorizeLogin {
    [[CJSpotifyHelper defaultHelper] authorizeLoginWithViewController:self];
}


@end
