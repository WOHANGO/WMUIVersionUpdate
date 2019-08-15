//
//  WMUIVersionUpdateCheckAppStore.m
//  WMUIVersionUpdate
//
//  Created by 吳梓杭 on 2019/8/15.
//  Copyright © 2019 吳梓杭. All rights reserved.
//

#import "WMUIVersionUpdateCheckAppStore.h"
#import <SystemConfiguration/SystemConfiguration.h>


@implementation WMUIVersionUpdateCheckAppStore

+ (WMUIVersionUpdateCheckAppStore *)sharedInstance {
    static dispatch_once_t once;
    static WMUIVersionUpdateCheckAppStore *instance = nil;
    if ([NSThread isMainThread]) {
        dispatch_once(&once, ^{
            instance = [[WMUIVersionUpdateCheckAppStore alloc] init];
        });
    }else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            dispatch_once(&once, ^{
                instance = [[WMUIVersionUpdateCheckAppStore alloc] init];
            });
        });
    }
    return instance;
}

- (void)setCheckBlock:(versionCheckBlock)checkBlock {
    _checkBlock = checkBlock;
    if (self.checkBlock) {
        BOOL hasConnection = [self hasConnection];
        if (!hasConnection) {
            self.checkBlock(NO, nil, nil, nil, [NSError errorWithDomain:@"VersionUpdate" code:10000 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"无法连接到 AppStore。", @"message", nil]]);
            return;
        }
        NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/%@/lookup?bundleId=%@", [[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] lowercaseString], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                self.checkBlock(NO, nil, nil, nil, [NSError errorWithDomain:@"VersionUpdate" code:10000 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error.localizedDescription, @"message", nil]]);
                return;
            }
            if (![data isKindOfClass:[NSData class]]) {
                self.checkBlock(NO, nil, nil, nil, [NSError errorWithDomain:@"VersionUpdate" code:10000 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"无法解析 AppStore 返回的数据。", @"message", nil]]);
                return;
            }
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (![NSJSONSerialization isValidJSONObject:jsonObject] || [error isKindOfClass:[NSError class]]) {
                self.checkBlock(NO, nil, nil, nil, [NSError errorWithDomain:@"VersionUpdate" code:10000 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"无法解析 AppStore 返回的数据。", @"message", nil]]);
                return;
            }
            NSArray *results = [jsonObject objectForKey:@"results"];
            if (results.count < 1) {
                self.checkBlock(NO, nil, nil, nil, [NSError errorWithDomain:@"VersionUpdate" code:10000 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"未能获取到 AppStore 上该应用的信息。", @"message", nil]]);
                return;
            }
            NSDictionary* result0 = [results objectAtIndex:0];
            NSString *storeVersion = [result0 objectForKey:@"version"];
            NSString *whatsNew = [result0 objectForKey:@"releaseNotes"];
            NSString *appUrl = [result0[@"trackViewUrl"] stringByReplacingOccurrencesOfString:@"&uo=4" withString:@""];
            NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSLog(@"%@---------%@",storeVersion,bundleVersion);
            if (storeVersion && [bundleVersion compare:storeVersion options:NSNumericSearch] == NSOrderedAscending) {
                self.checkBlock(YES, storeVersion, whatsNew, appUrl, nil);
            }else {
                self.checkBlock(NO, storeVersion, whatsNew, appUrl, nil);
            }
        }];
        [task resume];
    }
}

#pragma mark - 私有方法
- (BOOL)hasConnection {
    const char *host = "itunes.apple.com";
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);
    BOOL reachable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
    return reachable;
}


@end
