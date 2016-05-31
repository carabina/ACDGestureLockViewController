//
//  ACDGestureLockNavigationController.m
//  ACDGestureLockNavigationController
//
//  Created by onedotM on 16/5/31.
//  Copyright © 2016年 WangBo. All rights reserved.
//

#import "ACDGestureLockNavigationController.h"

@implementation ACDGestureLockNavigationController

- (BOOL)shouldAutorotate {
    //返回为YES，supportedInterfaceOrientations才有效
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    NSUInteger rst = self.topViewController.supportedInterfaceOrientations;
    return rst;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

@end
