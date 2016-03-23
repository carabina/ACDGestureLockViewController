//
//  ACDGestureLockItemView.h
//  GestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

//  九宫格原点元素

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LockItemViewDirect) {
    //正上
    LockItemViewDirecTop = 1,
    //右上
    LockItemViewDirecRightTop,
    //右
    LockItemViewDirecRight,
    //右下
    LockItemViewDiretRightBottom,
    //下
    LockItemViewDirecBottom,
    //左下
    LockItemViewDirecLeftBottom,
    //左
    LockItemViewDirecLeft,
    //左上
    LockItemViewDirecLeftTop,
};

@interface ACDGestureLockItemView : UIView

//是否选中
@property (nonatomic, assign) BOOL selected;

//方向
@property (nonatomic, assign) LockItemViewDirect direct;

@end
