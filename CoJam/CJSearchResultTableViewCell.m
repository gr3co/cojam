//
//  CJSearchResultTableViewCell.m
//  CoJam
//
//  Created by Stephen Greco on 4/30/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJSearchResultTableViewCell.h"
#import "CJColors.h"

@implementation CJSearchResultTableViewCell

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
    
    _songTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.05 * width, 0, 0.9 * width, height - 20)];
    _songTitle.numberOfLines = 1;
    _songTitle.font = [UIFont fontWithName:@"Avenir" size:16];
    _songTitle.textColor = [CJColors altColorB];
    
    _artists = [[UILabel alloc] initWithFrame:CGRectMake(0.05 * width, height - 20, 0.9 * width, 20)];
    _artists.numberOfLines = 1;
    _artists.font = [UIFont fontWithName:@"Avenir" size:12];
    _artists.textColor = [CJColors backgroundColorA];
    
    [self.contentView addSubview:_songTitle];
    [self.contentView addSubview:_artists];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
