//
//  CJRoomViewController.h
//  CoJam
//
//  Created by Stephen Greco on 4/24/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJRoom.h"

@interface CJRoomViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property CJRoom *room;
@property UITableView *tableView;

- (void) refresh;

@end
