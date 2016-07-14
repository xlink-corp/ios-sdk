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

#define productId       @"1607d2ae2b6c08001607d2ae2b6c0801"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)registerAPNWithAccessToken:(NSString *)accessToken toUserID:(NSNumber *)userID;

@end

