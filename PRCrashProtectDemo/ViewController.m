//
//  ViewController.m
//  PRCrashProtectDemo
//
//  Created by haiou.wang on 2021/1/4.
//

#import "ViewController.h"
#import "PushedViewController.h"
#import "PRCrashProtect/PRCrashProtect.h"

@interface ViewController ()

@property (nonatomic, strong) NSNumber *vcNumber;

@end

@implementation ViewController {
    __unsafe_unretained UIViewController *_vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"点击屏幕";
    [PRCrashProtect.shareCrashProtect registerCrashProtect:PRCrashProtectOptionAll];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName" object:nil];
    self.vcNumber = @3;
    [_vc removeObserver:self forKeyPath:@"number"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    PushedViewController *vc = [[PushedViewController alloc] init];
    vc.vc = self;
    [vc addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:nil];
    [self.navigationController pushViewController:vc animated:YES];
    _vc = vc;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%s %@ %@", __FUNCTION__, keyPath, change);
}

@end
