//
//  CJNewRoomView.m
//  CoJam
//
//  Created by Stephen Greco on 4/24/15.
//  Copyright (c) 2015 Stephen Greco. All rights reserved.
//

#import "CJNewRoomView.h"
#import "CJColors.h"

@interface CJNewRoomView ()
@property UITextField *nameInput;
@property UILabel *nameLabel;
@property UIButton *submitButton;
@end

@implementation CJNewRoomView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [CJColors backgroundColorA];
        float height = frame.size.height;
        float width = frame.size.width;
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        _nameInput = [[UITextField alloc] initWithFrame:CGRectMake(0.03 * width,
                                                                   0.05 * height,
                                                                   0.75 * width,
                                                                   0.9 * height)];
        _nameInput.backgroundColor = [UIColor whiteColor];
        _nameInput.placeholder = @"Untitled";
        _nameInput.leftView = paddingView;
        _nameInput.leftViewMode = UITextFieldViewModeAlways;
        _nameInput.delegate = self;
        [self addSubview:_nameInput];
        
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0.75 * width,
                                                                   0.05 * height,
                                                                   0.22 * width,
                                                                   0.9 * height)];
        _submitButton.backgroundColor = [CJColors altColorA];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitle:@"Create" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(createRoom)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitButton];
        
    }
    return self;
}

- (void) createRoom {
    CJRoom *newRoom = [CJRoom object];
    newRoom.creator = [CJUser currentUser];
    newRoom.displayName = _nameInput.text;
    [newRoom.members addObject:[PFUser currentUser]];
    [newRoom saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else if (success) {
            if (_delegate != nil) {
                [_delegate newRoomCreated:newRoom];
            }
            [self remove];
        } else {
            NSLog(@"not success?");
        }
    }];
}

- (void) remove {
    [UIView animateWithDuration:.25
                     animations:^{
                         self.frame = CGRectOffset(self.frame, 0, -self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_nameInput resignFirstResponder];
}

@end
