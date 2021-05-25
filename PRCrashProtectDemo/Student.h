//
//  Student.h
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/8.
//

#import <Foundation/Foundation.h>
#import "Teacher.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) Teacher *teacher;

@end

NS_ASSUME_NONNULL_END
