//
//  NSNotificationCenter+PRCrashPtotect.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import "NSNotificationCenter+PRCrashPtotect.h"
#import <objc/runtime.h>

@interface PRNotificationRemover ()

@end

@implementation PRNotificationRemover {
    // __unsafe_unretained: 不会对对象进行retain,当对象销毁时,会依然指向之前的内存空间(野指针) (__weak: 不会对对象进行retain,当对象销毁时,会自动指向nil)
    __unsafe_unretained id _observer;
    // 用数组保存observer的center
    __strong NSMutableArray <NSNotificationCenter *>* _notificationCenters;
}

- (instancetype)initWithObserver:(id)observer {
    self = [super init];
    if (self) {
        _observer = observer;
        _notificationCenters = [NSMutableArray array];
    }
    return self;
}

- (void)addObserverWithCenter:(NSNotificationCenter *)center {
    if (_notificationCenters) {
        [_notificationCenters addObject:center];
    }
}

- (void)dealloc {
    for (NSNotificationCenter *center in _notificationCenters) {
        [center removeObserver:_observer];
    }
}

@end

@implementation NSNotificationCenter (PRCrashPtotect)

/**
 重复添加或移除观察者，本身不会引起Crash；从 iOS 9 开始，即使不移除观察者，程序也不会出现异常。
 但是如果观察者被销毁后不移除，仍会执行对应的selector，可能会引起意想不到的Crash，而此类Crash往往难以定位。
 */

- (void)pr_addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject {
    
    if (!([NSStringFromClass([observer class]) hasPrefix:@"UI"] || [NSStringFromClass([observer class]) hasPrefix:@"_UI"] || [NSStringFromClass([observer class]) hasPrefix:@"CUI"])) {
        static const char PRNotificationRemoverKey;
        PRNotificationRemover *notificationRemover = objc_getAssociatedObject(observer, &PRNotificationRemoverKey);
        if (notificationRemover == nil) {
            notificationRemover = [[PRNotificationRemover alloc] initWithObserver:observer];
            objc_setAssociatedObject(observer, &PRNotificationRemoverKey, notificationRemover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [notificationRemover addObserverWithCenter:self];
    }
    
    [self pr_addObserver:observer selector:aSelector name:aName object:anObject];
}

@end
