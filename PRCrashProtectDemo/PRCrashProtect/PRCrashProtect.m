//
//  PRCrashProtect.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import "PRCrashProtect.h"
#import <objc/runtime.h>
#import "PRCrashSwizzling.h"
#import "PRCatchCrash.h"

@implementation PRCrashProtect

+ (instancetype)shareCrashProtect {
    static PRCrashProtect *crashProtect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crashProtect = [[PRCrashProtect alloc] init];
    });
    return crashProtect;
}

- (void)registerCrashProtect:(PRCrashProtectOption)option {
    if (option & PRCrashProtectOptionAll || option & PRCrashProtectOptionUnrecognizedSelector) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [PRCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(forwardingTargetForSelector:)
                                   swizzleSEL:NSSelectorFromString(@"pr_forwardingTargetForSelector:")];
        });
    }
    if (option & PRCrashProtectOptionAll || option & PRCrashProtectOptionKVC) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [PRCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(setValue:forKey:)
                                   swizzleSEL:NSSelectorFromString(@"pr_setValue:forKey:")];
            [PRCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(setValue:forUndefinedKey:)
                                   swizzleSEL:NSSelectorFromString(@"pr_setValue:forUndefinedKey:")];
            [PRCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(valueForUndefinedKey:)
                                   swizzleSEL:NSSelectorFromString(@"pr_valueForUndefinedKey:")];
        });
    }
    if (option & PRCrashProtectOptionAll || option & PRCrashProtectOptionKVO) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [PRCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(addObserver:forKeyPath:options:context:)
                                   swizzleSEL:NSSelectorFromString(@"pr_addObserver:forKeyPath:options:context:")];
            [PRCrashSwizzling swizzlingMethod:NSObject.class
                                  originalSEL:@selector(removeObserver:forKeyPath:)
                                   swizzleSEL:NSSelectorFromString(@"pr_removeObserver:forKeyPath:")];
        });
    }
    if (option & PRCrashProtectOptionAll || option & PRCrashProtectOptionNotification) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [PRCrashSwizzling swizzlingMethod:NSNotificationCenter.class
                                  originalSEL:@selector(addObserver:selector:name:object:)
                                   swizzleSEL:NSSelectorFromString(@"pr_addObserver:selector:name:object:")];
        });
    }
    if (option & PRCrashProtectOptionAll || option & PRCrashProtectOptionContainer || option & PRCrashProtectOptionArray) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSPlaceholderArray")
                                  originalSEL:@selector(initWithObjects:count:)
                                   swizzleSEL:NSSelectorFromString(@"pr_initWithObjects:count:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSSingleObjectArrayI")
                                  originalSEL:@selector(objectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"pr_objectWithSingleObjectArrayIAtIndex:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayI")
                                  originalSEL:@selector(objectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"pr_objectWithArrayIAtIndex:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArray0")
                                  originalSEL:@selector(objectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"pr_objectWithArray0AtIndex:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSSingleObjectArrayI")
                                  originalSEL:@selector(objectAtIndexedSubscript:)
                                   swizzleSEL:NSSelectorFromString(@"pr_objectWithSingleObjectArrayIAtIndexedSubscript:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayI")
                                  originalSEL:@selector(objectAtIndexedSubscript:)
                                   swizzleSEL:NSSelectorFromString(@"pr_objectWithArrayIAtIndexedSubscript:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(insertObject:atIndex:)
                                   swizzleSEL:NSSelectorFromString(@"pr_insertObject:atIndex:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(removeObjectsInRange:)
                                   swizzleSEL:NSSelectorFromString(@"pr_removeObjectsInRange:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(removeObjectAtIndex:)                                   swizzleSEL:NSSelectorFromString(@"pr_removeObjectAtIndex:")];

            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(replaceObjectAtIndex:withObject:)
                                   swizzleSEL:NSSelectorFromString(@"pr_replaceObjectAtIndex:withObject:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSArrayM")
                                  originalSEL:@selector(exchangeObjectAtIndex:withObjectAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"pr_exchangeObjectAtIndex:withObjectAtIndex:")];
        });
    }
    if (option & PRCrashProtectOptionAll || option & PRCrashProtectOptionContainer || option & PRCrashProtectOptionDictionary) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSDictionaryM")
                                  originalSEL:@selector(setObject:forKey:)
                                   swizzleSEL:NSSelectorFromString(@"pr_setObject:forKey:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSDictionaryM")
                                  originalSEL:@selector(setObject:forKeyedSubscript:)
                                   swizzleSEL:NSSelectorFromString(@"pr_setObject:forKeyedSubscript:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSDictionaryM")
                                  originalSEL:@selector(removeObjectForKey:)
                                   swizzleSEL:NSSelectorFromString(@"pr_removeObjectForKey:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSPlaceholderDictionary")
                                  originalSEL:@selector(initWithObjects:forKeys:count:)
                                   swizzleSEL:NSSelectorFromString(@"pr_initWithObjects:forKeys:count:")];
        });
    }
    if (option & PRCrashProtectOptionAll || option & PRCrashProtectOptionContainer || option & PRCrashProtectOptionString) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"NSPlaceholderString")
                                  originalSEL:@selector(initWithString:)
                                   swizzleSEL:NSSelectorFromString(@"pr_initWithString:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(stringByAppendingString:)
                                   swizzleSEL:NSSelectorFromString(@"pr_stringByAppendingString:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(characterAtIndex:)
                                   swizzleSEL:NSSelectorFromString(@"pr_characterAtIndex:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(substringToIndex:)
                                   swizzleSEL:NSSelectorFromString(@"pr_substringToIndex:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(substringFromIndex:)
                                   swizzleSEL:NSSelectorFromString(@"pr_substringFromIndex:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFConstantString")
                                  originalSEL:@selector(substringWithRange:)
                                   swizzleSEL:NSSelectorFromString(@"pr_substringWithRange:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"NSPlaceholderMutableString")
                                  originalSEL:@selector(initWithString:)
                                   swizzleSEL:NSSelectorFromString(@"pr_initWithString:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(appendString:)
                                   swizzleSEL:NSSelectorFromString(@"pr_appendString:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(stringByAppendingString:)
                                   swizzleSEL:NSSelectorFromString(@"pr_stringByAppendingString:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(insertString:atIndex:)
                                   swizzleSEL:NSSelectorFromString(@"pr_insertString:atIndex:")];
            [PRCrashSwizzling swizzlingMethod:NSClassFromString(@"__NSCFString")
                                  originalSEL:@selector(deleteCharactersInRange:)
                                   swizzleSEL:NSSelectorFromString(@"pr_deleteCharactersInRange:")];
        });
    }
    if (option & PRCrashProtectOptionAll || option & PRCrashProtectOptionCatchCrash) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [PRCatchCrash registerHandler];
        });
    }
    
}

@end
