//
//  ACDGestureLockConst.h
//  GestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef ACDGestureLockConst_h
#define ACDGestureLockConst_h

#define rgba(r, g, b, a)                                                       \
    [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

//外环线条颜色：默认
#define GestureLockCircleLineNormalColor rgba(41, 171, 194, 1)

//外环线条颜色：选中
#define GestureLockCircleLineSelectedColor rgba(41, 171, 194, 1)

//提示文字颜色
#define GestureLockTipsLabelColor rgba(120, 130, 140, 1)

//实心圆颜色
#define GestureLockCircleLineColor [UIColor redColor]

// 背景色
#define ACDGestureLockViewBgColor [UIColor whiteColor]

//默认圆大小的线宽
static CGFloat GestureLockNormalLineWidth = 1.0f;

//选中圆大小的线宽
static CGFloat GestureLockSelectedCircleLineWidth = 3.0f;

//选中圆大小比例
static CGFloat GestureLockSelectedCircleProportion = 0.3f;

//圆之间的间距
static const CGFloat CircleMarginValueforIpad = 36.0f;
static const CGFloat CircleMarginValueforIphone = 20.0f;

//最低设置密码数目
static NSUInteger GestureLockMinItemCount = 4;

//设置密码提示文字
static NSString *const GestureLockPWDTitleFirst = @"请滑动设置新密码";

//设置密码提示文字：确认
static NSString *const GestureLockPWDTitleConfirm = @"请再次输入确认密码";

//设置密码提示文字：再次密码不一致
static NSString *const GestureLockPWDDiffTitle = @"再次密码输入不一致";

//设置密码提示文字：设置成功
static NSString *const GestureLockPWSuccessTitle = @"密码设置成功！";

//验证密码：普通提示文字
static NSString *const GestureLockVerifyNormalTitle = @"请滑动输入密码";

//验证密码：密码错误
static NSString *const GestureLockVerifyErrorPwdTitle = @"输入密码错误";

//验证密码：验证成功
static NSString *const GestureLockVerifySuccesslTitle = @"密码正确";

//修改密码：普通提示文字
static NSString *const GestureLockModifyNormalTitle = @"请输入旧密码";

#endif // ACDGestureLockConst_h
