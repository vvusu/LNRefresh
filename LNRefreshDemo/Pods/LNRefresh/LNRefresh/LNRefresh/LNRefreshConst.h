//
//  LNRefreshConst.h
//  LNRefresh
//
//  Created by vvusu on 8/3/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import <UIKit/UIKit.h>

//Frame
UIKIT_EXTERN const CGFloat LNRefreshTrigger;
UIKIT_EXTERN const CGFloat LNRefreshIncremental;
//Refresh Time
UIKIT_EXTERN const CGFloat LNRefreshNORRefreshTime;
UIKIT_EXTERN const CGFloat LNRefreshDIYRefreshTime;
//String
UIKIT_EXTERN NSString *const LNRefreshLoading;
UIKIT_EXTERN NSString *const LNRefreshPullToRefresh;
UIKIT_EXTERN NSString *const LNRefreshReleaseToRefresh;
UIKIT_EXTERN NSString *const LNRefreshLoadingMore;
UIKIT_EXTERN NSString *const LNRefreshNoMoreData;
//Notification
UIKIT_EXTERN NSString *const LNRefreshChangeNotification;

//RGB颜色
#define LNRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//文字颜色
#define LNRefreshLabelTextColor LNRefreshColor(128, 128, 128)
//字体大小
#define LNRefreshLabelFont [UIFont systemFontOfSize:14]
