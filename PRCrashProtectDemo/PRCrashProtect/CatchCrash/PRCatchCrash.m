//
//  PRCatchCrash.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/6.
//

#import "PRCatchCrash.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#import "PRCrashReport.h"

static NSUncaughtExceptionHandler *pr_previousUncaughtExceptionHandler;

typedef void (*SignalHandler)(int signo, siginfo_t *info, void *context);
static SignalHandler pr_previousSignalHandler = NULL;

@implementation PRCatchCrash

+ (void)registerHandler {
    PRInstallSignalHandler();
    PRInstallUncaughtExceptionHandler();
}

static void PRInstallSignalHandler(void) {
    struct sigaction old_action;
    sigaction(SIGABRT, NULL, &old_action);
    if (old_action.sa_flags & SA_SIGINFO) {
        pr_previousSignalHandler = old_action.sa_sigaction;
    }
    
    PRSignalRegister(SIGABRT);
//    PRSignalRegister(SIGHUP);
//    PRSignalRegister(SIGINT);
//    PRSignalRegister(SIGQUIT);
//    PRSignalRegister(SIGILL);
//    PRSignalRegister(SIGSEGV);
//    PRSignalRegister(SIGFPE);
//    PRSignalRegister(SIGBUS);
//    PRSignalRegister(SIGPIPE);
    // .......
    /*
     SIGABRT--程序中止命令中止信号
     SIGALRM--程序超时信号
     SIGFPE--程序浮点异常信号
     SIGILL--程序非法指令信号
     SIGHUP--程序终端中止信号
     SIGINT--程序键盘中断信号
     SIGKILL--程序结束接收中止信号
     SIGTERM--程序kill中止信号
     SIGSTOP--程序键盘中止信号
     SIGSEGV--程序无效内存中止信号
     SIGBUS--程序内存字节未对齐中止信号
     SIGPIPE--程序Socket发送失败中止信号
     */
}

static void PRSignalRegister(int signal) {
    struct sigaction action;
    action.sa_sigaction = PRSignalHandler;
    action.sa_flags = SA_NODEFER | SA_SIGINFO;
    sigemptyset(&action.sa_mask);
    sigaction(signal, &action, 0);
}
static void PRSignalHandler(int signal, siginfo_t* info, void* context) {
    NSString *crashMessage = [NSString stringWithFormat:@"*** crash *** signal: %d, info: %@", signal, info];
    [PRCrashReport.shareCrashReport reportCrashMessage:crashMessage];
    // PRClearSignalRigister();
    // 处理前者注册的 handler
    if (pr_previousSignalHandler) {
        pr_previousSignalHandler(signal, info, context);
    }
}

static void PRHandleException(NSException *exception) {
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    [PRCrashReport.shareCrashReport reportCrashMessage:[NSString stringWithFormat:@"*** crash *** %@ \n*** First throw call stack:\n%@", reason, [exception callStackSymbols]]];
    
    // 处理前者注册的 handler
    if (pr_previousUncaughtExceptionHandler) {
        pr_previousUncaughtExceptionHandler(exception);
    }
}

static void PRInstallUncaughtExceptionHandler(void) {
    pr_previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&PRHandleException);
}

@end
