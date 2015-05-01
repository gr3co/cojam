//
//  CJMainViewController.h
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJNewRoomView.h"
#import "CJSpotifyHelper.h"

@interface CJMainViewController : UIViewController
<CJSpotifyHelperDelegate, CJNewRoomViewDelegate,
UITableViewDataSource, UITableViewDelegate>

@property NSArray *rooms;

@property UITableView *tableView;

- (void) refresh;

@end

