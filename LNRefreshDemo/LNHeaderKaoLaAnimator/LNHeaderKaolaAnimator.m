//
//  LNHeaderKaolaAnimator.m
//  LNRefresh
//
//  Created by vvusu on 8/25/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderKaolaAnimator.h"

@interface LNHeaderKaolaAnimator ()
@property (nonatomic, assign) CGPoint kaolaView1Rect;
@property (nonatomic, assign) CGPoint kaolaView2Rect;
@property (nonatomic, assign) CGPoint kaolaView3Rect;
@property (nonatomic, strong) UIView *kaolaBGView;
@property (nonatomic, strong) UIImageView *kaolaView1;
@property (nonatomic, strong) UIImageView *kaolaView2;
@property (nonatomic, strong) UIImageView *kaolaView3;
@end

@implementation LNHeaderKaolaAnimator

+ (instancetype)createAnimator {
    LNHeaderKaolaAnimator *diyAnimator = [[LNHeaderKaolaAnimator alloc]init];
    diyAnimator.headerType = LNRefreshHeaderType_DIY;
    diyAnimator.trigger = 50;
    diyAnimator.incremental = 50;
    return diyAnimator;
}

- (UIView *)kaolaBGView {
    if (!_kaolaBGView) {
        _kaolaBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.animatorView.frame.size.width, self.animatorView.frame.size.height/2 + 17)];
        _kaolaBGView.clipsToBounds = YES;
        [_kaolaBGView addSubview:self.kaolaView1];
        [_kaolaBGView addSubview:self.kaolaView2];
        [_kaolaBGView addSubview:self.kaolaView3];
    }
    return _kaolaBGView;
}

- (UIImageView *)kaolaView1 {
    if (!_kaolaView1) {
        _kaolaView1 = [[UIImageView alloc] init];
        _kaolaView1.image = [UIImage imageNamed:@"loadingview_kaola_left"];
        _kaolaView1.frame = CGRectMake(0, 0, 24, 28);
    }
    return _kaolaView1;
}

- (UIImageView *)kaolaView2 {
    if (!_kaolaView2) {
        _kaolaView2 = [[UIImageView alloc] init];
        _kaolaView2.image = [UIImage imageNamed:@"loadingview_kaola_middle"];
        _kaolaView2.frame = CGRectMake(0, 0, 24, 28);
    }
    return _kaolaView2;
}

- (UIImageView *)kaolaView3 {
    if (!_kaolaView3) {
        _kaolaView3 = [[UIImageView alloc] init];
        _kaolaView3.image = [UIImage imageNamed:@"loadingview_kaola_right"];
        _kaolaView3.frame = CGRectMake(0, 0, 24, 28);
    }
    return _kaolaView3;
}

- (void)setupHeaderView_DIY {
    [self.animatorView addSubview:self.kaolaBGView];
}

- (void)layoutHeaderView_DIY {
    if (self.state == LNRefreshState_Normal) {
        [self resetKaolaViewPoint];
    }
}

- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
            [self resetKaolaViewPoint];
            break;
        case LNRefreshState_PullToRefresh:
            break;
        case LNRefreshState_WillRefresh:
            break;
        case LNRefreshState_Refreshing:
            [self startRefreshAnimation_DIY:view];
            break;
        default:
            break;
    }
}

- (void)startRefreshAnimation_DIY:(LNRefreshComponent *)view {
    [self resetKaolaViewPoint];
    [self kaolaAnimation1];
}

- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {
    if (progress > 1.0) {
        progress = progress - floor(progress);
    }
    CGFloat num = 1.0/3.0;
    if (progress <= num) {
        self.kaolaView1.center = CGPointMake(self.kaolaView1Rect.x, self.kaolaView1Rect.y + 36*progress);
        self.kaolaView2.center = CGPointMake(self.kaolaView2Rect.x, self.kaolaView2Rect.y - 36*progress);
    } else if (progress <= 2*num) {
        progress -= num;
        self.kaolaView2.center = CGPointMake(self.kaolaView2Rect.x, self.kaolaView1Rect.y + 36*progress);
        self.kaolaView3.center = CGPointMake(self.kaolaView3Rect.x, self.kaolaView3Rect.y - 36*progress);
    } else {
        progress -= 2*num;
        self.kaolaView3.center = CGPointMake(self.kaolaView3Rect.x, self.kaolaView1Rect.y + 36*progress);
        self.kaolaView1.center = CGPointMake(self.kaolaView1Rect.x, self.kaolaView3Rect.y - 36*progress);
    }
}

#pragma mark - Aciton
- (void)resetKaolaViewPoint {
    CGRect react = self.animatorView.frame;
    CGFloat X = react.size.width/2.0;
    CGFloat Y = react.size.height/2.0 + 5;
    self.kaolaView1Rect = CGPointMake(X - 28, Y);
    self.kaolaView2Rect = CGPointMake(X, Y + 12);
    self.kaolaView3Rect = CGPointMake(X + 28, Y + 12);
    self.kaolaView1.center = self.kaolaView1Rect;
    self.kaolaView2.center = self.kaolaView2Rect;
    self.kaolaView3.center = self.kaolaView3Rect;
}

- (void)kaolaAnimation1 {
    [UIView animateWithDuration:0.4 animations:^{
        self.kaolaView1.center = CGPointMake(self.kaolaView1Rect.x, self.kaolaView2Rect.y);
        self.kaolaView2.center = CGPointMake(self.kaolaView2Rect.x, self.kaolaView1Rect.y);
    } completion:^(BOOL finished) {
        if (finished && self.state == LNRefreshState_Refreshing) {
            [self kaolaAnimation2];
        }
    }];
}

- (void)kaolaAnimation2 {
    [UIView animateWithDuration:0.4 animations:^{
        self.kaolaView2.center = CGPointMake(self.kaolaView2Rect.x, self.kaolaView2Rect.y);
        self.kaolaView3.center = CGPointMake(self.kaolaView3Rect.x, self.kaolaView1Rect.y);
    } completion:^(BOOL finished) {
        if (finished && self.state == LNRefreshState_Refreshing) {
            [self kaolaAnimation3];
        }
    }];
}

- (void)kaolaAnimation3 {
    [UIView animateWithDuration:0.4 animations:^{
        self.kaolaView1.center = CGPointMake(self.kaolaView1Rect.x, self.kaolaView1Rect.y);
        self.kaolaView3.center = CGPointMake(self.kaolaView3Rect.x, self.kaolaView3Rect.y);
    } completion:^(BOOL finished) {
        if (finished && self.state == LNRefreshState_Refreshing) {
            [self kaolaAnimation1];
        }
    }];
}

@end
