//
//  NSObject+PRKVOCrash.h
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRObserverRemover : NSObject

@end

@interface PRObserverContainer : NSObject

@end

@interface NSObject (PRKVOCrash)

- (void)pr_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
