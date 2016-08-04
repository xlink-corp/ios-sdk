//
//  DeviceViewController.h
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/6/8.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeviceEntity, DataPointEntity;

@interface DeviceTabBarViewController : UITabBarController

@property (strong, nonatomic) DeviceEntity  *device;
@property (strong, nonatomic) NSNumber      *pwd;

@property (strong, nonatomic) NSMutableArray  <DataPointEntity *> *dataPoints;

@end
