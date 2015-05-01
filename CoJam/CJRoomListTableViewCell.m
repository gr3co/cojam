//
//  CJRoomListTableViewCell.m
//  CoJam
//
//  Created by Stephen Greco on 4/24/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJRoomListTableViewCell.h"
#import "CJColors.h"

@implementation CJRoomListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupView];
        
    }
    return self;
}


- (void) setupView {
    
    float height = self.contentView.frame.size.height;
    float width = self.contentView.frame.size.width;
    
    _displayName = [[UILabel alloc] initWithFrame:CGRectMake(0.1 * width, 0, 0.8 * width, height)];
    _displayName.numberOfLines = 1;
    _displayName.font = [UIFont fontWithName:@"Avenir" size:20];
    _displayName.textColor = [CJColors altColorA];
    
    [self.contentView addSubview:_displayName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
