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
    return footer;
}

# pragma mark - Action

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        self.scrollView.ln_insetB = self.scrollViewInsets.bottom;
        CGRect rect = self.frame;
        rect.origin.y = self.scrollView ? self.scrollView.contentSize.height:0.0;
        self.frame = rect;
    } else {
        self.scrollView.ln_insetB = self.scrollViewInsets.bottom + self.animator.incremental;
        CGRect rect = self.frame;
        rect.origin.y = self.scrollView ? self.scrollView.contentSize.height:0.0;
        self.frame = rect;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.scrollViewInsets = self.scrollView ? self.scrollView.contentInset : UIEdgeInsetsZero;
    self.scrollView.ln_insetB = self.scrollViewInsets.bottom + self.bounds.size.height;
    CGRect rect = self.frame;
    rect.origin.y = self.scrollView ? self.scrollView.contentSize.height : 0;
    self.frame = rect;
}

- (void)contentSizeChangeAction:(NSDictionary *)change {
    [super contentSizeChangeAction:change];
    CGFloat targetY = self.scrollView.contentSize.height + self.scrollViewInsets.bottom;
    if (self.frame.origin.y != targetY) {
        CGRect rect = self.frame;
        rect.origin.y = targetY;
        self.frame = rect;
    }
}

- (void)contentOffsetChangeAction:(NSDictionary *)change {
    [super contentOffsetChangeAction:change];
    if (self.isRefreshing || self.noMoreData || self.isHidden) {
        return;
    }
    if (self.scrollView.contentSize.height <= 0 || self.scrollView.contentOffset.y + self.scrollView.contentInset.top <= 0) {
        self.alpha = 0;
    } else {
        self.alpha = 1.0;
    }
    if (self.scrollView.contentSize.height + self.scrollView.contentInset.top > self.scrollView.bounds.size.height) {
        if (self.scrollView.contentSize.height - self.scrollView.contentOffset.y + self.scrollView.contentInset.bottom <= self.scrollView.bounds.size.height) {
            [self.animator refreshView:self state:LNRefreshState_Refreshing];
            [self startRefreshing];
        }
    } else {
        if (self.scrollView.contentOffset.y + self.scrollView.contentInset.top >= self.animator.trigger/2.0) {
            [self.animator refreshView:self state:LNRefreshState_Refreshing];
            [self startRefreshing];
        }
    }
}

- (void)start {
    [super start];
    self.ignoreObserving = YES;
    [self.animator startRefreshAnimation:self];
    CGFloat x = self.scrollView.contentOffset.x;
    CGFloat y = MAX(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.ln_insetB);
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.scrollView.contentOffset = CGPointMake(x, y);
    } completion:^(BOOL finished) {
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        self.ignoreObserving = NO;
    }];
}

- (void)stop {
    [super stop];
    [self.animator endRefreshAnimation:self];
    if (!self.noMoreData) {
        self.alpha = 0;
        [self.animator refreshView:self state:LNRefreshState_Normal];
    } else {
        [self.animator refreshView:self state:LNRefreshState_NoMoreData];
    }
}

- (void)noticeNoMoreData {
    self.noMoreData = YES;
}

- (void)resetNoMoreData {
    self.noMoreData = NO;
}

@end
