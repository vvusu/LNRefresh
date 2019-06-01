//
//  LNRefreshAnimator.m
//  LNRefresh
//
//  Created by vvusu on 7/11/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNRefreshAnimator.h"
#import "LNRefreshComponent.h"
#import "NSObject+LNRefresh.h"

@implementation LNRefreshAnimator

- (instancetype)init {
    if (self = [super init]) {
        self.trigger = LNRefreshTrigger;
        self.incremental = LNRefreshIncremental;
        self.ignoreGlobSetting = NO;
        self.state = LNRefreshState_Normal;
    }
    return self;
}

- (void)setAnimatorView:(UIView *)animatorView {
    _animatorView = animatorView;
    [self setupSubViews];
}

- (void)setIncremental:(CGFloat)incremental {
    CGFloat num = incremental - _incremental;
    _incremental = incremental;
    if (self.trigger < incremental) {
        self.trigger = incremental;
    }
    if (self.animatorView) {
        [self updateAnimationView:num];
    }
}

- (void)updateAnimationView {
    [self updateAnimationView:0];
}

- (void)updateAnimationView:(CGFloat)num {
    CGRect frame = self.animatorView.frame;
    frame.origin.y -= num;
    frame.size.height = self.incremental;
    if (self.animatorView) {
        self.animatorView.frame = frame;        
    }
}

- (void)setupSubViews {
    dispatch_semaphore_t signal = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.animatorView) {
            NSArray *views = [self.animatorView.subviews copy];
            for (UIView *view in views) {
                [view removeFromSuperview];
            }
            NSArray *layers = [self.animatorView.layer.sublayers copy];
            for (CALayer *layer in layers) {
                [layer removeFromSuperlayer];
            }
        }
        dispatch_semaphore_signal(signal);
    });
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
}

- (void)layoutSubviews {}
- (void)endRefreshAnimation:(LNRefreshComponent *)view {}
- (void)startRefreshAnimation:(LNRefreshComponent *)view {}
- (void)refreshView:(LNRefreshComponent *)view progress:(CGFloat)progress {}
- (void)refreshView:(LNRefreshComponent *)view state:(LNRefreshState)state {}

@end
