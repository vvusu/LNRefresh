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
    self.animatorView.frame = frame;
}

- (void)setupSubViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.animatorView) {
            for (UIView *view in self.animatorView.subviews) {
                [view removeFromSuperview];
            }
            if (self.animatorView.layer.sublayers) {
                for (CALayer *layer in self.animatorView.layer.sublayers) {
                    [layer removeFromSuperlayer];
                }
            }
        }
    });
}

- (void)layoutSubviews {}
- (void)endRefreshAnimation:(LNRefreshComponent *)view {}
- (void)startRefreshAnimation:(LNRefreshComponent *)view {}
- (void)refreshView:(LNRefreshComponent *)view progress:(CGFloat)progress {}
- (void)refreshView:(LNRefreshComponent *)view state:(LNRefreshState)state {}

@end
