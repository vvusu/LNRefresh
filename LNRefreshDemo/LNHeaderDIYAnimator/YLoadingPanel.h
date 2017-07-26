//
//  YLoadingPanel.h
//  MVendorFramework
//
//  Created by wscn on 16/12/3.
//  Copyright © 2016年 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLoadingPanel : UIView

//最多允许多少个圆
@property (assign, nonatomic) int maxCirclesNumber;

//圆的半径
@property (readwrite, nonatomic) CGFloat radius;

//圆与圆之间的空隙
@property (readwrite, nonatomic) CGFloat internalSpacing;

//每个圆的动画延迟
@property (readwrite, nonatomic) CGFloat delay;

//每个月的动画时间
@property (readwrite, nonatomic) CGFloat duration;

//圆的颜色
@property (strong, nonatomic) UIColor *defaultColor;

//整个头部的下拉刷新触发高度
@property (nonatomic, assign) CGFloat refreshHeader;//跟偏移量offSetY配合使用

//偏移量
@property (nonatomic, assign) CGFloat offsetY;//根据offSetY
@property (nonatomic, assign) CGFloat pullingPercent;//根据百分比

@property (nonatomic, assign) BOOL isCircleAnimation;//根据offSetY

//添加一个圆
- (void)addACircle;

//删除一个圆
- (void)removeACircle;

//删除所有圆
- (void)removeAllCircles;

//开始下拉刷新动画
- (void)doAnimation;

//结束动画
- (void)stopAnimation;

//自动下拉
- (void)doAutoPullDown;//根据offSetY
- (void)doAutoPullDownWithPullingPercent;//根据百分比

//开始页面加载动画
- (void)doPageLoadingAnimation;

//结束页面加载动画
- (void)stopPageLoadingAnimation;

@end
