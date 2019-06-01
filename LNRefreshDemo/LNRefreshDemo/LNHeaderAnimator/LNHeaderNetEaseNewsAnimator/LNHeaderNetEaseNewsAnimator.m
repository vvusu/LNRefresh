//
//  LNHeaderNetEaseNewsAnimator.m
//  LNRefresh
//
//  Created by vvusu on 8/28/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderNetEaseNewsAnimator.h"

@interface LNHeaderNetEaseNewsAnimator()
@property (nonatomic, strong) NSMutableArray *gifViewImages;
@end

@implementation LNHeaderNetEaseNewsAnimator

+ (instancetype)createAnimator {
    LNHeaderNetEaseNewsAnimator *diyAnimator = [[LNHeaderNetEaseNewsAnimator alloc]init];
    diyAnimator.headerType = LNRefreshHeaderType_DIY;
    diyAnimator.trigger = 60;
    diyAnimator.incremental = 60;
    return diyAnimator;
}

- (void)setupHeaderView_DIY {
    self.titleLabel.text = @"下拉推荐";
    self.titleLabel.textColor = [UIColor grayColor];
    self.gifViewImages = [NSMutableArray array];
    for (NSUInteger i = 0; i <= 19; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_pull_%zd", i]];
        [self.gifViewImages addObject:image];
    }
    [self.animatorView addSubview:self.gifView];
    [self.animatorView addSubview:self.titleLabel];
}

- (void)layoutHeaderView_DIY {
    CGRect react = self.animatorView.frame;
    self.gifView.frame = CGRectMake(0, 0, 35, 35);
    self.gifView.center = CGPointMake((react.size.width - 80)/2, react.size.height/2.0);
    self.titleLabel.frame = CGRectMake((react.size.width - 100)/2 + 35, react.size.height/2.0 - 15, 100, 30);
}

- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
        case LNRefreshState_PullToRefresh:
            [self endRefreshAnimation_DIY:view];
            break;
        case LNRefreshState_WillRefresh: {
            self.titleLabel.text = @"松开推荐";
            NSMutableArray *idleImages = [NSMutableArray array];
            for (NSUInteger i = 0; i <= 11; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_release_%zd", i]];
                [idleImages addObject:image];
            }
            self.gifView.animationImages = idleImages;
            self.gifView.animationDuration = 1.0;
            [self.gifView startAnimating];
        }
            break;
        case LNRefreshState_Refreshing:
            [self startRefreshAnimation_DIY:view];
            break;
        default:
            break;
    }
}

- (void)endRefreshAnimation_DIY:(LNRefreshComponent *)view {
    self.titleLabel.text = @"下拉推荐";
    self.gifView.image = [UIImage imageNamed:@"refresh_pull_0"];
}

- (void)startRefreshAnimation_DIY:(LNRefreshComponent *)view {
    self.titleLabel.text = @"推荐中...";
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i <= 23; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_loop_%zd", i]];
        [idleImages addObject:image];
    }
    self.gifView.animationImages = idleImages;
    self.gifView.animationDuration = 1.0;
    [self.gifView startAnimating];
}

- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {
    if (progress > 1.0) { return; }
    [self.gifView stopAnimating];
    NSUInteger index = 20 * progress;
    if (index >= self.gifViewImages.count) index = self.gifViewImages.count - 1;
    self.gifView.image = self.gifViewImages[index];
}

@end
