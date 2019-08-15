//
//  WMUIVersionUpdateCheckAppStore.h
//  WMUIVersionUpdate
//
//  Created by 吳梓杭 on 2019/8/15.
//  Copyright © 2019 吳梓杭. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 版本检测结果回调
 
 @param hasNewVersion 是否有新版本
 @param version 当前应用在商店中的版本号
 @param releaseNotes 版本更新日志
 @param appUrl App在应用商店的地址
 @param error 检测过程发生的错误
 */
typedef void(^versionCheckBlock)(BOOL hasNewVersion, NSString * __nullable version, NSString * __nullable releaseNotes, NSString * __nullable appUrl, NSError * __nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface WMUIVersionUpdateCheckAppStore : NSObject

/**
 单利模式
 */
+ (WMUIVersionUpdateCheckAppStore *)sharedInstance;

/**
 版本检测回调
 */
@property (nonatomic, copy) versionCheckBlock checkBlock;



@end

NS_ASSUME_NONNULL_END
