//
//  LNHeaderTmallAnimator.m
//  LNRefresh
//
//  Created by vvusu on 8/25/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderTmallAnimator.h"
#import "UIImage+animatedGIF.h"

@interface LNHeaderTmallAnimator()
@property (nonatomic, strong) UIImageView *tmallGifView;
@end

@implementation LNHeaderTmallAnimator

+ (instancetype)createAnimator {
    LNHeaderTmallAnimator *diyAnimator = [[LNHeaderTmallAnimator alloc]init];
    diyAnimator.headerType = LNRefreshHeaderType_DIY;
    diyAnimator.trigger = 85;
    diyAnimator.incremental = 85;
    return diyAnimator;
}

- (UIImageView *)tmallGifView {
    if (!_tmallGifView) {
        _tmallGifView = [[UIImageView alloc]init];
    }
    return _tmallGifView;
}

- (void)setupHeaderView_DIY {
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"下拉刷新";
    [self.animatorView addSubview:self.titleLabel];
    [self.animatorView addSubview:self.tmallGifView];
}

- (void)layoutHeaderView_DIY {
    CGRect react = self.animatorView.frame;
    self.titleLabel.frame = CGRectMake(0, react.size.height - 25, react.size.width, 20);
    self.tmallGifView.frame = CGRectMake(0, react.size.height - 85, react.size.width, 80);
}

- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
            [self endRefreshAnimation_DIY:view];
            break;
        case LNRefreshState_PullToRefresh:
            self.titleLabel.text = @"下拉刷新";
            break;
        case LNRefreshState_WillRefresh:
            self.titleLabel.text = @"松开立即刷新";
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
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"frontpage_refresh@2x" withExtension:@"gif"];
    self.tmallGifView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
}

- (void)startRefreshAnimation_DIY:(LNRefreshComponent *)view {
    self.titleLabel.text = @"正在刷新";
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"frontpage_refresh_release@2x" withExtension:@"gif"];
    self.tmallGifView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
}

@end
