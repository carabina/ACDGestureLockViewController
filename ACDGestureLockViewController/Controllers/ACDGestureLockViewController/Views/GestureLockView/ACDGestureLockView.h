//
//  ACDGestureLockView.h
//  GestureLock
//
//  Created by 王 博 on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import "ACDGestureLockViewController.h"
#import <UIKit/UIKit.h>

@interface ACDGestureLockView : UIView

@property (nonatomic, assign) GestureLockType type;

//开始输入，第一次
@property (nonatomic, copy) void (^setPWBeginBlock)();

//开始输入，确认密码
@property (nonatomic, copy) void (^setPWConfirmlock)();

//设置密码出错：长度不够
@property (nonatomic, copy) void (^setPWSErrorLengthTooShortBlock)
    (NSUInteger currentCount);

//设置密码出错：再次密码不一致
@property (nonatomic, copy) void (^setPWSErrorTwiceDiffBlock)
    (NSString *pwd1, NSString *pwdNow);

//设置密码：第一次输入正确
@property (nonatomic, copy) void (^setPWFirstRightBlock)();

//再次密码输入一致
@property (nonatomic, copy) void (^setPWTwiceSameBlock)(NSString *pwd);

//重设密码
- (void)resetPwd;

//验证密码开始
@property (nonatomic, copy) void (^verifyPWBeginBlock)();

//验证密码
@property (nonatomic, copy) BOOL (^verifyPwdBlock)(NSString *pwd);

//再次密码输入一致
@property (nonatomic, copy) void (^modifyPwdBlock)();

//密码修改成功
@property (nonatomic, copy) void (^modifyPwdSuccessBlock)();

@end
