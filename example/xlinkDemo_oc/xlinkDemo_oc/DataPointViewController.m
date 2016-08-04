//
//  DataPointViewController.m
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/6/12.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "DataPointViewController.h"
#import "DeviceTabBarViewController.h"
#import "BoolTableViewCell.h"
#import "ValueTableViewCell.h"
#import "TextTableViewCell.h"
#import "XLinkExportObject.h"
#import "DeviceEntity.h"
#import "DataPointEntity.h"

@interface DataPointViewController ()<UITableViewDelegate, UITableViewDataSource, BoolTableViewCellDelegate, ValueTableViewCellDelegate, TextTableViewCellDelegate>

@end

@implementation DataPointViewController{
    __weak  IBOutlet    UITableView *_tableView;
    __weak  NSMutableArray    <DataPointEntity *> *_dataPoints;
    __weak  DeviceEntity            *_device;
    
    NSArray         *_dataPointList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProductDataPoint) name:@"kUpdateProductDataPoint" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataPoint:) name:@"kUpdateDataPoint" object:nil];
    _dataPoints = ((DeviceTabBarViewController *)self.tabBarController).dataPoints;
    _device = ((DeviceTabBarViewController *)self.tabBarController).device;
    [self updateProductDataPoint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateProductDataPoint{
    _dataPointList = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"dataPoints"];
    [_tableView reloadData];
}

#pragma mark
#pragma mark UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataPointList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSDictionary *dataPoint = _dataPointList[indexPath.row];
//    uint8_t type = [dataPoint[@"type"] unsignedCharValue];
//    uint8_t index = [dataPoint[@"index"] unsignedCharValue];
//    DataPointEntity *dataPointEntity = nil;
//    for (dataPointEntity in _dataPoints) {
//        if (dataPointEntity.index == index) {
//            break;
//        }
//    }
    
//    DataPointEntity *dataPoint = _dataPoints[indexPath.row];
    NSDictionary *dataPointDic = _dataPointList[indexPath.row];
    uint8_t type = [dataPointDic[@"type"] unsignedCharValue];
    uint8_t index = [dataPointDic[@"index"] unsignedCharValue];
    NSString *name = dataPointDic[@"name"];
    
    DataPointEntity *dataPoint = nil;
    for (dataPoint in _dataPoints) {
        if (dataPoint.index == index) {
            break;
        }
    }
    
    if (type == 1) {
        //Byte | Bool
        BoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoolTableViewCell"];
        cell.delegate = self;
        
        cell.index = index;
        cell.name = name;
        
        if (dataPoint) {
            cell.switchBtn.on = [dataPoint.value unsignedCharValue];
        }else{
            cell.switchBtn.on = 0;
        }
        
        return cell;
    }else if (type == 6){
        //String
        TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextTableViewCell"];
        cell.delegate = self;
        
        cell.index = index;
        cell.name = name;
        
        if (dataPoint) {
            cell.textFiled.text = dataPoint.value;
        }else{
            cell.textFiled.text = @"";
        }
        
        return cell;
    }else{
        ValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValueTableViewCell"];
        cell.delegate = self;
        
        cell.index = index;
        cell.type = type;
        cell.name = name;
        
        if (type == 2){
            //unsigned char
            if ([dataPointDic[@"min"] unsignedCharValue] == 0 && [dataPointDic[@"max"] unsignedCharValue] == 0) {
                cell.min = @(0);
                cell.max = @(0xff);
            }else{
                cell.min = dataPointDic[@"min"];
                cell.max = dataPointDic[@"max"];
            }
            
        }else if (type == 3){
            //Int16
            if ([dataPointDic[@"min"] shortValue] == 0 && [dataPointDic[@"max"] shortValue] == 0) {
                cell.min = @(-0x7fff);
                cell.max = @(0x7fff);
            }else{
                cell.min = dataPointDic[@"min"];
                cell.max = dataPointDic[@"max"];
            }
            
        }else if (type == 8){
            //unsigned Int16
            if ([dataPointDic[@"min"] unsignedShortValue] == 0 && [dataPointDic[@"max"] unsignedShortValue] == 0) {
                cell.min = @(0);
                cell.max = @(0xffff);
            }else{
                cell.min = dataPointDic[@"min"];
                cell.max = dataPointDic[@"max"];
            }
            
        }else if (type == 4){
            //Int32
            if ([dataPointDic[@"min"] intValue] == 0 && [dataPointDic[@"max"] intValue] == 0) {
                cell.min = @(-0x7fffffff);
                cell.max = @(0x7fffffff);
            }else{
                cell.min = dataPointDic[@"min"];
                cell.max = dataPointDic[@"max"];
            }
            
        }else if (type == 9){
            //unsigned Int32
            if ([dataPointDic[@"min"] unsignedIntValue] == 0 && [dataPointDic[@"max"] unsignedIntValue] == 0) {
                cell.min = @(0);
                cell.max = @(0xffffffff);
            }else{
                cell.min = dataPointDic[@"min"];
                cell.max = dataPointDic[@"max"];
            }
            
        }else if (type == 5){
            //float
            if ([dataPointDic[@"min"] floatValue] == 0 && [dataPointDic[@"max"] floatValue] == 0) {
                cell.min = @(-0x7fff);
                cell.max = @(0x7fff);
            }else{
                cell.min = dataPointDic[@"min"];
                cell.max = dataPointDic[@"max"];
            }
            
        }
        
        cell.value = dataPoint.value;
        
        return cell;

    }
    
}

-(void)updateDataPoint:(NSNotification *)noti{
    NSInteger i = [noti.object unsignedCharValue];
    DataPointEntity *dataPointEntity = _dataPoints[i];
    for (i = 0; i < _dataPointList.count; i++) {
        NSDictionary *dataPoint = _dataPointList[i];
        uint8_t index = [dataPoint[@"index"] unsignedCharValue];
        if (dataPointEntity.index == index) {
            [self performSelectorOnMainThread:@selector(reloadDataWithIndexPath:) withObject:[NSIndexPath indexPathForRow:i inSection:0] waitUntilDone:YES];
            break;
        }
    }
}

-(void)reloadDataWithIndexPath:(NSIndexPath *)indexPath{
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark
#pragma mark Cell Delegate
-(void)boolTableViewCell:(BoolTableViewCell *)cell onSwitchValueChange:(UISwitch *)switchBtn{
    NSLog(@"%d", switchBtn.on);
    
    DataPointEntity *dataPointEntity = [[DataPointEntity alloc] init];
    
    dataPointEntity.index = cell.index;
    dataPointEntity.type = 0;
    dataPointEntity.len = 1;
    
    dataPointEntity.value = @(switchBtn.on);
    
    if (_device.isLANOnline) {
        [[XLinkExportObject sharedObject] setLocalDataPoints:@[dataPointEntity] withDevice:_device];
    }else if (_device.isWANOnline){
        [[XLinkExportObject sharedObject] setCloudDataPoints:@[dataPointEntity] withDevice:_device];
    }
}

-(void)valueChangeWithTableViewCell:(ValueTableViewCell *)cell{
    
    DataPointEntity *dataPointEntity = [[DataPointEntity alloc] init];
    
    dataPointEntity.index = cell.index;
    
    if (cell.type == 2) {
        dataPointEntity.type = 0;
    }else if (cell.type == 3){
        dataPointEntity.type = 1;
    }else if (cell.type == 8){
        dataPointEntity.type = 2;
    }else if (cell.type == 4){
        dataPointEntity.type = 3;
    }else if (cell.type == 9){
        dataPointEntity.type = 4;
    }else if (cell.type == 5){
        dataPointEntity.type = 7;
    }
    
    dataPointEntity.len = cell.len;
    
    dataPointEntity.value = cell.value;
    
    if (_device.isLANOnline) {
        [[XLinkExportObject sharedObject] setLocalDataPoints:@[dataPointEntity] withDevice:_device];
    }else if (_device.isWANOnline){
        [[XLinkExportObject sharedObject] setCloudDataPoints:@[dataPointEntity] withDevice:_device];
    }
}

-(void)textTableViewCell:(TextTableViewCell *)cell onSetWithText:(NSString *)text{
    NSLog(@"%@", text);
    
    DataPointEntity *dataPointEntity = [[DataPointEntity alloc] init];
    
    dataPointEntity.index = cell.index;
    dataPointEntity.type = 9;
    dataPointEntity.len = strlen([text UTF8String]);
    
    dataPointEntity.value = text;
    
    if (_device.isLANOnline) {
        [[XLinkExportObject sharedObject] setLocalDataPoints:@[dataPointEntity] withDevice:_device];
    }else if (_device.isWANOnline){
        [[XLinkExportObject sharedObject] setCloudDataPoints:@[dataPointEntity] withDevice:_device];
    }
}

@end