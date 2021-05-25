//
//  NSObject+PRUnrecognizedSelector.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import "NSObject+PRUnrecognizedSelector.h"
#import "PRCrashReport.h"
#import <objc/runtime.h>

@implementation PRForwardingTarget

/**
 default Implement
 
 @param target trarget
 @param cmd cmd
 @param ... other param
 @return default Implement is zero
 */
int smartFunctionForPRForwardingTarget(id target, SEL cmd, ...) {
    return 0;
}

static BOOL __addMethodForPRForwardingTarget(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)smartFunctionForPRForwardingTarget, funcTypeEncoding);
}

+ (instancetype)defaultForwardingTarget {
    static PRForwardingTarget *target = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        target = [[PRForwardingTarget alloc] init];
    });
    return target;
}

- (BOOL)addInstanceMethod:(SEL)instanceSEL {
    return __addMethodForPRForwardingTarget([PRForwardingTarget class], instanceSEL);
}

+ (BOOL)addClassMethod:(SEL)classSEL {
    Class metaClass = objc_getMetaClass(class_getName([PRForwardingTarget class]));
    return __addMethodForPRForwardingTarget(metaClass, classSEL);
}

@end

@implementation NSObject (PRUnrecognizedSelector)

- (id)pr_forwardingTargetForSelector:(SEL)aSelector {
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    if ([self respondsToSelector:aSelector] || signatrue) {
        return self;
    } else {
        NSString *crashMessages = [NSString stringWithFormat:@"-[%@ %@]: unrecognized selector sent to instance (%@)",self.class, NSStringFromSelector(aSelector), self];
        [PRCrashReport.shareCrashReport reportCrashMessage:crashMessages];
        
        [PRForwardingTarget.defaultForwardingTarget addInstanceMethod:aSelector];
        return PRForwardingTarget.defaultForwardingTarget;
    }
}

@end
