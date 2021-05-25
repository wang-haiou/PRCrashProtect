//
//  PRCrashProtect.h
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

/*
 crash防护（PRCrashProtect）
 简介：防止常见的bug导致crash，并收集crash原因和堆栈信息；收集导致crash的错误信息和堆栈信息。
 使用规则：
 1、在 -application:didFinishLaunchingWithOptions: 方法中使用PRCrashProtect.h的注册方法；
 2、在 PRCrashReport.h文件中提供了crash信息上报接口，还可以根据userInfo附件额外信息；
 3、如果需要将crash信息上传服务器，可以通过-receivedReport:方法或者+crashMessagesHistory方法去获取。
 备注：建议仅在release模式下开启，debug模式下使用该框架容易让开发人员忽略问题。
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PRCrashProtectOption) {
    PRCrashProtectOptionUnrecognizedSelector = 1 << 1,
    PRCrashProtectOptionKVC = 1 << 2,
    PRCrashProtectOptionKVO = 1 << 3,
    
    PRCrashProtectOptionNotification = 1 << 4, // Notification itself does not cause a Crash.
    
    PRCrashProtectOptionArray = 1 << 10,
    PRCrashProtectOptionDictionary = 1 << 11,
    PRCrashProtectOptionString = 1 << 12,
    PRCrashProtectOptionContainer = 1 << 13, // If it is called, the array, dictionary, and string options are also called.
    
    PRCrashProtectOptionCatchCrash = 1 << 14, // Collecting unhandled exceptions, which cause crashes.
    
    PRCrashProtectOptionAll = 1 << 15, // If it is called, all the options are called.
}; // Crash防护的相关选项

@interface PRCrashProtect : NSObject

+ (instancetype)shareCrashProtect;

- (void)registerCrashProtect:(PRCrashProtectOption)option;

@end

NS_ASSUME_NONNULL_END
