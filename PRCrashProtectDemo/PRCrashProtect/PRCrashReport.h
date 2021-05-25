//
//  PRCrashReport.h
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRCrashReport : NSObject

+ (instancetype)shareCrashReport;
// 崩溃日志上报
- (void)reportCrashMessage:(NSString *)crashMessage;
// 收到崩溃日志时的回调
- (void)receivedReport:(void(^)(NSString *crashMessage))handle;

@property (nonatomic, strong, readonly) NSMutableDictionary *userInfo;

@end

@interface PRCrashReport (PRFileManager)
// 获取本地的崩溃日志
+ (NSArray <NSString *>*)crashMessagesHistory;
// 清除本地的崩溃日志
+ (void)clean;

@end

@interface NSObject (PRCrashStack)

// 获取当前的堆栈信息
+ (NSArray <NSString *>*)pr_callStackSymbols;

@end

NS_ASSUME_NONNULL_END
