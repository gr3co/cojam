//
//  CJMainViewController.m
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJMainViewController.h"
#import "CJLoginViewController.h"
#import "CJHomeHeaderTableViewCell.h"
#import "CJColors.h"
#import "CJRoomListTableViewCell.h"
#import "CJRoomViewController.h"

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

static NSString* const CJRoomListTableViewCellIdentifier = @"CJRoomListTableViewCell";

@interface CJMainViewController ()

@property CJNewRoomView *createRoomForm;
@property UIView *backgroundTint;

@property PFQuery *roomsQuery;

@end

@implementation CJMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.view.backgroundColor = [CJColors backgroundColorA];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 75;
    [self.view addSubview: _tableView];
    
    [_tableView registerClass:[CJRoomListTableViewCell class]
           forCellReuseIdentifier:CJRoomListTableViewCellIdentifier];
    
    CJSpotifyHelper *helper = [CJSpotifyHelper defaultHelper];
    helper.delegate = self;
    
    _roomsQuery = [PFQuery queryWithClassName:@"Room"];
    [_roomsQuery whereKey:@"members" equalTo:[PFUser currentUser]];
    [_roomsQuery whereKey:@"isActive" equalTo:@YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [helper attemptToReauthenticateWithBlock:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"Auth error: %@", [error localizedDescription]);
        }
        
        if (!success) {
            SPTAuthViewController *authvc = [SPTAuthViewController authenticationViewController];
            authvc.delegate = [CJSpotifyHelper defaultHelper];
            authvc.modalPresentationStyle = UIModalPresentationCustom;
            authvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            self.definesPresentationContext = YES;
            [self.navigationController presentViewController:authvc animated:YES completion:nil];
        } else {
            NSLog(@"Logged in as %@", [CJUser currentUser].spotifyUsername);
            [self refresh];
        }
    }];
    
    [self initNavbar];
    
}

- (void) initNavbar {
    // Logo in the center of navigation bar
    self.navigationController.view.window.tintColor = [CJColors altColorB];
    self.navigationController.navigationBar.barTintColor = [CJColors backgroundColorA];
    
    UIImage *logo = [UIImage imageNamed:@"CJLogo"];
    float height = self.navigationController.navigationBar.frame.size.height;
    float imageWidth = logo.size.width;
    float imageHeight = logo.size.height;
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, height * 0.15,
                                                                imageWidth * (height * 0.6 / imageHeight),
                                                                height * 0.6)];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:logo];
    titleImageView.frame = CGRectMake(0, 0, logoView.frame.size.width, logoView.frame.size.height);
    [logoView addSubview:titleImageView];
    self.navigationItem.titleView = logoView;
    
    UIBarButtonItem *addRoom = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self action:@selector(addRoom)];
    
    UIBarButtonItem *searchRoom = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                target:self action:nil];
    
    self.navigationItem.rightBarButtonItem = addRoom;
    self.navigationItem.leftBarButtonItem = searchRoom;
    
}

- (void) addRoom {
    
    if (_createRoomForm != nil) {
        return;
    }
    
    float width = self.view.frame.size.width;
    float height = self.navigationController.navigationBar.frame.size.height;
    float statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    _createRoomForm = [[CJNewRoomView alloc]
                              initWithFrame:CGRectMake(0,0, width, 1.1 * height)];
    _createRoomForm.delegate = self;
    _backgroundTint = [[UIView alloc] initWithFrame:self.view.frame];
    _backgroundTint.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backgroundTint];
    
    [self.view addSubview:_createRoomForm];
    [UIView animateWithDuration:.25
                     animations:^{
                         _backgroundTint.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
                         _createRoomForm.frame = CGRectOffset(_createRoomForm.frame, 0, height + statusHeight);
                     }
                     completion:^(BOOL finished){
                         // WOOOOOO
                     }];
}

- (void) newRoomCreated:(CJRoom *)room {
    [_backgroundTint removeFromSuperview];
    _backgroundTint = nil;
    _createRoomForm = nil;
    [self refresh];
}

- (void) refresh {
    if ([MBProgressHUD HUDForView:self.view] == nil) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [_roomsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        NSLog(@"Found %i room(s)", (int)[objects count]);
        _rooms = [[NSArray alloc] initWithArray:objects];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

- (void) openRoomView:(CJRoom*) room {
    
    if (room == nil) {
        // TODO: open some sort of 404 view
    } else {
        CJRoomViewController *roomVc = [[CJRoomViewController alloc]
                                        initWithNibName:nil bundle:nil];
        roomVc.room = room;
        [self.navigationController pushViewController:roomVc animated:YES];
    }
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_rooms == nil) ? 0 : [_rooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CJRoomListTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:
                                     CJRoomListTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[CJRoomListTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CJRoomListTableViewCellIdentifier];
    }
    
    CJRoom *room = _rooms[indexPath.row];
    cell.displayName.text = room.displayName;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CJRoom *room = _rooms[indexPath.row];
    [self openRoomView:room];
    
}

-(UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_createRoomForm != nil) {
        UIView *responder = resignFirstResponder(self.view);
        if ([responder superview] != _createRoomForm) {
            [_createRoomForm remove];
            [_backgroundTint removeFromSuperview];
            _createRoomForm = nil;
            _backgroundTint = nil;
        }
    }
}

UIView *resignFirstResponder(UIView *theView){
    if([theView isFirstResponder]) {
        [theView resignFirstResponder];
        return theView;
    }
    for(UIView *subview in theView.subviews) {
        UIView *result = resignFirstResponder(subview);
        if(result) return result;
    }
    return nil;
}

@end
