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
    self.animatorView.ln_y -= num;
    self.animatorView.ln_h = self.incremental;
}

- (void)setupSubViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.animatorView) {
            for (UIView *view in self.animatorView.subviews) {
                [view removeFromSuperview];
            }
            [[self.animatorView.layer.sublayers copy] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        }
    });
}

- (void)layoutSubviews {}
- (void)endRefreshAnimation:(LNRefreshComponent *)view {}
- (void)startRefreshAnimation:(LNRefreshComponent *)view {}
- (void)refreshView:(LNRefreshComponent *)view progress:(CGFloat)progress {}
- (void)refreshView:(LNRefreshComponent *)view state:(LNRefreshState)state {}

@end
