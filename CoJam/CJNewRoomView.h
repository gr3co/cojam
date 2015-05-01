//
//  CJNewRoomView.h
//  CoJam
//
//  Created by Stephen Greco on 4/24/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJRoom.h"

@protocol CJNewRoomViewDelegate

@required
- (void) newRoomCreated:(CJRoom*) room;

@end

@interface CJNewRoomView : UIView <UITextFieldDelegate>

- (void) remove;

@property id<CJNewRoomViewDelegate> delegate;

@end
