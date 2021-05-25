//
//  NSString+PRCrashProtect.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import "NSString+PRCrashProtect.h"
#import "PRCrashReport.h"

@implementation NSString (PRCrashProtect)

// NSPlaceholderString的同名类方法也会执行该方法
- (instancetype)pr_initWithString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithString:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self pr_initWithString:@""];
    } else return [self pr_initWithString:aString];
}

- (NSString *)pr_stringByAppendingString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(stringByAppendingString:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return self;
    } else return [self pr_stringByAppendingString:aString];
}

- (unichar)pr_characterAtIndex:(NSUInteger)index {
    if (index < self.length) {
        return [self pr_characterAtIndex:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range or index out of bounds", self.class, NSStringFromSelector(@selector(characterAtIndex:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return 0;
    }
}

- (NSString *)pr_substringFromIndex:(NSUInteger)from {
    if (from <= self.length) {
        return [self pr_substringFromIndex:from];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Index %lu out of bounds; string length %lu", self.class, NSStringFromSelector(@selector(substringFromIndex:)), from, self.length];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return @"";
    }
}

- (NSString *)pr_substringToIndex:(NSUInteger)to {
    if (to <= self.length) {
        return [self pr_substringToIndex:to];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Index %lu out of bounds; string length %lu", self.class, NSStringFromSelector(@selector(substringToIndex:)), to, self.length];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return self;
    }
}

- (NSString *)pr_substringWithRange:(NSRange)range {
    if (range.location < self.length && range.location + range.length <= self.length) {
        return [self pr_substringWithRange:range];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range {%lu, %lu} out of bounds; string length %lu", self.class, NSStringFromSelector(@selector(substringWithRange:)), range.location, range.length, self.length];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        
        NSRange intersectionRange = NSIntersectionRange(range, NSMakeRange(0, self.length));
        return [self pr_substringWithRange:intersectionRange];
    }
}

@end
