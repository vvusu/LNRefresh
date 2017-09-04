//
//  LNHeaderDIYAnimator.m
//  LNRefresh
//
//  Created by vvusu on 7/20/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderDIYAnimator.h"
#import "YLoadingPanel.h"

@interface LNHeaderDIYAnimator()
@property (strong, nonatomic) YLoadingPanel *loadingPanel;
@end

@implementation LNHeaderDIYAnimator

+ (instancetype)createAnimator {
    LNHeaderDIYAnimator *diyAnimator = [[LNHeaderDIYAnimator alloc]init];
    diyAnimator.headerType = LNRefreshHeaderType_DIY;
    return diyAnimator;
}

-(YLoadingPanel *)loadingPanel {
    if (!_loadingPanel) {
        _loadingPanel = [[YLoadingPanel alloc]init];
        _loadingPanel.backgroundColor = [UIColor clearColor];
        _loadingPanel.frame = CGRectMake(0, 0, 40, 10);
        _loadingPanel.center = CGPointMake(self.animatorView.center.x, 0);
    }
    return _loadingPanel;
}

- (void)setupHeaderView_DIY {
    [self.animatorView addSubview:self.loadingPanel];
}

- (void)layoutHeaderView_DIY {
    CGRect panelFrame = self.loadingPanel.frame;
    panelFrame.origin.y =  CGRectGetHeight(self.animatorView.bounds)/2.0f - CGRectGetHeight(self.loadingPanel.bounds) + 10;
    self.loadingPanel.frame = panelFrame;
}

- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
            [self.loadingPanel stopPageLoadingAnimation];
            break;
        case LNRefreshState_Refreshing:
            [self.loadingPanel doPageLoadingAnimation];
        default:
            break;
    }
}

- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {
    self.loadingPanel.pullingPercent = progress;
}

@end
