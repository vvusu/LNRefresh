//
//  LNHeaderFeizhuAnimator.m
//  LNRefresh
//
//  Created by vvusu on 9/1/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderFeizhuAnimator.h"
#import "UIImage+animatedGIF.h"

@interface LNHeaderFeizhuAnimator()
@property (nonatomic, strong) UIImageView *feizhuGifView;
@property (nonatomic, strong) UIImageView *feizhuSloganView;
@end

@implementation LNHeaderFeizhuAnimator

+ (instancetype)createAnimator {
    LNHeaderFeizhuAnimator *diyAnimator = [[LNHeaderFeizhuAnimator alloc]init];
    diyAnimator.headerType = LNRefreshHeaderType_DIY;
    diyAnimator.trigger = 90;
    diyAnimator.incremental = 90;
    return diyAnimator;
}

- (UIImageView *)feizhuGifView {
    if (!_feizhuGifView) {
        _feizhuGifView = [[UIImageView alloc]init];
    }
    return _feizhuGifView;
}

- (UIImageView *)feizhuSloganView {
    if (!_feizhuSloganView) {
        _feizhuSloganView = [[UIImageView alloc]init];
        _feizhuSloganView.image = [UIImage imageNamed:@"bg_refresh_slogan_hotel"];
    }
    return _feizhuSloganView;
}

- (void)setupHeaderView_DIY {
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"下拉刷新";
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"feizhu_pull_refresh" withExtension:@"gif"];
    self.feizhuGifView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    [self.animatorView addSubview:self.titleLabel];
    [self.animatorView addSubview:self.feizhuGifView];
    [self.animatorView addSubview:self.feizhuSloganView];
}

- (void)layoutHeaderView_DIY {
    if (self.state == LNRefreshState_Normal) {
        CGRect react = self.animatorView.frame;
        self.feizhuGifView.frame = CGRectMake((react.size.width - 155)/2, react.size.height/2 - 45, 155, 62);
        self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.feizhuGifView.frame), react.size.width, 20);
        self.feizhuSloganView.frame = CGRectMake(self.feizhuGifView.frame.origin.x, self.feizhuGifView.frame.origin.y - 40, self.feizhuGifView.frame.size.width, 40);
    }
}

- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
        case LNRefreshState_PullToRefresh:
            [self endRefreshAnimation_DIY:view];
            break;
        case LNRefreshState_WillRefresh:
            self.titleLabel.text = @"松开刷新";
            break;
        case LNRefreshState_Refreshing:
            [self startRefreshAnimation_DIY:view];
            break;
        default:
            break;
    }
}

- (void)endRefreshAnimation_DIY:(LNRefreshComponent *)view {
    self.titleLabel.text = @"下拉刷新";
}

- (void)startRefreshAnimation_DIY:(LNRefreshComponent *)view {
    self.titleLabel.text = @"正在刷新...";
    [self refreshView_DIY:nil progress:1];
}

- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {
    if (progress > 1.0) { progress = 1.0; }
    self.titleLabel.alpha = progress;
    self.feizhuGifView.alpha = progress;
}

@end
