//
//  LNRefreshComponent.m
//  LNRefresh
//
//  Created by vvusu on 7/11/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNRefreshComponent.h"
#import "LNRefreshAnimator.h"
#import "NSObject+LNRefresh.h"

NSString *const LNRefreshContentSize = @"contentSize";
NSString *const LNRefreshContentOffset = @"contentOffset";

@interface LNRefreshComponent()
@property (nonatomic, assign) BOOL finishLoad;
@end

@implementation LNRefreshComponent

- (void)dealloc {
    [self removeObserver];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setIgnoreObserving:(BOOL)ignoreObserving {
    _ignoreObserving = ignoreObserving;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.finishLoad = YES;
}

# pragma Action
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    [self removeObserver];
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollViewInsets = self.scrollView.contentInset;
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addObserver];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}

- (void)startRefreshing {
    if (self.isRefreshing || !self.finishLoad) { return; }
    [self start];
}

- (void)stopRefreshing {
    if (self.isRefreshing) {
        [self stop];
    }
}

- (void)stop {
    self.refreshing = NO;
}

- (void)start {
    self.refreshing = YES;
}

- (void)contentSizeChangeAction:(NSDictionary *)change {};
- (void)contentOffsetChangeAction:(NSDictionary *)change {};

# pragma KVO Method
- (void)addObserver {
    if (!self.isObserving) {
        self.observing = YES;
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [self.scrollView addObserver:self forKeyPath:LNRefreshContentSize options:options context:nil];
        [self.scrollView addObserver:self forKeyPath:LNRefreshContentOffset options:options context:nil];
    }
}

- (void)removeObserver {
    if (self.isObserving) {
        self.observing = NO;
        [self.superview removeObserver:self forKeyPath:LNRefreshContentSize];
        [self.superview removeObserver:self forKeyPath:LNRefreshContentOffset];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (!self.userInteractionEnabled || self.hidden) {
        return;
    }
    if ([keyPath isEqualToString:LNRefreshContentSize]) {
        if (!self.isIgnoreObserving) {
            [self contentSizeChangeAction:change];
        }
    }
    if ([keyPath isEqualToString:LNRefreshContentOffset]) {
        if (!self.isIgnoreObserving) {
            [self contentOffsetChangeAction:change];
        }
    }
}

@end
