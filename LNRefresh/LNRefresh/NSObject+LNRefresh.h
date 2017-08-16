//
//  NSObject+LNRefresh.h
//  LNRefresh
//
//  Created by vvusu on 7/5/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (LNRefresh)
+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2;
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2;
@end

@interface UIView (LNRefresh)
@property (assign, nonatomic) CGFloat ln_x;
@property (assign, nonatomic) CGFloat ln_y;
@property (assign, nonatomic) CGFloat ln_w;
@property (assign, nonatomic) CGFloat ln_h;
@property (assign, nonatomic) CGSize ln_size;
@property (assign, nonatomic) CGPoint ln_origin;
@end

@interface UIScrollView (LNRefresh)
@property (assign, nonatomic) CGFloat ln_insetT;
@property (assign, nonatomic) CGFloat ln_insetB;
@property (assign, nonatomic) CGFloat ln_insetL;
@property (assign, nonatomic) CGFloat ln_insetR;
@property (assign, nonatomic) CGFloat ln_offsetX;
@property (assign, nonatomic) CGFloat ln_offsetY;
@property (assign, nonatomic) CGFloat ln_contentW;
@property (assign, nonatomic) CGFloat ln_contentH;
@end

#import "LNRefreshComponent.h"
@class LNRefreshHeader, LNRefreshFooter, LNHeaderAnimator, LNFooterAnimator;
@interface UIScrollView (LNRefreshExcetion)
@property (nonatomic, strong) LNRefreshHeader *ln_header;
@property (nonatomic, strong) LNRefreshFooter *ln_footer;

/**
 添加下拉刷新

 @param block LNRefreshComponentBlock
 @return LNRefreshHeader
 */
- (LNRefreshHeader *)addPullToRefresh:(LNRefreshComponentBlock)block;

/**
 添加DIY下拉刷新
 
 @param block LNRefreshComponentBlock
 @return LNRefreshHeader
 */
- (LNRefreshHeader *)addPullToRefreshTypeDIY:(LNRefreshComponentBlock)block;

/**
 加载自定义动画下拉刷新

 @param animater 自定义动画 LNHeaderAnimator类
 @param block LNRefreshComponentBlock
 @return LNRefreshHeader
 */
- (LNRefreshHeader *)addPullToRefresh:(LNHeaderAnimator *)animater block:(LNRefreshComponentBlock)block;

/**
 添加加载更多

 @param block block
 @return LNRefreshFooter
 */
- (LNRefreshFooter *)addInfiniteScrolling:(LNRefreshComponentBlock)block;

/**
 添加自定义动画加载更多

 @param animater 自定义动画 LNFooterAnimator类
 @param block LNRefreshComponentBlock
 @return LNRefreshFooter
 */
- (LNRefreshFooter *)addInfiniteScrolling:(LNFooterAnimator *)animater block:(LNRefreshComponentBlock)block;

/**
 开始下拉刷新
 */
- (void)startRefreshing;

/**
 结束下拉刷新
 */
- (void)endRefreshing;

/**
 移除头部刷新控件
 */
- (void)removeRefreshHeader;

/**
 移除尾部加载控件
 */
- (void)removeRefreshFooter;

/**
 结束加载更多
 */
- (void)endLoadingMore;

/**
 重置没有更多数据
 */
- (void)resetNoMoreData;

/**
 提示没有更多数据
 */
- (void)noticeNoMoreData;
@end

