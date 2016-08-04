
//
//  DeviceViewController.m
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/6/8.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "DeviceTabBarViewController.h"
#import "XLinkExportObject.h"
#import "DeviceEntity.h"
#import "DataPointEntity.h"

@interface DeviceTabBarViewController ()

@end

@implementation DeviceTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.title = [[_device getMacAddressString] uppercaseString];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.rightBarButtonItem = item;
    [self updateStatus];
    
    _dataPoints = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceStateChanged:) name:kOnDeviceStateChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDataPointUpdate:) name:kOnLocalDataPoint2Update object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDataPointUpdate:) name:kOnCloudDataPoint2Update object:nil];
    
    [[XLinkExportObject sharedObject] connectDevice:_device andAuthKey:_pwd];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"%s", __func__);
}

-(void)back{
    if( _device.isConnected || _device.isConnecting ) {
        [[XLinkExportObject sharedObject] disconnectDevice:_device withReason:0];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateStatus{
    NSString *title;
    if (_device.connectStatus == ConnectStatusLANAndWANConnectSuccessfully) {
        title = @"本地&云端";
    }else if (_device.connectStatus == ConnectStatusLANAndWANConnectFailed){
        title = @"离线";
    }else if (_device.connectStatus & ConnectStatusLANConnectSuccessfully) {
        title = @"本地";
    }else if (_device.connectStatus & ConnectStatusWANConnectSuccessfully){
        title = @"云端";
    }else{
        title = @"连接中";
    }
    UIBarButtonItem *statusItem = self.navigationItem.rightBarButtonItem;
    ((UILabel *)statusItem.customView).text = title;
    [(UILabel *)statusItem.customView sizeToFit];
}

#pragma mark
#pragma mark XlinkExportObject Delegate Notification
- (void)onDeviceStateChanged:(NSNotification *)notify {
    //        DeviceEntity * device = [notify.object objectForKey:@"device"];
//    if (_device.connectStatus == ConnectStatusLANAndWANConnectSuccessfully) {
//        
//    }else if (_device.connectStatus == ConnectStatusLANAndWANConnectFailed){
//        
//    }else if (_device.connectStatus & ConnectStatusLANConnectSuccessfully) {
//        
//    }else if (_device.connectStatus & ConnectStatusWANConnectSuccessfully){
//        
//    }else{
//        
//    }
    //    int state = [[notify.object objectForKey:@"state"] intValue];
    [self performSelectorOnMainThread:@selector(updateStatus) withObject:nil waitUntilDone:NO];
    
}

-(void)onDataPointUpdate:(NSNotification *)noti{
    
    NSArray <DataPointEntity *> *dataPoints = noti.object[@"datapoints"];
    for (DataPointEntity *dataPointEntity in dataPoints) {
        NSUInteger i;
        for (i = 0; i < _dataPoints.count; i++) {
            DataPointEntity *temp = _dataPoints[i];
            if (dataPointEntity.index == temp.index) {
                temp.value = dataPointEntity.value;
                break;
            }
        }
        if (i == _dataPoints.count) {
            [_dataPoints addObject:dataPointEntity];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateDataPoint" object:@(i)];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
