//
//  WMUIVersionUpdateCheck.h
//  WMUIVersionUpdate
//
//  Created by 吳梓杭 on 2019/8/15.
//  Copyright © 2019 吳梓杭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMUIVersionUpdateCheck : NSObject

/**
 检查是否有新版本
 */
+ (void)checkResult;

/**
 检查是否有新版本
 
 @param isforce 是否强制更新
 */
+ (void)checkResultExecuteWithForceUpdate:(BOOL)isforce;

@end

NS_ASSUME_NONNULL_END
