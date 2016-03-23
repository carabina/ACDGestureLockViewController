//
//  CALayer+Animation.m
//  GestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import "CALayer+Animation.h"

@implementation CALayer (Animation)

- (void)shake {
    CAKeyframeAnimation *kfa =
        [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat s = 16;
    kfa.values = @[ @(-s), @(0), @(s), @(0), @(-s), @(0), @(s), @(0) ];
    //时长
    kfa.duration = 0.1f;
    //重复
    kfa.repeatCount = 2;
    //移除
    kfa.removedOnCompletion = YES;
    [self addAnimation:kfa forKey:@"shake"];
}

@end
