//
//  ACDGestureLockView.m
//  GestureLock
//
//  Created by 王 博 on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import "ACDGestureLockConst.h"
#import "ACDGestureLockItemView.h"
#import "ACDGestureLockView.h"

@interface ACDGestureLockView () {
    CGFloat CircleMarginValue;
}

//装itemView的可变数组
@property (nonatomic, strong) NSMutableArray *itemViewsM;

//临时密码记录器
@property (nonatomic, copy) NSMutableString *pwdM;

//设置密码：第一次设置的正确的密码
@property (nonatomic, copy) NSString *firstRightPWD;

//修改密码过程中的验证旧密码正确
@property (nonatomic, assign) BOOL modify_VeriryOldRight;

@end

@implementation ACDGestureLockView

#pragma mark - init
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self lockViewPrepare];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self lockViewPrepare];
    }
    return self;
}

#pragma mark - UIView
//通过计算，实现视图布局
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat itemViewWH = (self.frame.size.width - 4 * CircleMarginValue) / 3.0f;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx,
                                                BOOL *stop) {
        NSUInteger col = idx % 3; //列
        NSUInteger row = idx / 3; //行
        CGFloat x = CircleMarginValue * (col + 1) + col * itemViewWH;
        CGFloat y = CircleMarginValue * (row + 1) + row * itemViewWH;
        CGRect frame = CGRectMake(x, y, itemViewWH, itemViewWH);
        //设置tag
        subview.tag = idx;
        subview.frame = frame;
    }];
}

#pragma mark - private methods
- (void)checkDevice {
    NSString *deviceType = [UIDevice currentDevice].model;

    if ([deviceType rangeOfString:@"iPad"].location != NSNotFound) {
        CircleMarginValue = CircleMarginValueforIpad;
    } else if ([deviceType rangeOfString:@"iPhone"].location != NSNotFound) {
        CircleMarginValue = CircleMarginValueforIphone;
    }
}

- (void)lockViewPrepare {
    self.backgroundColor = [UIColor clearColor];
    for (NSUInteger i = 0; i < 9; i++) {
        //加载九宫格所需的九个view
        ACDGestureLockItemView *itemView =
            [[ACDGestureLockItemView alloc] init];
        [self addSubview:itemView];
    }
    [self checkDevice];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //解锁处理
    [self lockHandle:touches];
    //设置密码
    if (GestureLockTypeSetPwd == _type) {
        if (self.firstRightPWD == nil) { //第一次输入
            if (_setPWBeginBlock != nil) _setPWBeginBlock();
        } else {
            if (_setPWConfirmlock != nil) _setPWConfirmlock();
        }
    } else if (GestureLockTypeVeryfiPwd == _type) { //验证密码
        if (_verifyPWBeginBlock != nil) _verifyPWBeginBlock();
    } else if (GestureLockTypeModifyPwd == _type) { //修改密码
        if (_modifyPwdBlock != nil) _modifyPwdBlock();
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //解锁处理
    [self lockHandle:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //手势结束
    [self gestureEnd];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //手势结束
    [self gestureEnd];
}

//手势结束
- (void)gestureEnd {
    //设置密码检查
    if (self.pwdM.length != 0) {
        [self setpwdCheck];
    }
    for (ACDGestureLockItemView *itemView in self.itemViewsM) {
        itemView.selected = NO;
        //清空方向
        itemView.direct = 0;
    }
    //清空数组所有对象
    [self.itemViewsM removeAllObjects];
    //再绘制
    [self setNeedsDisplay];
    //清空密码
    self.pwdM = nil;
}

//设置密码检查
- (void)setpwdCheck {
    NSUInteger count = self.itemViewsM.count;
    if (count < GestureLockMinItemCount) {
        if (_setPWSErrorLengthTooShortBlock != nil)
            _setPWSErrorLengthTooShortBlock(count);
        return;
    }
    if (GestureLockTypeSetPwd == _type) {
        //设置密码
        [self setpwd];
    } else if (GestureLockTypeVeryfiPwd == _type) { //验证密码
        if (_verifyPwdBlock != nil) _verifyPwdBlock(self.pwdM);
    } else if (GestureLockTypeModifyPwd == _type) { //修改密码
        if (!_modify_VeriryOldRight) {
            if (_verifyPwdBlock != nil) {
                _modify_VeriryOldRight = _verifyPwdBlock(self.pwdM);
            }
        } else {
            //设置密码
            [self setpwd];
        }
    }
}

//设置密码
- (void)setpwd {
    //密码合法
    if (self.firstRightPWD == nil) { // 第一次设置密码
        self.firstRightPWD = self.pwdM;
        if (_setPWFirstRightBlock != nil) _setPWFirstRightBlock();
    } else {
        if (![self.firstRightPWD isEqualToString:self.pwdM]) {
            //两次密码不一致
            if (_setPWSErrorTwiceDiffBlock != nil)
                _setPWSErrorTwiceDiffBlock(self.firstRightPWD, self.pwdM);
            return;
        } else { //再次密码输入一致
            if (_setPWTwiceSameBlock != nil)
                _setPWTwiceSameBlock(self.firstRightPWD);
        }
    }
}

//解锁处理
- (void)lockHandle:(NSSet *)touches {
    //取出触摸点
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self];
    ACDGestureLockItemView *itemView = [self itemViewWithTouchLocation:loc];
    //如果为空，返回
    if (itemView == nil) return;
    //如果已经存在，返回
    if ([self.itemViewsM containsObject:itemView]) return;
    //添加
    [self.itemViewsM addObject:itemView];
    //记录密码
    [self.pwdM appendFormat:@"%@", @(itemView.tag)];
    //计算方向：每添加一次itemView就计算一次
    [self calDirect];
    // item处理
    [self itemHandel:itemView];
}

// item处理
- (void)itemHandel:(ACDGestureLockItemView *)itemView {
    //选中
    itemView.selected = YES;
    //绘制
    [self setNeedsDisplay];
}

//提取
- (ACDGestureLockItemView *)itemViewWithTouchLocation:(CGPoint)loc {
    ACDGestureLockItemView *itemView = nil;
    for (ACDGestureLockItemView *itemViewSub in self.subviews) {
        if (!CGRectContainsPoint(itemViewSub.frame, loc)) continue;
        itemView = itemViewSub;
        break;
    }
    return itemView;
}

//重设密码
- (void)resetPwd {
    //清空第一次密码即可
    self.firstRightPWD = nil;
}

#pragma mark - drawer
//绘制线条
- (void)drawRect:(CGRect)rect {
    //数组为空直接返回
    if (_itemViewsM == nil || _itemViewsM.count == 0) return;
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //添加路径
    CGContextAddRect(ctx, rect);
    //遍历所有的itemView
    [_itemViewsM enumerateObjectsUsingBlock:^(ACDGestureLockItemView *itemView,
                                              NSUInteger idx, BOOL *stop) {
        //添加圆形路径
        CGContextAddEllipseInRect(ctx, itemView.frame);
    }];
    //剪裁
    CGContextEOClip(ctx);
    //新建路径：管理线条
    CGMutablePathRef pathM = CGPathCreateMutable();
    //设置上下文属性
    // 1.设置线条颜色
    [GestureLockCircleLineColor set];
    //线条转角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    //设置线宽
    CGContextSetLineWidth(ctx, 1.0f);
    //遍历所有的itemView
    [_itemViewsM enumerateObjectsUsingBlock:^(ACDGestureLockItemView *itemView,
                                              NSUInteger idx, BOOL *stop) {
        CGPoint directPoint = itemView.center;
        if (idx == 0) { //第一个
            //添加起点
            CGPathMoveToPoint(pathM, NULL, directPoint.x, directPoint.y);
        } else { //其他
            //添加路径线条
            CGPathAddLineToPoint(pathM, NULL, directPoint.x, directPoint.y);
        }
    }];
    //将路径添加到上下文
    CGContextAddPath(ctx, pathM);
    //渲染路径
    CGContextStrokePath(ctx);
    //释放路径
    CGPathRelease(pathM);
}

//计算方向：每添加一次itemView就计算一次
- (void)calDirect {
    NSUInteger count = _itemViewsM.count;
    if (_itemViewsM == nil || count <= 1) return;
    //取出最后一个对象
    ACDGestureLockItemView *last_1_ItemView = _itemViewsM.lastObject;
    //倒数第二个
    ACDGestureLockItemView *last_2_ItemView = _itemViewsM[count - 2];
    //计算倒数第二个的位置
    CGFloat last_1_x = last_1_ItemView.frame.origin.x;
    CGFloat last_1_y = last_1_ItemView.frame.origin.y;
    CGFloat last_2_x = last_2_ItemView.frame.origin.x;
    CGFloat last_2_y = last_2_ItemView.frame.origin.y;
    //倒数第一个itemView相对倒数第二个itemView来说
    //正上
    if (last_2_x == last_1_x && last_2_y > last_1_y) {
        last_2_ItemView.direct = LockItemViewDirecTop;
    }
    //正左
    if (last_2_y == last_1_y && last_2_x > last_1_x) {
        last_2_ItemView.direct = LockItemViewDirecLeft;
    }
    //正下
    if (last_2_x == last_1_x && last_2_y < last_1_y) {
        last_2_ItemView.direct = LockItemViewDirecBottom;
    }
    //正右
    if (last_2_y == last_1_y && last_2_x < last_1_x) {
        last_2_ItemView.direct = LockItemViewDirecRight;
    }
    //左上
    if (last_2_x > last_1_x && last_2_y > last_1_y) {
        last_2_ItemView.direct = LockItemViewDirecLeftTop;
    }
    //右上
    if (last_2_x < last_1_x && last_2_y > last_1_y) {
        last_2_ItemView.direct = LockItemViewDirecRightTop;
    }
    //左下
    if (last_2_x > last_1_x && last_2_y < last_1_y) {
        last_2_ItemView.direct = LockItemViewDirecLeftBottom;
    }
    //右下
    if (last_2_x < last_1_x && last_2_y < last_1_y) {
        last_2_ItemView.direct = LockItemViewDiretRightBottom;
    }
}

#pragma mark - access methods
- (NSMutableString *)pwdM {
    if (_pwdM == nil) {
        _pwdM = [NSMutableString string];
    }
    return _pwdM;
}

- (NSMutableArray *)itemViewsM {
    if (_itemViewsM == nil) {
        _itemViewsM = [NSMutableArray array];
    }
    return _itemViewsM;
}

@end
