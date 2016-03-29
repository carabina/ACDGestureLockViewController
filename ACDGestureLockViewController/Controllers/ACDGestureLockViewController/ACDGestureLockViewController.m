//
//  ACDGestureLockViewController.m
//  ACDGestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import "ACDGestureLockConst.h"
#import "ACDGestureLockLabel.h"
#import "ACDGestureLockView.h"
#import "ACDGestureLockViewController.h"

@interface ACDGestureLockViewController () {
    NSString *userPassword; //临时存储用户设置的密码
}

#pragma mark - Block
@property (nonatomic, copy) void (^successBlock)
    (ACDGestureLockViewController *lockVC, NSString *pwd);
@property (nonatomic, copy) void (^forgetPwdBlock)();

#pragma mark -
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, strong) UIBarButtonItem *resetItem;
@property (nonatomic, strong) UIBarButtonItem *forgetItem;
@property (nonatomic, copy) NSString *modifyCurrentTitle;
@property (nonatomic, weak) IBOutlet ACDGestureLockLabel *label;
@property (nonatomic, weak) IBOutlet ACDGestureLockView *lockView;
@end

@implementation ACDGestureLockViewController
#pragma mark - Life Cycle
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType rangeOfString:@"iPad"].location != NSNotFound) {
        return UIInterfaceOrientationMaskLandscape;
    }
    //如果是iphone
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self vcPrepare];
    [self event];
}

#pragma mark - Private Methods
//控制器准备
- (void)vcPrepare {
    //设置背景色
    self.view.backgroundColor = ACDGestureLockViewBgColor;
    [self.label showNormalMsg:self.msg];
    self.lockView.type = self.type;
    // TODO:视图准备工作：处理navigation的rightButton
}

//实现各个代码块
- (void)event {
    //设置密码
    //开始输入：第一次
    self.lockView.setPWBeginBlock = ^() {
        [self.label showNormalMsg:GestureLockPWDTitleFirst];
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };
    //开始输入：确认
    self.lockView.setPWConfirmlock = ^() {
        [self.label showNormalMsg:GestureLockPWDTitleConfirm];
    };
    //密码长度不够
    self.lockView.setPWSErrorLengthTooShortBlock = ^(NSUInteger currentCount) {
        [self.label
            showWarnMsg:[NSString stringWithFormat:@"请连接至少%@个点",
                                                   @(GestureLockMinItemCount)]];
    };
    //两次密码不一致
    self.lockView.setPWSErrorTwiceDiffBlock =
        ^(NSString *pwd1, NSString *pwdNow) {
            [self.label showWarnMsg:GestureLockPWDDiffTitle];
        };
    //第一次输入密码：正确
    self.lockView.setPWFirstRightBlock = ^() {
        [self.label showNormalMsg:GestureLockPWDTitleConfirm];
    };
    //再次输入密码一致
    self.lockView.setPWTwiceSameBlock = ^(NSString *pwd) {
        [self.label showNormalMsg:GestureLockPWSuccessTitle];
        //随后返回给调用着
        userPassword = pwd;

        //禁用交互
        self.view.userInteractionEnabled = NO;
        if (_successBlock != nil)
            _successBlock(self, pwd);
        if (GestureLockTypeModifyPwd == _type) {
            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
        }
    };

    //验证密码
    self.lockView.verifyPWBeginBlock = ^() {
        [self.label showNormalMsg:GestureLockVerifyNormalTitle];
    };
    //验证
    self.lockView.verifyPwdBlock = ^(NSString *pwd) {
        BOOL res = [self.correctPwd isEqualToString:pwd];

        if (res) { //密码一致
            [self.label showNormalMsg:GestureLockVerifySuccesslTitle];
            if (GestureLockTypeVeryfiPwd == _type) {
                //禁用交互
                self.view.userInteractionEnabled = NO;
            } else if (GestureLockTypeModifyPwd == _type) {
                //修改密码
                [self.label showNormalMsg:GestureLockPWDTitleFirst];
                self.navigationItem.rightBarButtonItem = nil;
                self.modifyCurrentTitle = GestureLockPWDTitleFirst;
            }
            if (GestureLockTypeVeryfiPwd == _type) {
                if (_successBlock != nil)
                    _successBlock(self, pwd);
            }
        } else {
            //密码错误
            [self.label showWarnMsg:GestureLockVerifyErrorPwdTitle];
        }
        return res;
    };

    //修改
    self.lockView.modifyPwdBlock = ^() {
        [self.label showNormalMsg:self.msg];
    };
}

- (void)dismiss {
    [self dismiss:0];
}

//密码重设
- (void)setPwdReset {
    [self.label showNormalMsg:GestureLockPWDTitleFirst];
    //隐藏
    self.navigationItem.rightBarButtonItem = nil;
    //通知视图重设
    [self.lockView resetPwd];
}

- (void)setType:(GestureLockType)type {
    _type = type;
    //根据type自动调整label文字
    [self labelWithType];
}

// 根据type自动调整label文字
- (void)labelWithType {
    if (GestureLockTypeSetPwd == _type) {
        //设置密码
        self.msg = GestureLockPWDTitleFirst;
    } else if (GestureLockTypeVeryfiPwd == _type) {
        //验证密码
        self.msg = GestureLockVerifyNormalTitle;
        self.navigationItem.rightBarButtonItem = self.forgetItem;
    } else if (GestureLockTypeModifyPwd == _type) {
        //修改密码
        self.msg = GestureLockModifyNormalTitle;
        self.navigationItem.rightBarButtonItem = self.forgetItem;
    }
}

- (void)onForgetPwd {
    [self dismiss:0];
    if (_forgetPwdBlock != nil)
        _forgetPwdBlock();
}

#pragma mark - Access Methods
//重置按钮
- (UIBarButtonItem *)resetItem {
    if (_resetItem == nil) {
        //添加右按钮
        _resetItem =
            [[UIBarButtonItem alloc] initWithTitle:@"重设"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(setPwdReset)];
    }
    return _resetItem;
}

- (UIBarButtonItem *)forgetItem {
    if (_forgetItem == nil) {
        //添加右按钮
        _forgetItem =
            [[UIBarButtonItem alloc] initWithTitle:@"忘记密码"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(onForgetPwd)];
    }
    return _forgetItem;
}

#pragma mark - Public Methods
// 展示设置密码控制器
+ (instancetype)showSettingLockVCInVC:(UIViewController *)vc
                         successBlock:
                             (void (^)(ACDGestureLockViewController *lockVC,
                                       NSString *pwd))successBlock {
    ACDGestureLockViewController *lockVC = [self lockVC:vc];
    lockVC.title = @"设置密码";
    //设置类型
    lockVC.type = GestureLockTypeSetPwd;
    //保存block
    lockVC.successBlock = successBlock;
    return lockVC;
}

// 展示验证密码输入框
+ (instancetype)showVerifyLockVCInVC:(UIViewController *)vc
                     correctPassword:(NSString *)correctPassword
                      forgetPwdBlock:(void (^)())forgetPwdBlock
                        successBlock:
                            (void (^)(ACDGestureLockViewController *lockVC,
                                      NSString *pwd))successBlock {
    ACDGestureLockViewController *lockVC = [self lockVC:vc];
    lockVC.title = @"手势解锁";
    //设置类型
    lockVC.type = GestureLockTypeVeryfiPwd;
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    lockVC.correctPwd = correctPassword;
    return lockVC;
}

// 展示修改密码输入框
+ (instancetype)showModifyLockVCInVC:(UIViewController *)vc
                     correctPassword:(NSString *)correctPassword
                      forgetPwdBlock:(void (^)())forgetPwdBlock
                        successBlock:
                            (void (^)(ACDGestureLockViewController *lockVC,
                                      NSString *pwd))successBlock {
    ACDGestureLockViewController *lockVC = [self lockVC:vc];
    lockVC.title = @"修改密码";
    //设置类型
    lockVC.type = GestureLockTypeModifyPwd;
    //记录
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    lockVC.correctPwd = correctPassword;
    return lockVC;
}

// 初始化lockVC控制器
+ (instancetype)lockVC:(UIViewController *)vc {
    ACDGestureLockViewController *lockVC =
        [[ACDGestureLockViewController alloc] init];
    lockVC.vc = vc;
    return lockVC;
}

- (NSString *)userPwd {
    return userPassword;
}

- (void)dismiss:(NSTimeInterval)interval {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Unuse Methods
- (IBAction)modifyPwdAction:(id)sender {
    ACDGestureLockViewController *lockVC =
        [[ACDGestureLockViewController alloc] init];
    lockVC.title = @"修改密码";
    //设置类型
    lockVC.type = GestureLockTypeModifyPwd;
    [self.navigationController pushViewController:lockVC animated:YES];
}

@end
