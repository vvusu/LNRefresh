//
//  LNRefreshHandler.h
//  LNRefresh
//
//  Created by vvusu on 7/21/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNHeaderAnimator.h"

@interface LNRefreshHandler : NSObject
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, assign) CGFloat incremental;
@property (nonatomic, assign) NSTimeInterval refreshTime;
@property (nonatomic, strong) NSDictionary *localizedStringDic;
@property (nonatomic, strong) NSMutableDictionary *stateImages;
@property (nonatomic, assign) LNRefreshHeaderType headerType;

+ (LNRefreshHandler *)defaultHandler;

// Bundle中的Image
+ (UIImage *)bundleImage:(NSString *)imageName;

// Bundle中的多语言
+ (NSString *)localizedStringForKey:(NSString *)key;

// 改变全局头部样式
+ (void)changeAllHeaderAnimatorType:(LNRefreshHeaderType)type;

// 改变全局头部样式 + 背景图
+ (void)changeAllHeaderAnimatorType:(LNRefreshHeaderType)type
                            bgImage:(UIImage *)image;

+ (void)changeAllHeaderAnimatorType:(LNRefreshHeaderType)type
                            bgImage:(UIImage *)image
                        incremental:(CGFloat)incremental;

+ (void)setAllHeaderAnimatorStateImages:(NSArray *)stateImages
                                  state:(LNRefreshState)state;

+ (void)setAllHeaderAnimatorStateImages:(NSArray *)stateImages
                                  state:(LNRefreshState)state
                               duration:(NSTimeInterval)duration;

@end
