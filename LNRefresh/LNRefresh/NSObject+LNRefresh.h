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

- (LNRefreshHeader *)addPullToRefresh:(LNRefreshComponentBlock)block;
- (LNRefreshHeader *)addPullToRefreshTypeDIY:(LNRefreshComponentBlock)block;
- (LNRefreshHeader *)addPullToRefreshWithHeight:(CGFloat)height typeDIY:(LNRefreshComponentBlock)block;
- (LNRefreshHeader *)addPullToRefresh:(LNHeaderAnimator *)animater block:(LNRefreshComponentBlock)block;

- (LNRefreshFooter *)addInfiniteScrolling:(LNRefreshComponentBlock)block;
- (LNRefreshFooter *)addInfiniteScrolling:(LNFooterAnimator *)animater block:(LNRefreshComponentBlock)block;

- (void)startRefreshing;
- (void)endRefreshing;
- (void)removeRefreshHeader;
- (void)removeRefreshFooter;
- (void)endLoadingMore;
- (void)resetNoMoreData;
- (void)noticeNoMoreData;

- (void)reStartGIFAnimation;
- (void)pullDownDealFooterWithItemCount:(NSInteger)itemCount cursor:(NSString *)cursor;
- (void)pullUpRefreshDealFooterWithItemCount:(NSInteger)itemCount cursor:(NSString *)cursor;

- (void)hideRefreshFooter;
- (void)hideRefreshHeader;
- (void)showRefreshFooter;
- (void)showRefreshHeader;

@end

