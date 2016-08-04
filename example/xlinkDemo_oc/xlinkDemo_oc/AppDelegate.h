//
//  AppDelegate.h
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/4/15.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOnStart                        @"kOnStart"
#define kOnGotDeviceByScan              @"kOnGotDeviceByScan"
#define kOnConnectDevice                @"kOnConnectDevice"
#define kOnSetLocalDeviceAuthorizeCode  @"kOnSetLocalDeviceAuthorizeCode"
#define kOnHandShake                    @"kOnHandShake"
#define kOnRecvLocalPipeData            @"kOnRecvLocalPipeData"
#define kOnLogin                        @"kOnLogin"
#define kOnSubscription                 @"kOnSubscription"
#define kOnDeviceProbe                  @"kOnDeviceProbe"
#define kOnSetDeviceAuthorizeCode       @"kOnSetDeviceAuthorizeCode"
#define kOnSendPipeData                 @"kOnSendPipeData"
#define kOnSendLocalPipeData            @"kOnSendLocalPipeData"
#define kOnRecvPipeData                 @"kOnRecvPipeData"
#define kOnRecvPipeSyncData             @"kOnRecvPipeSyncData"
#define kOnDataPointUpdata              @"kOnDataPointUpdata"
#define kOnDeviceStateChanged           @"kOnDeviceStateChanged"
#define kOnSetDeviceAccessKey           @"kOnSetDeviceAccessKey"

#define kOnLocalDataPoint2Update        @"kOnLocalDataPoint2Update"
#define kOnCloudDataPoint2Update        @"kOnCloudDataPoint2Update"

#define productId       @"160fa2af1082d000160fa2af1082d001"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)registerAPNWithAccessToken:(NSString *)accessToken toUserID:(NSNumber *)userID;

@end

