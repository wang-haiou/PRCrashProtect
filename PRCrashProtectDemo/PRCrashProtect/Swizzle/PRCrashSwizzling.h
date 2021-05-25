//
//  PRCrashSwizzling.h
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRCrashSwizzling : NSObject

+ (void)swizzlingMethod:(Class)clazz originalSEL:(SEL)originalSEL swizzleSEL:(SEL)swizzleSEL;

@end

NS_ASSUME_NONNULL_END
