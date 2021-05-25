//
//  NSMutableDictionary+PRCrashProtect.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import "NSMutableDictionary+PRCrashProtect.h"
#import "PRCrashReport.h"

@implementation NSMutableDictionary (PRCrashProtect)

/*
 NSMutableDictionary实际对应的是__NSDictionaryM类
 setValue:forKey:也会执行setObject:forKey:
 */
- (void)pr_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(setObject:forKey:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return;
    }
    if (!anObject) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: object cannot be nil (key: %@)", self.class, NSStringFromSelector(@selector(setObject:forKey:)), aKey];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return;
    }
    [self pr_setObject:anObject forKey:aKey];
}

- (void)pr_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    // obj可以为nil
    if (!key) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(setObject:forKeyedSubscript:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return;
    }
    [self pr_setObject:obj forKeyedSubscript:key];
}

- (void)pr_removeObjectForKey:(id)aKey {
    if (aKey) {
        [self pr_removeObjectForKey:aKey];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: key cannot be nil", self.class, NSStringFromSelector(@selector(removeObjectForKey:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}


@end
