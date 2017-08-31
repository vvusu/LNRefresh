//
//  LNHeaderMeituanAnimator.m
//  LNRefresh
//
//  Created by vvusu on 8/28/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderMeituanAnimator.h"

@interface LNHeaderMeituanAnimator()
@property (nonatomic, assign) CGRect GifViewRect;
@property (nonatomic, strong) UIImageView *meituanGifView;
@end

@implementation LNHeaderMeituanAnimator

+ (instancetype)createAnimator {
    LNHeaderMeituanAnimator *diyAnimator = [[LNHeaderMeituanAnimator alloc]init];
    diyAnimator.headerType = LNRefreshHeaderType_DIY;
    diyAnimator.trigger = 75;
    diyAnimator.incremental = 75;
    return diyAnimator;
}

- (UIImageView *)meituanGifView {
    if (!_meituanGifView) {
        _meituanGifView = [[UIImageView alloc]init];
    }
    return _meituanGifView;
}

- (void)setupHeaderView_DIY {
    [self.animatorView addSubview:self.meituanGifView];
    self.meituanGifView.image = [UIImage imageNamed:@"icon_kangaroo_home_pull_down_loading_1"];
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 15; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_kangaroo_home_pull_down_loading_%zd", i]];
        [idleImages addObject:image];
    }
    self.meituanGifView.animationImages = idleImages;
    self.meituanGifView.animationDuration = 0.5;
}

- (void)layoutHeaderView_DIY {
    if (self.state == LNRefreshState_Normal) {
        CGRect react = self.animatorView.frame;
        self.GifViewRect = CGRectMake(react.size.width/2.0, react.size.height - 5, 0, 0);
        self.meituanGifView.frame = self.GifViewRect;
    }
}

- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
            break;
        case LNRefreshState_PullToRefresh:
            break;
        case LNRefreshState_WillRefresh:
        case LNRefreshState_Refreshing:
            [self startRefreshAnimation_DIY:view];
            break;
        default:
            break;
    }
}

- (void)startRefreshAnimation_DIY:(LNRefreshComponent *)view {
    [self refreshView_DIY:nil progress:1];
    [self.meituanGifView startAnimating];
}

- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {
    if (progress > 1.0) { return; }
    self.meituanGifView.frame = CGRectMake(self.GifViewRect.origin.x - 84*progress,
                                           self.GifViewRect.origin.y - 64.0*progress,
                                           self.GifViewRect.size.width + 168*progress,
                                           self.GifViewRect.size.height + 64.0*progress);
}

@end
