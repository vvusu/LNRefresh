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
        _loadingPanel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _loadingPanel;
}

- (void)setupHeaderView_DIY {
    [self.animatorView addSubview:self.loadingPanel];
}

- (void)layoutHeaderView_DIY {
    self.loadingPanel.frame = self.animatorView.bounds;
}

- (void)refreshHeaderView_DIY:(LNRefreshState)state {
    switch (state) {
        case LNRefreshState_Normal:
            break;
        default:
            break;
    }
}

- (void)endRefreshAnimation_DIY:(LNRefreshComponent *)view {
    NSLog(@"LN______end");
    [self.loadingPanel stopPageLoadingAnimation];
}

- (void)startRefreshAnimation_DIY:(LNRefreshComponent *)view {
    NSLog(@"LN______start");
    [self.loadingPanel doPageLoadingAnimation];
}

@end
