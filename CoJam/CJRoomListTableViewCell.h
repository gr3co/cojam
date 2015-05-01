//
//  CJRoomListTableViewCell.h
//  CoJam
//
//  Created by Stephen Greco on 4/24/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJRoomListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *displayName;
@property (nonatomic, strong) UILabel *currentSongTitle;
@property (nonatomic, strong) UILabel *numberMembers;

@end
