//
//  LNRefreshComponent.h
//  LNRefresh
//
//  Created by vvusu on 7/11/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LNRefreshComponentBlock)(void);

@class LNRefreshAnimator;
@interface LNRefreshComponent : UIView
@property (nonatomic, weak) UIScrollView *scrollView;                           //ScrollView
@property (nonatomic, assign) UIEdgeInsets scrollViewInsets;                    //原始scrollviewInsets
@property (nonatomic, strong) LNRefreshAnimator *animator;                      //具体动画展现
@property (nonatomic, copy) LNRefreshComponentBlock refreshBlock;               //刷新Block
@property (nonatomic, assign, getter=isObserving) BOOL observing;               //是否正在监听
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;             //是否正在刷新
@property (nonatomic, assign, getter=isIgnoreObserving) BOOL ignoreObserving;   //是否屏蔽监听

- (void)stop;
- (void)start;
- (void)startRefreshing;
- (void)stopRefreshing;
- (void)contentSizeChangeAction:(NSDictionary *)change;
- (void)contentOffsetChangeAction:(NSDictionary *)change;
@end
