//
//  ACDGestureLockViewController.m
//  ACDGestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import "ACDGestureLockConst.h"
#import "ACDGestureLockLabel.h"
#import "ACDGestureLockNavigationController.h"
#import "ACDGestureLockView.h"
#import "ACDGestureLockViewController.h"

@interface ACDGestureLockViewController ()
#pragma mark -
@property (nonatomic, copy) void (^successBlock)
    (ACDGestureLockViewController *lockVC, NSString *pwd);
@property (nonatomic, copy) void (^forgetPwdBlock)();

#pragma mark -
// 用于通过presentViewController把九宫格控制器展示在当前窗口
@property (nonatomic, weak) UIViewController *vc;

//  bar button
@property (nonatomic, strong) UIBarButtonItem *resetItem;
@property (nonatomic, strong) UIBarButtonItem *forgetItem;
@property (nonatomic, strong) UIBarButtonItem *backItem;

@property (nonatomic, copy) NSString *msg;

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
    } else {
        // iphone
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationItem.leftBarButtonItem = self.backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

//实现各个代码块
- (void)event {
    //设置密码
    //开始输入：第一次
    self.lockView.setPWDBeginBlock = ^() {
        [self.label showNormalMsg:GestureLockPWDTitleFirst];
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };
    //开始输入：确认
    self.lockView.setPWDConfirmlock = ^() {
        [self.label showNormalMsg:GestureLockPWDTitleConfirm];
    };

    //异常处理
    //密码长度不够
    self.lockView.setPWDErrorLengthTooShortBlock = ^(NSUInteger currentCount) {
        [self.label
            showWarnMsg:[NSString stringWithFormat:@"请连接至少%@个点",
                                                   @(GestureLockMinItemCount)]];
    };
    //两次密码不一致
    self.lockView.setPWDErrorTwiceDiffBlock =
        ^(NSString *pwd1, NSString *pwdNow) {
            [self.label showWarnMsg:GestureLockPWDDiffTitle];
        };

    //输入正确
    //第一次输入密码：正确
    self.lockView.setPWDFirstRightBlock = ^() {
        [self.label showNormalMsg:GestureLockPWDTitleConfirm];
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };
    //再次输入密码一致
    self.lockView.setPWDTwiceSameBlock = ^(NSString *pwd) {
        [self.label showNormalMsg:GestureLockPWDSuccessTitle];
        //禁用交互
        self.view.userInteractionEnabled = NO;
        if (self.successBlock != nil)
            self.successBlock(self, pwd);
    };

    //验证密码
    self.lockView.verifyPWBeginBlock = ^() {
        [self.label showNormalMsg:GestureLockVerifyNormalTitle];
    };
    //验证(可能来自修改密码的触发)
    self.lockView.verifyPwdBlock = ^(NSString *pwd) {
        BOOL res = [self.correctPwd isEqualToString:pwd];
        if (res) {
            //密码一致
            [self.label showNormalMsg:GestureLockVerifySuccesslTitle];
            if (GestureLockTypeVerifyPwd == self.type) {
                //禁用交互
                self.view.userInteractionEnabled = NO;
                if (self.successBlock != nil)
                    self.successBlock(self, pwd);
            } else if (GestureLockTypeModifyPwd == self.type) {
                //修改密码
                [self.label showNormalMsg:GestureLockPWDTitleFirst];
                self.navigationItem.rightBarButtonItem = nil;
                self.msg = nil;
            }
        } else {
            //密码错误
            [self.label showWarnMsg:GestureLockVerifyErrorPwdTitle];
        }
        return res;
    };

    //修改
    self.lockView.modifyPwdBlock = ^() {
        if ([self.msg isEqualToString:GestureLockModifyNormalTitle]) {
            [self.label showNormalMsg:self.msg];
        }

    };
}

//密码重设
- (void)setPwdReset {
    [self.label showNormalMsg:GestureLockPWDTitleFirst];
    //隐藏
    self.navigationItem.rightBarButtonItem = nil;
    //通知视图重设
    [self.lockView resetPwd];
}

- (void)onForgetPwd {
    [self dismiss:0];
    if (_forgetPwdBlock != nil)
        _forgetPwdBlock();
}

- (void)setType:(GestureLockType)type {
    _type = type;
    [self labelWithType];
}

// 根据type自动调整label文字
- (void)labelWithType {
    if (GestureLockTypeSetPwd == self.type) {
        //设置密码
        self.msg = GestureLockPWDTitleFirst;
    } else if (GestureLockTypeVerifyPwd == self.type) {
        //验证密码
        self.msg = GestureLockVerifyNormalTitle;
        self.navigationItem.rightBarButtonItem = self.forgetItem;
    } else if (GestureLockTypeModifyPwd == self.type) {
        //修改密码
        self.msg = GestureLockModifyNormalTitle;
        self.navigationItem.rightBarButtonItem = self.forgetItem;
    }
}

// 初始化lockVC控制器
+ (instancetype)lockVC:(UIViewController *)vc {
    ACDGestureLockViewController *lockVC =
        [[ACDGestureLockViewController alloc] init];
    lockVC.vc = vc;

    ACDGestureLockNavigationController *nav =
        [[ACDGestureLockNavigationController alloc]
            initWithRootViewController:lockVC];

    [vc presentViewController:nav animated:YES completion:nil];

    return lockVC;
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

- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        _backItem =
            [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(dismiss:)];
    }
    return _backItem;
}

#pragma mark - Public Methods
// 展示设置密码控制器
+ (void)showSettingLockVCInVC:(UIViewController *)vc
                 successBlock:(void (^)(ACDGestureLockViewController *lockVC,
                                        NSString *pwd))successBlock {
    ACDGestureLockViewController *lockVC = [self lockVC:vc];
    lockVC.title = @"设置密码";
    lockVC.type = GestureLockTypeSetPwd;
    lockVC.successBlock = successBlock;
}

// 展示验证密码输入框
+ (void)showVerifyLockVCInVC:(UIViewController *)vc
             correctPassword:(NSString *)correctPassword
              forgetPwdBlock:(void (^)())forgetPwdBlock
                successBlock:(void (^)(ACDGestureLockViewController *lockVC,
                                       NSString *pwd))successBlock {
    ACDGestureLockViewController *lockVC = [self lockVC:vc];
    lockVC.title = @"手势解锁";
    lockVC.type = GestureLockTypeVerifyPwd;
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    lockVC.correctPwd = correctPassword;
}

// 展示修改密码输入框
+ (void)showModifyLockVCInVC:(UIViewController *)vc
             correctPassword:(NSString *)correctPassword
              forgetPwdBlock:(void (^)())forgetPwdBlock
                successBlock:(void (^)(ACDGestureLockViewController *lockVC,
                                       NSString *pwd))successBlock {
    ACDGestureLockViewController *lockVC = [self lockVC:vc];
    lockVC.title = @"修改密码";
    lockVC.type = GestureLockTypeModifyPwd;
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    lockVC.correctPwd = correctPassword;
}

- (void)dismiss:(NSTimeInterval)interval {
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
}

@end
