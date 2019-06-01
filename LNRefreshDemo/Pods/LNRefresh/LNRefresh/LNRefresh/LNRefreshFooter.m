//
//  LNRefreshFooter.m
//  LNRefresh
//
//  Created by vvusu on 7/12/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNRefreshFooter.h"
#import "LNFooterAnimator.h"
#import "NSObject+LNRefresh.h"

@implementation LNRefreshFooter

+ (instancetype)initWithFrame:(CGRect)frame {
    return [LNRefreshFooter initWithFrame:frame block:nil];
}

+ (instancetype)initWithFrame:(CGRect)frame
                        block:(LNRefreshComponentBlock)block {
    LNFooterAnimator *animator = [[LNFooterAnimator alloc]init];
    return [LNRefreshFooter initWithFrame:frame animator:animator block:block];
}

+ (instancetype)initWithFrame:(CGRect)frame
                     animator:(LNFooterAnimator *)animator
                        block:(LNRefreshComponentBlock)block {
    LNRefreshFooter *footer = [[LNRefreshFooter alloc]init];
    footer.animator = animator;
    footer.refreshBlock = block;
    footer.autoRefresh = YES;
    return footer;
}

# pragma mark - Action
- (void)contentSizeChangeAction:(NSDictionary *)change {
    [super contentSizeChangeAction:change];
    CGFloat targetY = self.scrollView.contentSize.height;
    if (self.frame.origin.y != targetY) {
        self.ln_y = targetY;
    }
    [self.animator layoutSubviews];
}

- (void)updateScrollViewInset
{
    if (!self.noMoreData) {
        self.scrollView.ln_insetB = self.scrollViewInsets.bottom;
    } else {
        self.scrollView.ln_insetB = self.scrollViewInsets.bottom + self.animator.incremental;
    }
}

- (void)contentOffsetChangeAction:(NSDictionary *)change {
    [super contentOffsetChangeAction:change];
    CGFloat previousOffset = self.scrollView.contentOffset.y+self.scrollView.contentInset.top;
    if (self.isRefreshing || self.hidden || previousOffset < 0) {
        return;
    }
    // 解决系统 UITableViewStylePlain 状态下 FooterInSection 偏移问题
    CGFloat instenBottom = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
    CGFloat progress = (self.previousOffset - instenBottom)/self.animator.trigger;
    if (instenBottom < 0) {
        progress = self.previousOffset/self.animator.trigger;
    }
    if (self.isNoNoreData) {
        if (instenBottom > 0) {
            if(progress > 0) {
                self.scrollView.ln_insetB = self.scrollViewInsets.bottom + self.animator.incremental;
            } else {
                self.scrollView.ln_insetB = self.scrollViewInsets.bottom;
            }
        }
        self.previousOffset = self.scrollView.contentOffset.y+self.scrollView.contentInset.top;
        return;
    }
    if (progress > 0) {
        if (self.isAutoRefresh) {
            [self startRefreshing];
            [self.animator refreshView:self state:LNRefreshState_Refreshing];
        } else {
            if (progress >= 1) {
                if (!self.scrollView.isDragging) {
                    [self startRefreshing];
                    [self.animator refreshView:self state:LNRefreshState_Refreshing];
                } else {
                    [self.animator refreshView:self state:LNRefreshState_WillRefresh];
                }
            } else {
                [self.animator refreshView:self state:LNRefreshState_PullToRefresh];
            }
            [self.animator refreshView:self progress:progress];
        }
    }
    self.previousOffset = self.scrollView.contentOffset.y+self.scrollView.contentInset.top;
}

- (void)start {
    [super start];
    self.ignoreObserving = YES;
    [self.animator refreshView:self state:LNRefreshState_Refreshing];
    // 动画去掉可以解决上拉加载更多时候，HeaderInSection 偏移问题
    [UIView animateWithDuration:0.25f animations:^{
        self.scrollView.ln_insetB = self.scrollViewInsets.bottom + self.animator.incremental;
        CGFloat contentOffsetY = (self.scrollView.contentSize.height + self.scrollView.ln_insetB) - self.scrollView.frame.size.height;
        if (contentOffsetY >= 0) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, contentOffsetY);
        }
    } completion:^(BOOL finished) {
        self.ignoreObserving = NO;
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }];
}

- (void)stop {
    [super stop];
    self.ignoreObserving = YES;
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.ln_insetB = self.scrollViewInsets.bottom + self.animator.incremental;
    } completion:^(BOOL finished) {
        [self updateScrollViewInset];
        self.previousOffset = self.scrollView.contentOffset.y;
        if (!self.noMoreData) {
            [self.animator refreshView:self state:LNRefreshState_Normal];
        } else {
            [self.animator refreshView:self state:LNRefreshState_NoMoreData];
        }
        self.ignoreObserving = NO;
    }];
}

@end
