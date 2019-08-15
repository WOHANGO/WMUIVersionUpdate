

//
//  WMUIVersionUpdateCheck.m
//  WMUIVersionUpdate
//
//  Created by 吳梓杭 on 2019/8/15.
//  Copyright © 2019 吳梓杭. All rights reserved.
//

#import "WMUIVersionUpdateCheck.h"
#import "WMUIVersionUpdateCheckAppStore.h"

@implementation WMUIVersionUpdateCheck

/**
 检查是否有新版本
 */
+ (void)checkResult {
    [[WMUIVersionUpdateCheckAppStore sharedInstance] setCheckBlock:^(BOOL hasNewVersion, NSString * _Nullable version, NSString * _Nullable releaseNotes, NSString * _Nullable appUrl, NSError * _Nullable error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!hasNewVersion) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前版本已经是最新版本" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
            }else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本v%@", version] message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *temporaryAction = [UIAlertAction actionWithTitle:@"下次更新" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl] options:@{} completionHandler:nil];
                    } else {
                        // Fallback on earlier versions
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
                    }
                }];
                [alertController addAction:temporaryAction];
                [alertController addAction:updateAction];
                [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
            }
        });
    }];
}

/**
 检查是否有新版本

 @param isforce 是否强制更新
 */
+ (void)checkResultExecuteWithForceUpdate:(BOOL)isforce {
    [[WMUIVersionUpdateCheckAppStore sharedInstance] setCheckBlock:^(BOOL hasNewVersion, NSString * _Nullable version, NSString * _Nullable releaseNotes, NSString * _Nullable appUrl, NSError * _Nullable error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (hasNewVersion) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本v%@", version] message:releaseNotes preferredStyle:UIAlertControllerStyleAlert];
                if (isforce) {   //强制更新
                    UIAlertAction *forceAction = [UIAlertAction actionWithTitle:@"强制更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl] options:@{} completionHandler:nil];
                        } else {
                            // Fallback on earlier versions
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
                        }
                    }];
                    [alertController addAction:forceAction];
                    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
                }else {
                    NSString *neglectVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"neglectVersion"];
                    if (![neglectVersion isEqualToString:version]) {
                        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            if (@available(iOS 10.0, *)) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl] options:@{} completionHandler:nil];
                            } else {
                                // Fallback on earlier versions
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
                            }
                        }];
                        UIAlertAction *temporaryAction = [UIAlertAction actionWithTitle:@"下次更新" style:UIAlertActionStyleDefault handler:nil];
                        UIAlertAction *neglectAction = [UIAlertAction actionWithTitle:@"忽略该版本" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"neglectVersion"];
                        }];
                        [alertController addAction:updateAction];
                        [alertController addAction:temporaryAction];
                        [alertController addAction:neglectAction];
                        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
                    }
                }
            }
        });
    }];
}

@end
