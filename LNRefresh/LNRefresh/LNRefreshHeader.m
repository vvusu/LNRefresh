//
//  LNRefreshHeader.m
//  LNRefresh
//
//  Created by vvusu on 7/12/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNRefreshHeader.h"
#import "LNHeaderAnimator.h"
#import "NSObject+LNRefresh.h"

@implementation LNRefreshHeader

+ (instancetype)initWithFrame:(CGRect)frame {
    return [LNRefreshHeader initWithFrame:frame block:nil];
}

+ (instancetype)initWithFrame:(CGRect)frame
                        block:(LNRefreshComponentBlock)block {
    return [LNRefreshHeader initWithFrame:frame animator:[[LNHeaderAnimator alloc]init] block:block];
}

+ (instancetype)initWithFrame:(CGRect)frame
                     animator:(LNHeaderAnimator *)animator
                        block:(LNRefreshComponentBlock)block {
    LNRefreshHeader *header = [[LNRefreshHeader alloc]init];
    header.refreshBlock = block;
    header.animator = animator;
    header.scrollViewBounces = YES;
    return header;
}

# pragma mark - Action

- (void)contentOffsetChangeAction:(NSDictionary *)change {
    [super contentOffsetChangeAction:change];
    CGFloat offsets = self.previousOffset + self.scrollViewInsets.top;
    if (offsets < -self.animator.trigger) {
        if (!self.isRefreshing) {
            if (!self.scrollView.isDragging) {
                [self startRefreshing];
                [self.animator refreshView:self state:LNRefreshState_Refreshing];
            } else {
                [self.animator refreshView:self state:LNRefreshState_PullToRefresh];
            }
        }
    } else if (offsets < 0) {
        if (!self.isRefreshing) {
            [self.animator refreshView:self state:LNRefreshState_Normal];
            [self.animator refreshView:self progress:-offsets/self.animator.trigger];
        }
    } else {}
    self.previousOffset = self.scrollView.contentOffset.y;
}

- (void)start {
    self.ignoreObserving = YES;
    self.scrollView.bounces = NO;
    [super start];
    [self.animator startRefreshAnimation:self];
    UIEdgeInsets insets = self.scrollView.contentInset;
    UIEdgeInsets scrollInsets = self.scrollViewInsets;
    scrollInsets.top = insets.top;
    self.scrollViewInsets = scrollInsets;
    insets.top += self.animator.trigger;
    self.scrollView.contentInset = insets;
    self.scrollView.ln_offsetY = self.previousOffset;
    self.previousOffset -= self.animator.trigger;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.scrollView.ln_offsetY = -insets.top;
    } completion:^(BOOL finished) {
        self.ignoreObserving = NO;
        self.scrollView.bounces = self.scrollViewBounces;
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }];
}

- (void)stop {
    [super stop];
    self.ignoreObserving = YES;
    [self.animator endRefreshAnimation:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4f animations:^{
            self.scrollView.ln_insetT = self.scrollViewInsets.top;
            self.scrollView.ln_offsetY = -self.scrollViewInsets.top;
        } completion:^(BOOL finished) {
            [self.animator refreshView:self state:LNRefreshState_Normal];
            self.scrollView.ln_insetT = self.scrollViewInsets.top;
            self.previousOffset = self.scrollView.contentOffset.y;
            self.ignoreObserving = NO;
        }];
    });
}

@end
