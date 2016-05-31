//
//  RootViewController.m
//  GestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import "ACDGestureLockViewController.h"
#import "RootViewController.h"

@interface RootViewController () {
    NSString *userPwd;
}
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
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"手势解锁";
}

- (IBAction)onSetPwd:(UIButton *)sender {
    [ACDGestureLockViewController
        showSettingLockVCInVC:self
                 successBlock:^(ACDGestureLockViewController *lockVC,
                                NSString *pwd) {
                     NSLog(@"%@", pwd);
                     userPwd = pwd;
                     [lockVC dismiss:0.5f];
                 }];
}

- (IBAction)onVerifyPwd:(UIButton *)sender {
    [ACDGestureLockViewController showVerifyLockVCInVC:self
        correctPassword:userPwd
        forgetPwdBlock:^{
            NSLog(@"忘记密码");
        }
        successBlock:^(ACDGestureLockViewController *lockVC, NSString *pwd) {
            NSLog(@"密码正确");
            [lockVC dismiss:0.5f];
        }];
}

- (IBAction)onFindPwd:(UIButton *)sender {
    [ACDGestureLockViewController showModifyLockVCInVC:self
        correctPassword:userPwd
        forgetPwdBlock:^{
            NSLog(@"忘记密码");
        }
        successBlock:^(ACDGestureLockViewController *lockVC, NSString *pwd) {
            NSLog(@"%@", pwd);
            userPwd = pwd;
            [lockVC dismiss:0.5f];
        }];
}

@end
