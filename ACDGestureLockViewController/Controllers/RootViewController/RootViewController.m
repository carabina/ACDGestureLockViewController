//
//  RootViewController.m
//  GestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import "ACDGestureLockViewController.h"
#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

#pragma mark - UIView
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType rangeOfString:@"iPad"].location != NSNotFound) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"手势解锁";
}

- (IBAction)onSetPwd:(UIButton *)sender {
    ACDGestureLockViewController *gestureVC = [ACDGestureLockViewController
        showSettingLockVCInVC:self
                 successBlock:^(ACDGestureLockViewController *lockVC,
                                NSString *pwd) {
                     //获取用户设置的密码
                     NSLog(@"%@", [lockVC userPwd]);
                     [lockVC dismiss:1.0f];
                 }];
    [self.navigationController pushViewController:gestureVC animated:YES];
}

- (IBAction)onVerifyPwd:(UIButton *)sender {
    ACDGestureLockViewController *gestureVC = [ACDGestureLockViewController
        showVerifyLockVCInVC:self
        correctPassword:@"03678"
        forgetPwdBlock:^{
            NSLog(@"忘记密码");
            [self forgetPwd];
        }
        successBlock:^(ACDGestureLockViewController *lockVC, NSString *pwd) {
            NSLog(@"密码正确");
            [lockVC dismiss:1.0f];
        }];
    [self.navigationController pushViewController:gestureVC animated:YES];
}

- (IBAction)onFindPwd:(UIButton *)sender {
    ACDGestureLockViewController *gestureVC = [ACDGestureLockViewController
        showModifyLockVCInVC:self
        correctPassword:@"03678"
        forgetPwdBlock:^{
            NSLog(@"忘记密码");
            [self forgetPwd];
        }
        successBlock:^(ACDGestureLockViewController *lockVC, NSString *pwd) {
            NSLog(@"%@", [lockVC userPwd]);
            [lockVC dismiss:1.0f];
        }];
    [self.navigationController pushViewController:gestureVC animated:YES];
}

- (void)forgetPwd {
    ACDGestureLockViewController *gestureVC = [ACDGestureLockViewController
        showSettingLockVCInVC:self
                 successBlock:^(ACDGestureLockViewController *lockVC,
                                NSString *pwd) {
                     //获取用户设置的密码
                     NSLog(@"%@", [lockVC userPwd]);
                     [lockVC dismiss:1.0f];
                 }];
    [self.navigationController pushViewController:gestureVC animated:YES];
}

@end
