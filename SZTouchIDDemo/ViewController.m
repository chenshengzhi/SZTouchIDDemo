//
//  ViewController.m
//  SZTouchIDDemo
//
//  Created by 陈圣治 on 15/9/24.
//  Copyright © 2015年 shengzhichen. All rights reserved.
//

#import "ViewController.h"
@import LocalAuthentication;

#ifdef DEBUG
#define CLog(fmt, ...) NSLog((@" %d %s " fmt), __LINE__, __PRETTY_FUNCTION__,  ##__VA_ARGS__)
#else
#define CLog(fmt, ...) do{}while(0)
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapHandle:(id)sender {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSString *localizedReason = @"test";
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReason reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success) {
                    [self showMessage:@"解锁成功"];
                } else {
                    CLog(@"%@", error.localizedDescription);
                    [self dispatchWithErrorCode:error.code];
                }
            });
        }];
    } else {
        CLog(@"%@", error.localizedDescription);
        [self dispatchWithErrorCode:error.code];
    }
}

- (void)dispatchWithErrorCode:(NSInteger)code {
    switch (code) {
        case LAErrorAuthenticationFailed: {
            [self showMessage:@"失败请重试"];
            break;
        }
        case LAErrorUserCancel: {
            [self showMessage:@"你取消了指纹解锁"];
            break;
        }
        case LAErrorUserFallback: {
            [self showMessage:@"选择输入密码"];
            break;
        }
        case LAErrorSystemCancel: {
            [self showMessage:@"系统取消"];
            break;
        }
        case LAErrorPasscodeNotSet: {
            [self showMessage:@"kLAErrorPasscodeNotSet"];
            break;
        }
        case LAErrorTouchIDNotAvailable: {
            [self showMessage:@"kLAErrorTouchIDNotAvailable"];
            break;
        }
        case LAErrorTouchIDNotEnrolled: {
            [self showMessage:@"没有设置指纹"];
            break;
        }
        case LAErrorTouchIDLockout: {
            [self showMessage:@"kLAErrorTouchIDLockout"];
            break;
        }
        case LAErrorAppCancel: {
            [self showMessage:@"kLAErrorAppCancel"];
            break;
        }
        default:
            break;
    }
}

- (void)showMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

@end

