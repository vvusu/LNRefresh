//
//  LNRefreshFooter.h
//  LNRefresh
//
//  Created by vvusu on 7/12/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNRefreshComponent.h"

@class LNFooterAnimator;
@interface LNRefreshFooter : LNRefreshComponent
@property (nonatomic, assign, getter=isAutoBack) BOOL autoBack;
@property (nonatomic, assign, getter=isNoNoreData) BOOL noMoreData;

+ (instancetype)initWithFrame:(CGRect)frame;

+ (instancetype)initWithFrame:(CGRect)frame
                        block:(LNRefreshComponentBlock)block;

+ (instancetype)initWithFrame:(CGRect)frame
                     animator:(LNFooterAnimator *)animator
                        block:(LNRefreshComponentBlock)block;
@end
