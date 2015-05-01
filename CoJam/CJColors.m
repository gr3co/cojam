//
//  CJColors.m
//  CoJam
//
//  Created by Stephen Greco on 4/23/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJColors.h"

UIColor *colorFromRGB(short red, short green, short blue) {
    return [UIColor colorWithRed:red/255.0
                           green:green/255.0
                            blue:blue/225.0
                           alpha:1.0];
}


@implementation CJColors

// #39a394
+ (UIColor *) backgroundColorA {
    return colorFromRGB(0x39, 0xa3, 0x94);
}

// #39c2b0
+ (UIColor *) backgroundColorB {
    return colorFromRGB(0x39, 0xc2, 0xb0);
}

// #9b3846
+ (UIColor *) altColorA {
    return colorFromRGB(0x9b, 0x38, 0x46);
}

// #8d3743
+ (UIColor *) altColorB {
    return colorFromRGB(0x8d, 0x37, 0x43);
}

// Taken from http://spotify.kennedysgarage.com/branding.html
+ (UIColor *) spotifyColor {
    return colorFromRGB(129, 183, 26);
}


@end
