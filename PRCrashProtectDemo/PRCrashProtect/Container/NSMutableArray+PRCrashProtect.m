//
//  NSMutableArray+PRCrashProtect.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import "NSMutableArray+PRCrashProtect.h"
#import "PRCrashReport.h"

@implementation NSMutableArray (PRCrashProtect)

/*
 NSMutableArray的实际执行者是__NSArrayM类
 addObject:也会执行insertObject:atIndex:方法；
 */
- (void)pr_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject) {
        if (NSLocationInRange(index, NSMakeRange(0, self.count + 1))) {
            [self pr_insertObject:anObject atIndex:index];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds", self.class, NSStringFromSelector(@selector(insertObject:atIndex:)), index];
            if (self.count == 0) {
                crashMessages = [crashMessages stringByAppendingString:@" for empty array"];
            } else {
                crashMessages = [crashMessages stringByAppendingFormat:@" [0 .. %lu]", self.count];
            }
            [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: object cannot be nil", self.class, NSStringFromSelector(@selector(insertObject:atIndex:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}
/*
 iOS10后removeObjectAtIndex:也会执行removeObjectsInRange:
 */
- (void)pr_removeObjectsInRange:(NSRange)range {
    if (self.count == 0) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: rannge {%lu, %lu} extends beyond bounds for empty array", self.class, NSStringFromSelector(@selector(removeObjectsInRange:)), range.location, range.length];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else {
        NSRange bounds = NSMakeRange(0, self.count);
        if (NSLocationInRange(range.location, bounds) && NSLocationInRange(range.location + range.length - 1, bounds)) {
            [self pr_removeObjectsInRange:range];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: rannge {%lu, %lu} extends beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(removeObjectsInRange:)), range.location, range.length, self.count - 1];
            [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    }
}

- (void)pr_removeObjectAtIndex:(NSUInteger)index {
    if (self.count == 0) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu extends beyond bounds for empty array", self.class, NSStringFromSelector(@selector(removeObjectAtIndex:)), index];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else {
        if (index < self.count) {
            [self pr_removeObjectAtIndex:index];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu extends beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(removeObjectAtIndex:)), index, self.count - 1];
            [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    }
}

- (void)pr_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (anObject) {
        if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
            [self pr_replaceObjectAtIndex:index withObject:anObject];
        } else {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds", self.class, NSStringFromSelector(@selector(replaceObjectAtIndex:withObject:)), index];
            if (self.count == 0) {
                crashMessages = [crashMessages stringByAppendingString:@" for empty array"];
            } else {
                crashMessages = [crashMessages stringByAppendingFormat:@" [0 .. %lu]", self.count];
            }
            [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        }
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: object cannot be nil", self.class, NSStringFromSelector(@selector(replaceObjectAtIndex:withObject:))];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
}

- (void)pr_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    if (self.count == 0) {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds for empty array", self.class, NSStringFromSelector(@selector(exchangeObjectAtIndex:withObjectAtIndex:)), idx1];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    } else {
        if (!NSLocationInRange(idx1, NSMakeRange(0, self.count))) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(exchangeObjectAtIndex:withObjectAtIndex:)), idx1, self.count - 1];
            [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        } else if (!NSLocationInRange(idx2, NSMakeRange(0, self.count))) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(exchangeObjectAtIndex:withObjectAtIndex:)), idx2, self.count - 1];
            [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        } else {
            [self pr_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
        }
    }
}

- (id)pr_objectAtIndex:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.count))) {
        return [self pr_objectAtIndex:index];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndex:)), index, self.count - 1];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}

- (id)pr_objectAtIndexedSubscript:(NSUInteger)idx {
    if (NSLocationInRange(idx, NSMakeRange(0, self.count))) {
        return [self pr_objectAtIndexedSubscript:idx];
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: index %lu beyond bounds [0 .. %lu]", self.class, NSStringFromSelector(@selector(objectAtIndexedSubscript:)), idx, self.count - 1];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
    }
    return nil;
}

@end
