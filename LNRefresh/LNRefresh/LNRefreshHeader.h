//
//  LNRefreshHeader.h
//  LNRefresh
//
//  Created by vvusu on 7/12/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNRefreshComponent.h"

@class LNHeaderAnimator;
@interface LNRefreshHeader : LNRefreshComponent
@property (nonatomic, assign) BOOL scrollViewBounces;   //ScrollView是否弹回
@property (nonatomic, assign) CGFloat previousOffset;   //原始的偏移量
@property (nonatomic, assign) NSTimeInterval startData; //开始刷新时间

+ (instancetype)initWithFrame:(CGRect)frame;
+ (instancetype)initWithFrame:(CGRect)frame
                        block:(LNRefreshComponentBlock)block;
+ (instancetype)initWithFrame:(CGRect)frame
                     animator:(LNHeaderAnimator *)animator
                        block:(LNRefreshComponentBlock)block;

@end
