//
//  ACDGestureLockLabel.h
//  GestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

//  解锁视图提示标签

#import <UIKit/UIKit.h>

@interface ACDGestureLockLabel : UILabel

//普通提示信息
- (void)showNormalMsg:(NSString *)msg;

//警示信息
- (void)showWarnMsg:(NSString *)msg;

@end
