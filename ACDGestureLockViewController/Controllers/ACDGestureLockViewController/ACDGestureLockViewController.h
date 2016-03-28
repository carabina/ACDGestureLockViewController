//
//  ACDGestureLockViewController.h
//  ACDGestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GestureLockType) {
    //设置密码
    GestureLockTypeSetPwd,
    //验证密码
    GestureLockTypeVeryfiPwd,
    //修改密码
    GestureLockTypeModifyPwd,
};

@interface ACDGestureLockViewController : UIViewController
@property (nonatomic, assign) GestureLockType type;
@property (nonatomic, strong) NSString *correctPwd;

/**
 *  展示设置密码控制器
 *
 *  @param vc           装纳控制器
 *  @param successBlock 成功执行后将会执行的代码块，在此应该调用- (NSString
 *                      *)userPwd;以获得密码
 *
 *  @return 返回一个用于设置密码的试图控制器
 */
+ (instancetype)showSettingLockVCInVC:(UIViewController *)vc
                         successBlock:
                             (void (^)(ACDGestureLockViewController *lockVC,
                                       NSString *pwd))successBlock;

/**
 *  验证密码输入框
 *
 *  @param vc              装纳控制器
 *  @param correctPassword 调用者传入一个用于比较的正确密码字符串
 *  @param forgetPwdBlock  忘记密码事件触发时将会执行的代码块
 *  @param successBlock    成功执行后将会执行的代码块
 *
 *  @return 返回一个用于验证密码是否正确地控制器
 */
+ (instancetype)showVerifyLockVCInVC:(UIViewController *)vc
                     correctPassword:(NSString *)correctPassword
                      forgetPwdBlock:(void (^)())forgetPwdBlock
                        successBlock:
                            (void (^)(ACDGestureLockViewController *lockVC,
                                      NSString *pwd))successBlock;

/**
 *  验修改密码输入框
 *
 *  @param vc              装纳控制器
 *  @param correctPassword 调用者传入一个用于比较的正确密码字符串
 *  @param forgetPwdBlock  忘记密码事件触发时将会执行的代码块
 *  @param successBlock    成功执行后将会执行的代码块，在此应该调用- (NSString
 * *)userPwd;以获得密码
 *
 *  @return 返回一个用于修改密码的控制器
 */
+ (instancetype)showModifyLockVCInVC:(UIViewController *)vc
                     correctPassword:(NSString *)correctPassword
                      forgetPwdBlock:(void (^)())forgetPwdBlock
                        successBlock:
                            (void (^)(ACDGestureLockViewController *lockVC,
                                      NSString *pwd))successBlock;

/**
 *  密码操作成功后，调用此方法返回主调用者控制器
 *
 *  @param interval 动画持续时间
 */
- (void)dismiss:(NSTimeInterval)interval;

/**
 *  返回用户设置的密码给调用者
 *
 *  @return 在对密码操作成功后，应该在successBlock中调用该函数
 */
- (NSString *)userPwd;

@end
