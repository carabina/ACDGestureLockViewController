//
//  ACDGestureLockLabel.m
//  GestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import "ACDGestureLockConst.h"
#import "ACDGestureLockLabel.h"
#import "CALayer+Animation.h"

@implementation ACDGestureLockLabel
#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self viewPrepare];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self viewPrepare];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self viewPrepare];
    }
    return self;
}

#pragma mark - UIView
- (void)viewPrepare {
    self.textColor = GestureLockTipsLabelColor;
    self.font = [UIFont systemFontOfSize:16.0f];
}

#pragma mark - Public methods
- (void)showNormalMsg:(NSString *)msg {
    self.text = msg;
    self.textColor = GestureLockTipsLabelColor;
}

- (void)showWarnMsg:(NSString *)msg {
    self.text = msg;
    self.textColor = GestureLockWarnLabelColor;
    [self.layer shake];
}

@end
