//
//  ACDGestureLockThumbnailView.m
//  GestureLock
//
//  Created by hhcncx_Cd on 15/11/2.
//  Copyright © 2015年 hhcncx_Cd. All rights reserved.
//

#import "ACDGestureLockConst.h"
#import "ACDGestureLockThumbnailView.h"

@implementation ACDGestureLockThumbnailView

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor whiteColor];
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置圆周宽度
    CGContextSetLineWidth(ctx, GestureLockNormalLineWidth);
    //设置线条颜色
    [GestureLockCircleLineNormalColor set];
    //新建路径
    CGMutablePathRef pathM = CGPathCreateMutable();
    //整个九宫格位于一个大小固定的view中
    CGFloat marginV = 3.0f; //间距
    CGFloat padding = 1.0f; //四周间距
    CGFloat rectWH =
        (rect.size.width - marginV * 2 - padding * 2) / 3; //一个圆的直径取整
    rectWH = (int) rectWH;
    //添加圆形路径
    for (NSUInteger i = 0; i < 9; i++) {
        NSUInteger row = i % 3;
        NSUInteger col = i / 3;
        CGFloat rectX = (rectWH + marginV) * row + padding;
        CGFloat rectY = (rectWH + marginV) * col + padding;
        CGRect rect =
            CGRectMake(rectX, rectY, rectWH, rectWH); //一个圆的frame信息
        //绘图
        CGPathAddEllipseInRect(pathM, NULL, rect);
    }
    //添加路径
    CGContextAddPath(ctx, pathM);
    //绘制路径，渲染
    CGContextStrokePath(ctx);
    //释放路径
    CGPathRelease(pathM);
}

@end
