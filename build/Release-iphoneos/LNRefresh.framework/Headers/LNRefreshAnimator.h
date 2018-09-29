//
//  LNRefreshAnimator.h
//  LNRefresh
//
//  Created by vvusu on 7/11/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNRefreshConst.h"

typedef NS_ENUM(NSInteger, LNRefreshState) {
    LNRefreshState_Normal = 0,
    LNRefreshState_PullToRefresh,
    LNRefreshState_WillRefresh,
    LNRefreshState_Refreshing,
    LNRefreshState_NoMoreData
};

@class LNRefreshComponent;
@interface LNRefreshAnimator : NSObject
@property (nonatomic, assign) CGFloat trigger;          //下拉触发高度
@property (nonatomic, weak) UIView *animatorView;       //执行动画View
@property (nonatomic, assign) CGFloat incremental;      //动画View的高度
@property (nonatomic, assign) UIEdgeInsets insets;      //Insets
@property (nonatomic, assign) LNRefreshState state;     //刷新状态
@property (nonatomic, assign) BOOL ignoreGlobSetting;   //是否屏蔽全局配置

- (void)setupSubViews;
- (void)layoutSubviews;
- (void)updateAnimationView;
- (void)refreshView:(LNRefreshComponent *)view progress:(CGFloat)progress;
- (void)refreshView:(LNRefreshComponent *)view state:(LNRefreshState)state;
@end
