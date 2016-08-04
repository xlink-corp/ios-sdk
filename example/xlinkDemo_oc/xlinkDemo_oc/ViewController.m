//
//  ViewController.m
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/4/15.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "ViewController.h"
#import "ScanDeviceViewController.h"

#import "HttpRequest.h"
#import "XLinkExportObject.h"
#import "DeviceEntity.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStart) name:kOnStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin:) name:kOnLogin object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self registerAccount];
}

-(void)showWarningAlert:(NSString *)msg{
    [self showWarningAlert:msg didFinish:nil];
}

-(void)showWarningAlert:(NSString *)msg didFinish:(void (^)(void))finish{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (finish != nil) {
            finish();
        }
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)registerAccount{
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
    if (userData == nil) {
        UIAlertController *emailAlertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入邮箱地址" preferredStyle:UIAlertControllerStyleAlert];
        [emailAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"邮箱地址";
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *email = [emailAlertController.textFields[0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            [self loginWithAccount:email withPassword:@"xt789456"];
            if (email.length != 0) {
                [HttpRequest registerWithAccount:email withNickname:@"test" withVerifyCode:nil withPassword:@"xt789456" didLoadData:^(id result, NSError *err) {
                    if (err != nil && err.code != 4001006) {
                        NSLog(@"register fail：%@", err);
                    }else{
                        [self loginWithAccount:email withPassword:@"xt789456"];
                    }
                }];
            }else{
                [self showWarningAlert:@"邮箱地址不能为空" didFinish:^{
                    [self registerAccount];
                }];
            }
        }];
        [emailAlertController addAction:okAction];
        [self presentViewController:emailAlertController animated:true completion:nil];
    }else{
        [self loginWithAccount:userData[@"account"] withPassword:userData[@"pwd"]];
//        [self loginWithAccount:userData[@""] withPassword:<#(NSString *)#>]
//        if ([[XLinkExportObject sharedObject] start] == 0) {
//            NSLog(@"调用start成功");
//        }else{
//            NSLog(@"调用start失败");
//        }
    }
}

-(void)loginWithAccount:(NSString *)account withPassword:(NSString *)pwd{
    [HttpRequest authWithAccount:account withPassword:pwd didLoadData:^(id result, NSError *err) {
        if (err) {
            NSLog(@"%@", err);
            NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
            if (userData) {
                if ([[XLinkExportObject sharedObject] start] == 0) {
                    NSLog(@"调用start成功");
                }else{
                    NSLog(@"调用start失败");
                }
            }
        }else{
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:result];
            [dic setObject:account forKey:@"account"];
            [dic setObject:pwd forKey:@"pwd"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"userData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[XLinkExportObject sharedObject] start];
            [self getDataPointWithAccessToken:result[@"access_token"]];
        }
    }];
}

-(void)pushScanDeviceViewController{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanDeviceViewController *scanView = [storyBoard instantiateViewControllerWithIdentifier:@"ScanDeviceViewController"];
    [self.navigationController pushViewController:scanView animated:YES];
}

//-(void)checkDataPointWithAccessToken:(NSString *)accessToken{
//    NSDictionary *productDataPointDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"ProductDataPoint"];
//    if (productDataPointDic) {
//        NSString *productID = productDataPointDic[@"ProductID"];
//        if (![productID isEqualToString:productId]) {
//            [self getDataPointWithAccessToken:accessToken];
//        }
//    }else{
//        [self getDataPointWithAccessToken:accessToken];
//    }
//    
//}

-(void)getDataPointWithAccessToken:(NSString *)accessToken{
    [HttpRequest getDataPointListWithProductID:productId withAccessToken:accessToken didLoadData:^(id result, NSError *err) {
        if (err) {
            
        }else{
//            NSDictionary *dataPointDic = @{productId : result};
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"dataPoints"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateProductDataPoint" object:nil];
        }
    }];
}

#pragma mark
#pragma mark Xlink Delegate
-(void)onStart{
    
    [self performSelectorOnMainThread:@selector(pushScanDeviceViewController) withObject:nil waitUntilDone:YES];
    
    
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userData"];
    if (userData) {
//        [self getDataPointWithAccessToken:[userData objectForKey:@"access_token"]];
        //注册APN
        NSNumber * user_id = [userData objectForKey:@"user_id"];
        AppDelegate * myAPP = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [myAPP registerAPNWithAccessToken:[userData objectForKey:@"access_token"] toUserID:user_id];
        
        if ([[XLinkExportObject sharedObject] loginWithAppID:[[userData objectForKey:@"user_id"] intValue] andAuthStr:[userData objectForKey:@"authorize"]] == 0) {
            
            NSLog(@"调用Login成功");
        }else{
            
        }
    }
    
}

//用户登陆成功回调
-(void)onLogin:(NSNotification*)noti{
    int result = [[noti.object objectForKey:@"result"] intValue];
    if (result == 0) {
        NSLog(@"登录成功");
    } else if( result == CODE_SERVER_KICK_DISCONNECT ) {
        NSLog(@"被踢下线");
        [self performSelectorOnMainThread:@selector(showWarningAlert:) withObject:@"被踢下线" waitUntilDone:YES];
    }else{
        // 其他断线逻辑处理
        NSLog(@"被登出，code：%d", result);
        
    }
}


@end
