//
//  NSObject+LNRefresh.m
//  LNRefresh
//
//  Created by vvusu on 7/5/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "NSObject+LNRefresh.h"
#import <objc/runtime.h>

@implementation NSObject (LNRefresh)
+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

@end

@implementation UIView (LNRefresh)
- (void)setLn_x:(CGFloat)ln_x {
    CGRect frame = self.frame;
    frame.origin.x = ln_x;
    self.frame = frame;
}

- (CGFloat)ln_x {
    return self.frame.origin.x;
}

- (void)setLn_y:(CGFloat)ln_y {
    CGRect frame = self.frame;
    frame.origin.y = ln_y;
    self.frame = frame;
}

- (CGFloat)ln_y {
    return self.frame.origin.y;
}

- (void)setLn_w:(CGFloat)ln_w {
    CGRect frame = self.frame;
    frame.size.width = ln_w;
    self.frame = frame;
}

- (CGFloat)ln_w {
    return self.frame.size.width;
}

- (void)setLn_h:(CGFloat)ln_h {
    CGRect frame = self.frame;
    frame.size.height = ln_h;
    self.frame = frame;
}

- (CGFloat)ln_h {
    return self.frame.size.height;
}

- (void)setLn_size:(CGSize)ln_size {
    CGRect frame = self.frame;
    frame.size = ln_size;
    self.frame = frame;
}

- (CGSize)ln_size {
    return self.frame.size;
}

- (void)setLn_origin:(CGPoint)ln_origin {
    CGRect frame = self.frame;
    frame.origin = ln_origin;
    self.frame = frame;
}

- (CGPoint)ln_origin {
    return self.frame.origin;
}

@end

@implementation UIScrollView (LNRefresh)

- (void)setLn_insetT:(CGFloat)ln_insetT {
    UIEdgeInsets inset = self.contentInset;
    inset.top = ln_insetT;
    self.contentInset = inset;
}

- (CGFloat)ln_insetT {
    return self.contentInset.top;
}

- (void)setLn_insetB:(CGFloat)ln_insetB {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = ln_insetB;
    self.contentInset = inset;
}

- (CGFloat)ln_insetB {
    return self.contentInset.bottom;
}

- (void)setLn_insetL:(CGFloat)ln_insetL {
    UIEdgeInsets inset = self.contentInset;
    inset.left = ln_insetL;
    self.contentInset = inset;
}

- (CGFloat)ln_insetL {
    return self.contentInset.left;
}

- (void)setLn_insetR:(CGFloat)ln_insetR {
    UIEdgeInsets inset = self.contentInset;
    inset.right = ln_insetR;
    self.contentInset = inset;
}

- (CGFloat)ln_insetR {
    return self.contentInset.right;
}

- (void)setLn_offsetX:(CGFloat)ln_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = ln_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)ln_offsetX {
    return self.contentOffset.x;
}

- (void)setLn_offsetY:(CGFloat)ln_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = ln_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)ln_offsetY {
    return self.contentOffset.y;
}

- (void)setLn_contentW:(CGFloat)ln_contentW {
    CGSize size = self.contentSize;
    size.width = ln_contentW;
    self.contentSize = size;
}

- (CGFloat)ln_contentW {
    return self.contentSize.width;
}

- (void)setLn_contentH:(CGFloat)ln_contentH {
    CGSize size = self.contentSize;
    size.height = ln_contentH;
    self.contentSize = size;
}

- (CGFloat)ln_contentH {
    return self.contentSize.height;
}

@end

#import "LNRefreshHeader.h"
#import "LNRefreshFooter.h"
#import "LNHeaderAnimator.h"
#import "LNFooterAnimator.h"
#import "LNHeaderDIYAnimator.h"
#import <objc/runtime.h>

static const char LNRefreshHeaderKey = '\0';
static const char LNRefreshFooterKey = '\0';
@implementation UIScrollView (LNRefreshExcetion)

#pragma mark - GET SET
- (void)setLn_header:(LNRefreshHeader *)ln_header {
    objc_setAssociatedObject(self, &LNRefreshHeaderKey, ln_header, OBJC_ASSOCIATION_RETAIN);
}

- (LNRefreshHeader *)ln_header {
    return objc_getAssociatedObject(self, &LNRefreshHeaderKey);
}

- (void)setLn_footer:(LNRefreshFooter *)ln_footer {
    objc_setAssociatedObject(self, &LNRefreshFooterKey, ln_footer, OBJC_ASSOCIATION_RETAIN);
}

- (LNRefreshFooter *)ln_footer {
    return objc_getAssociatedObject(self, &LNRefreshFooterKey);
}

#pragma mark - LNRefreshHeader 下拉
- (LNRefreshHeader *)addPullToRefresh:(LNRefreshComponentBlock)block {
    return [self addPullToRefresh:[[LNHeaderAnimator alloc] init] block:block];
}

//WSCN
- (LNRefreshHeader *)addPullToRefreshTypeDIY:(LNRefreshComponentBlock)block {
    return [self addPullToRefresh:[LNHeaderDIYAnimator createAnimator] block:block];
}

- (LNRefreshHeader *)addPullToRefresh:(LNHeaderAnimator *)animater block:(LNRefreshComponentBlock)block {
    if (!self.ln_header) {
        LNRefreshHeader *header = [LNRefreshHeader initWithFrame:CGRectZero animator:animater block:block];
        CGPoint offset = self.contentOffset;
        header.frame = CGRectMake(offset.x, -header.animator.incremental + offset.y, self.bounds.size.width, header.animator.incremental);
        header.animator.animatorView = header;
        self.ln_header = header;
        [self insertSubview:header atIndex:0];
    }
    return self.ln_header;
}

#pragma mark - LNRefreshFooter 上拉
- (LNRefreshFooter *)addInfiniteScrolling:(LNRefreshComponentBlock)block {
    return [self addInfiniteScrolling:[[LNFooterAnimator alloc] init] block:block];
}

- (LNRefreshFooter *)addInfiniteScrolling:(LNFooterAnimator *)animater block:(LNRefreshComponentBlock)block {
    if (!self.ln_footer) {
        LNRefreshFooter *footer = [LNRefreshFooter initWithFrame:CGRectZero animator:animater block:block];
        CGPoint offset = self.contentOffset;
        footer.frame = CGRectMake(offset.x, self.contentSize.height + self.contentInset.bottom - offset.y, self.bounds.size.width, footer.animator.incremental);
        footer.animator.animatorView = footer;
        self.ln_footer = footer;
        [self insertSubview:self.ln_footer atIndex:0];
    }
    return self.ln_footer;
}

#pragma mark - Action
- (void)startRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ln_header startRefreshing];
    });
}

- (void)endRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endRefreshing:NO];
    });
}

- (void)endRefreshing:(BOOL)ignoreFooter {
    [self.ln_header stopRefreshing];
    [self resetNoMoreData];
    self.ln_footer.hidden = ignoreFooter;
}

- (void)endLoadingMore {
    [self.ln_footer stopRefreshing];
}

- (void)resetNoMoreData {
    self.ln_footer.noMoreData = NO;
}

- (void)noticeNoMoreData {
    self.ln_footer.noMoreData = YES;
    [self.ln_footer stopRefreshing];
}

- (void)removeRefreshHeader {
    [self.ln_header stopRefreshing];
    [self.ln_header removeFromSuperview];
    self.ln_header = nil;
}

- (void)removeRefreshFooter {
    [self.ln_footer stopRefreshing];
    [self.ln_footer removeFromSuperview];
    self.ln_footer = nil;
}

@end
