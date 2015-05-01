//
//  CJHomeHeaderTableViewCell.m
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJHomeHeaderTableViewCell.h"

@implementation CJHomeHeaderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.layer.masksToBounds = NO;
        self.layer.masksToBounds = NO;
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self setupView];
        
    }
    return self;
}

- (void) setupView {
    
    float width = self.contentView.frame.size.width;
    float height = self.contentView.frame.size.height;
    
    UIImage *logoImage = [UIImage imageNamed:@"CJLogo"];
    float imageWidth = logoImage.size.width;
    float imageHeight = logoImage.size.height;
    
    float imageDisplayWidth = width * 0.4;
    float imageDisplayHeight = imageHeight * ((width/2) / imageWidth);
    
    _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CJLogo"]];
    _logo.frame = CGRectMake((width - imageDisplayWidth) / 2,
                             (height - imageDisplayHeight) / 2,
                             imageDisplayWidth, imageDisplayHeight);
    [self.contentView addSubview:_logo];
}

@end
