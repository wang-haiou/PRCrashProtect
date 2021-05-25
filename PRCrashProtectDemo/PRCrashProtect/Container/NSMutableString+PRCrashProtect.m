//
//  NSMutableString+PRCrashProtect.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import "NSMutableString+PRCrashProtect.h"
#import "PRCrashReport.h"

@implementation NSMutableString (PRCrashProtect)

// NSPlaceholderMutableString的同名类方法也会执行该方法
- (instancetype)pr_initWithString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(initWithString:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return [self pr_initWithString:@""];
    } else return [self pr_initWithString:aString];
}

- (void)pr_appendString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(appendString:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else [self pr_appendString:aString];
}

- (NSString *)pr_stringByAppendingString:(NSString *)aString {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(stringByAppendingString:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        return self;
    } else return [self pr_stringByAppendingString:aString];
}

- (void)pr_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    if (!aString) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: nil argument", self.class, NSStringFromSelector(@selector(insertString:atIndex:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else if (loc > self.length) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range or index out of bounds", self.class, NSStringFromSelector(@selector(insertString:atIndex:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else
    [self pr_insertString:aString atIndex:loc];
}

- (void)pr_deleteCharactersInRange:(NSRange)range {
    if (range.location < self.length && range.location + range.length <= self.length) {
        [self pr_deleteCharactersInRange:range];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: Range or index out of bounds", self.class, NSStringFromSelector(@selector(deleteCharactersInRange:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        
        NSRange intersectionRange = NSIntersectionRange(range, NSMakeRange(0, self.length));
        [self pr_deleteCharactersInRange:intersectionRange];
    }
}

@end
