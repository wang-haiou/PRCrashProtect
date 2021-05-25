//
//  NSDictionary+PRCrashProtect.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import "NSDictionary+PRCrashProtect.h"
#import "PRCrashReport.h"

@implementation NSDictionary (PRCrashProtect)

/**
 使用“@{}”创建字典时，系统会执行-[__NSPlaceholderDictionary initWithObjects:forKeys:count:]
 */
- (instancetype)pr_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: attempt to insert nil object from objects[%d]", self.class, NSStringFromSelector(@selector(initWithObjects:forKeys:count:)), i];
            [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
            continue;
        }
        newObjects[index] = tmpItem;
        newkeys[index] = tmpKey;
        index++;
    }
    
    return [self pr_initWithObjects:newObjects forKeys:newkeys count:index];
}

@end
