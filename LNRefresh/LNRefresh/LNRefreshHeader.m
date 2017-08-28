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
#import "LNRefreshHandler.h"

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
    if (offsets < 0) {
        if (!self.isRefreshing) {
            CGFloat progress = -offsets/self.animator.trigger;
            if (progress > 1) {
                if (!self.scrollView.isDragging) {
                    [self startRefreshing];
                    [self.animator refreshView:self state:LNRefreshState_Refreshing];
                } else {
                    [self.animator refreshView:self state:LNRefreshState_WillRefresh];
                }
            } else {
                [self.animator refreshView:self state:LNRefreshState_PullToRefresh];
            }
            if (self.scrollView.isDragging) {
                [self.animator refreshView:self progress:progress];
            }
        }
    }
    self.previousOffset = self.scrollView.contentOffset.y;
}

- (void)start {
    [super start];
    self.ignoreObserving = YES;
    self.scrollView.bounces = NO;
    self.startData = [NSDate timeIntervalSinceReferenceDate];
    [self.animator refreshView:self state:LNRefreshState_Refreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.ln_insetT = self.scrollViewInsets.top + self.animator.trigger;
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -self.scrollView.ln_insetT);
        } completion:^(BOOL finished) {
            self.scrollView.bounces = self.scrollViewBounces;
            self.ignoreObserving = NO;
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }];
    });
}

- (void)stop {
    [super stop];
    self.ignoreObserving = YES;
    NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate] - self.startData;
    if (time > [LNRefreshHandler defaultHandler].refreshTime) {
        time = 0;
    } else {
        time = [LNRefreshHandler defaultHandler].refreshTime - time;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.animator refreshView:self state:LNRefreshState_PullToRefresh];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4f animations:^{
                self.scrollView.ln_insetT = self.scrollViewInsets.top;
                self.previousOffset = self.scrollView.contentOffset.y;
            } completion:^(BOOL finished) {
                self.ignoreObserving = NO;
                [self.animator refreshView:self state:LNRefreshState_Normal];
            }];
        });
    });
}

@end
