//
//  NSObject+PRKVCCrash.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import "NSObject+PRKVCCrash.h"
#import "PRCrashReport.h"

@implementation NSObject (PRKVCCrash)

/*
 setValue:forKeyPath:方法 和 setValuesForKeysWithDictionary:方法最后都会执行setValue:forKey:方法
 */
- (void)pr_setValue:(id)value forKey:(NSString *)key {
    if (key) {
        [self pr_setValue:value forKey:key];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(setValue:forKey:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}
// 对未定义的属性赋值都会执行setValue:forUndefinedKey:
- (void)pr_setValue:(id)value forUndefinedKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: this class does not find this key (%@)", self.class, NSStringFromSelector(@selector(setValue:forUndefinedKey:)), key];
    [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
}
// 对未定义的属性取值都会执行valueForUndefinedKey:
- (id)pr_valueForUndefinedKey:(NSString *)key {
    NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: this class does not find this key (%@)", self.class, NSStringFromSelector(@selector(valueForUndefinedKey:)), key];
    [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    return nil;
}


@end
