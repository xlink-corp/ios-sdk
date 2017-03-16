//
//  ScanDeviceViewController.m
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/4/15.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "ScanDeviceViewController.h"
#import "AboutViewController.h"
#import "DeviceTabBarViewController.h"

#import "XLinkExportObject.h"
#import "DeviceEntity.h"


@interface ScanDeviceViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ScanDeviceViewController{
    __weak  IBOutlet    UITableView *_tableView;
    NSMutableArray  *_deviceList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = false;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0x3a / 255.0 green:0xba / 255.0 blue:0xe4 / 255.0 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
    [self addNotification];
    
    _deviceList = [NSMutableArray array];
    NSArray *deviceArr = [[NSUserDefaults standardUserDefaults] arrayForKey:@"deviceList"];
    for (NSDictionary *deviceDic in deviceArr) {
        DeviceEntity *device = [[DeviceEntity alloc] initWithDictionary:deviceDic];
        [_deviceList addObject:device];
    }
    
    UIBarButtonItem *nullItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = nullItem;
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(menuBtnAction)];
    self.navigationItem.rightBarButtonItem = menuItem;
    
    [_tableView setSeparatorColor:[UIColor colorWithRed:0xe1 / 255.0 green:0xe1 / 255.0 blue:0xe1 / 255.0 alpha:1]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onConnectDevice:) name:kOnConnectDevice object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOnConnectDevice object:nil];
//}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGotDeviceByScan:) name:kOnGotDeviceByScan object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSetDeviceAccessKey:) name:kOnSetDeviceAccessKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSetLocalDeviceAuthorizeCode:) name:kOnSetLocalDeviceAuthorizeCode object:nil];
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

- (IBAction)scanBtnAction {
    int ret = [[XLinkExportObject sharedObject] scanByDeviceProductID:productId];
    if( ret == CODE_STATE_NO_WIFI ) {
        [self showWarningAlert:@"请开启WIFI环境" didFinish:nil];
    }
}


//在TableView上添加device
-(void)addDevice:(DeviceEntity *)device{
    for (NSInteger i = _deviceList.count - 1; i >= 0; i--) {
        DeviceEntity *d = _deviceList[i];
        if ([device.macAddress isEqualToData:d.macAddress]) {
            [_deviceList removeObjectAtIndex:i];
            break;
        }
    }
    [_deviceList addObject:device];
    [self addDeviceCache:device];
    [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

//把device记录保存在本地
-(void)addDeviceCache:(DeviceEntity *)device{
    
    NSMutableDictionary *deviceDic = [[NSMutableDictionary alloc] initWithDictionary:[device getDictionaryFormat]];
    
    NSMutableArray *deviceArr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"deviceList"]];
    
    for (NSInteger i = deviceArr.count - 1; i >= 0; i--) {
        NSDictionary *dic = deviceArr[i];
        if ([[deviceDic objectForKey:@"macAddress"] isEqualToString:[dic objectForKey:@"macAddress"]]) {
            [deviceArr removeObjectAtIndex:i];
            break;
        }
    }
    
    [deviceArr addObject:deviceDic];
    [[NSUserDefaults standardUserDefaults] setObject:deviceArr forKey:@"deviceList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//推出发送指令页面
-(void)pushDeviceViewControllerWithDevice:(DeviceEntity *)device withPwd:(NSNumber *)pwd{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DeviceTabBarViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"DeviceTabBarViewController"];
    view.device = device;
    view.pwd = pwd;
    [self performSelectorOnMainThread:@selector(pushViewController:) withObject:view waitUntilDone:YES];
}

-(void)pushViewController:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}
//-(void)pushSendAndRecvPacketViewController:(DeviceEntity*)device{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SendAndRecvPacketViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"SendAndRecvPacketViewController"];
//    view.deviceEntity = device;
//    [self.navigationController pushViewController:view animated:YES];
//}

#pragma mark
#pragma mark Menu Action
-(void)menuBtnAction {
    UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *addDeviceManualAction = [UIAlertAction actionWithTitle:@"手动添加设备" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self addDeviceManual];
    }];
    
    UIAlertAction *cleanAction = [UIAlertAction actionWithTitle:@"清除缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self clearCache];
    }];
    
    UIAlertAction *aboutAction = [UIAlertAction actionWithTitle:@"关于" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AboutViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }];
    
    [sheetController addAction:cancelAction];
//    [sheetController addAction:settingAction];
    [sheetController addAction:cleanAction];
    [sheetController addAction:addDeviceManualAction];
    [sheetController addAction:aboutAction];
    
    [self presentViewController:sheetController animated:YES completion:nil];
}

//清除缓存
-(void)clearCache{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deviceList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_deviceList removeAllObjects];
    [_tableView reloadData];
}

//手动添加设备
-(void)addDeviceManual {
    DeviceEntity *device = [[DeviceEntity alloc] initWithMac:@"78b3b9000009" andProductID:@"160fa2aed1523200160fa2aed1523201"];
    
    device.version = 2;
    device.accessKey = @(8888);
    
    [self addDevice:device];
    [self addDeviceCache:device];
}

#pragma mark
#pragma mark UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _deviceList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    DeviceEntity *device = _deviceList[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"设备:%@(%d)", [[device getMacAddressString] uppercaseString], [device getDeviceID]];
//    if (device.connectStatus & ConnectStatusLANAndWANConnectSuccessfully) {
//        str = [NSString stringWithFormat:@"[已连接]%@", str];
//    }else if (device.connectStatus == ConnectStatusLANAndWANConnectFailed){
//        str = [NSString stringWithFormat:@"[未连接]%@", str];
//    }else{
//        str = [NSString stringWithFormat:@"[连接中]%@", str];
//    }
    
    
    NSString * name = device.deviceName;
    if( name != nil && name.length > 0 ) {
        str = [str stringByAppendingString:name];
    }
    cell.textLabel.text = str;
    [cell.textLabel setTextColor:[UIColor colorWithRed:0x34 / 255.0 green:0x34 / 255.0 blue:0x34 / 255.0 alpha:1]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __block DeviceEntity *device = _deviceList[indexPath.row];
    
    if (device.version == 1) {
        //旧版本设备
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *inputAction = [UIAlertAction actionWithTitle:@"输入授权码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIAlertController *inputAlert = [UIAlertController alertControllerWithTitle:nil message:@"请输入授权码" preferredStyle:UIAlertControllerStyleAlert];
            
            [inputAlert addTextFieldWithConfigurationHandler:nil];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSNumber *pwd = @([inputAlert.textFields.firstObject text].intValue);
                NSLog(@"%@", [device getDictionaryFormat]);
                [self pushDeviceViewControllerWithDevice:device withPwd:pwd];
//                [[XLinkExportObject sharedObject] connectDevice:device andAuthKey:pwd];
            }];
            
            [inputAlert addAction:cancelAction];
            [inputAlert addAction:okAction];
            [self presentViewController:inputAlert animated:YES completion:nil];
        }];
        
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"设置授权码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIAlertController *inputAlert = [UIAlertController alertControllerWithTitle:nil message:@"请输入授权码" preferredStyle:UIAlertControllerStyleAlert];
            
            [inputAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"4位数旧密码";
            }];
            [inputAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"4位数新密码";
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSNumber *oldPwd = @([inputAlert.textFields[0] text].intValue);
                NSNumber *newPwd = @([inputAlert.textFields[1] text].intValue);
                [[XLinkExportObject sharedObject] setLocalDeviceAuthorizeCode:device andOldAuthCode:oldPwd andNewAuthCode:newPwd];
            }];
            
            [inputAlert addAction:cancelAction];
            [inputAlert addAction:okAction];
            [self presentViewController:inputAlert animated:YES completion:nil];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:inputAction];
        [alertController addAction:settingAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        //新版本设备
        if ([device isDeviceInitted]) {
            [self pushDeviceViewControllerWithDevice:device withPwd:device.accessKey];
//            [[XLinkExportObject sharedObject] connectDevice:device andAuthKey:device.accessKey];
        }else{
            UIAlertController *inputAlert = [UIAlertController alertControllerWithTitle:nil message:@"请输入授权码" preferredStyle:UIAlertControllerStyleAlert];
            
            [inputAlert addTextFieldWithConfigurationHandler:nil];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSString *ack = [inputAlert.textFields.firstObject text];
                NSNumber *ack_int = @([ack intValue]);
                device.accessKey = ack_int;
                
                if (ack_int.unsignedIntValue <= 0 || ack_int.unsignedIntValue > 999999999) {
                    [self showWarningAlert:@"授权码不合法"];
                }else{
                    [[XLinkExportObject sharedObject] setAccessKey:ack_int withDevice:device];
                }
                
            }];
            
            [inputAlert addAction:cancelAction];
            [inputAlert addAction:okAction];
            [self presentViewController:inputAlert animated:YES completion:nil];
        }
    }
}

#pragma mark
#pragma mark XlinkExportObject Delegate
//扫描设备回调
-(void)onGotDeviceByScan:(NSNotification *)noti{
    DeviceEntity *device = noti.object;
    [self addDevice:device];
    [self addDeviceCache:device];
}

- (void)onConnectDevice:(NSNotification *)noti{
    DeviceEntity *device = [noti.object objectForKey:@"device"];
    NSInteger result = [[noti.object objectForKey:@"result"] integerValue];
    if (result == 0) {
        [self addDeviceCache:device];
    }
//
//    NSLog(@"%@", device.accessKey);
//    
//    switch (result) {
//        case 0:{
////            [[XLinkExportObject sharedObject] subscribeDevice:device andAuthKey:device.accessKey andFlag:YES];
//            [self performSelectorOnMainThread:@selector(pushSendAndRecvPacketViewController:) withObject:device waitUntilDone:YES];
//        }
//            break;
//        case 2:{
//            [self showWarningAlert:@"授权码认证失败" didFinish:nil];
//        }
//            break;
//        default:
//            break;
//    }
//    
}

-(void)onSetDeviceAccessKey:(NSNotification *)noti{
    NSLog(@"%@", noti.object);
    DeviceEntity *device = [noti.object objectForKey:@"device"];
    NSNumber *ack = device.accessKey;
    [self pushDeviceViewControllerWithDevice:device withPwd:ack];
//    [[XLinkExportObject sharedObject] connectDevice:device andAuthKey:ack];
    
}

-(void)onSetLocalDeviceAuthorizeCode:(NSNotification *)noti{
    UInt8 result = [[noti.object objectForKey:@"result"] unsignedCharValue];
    
    NSString *hint = [NSString stringWithFormat:@"修改授权码%@", result ? @"失败" : @"成功"];
    
    [self performSelectorOnMainThread:@selector(showWarningAlert:) withObject:hint waitUntilDone:NO];
    
}

@end
