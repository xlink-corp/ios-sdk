//
//  AppDelegate.m
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/4/15.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "AppDelegate.h"
#import "XLinkExportObject.h"
#import "DeviceEntity.h"
#import "HttpRequest.h"

@interface AppDelegate ()<XlinkExportObjectDelegate>

@end

@implementation AppDelegate{
    NSString    *_deviceTokenString;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //注册推送通知（注意iOS8注册方法发生了变化）
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    [application registerForRemoteNotifications];
    
    NSNumber *firstStart = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstStart"];
    if (!firstStart) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@[
                                                           @{@"name" : @"开", @"hexCode" : @"01"},
                                                           @{@"name" : @"关", @"hexCode" : @"00"},
                                                           @{@"name" : @"加", @"hexCode" : @"02"},
                                                           @{@"name" : @"减", @"hexCode" : @"03"}
                                                           ] forKey:@"hexCodePacket"];
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"firstStart"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [XLinkExportObject sharedObject].delegate = self;
    // 设置运行属性
    [[XLinkExportObject sharedObject] setSDKProperty:@"42.121.122.23" withKey:PROPERTY_CM_SERVER_ADDR];
    [[XLinkExportObject sharedObject] setSDKProperty:[NSNumber numberWithBool:NO] withKey:PROPERTY_SEND_OVERTIME_CHECK];
    [[XLinkExportObject sharedObject] setSDKProperty:[NSNumber numberWithBool:YES] withKey:PROPERTY_SEND_DATA_BUFFER];
    [[XLinkExportObject sharedObject] setSDKProperty:[NSNumber numberWithFloat:0.3] withKey:PROPERTY_SEND_DATA_INTERVAL];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark
#pragma mark XLinkExportObject Delegate

//onStart回调
-(void)onStart{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnStart object:nil];
}

//通知状态返回
-(void)onLogin:(int)result{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnLogin object:@{@"result" : [NSNumber numberWithInt:result]}];
}

//扫描返回
-(void)onGotDeviceByScan:(DeviceEntity *)device{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnGotDeviceByScan object:device];
}

-(void)onSetDeviceAccessKey:(DeviceEntity *)device withResult:(unsigned char)result withMessageID:(unsigned short)messageID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnSetDeviceAccessKey object:@{@"result" : @(result), @"device" : device}];
}

//设置本地设备的访问授权码结果回调
-(void)onSetLocalDeviceAuthorizeCode:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnSetLocalDeviceAuthorizeCode object:@{@"device" : device, @"result" : [NSNumber numberWithInt:result], @"messageID" : [NSNumber numberWithInt:messageID]}];
}

//云端设置授权结果回调
-(void)onSetDeviceAuthorizeCode:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnSetDeviceAuthorizeCode object:@{@"device" : device, @"result" : [NSNumber numberWithInt:result], @"messageID" : [NSNumber numberWithInt:messageID]}];
}

//握手状态回调
-(void)onHandShakeWithDevice:(DeviceEntity *)device withResult:(int)result{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnHandShake object:@{@"device" : device, @"result" : [NSNumber numberWithInt:result]}];
}

/**
 *  连接设备回调
 *
 *  @param device 设备实体
 *  @param result 连接结果
 *  @param taskID 任务ID
 */
-(void)onConnectDevice:(DeviceEntity *)device andResult:(int)result andTaskID:(int)taskID {
    
    if( result == 0 ) {
        NSLog(@"Devcice %@ connected", [device getLocalAddress]);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnConnectDevice object:@{@"device" : device, @"result" : [NSNumber numberWithInt:result], @"taskID" : [NSNumber numberWithInt:taskID]}];
}

-(void)onDeviceStatusChanged:(DeviceEntity *)device{
    NSLog(@"onDeviceStateChanged,DataLength mac:%@", [device getMacAddressString]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnDeviceStateChanged object:@{@"device" : device}];
}

//订阅状态返回
-(void)onSubscription:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnSubscription object:@{@"device" : device, @"result" : [NSNumber numberWithInt:result], @"messageID" : [NSNumber numberWithInt:messageID]}];
    
    if (result == 0) {
        NSLog(@"订阅成功,MessageID = %d", messageID);
    }else{
        NSLog(@"订阅失败,MessageID = %d; Result = %d", messageID, result);
    }
}

-(void)onDeviceProbe:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnDeviceProbe object:@{@"device" : device, @"result" : [NSNumber numberWithInt:result], @"messageID" : [NSNumber numberWithInt:messageID]}];
}

//发送本地pipe消息结果回调
-(void)onSendLocalPipeData:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID {
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnSendLocalPipeData object:@{@"device" : device, @"result" : [NSNumber numberWithInt:result], @"messageID" : [NSNumber numberWithInt:messageID]}];
}

//发送云端pipe数据结果
-(void)onSendPipeData:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnSendPipeData object:@{@"device" : device, @"result" : [NSNumber numberWithInt:result], @"messageID" : [NSNumber numberWithInt:messageID]}];
}

//接收本地设备发送的pipe包
-(void)onRecvLocalPipeData:(DeviceEntity *)device withPayload:(NSData *)payload{
    NSLog(@"onRecvLocalPipeData,DataLength %lu", (unsigned long)payload.length);
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnRecvLocalPipeData object:@{@"device" : device, @"payload" : payload}];
}

//接收到云端设备发送回来的pipe结构
-(void)onRecvPipeData:(DeviceEntity *)device withPayload:(NSData *)payload{
    NSLog(@"onRecvPipeData,DataLength %lu", (unsigned long)payload.length);
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnRecvPipeData object:@{@"device" : device, @"payload" : payload}];
}

//接收到云端设备发送的PIPE_SYNC(PIPE_2)
-(void)onRecvPipeSyncData:(DeviceEntity *)device withPayload:(NSData *)payload{
    NSLog(@"onRecvPipeSyncData,DataLength %lu", (unsigned long)payload.length);
    [[NSNotificationCenter defaultCenter] postNotificationName:kOnRecvPipeSyncData object:@{@"device" : device, @"payload" : payload}];
}

//接收到平台发送的Event Notify消息
-(void)onNotifyWithFlag:(unsigned char)flag withMessageData:(NSData *)data fromID:(int)fromID messageID:(int)messageID {
    NSLog(@"onNotifyWithFlag flag : %d , fromID : %d, messageID : %d;", flag, fromID, messageID);
    NSLog(@"MessageData with length %ld", (unsigned long)data.length);
    if( flag == EVENT_DATAPOINT_NOTICE || flag == EVENT_DATAPOINT_ALERT ) {
        int len = 0;
        [data getBytes:&len range:NSMakeRange(0, 2)];
        len = ntohs(len);
        NSData * temp = [data subdataWithRange:NSMakeRange(2, len)];
        NSString * text = [NSString stringWithUTF8String:[temp bytes]];
        NSLog(@"Message text : %@", text);
    }
}

#pragma mark
#pragma mark 获取deviceToken
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    _deviceTokenString = [self hexadecimalString:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error);
}


- (NSString *)hexadecimalString:(NSData *)data
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
    {
        return [NSString string];
    }
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    
    return [NSString stringWithString:hexString];
}

#pragma mark
#pragma mark 接收到推送通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"receiveRemoteNotification,userInfo is %@",userInfo);
}

#pragma mark
#pragma mark 向云端注册消息推送
-(void)registerAPNWithAccessToken:(NSString *)accessToken toUserID:(NSNumber *)userID {
    if (_deviceTokenString.length) {
        [HttpRequest registerAPNServiceWithUserID:userID withDeviceToken:_deviceTokenString withAccessToken:accessToken didLoadData:^(id result, NSError *err) {
            // TODO: 错误的处理
            if (err) {
                NSLog(@"register APN service error：%@", err);
            }
        }];
    }
}

@end
