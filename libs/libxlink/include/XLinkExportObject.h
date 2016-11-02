//
//  XLinkExportObject.h
//  xlinksdklib
//
//  Created by xtmac02 on 15/3/2.
//  Copyright (c) 2015年 xtmac02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class DataPointEntity;

#define XLINK_SDK_VER         @"1.2.0.14134"

#define ExtLoginState @"extLoginState"

/**
 *  通用错误码定义
 */
#define CODE_SUCCEED                0       // 成功

/**
 * 设备不在线
 */
#define CODE_DEVICE_OFFLINE         110

/**
 * 开始重新连接设备
 */
#define CODE_DEVICE_RECONNECT       111

/**
 * 连接成功
 */
#define CODE_DEVICE_CONNECTED       112

/**
 * 断开连接
 */
#define CODE_DEVICE_DISCONNECTED    113

/**
 * 正在连接设备
 */
#define CODE_DEVICE_CONNECTING      114

/**
 * 超时
 */
#define CODE_TIMEOUT                200

/**
 * 设备还未初始化
 */
#define CODE_DEVICE_UNINIT          201

/**
 * 参数不正确
 */
#define CODE_INVALID_PARAM          1

/**
 * KEY不正确
 */
#define CODE_INVALID_KEY            2

/**
 * ID没有找到订阅回包没找到目标设
 */
#define CODE_UNAVAILABLE_ID         3

/**
 * 服务器内部错误
 */
#define CODE_SERVER_ERROR           4

/**
 * 消息没授权，由于订阅关系不正确引起
 */
#define CODE_UNAUTHORIZED           5

/**
 * 消息发送者角色不对，比如Device到Device发送 set，probe等消息
 */
#define CODE_ILLEGAL_SENDER         6

/**
 * 设备在云端离线
 */
#define CODE_DEVICE_CLOUD_OFFLINE   10

/**
 * 被服务器踢下线
 */
#define CODE_SERVER_KICK_DISCONNECT 13

/**
 *  函数调用参数错误
 */
#define CODE_FUNC_PARAM_ERROR       -8

/**
 * Device属性错误
 */
#define CODE_FUNC_DEVICE_ERROR      -9

/**
 * Device还未激活
 */
#define CODE_FUNC_DEVICE_NOT_ACTIVATION     -10

/**
 * Device mac地址错误
 */
#define CODE_FUNC_DEVICE_MAC_ERROR   -11

/**
 * Device IP地址错误
 */
#define CODE_FUNC_DEVICE_IP_ERROR   -12

/**
 * 网络错误，不能连接设备
 */
#define CODE_FUNC_NETWOR_ERROR   -13


/**
 * 网络错误，不能连接设备
 */
#define CODE_FUNC_DEVICE_SESSION_ID_ERROR   -14

/**
 * 网络错误，不能连接设备
 */
#define CODE_FUNC_DEVICE_CONNECTING   -15

/**
 *  设备版本号错误
 */
#define CODE_FUNC_DEVICE_VERSION_ERROR -16

/**
 * APP下线
 */
#define CODE_STATE_OFFLINE          -101

/**
 * 没有WIFI环境
 */
#define CODE_STATE_NO_WIFI          -102

/**
 * APP被踢下线
 */
#define CODE_STATE_KICK_OFFLINE     -103

/**
 * EVENT NOTIFY 数据端点通知
 */
#define EVENT_DATAPOINT_NOTICE      1

/**
 * EVENT NOTIFY 数据端点告警
 */
#define EVENT_DATAPOINT_ALERT       2



#pragma mark SDK属性KEY定义

#define PROPERTY_CM_SERVER_ADDR         @"cm.server.addr"

#define PROPERTY_CM_SERVER_PORT         @"cm.server.port"

/**
 *  是否检测发送包是否超时
 */
#define PROPERTY_SEND_OVERTIME_CHECK    @"send.overtime.check"

/**
 *  是否使用数据缓冲，如果使用数据缓冲，将会串行发送数据包，并且每个包之间的发送间隔将由PROPERTY_SEND_DATA_INTERVAL属性决定
 */
#define PROPERTY_SEND_DATA_BUFFER       @"send.data.buffer"

/**
 *  使用数据缓冲，每个包之间的发送间隔，单位浮点，秒
 */
#define PROPERTY_SEND_DATA_INTERVAL     @"send.data.interval"

@class DeviceEntity;
@class XLinkExportObject;

@protocol XlinkExportObjectDelegate <NSObject>

@optional

/**
 *  SDK的start接口结果回调
 */
-(void)onStart;

/**
 *  SDK扫描到的设备结果回调
 *
 *  如果扫描到了多个设备，该回调会多次调用
 *
 *  @param device 设备实体。
 */
-(void)onGotDeviceByScan:(DeviceEntity *)device;


/**
 *  设置本地设备的访问授权码结果回调
 *
 *  @param device    设备实体
 *  @param result    设置结果
 *  @param messageID 消息ID，用于定位消息。APP可以忽略
 */
-(void)onSetLocalDeviceAuthorizeCode:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID;


/**
 *  发送本地透传消息结果回调
 *
 *  @param device    设备实体
 *  @param result    发送结果
 *  @param messageID 消息ID，用于定位消息。APP可以忽略
 */
-(void)onSendLocalPipeData:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID;


/**
 *  接收到设备发送过来的透穿消息
 *
 *  @param device 设备实体
 *  @param data   消息内容
 */
-(void)onRecvLocalPipeData:(DeviceEntity *)device withPayload:(NSData *)data;


/**
 *  登录状态回调
 *
 *  @param result 结果
 */
-(void)onLogin:(int)result;


/**
 *  云端设置授权结果回调
 *
 *  @param device    设备实体
 *  @param result    设置结果
 *  @param messageID 消息ID，APP可以忽略
 */
-(void)onSetDeviceAuthorizeCode:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID;


/**
 *  发送云端透传数据结果
 *
 *  @param device    设备实体
 *  @param result    发送结果
 *  @param messageID 消息ID，APP可以忽略
 */
-(void)onSendPipeData:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID;

/**
 *  接收到云端设备发送回来的透传数据
 *
 *  @param device   设备实体
 *  @param payload  数据实体
 */
-(void)onRecvPipeData:(DeviceEntity *)device withMsgID:(UInt16)msgID withPayload:(NSData *)payload;


/**
 *  接收到云端设备发送的广播透传数据
 *
 *  @param device   设备实体
 *  @param payload  数据实体
 */
-(void)onRecvPipeSyncData:(DeviceEntity *)device withPayload:(NSData *)payload;


/**
 *  云端探测返回回调
 *
 *  @param device    设备实体
 *  @param result    结果
 *  @param messageID 消息ID，APP可以忽略
 */
-(void)onDeviceProbe:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID;


/**
 *  设置设备AccessKey回调
 *
 *  @param device    被设置的设备
 *  @param result    结果
 *  @param messageID 消息ID
 */
-(void)onSetDeviceAccessKey:(DeviceEntity *)device withResult:(unsigned char)result withMessageID:(unsigned short)messageID;


/**
 *  数据端点数据回调（透传功能用不到）
 *
 *  @param device   设备实体
 *  @param index    端点索引
 *  @param dataBuff 索引值
 *  @param channel  通道：云端还是本地
 */
-(void)onDataPointUpdata:(DeviceEntity *)device withIndex:(int)index withDataBuff:(NSData*)dataBuff withChannel:(int)channel;


/**
 *  本地收到dataPoint sync包（非数据模板）
 *
 *  @param device 设备实体
 *  @param data   数据
 */
-(void)onLocalDataPoint2Update:(DeviceEntity *)device withDataPoints:(NSArray <DataPointEntity *> *)dataPoints;


/**
 *  云端收到dataPoint sync包（非数据模板）
 *
 *  @param device 设备实体
 *  @param data   数据
 */
-(void)onCloudDataPoint2Update:(DeviceEntity *)device withDataPoints:(NSArray <DataPointEntity *> *)dataPoints;


/**
 *  网络状态改变通知
 *
 *  @param state 状态值
 */
-(void)onNetStateChanged:(int)state;


/**
 *  连接设备结果回调
 *
 *  @param device 设备实体
 *  @param result 结果
 *  @param taskID 消息ID，APP可以忽略
 */
-(void)onConnectDevice:(DeviceEntity *)device andResult:(int)result andTaskID:(int)taskID ;


/**
 *  设备上下线状态回调
 *
 *  @param device 设备实体
 */
-(void)onDeviceStatusChanged:(DeviceEntity *)device;

/**
 *  淘汰接口（保留）
 *  与设备握手状态的回调
 *
 *  @param device 设备实体
 *  @param result 结果
 */
-(void)onHandShakeWithDevice:(DeviceEntity *)device withResult:(int)result;

/**
 *  获取到SUBKEY
 *
 *  @param device 设备实体
 *  @param subkey SUBKEY
 */
-(void)onGotSubKeyWithDevice:(DeviceEntity *)device withSubKey:(NSNumber *)subkey;

/**
 *  与设备订阅状态回调
 *
 *  @param device    设备实体
 *  @param result    结果
 *  @param messageID 消息ID，APP可以忽略
 */
-(void)onSubscription:(DeviceEntity *)device withResult:(int)result withMessageID:(int)messageID;

/**
 *  接收到云端通知
 *
 *  @param flag      消息类型
 *  @param data      消息实体，原始数据，如果是字符串类型的数据，前两位是字符串长度，后面是UT8的字符串数据
 *  @param fromID    消息发送者ID
 *  @param messageID 消息ID，APP可以忽略
 */
-(void)onNotifyWithFlag:(unsigned char)flag withMessageData:(NSData *)data fromID:(int)fromID messageID:(int)messageID;

-(void)onSetLocalDataPoint:(DeviceEntity *)device withResult:(int)result withMsgID:(unsigned short)msgID;

-(void)onSetCloudDataPoint:(DeviceEntity *)device withResult:(int)result withMsgID:(unsigned short)msgID;

@end

@interface XLinkExportObject : NSObject

+(XLinkExportObject *)sharedObject;

@property (nonatomic,retain)id<XlinkExportObjectDelegate> delegate;
@property (nonatomic, retain) NSNumber *accessKey;
@property (nonatomic, assign) BOOL isConnectDevice;
@property (nonatomic, retain, readonly) NSMutableArray *prodctid_value;

/**
 * 开始初始化操作 监听的app本地UDP端口 用于SDK监听WiFi设备数据回包
 *
 * 从休眠恢复之后，需要再次调用stop和start
 *
 *  @return 0 为成功，其它失败
 */
-(int)start;


/**
 *  释放SDK，清理本地资源。在退出程序，或者从休眠恢复之后，都需要再次调用stop和start
 */
-(void)stop;


/**
 *  APP登录到云端，登录到云端以后，才可以使用云端的功能。
 *
 *  @param appId   云端分配的唯一APPID，改通过HTTP接口注册获取到。
 *  @param authStr
 *
 *  @return 0 为成功，其它失败。登录结果通过异步的onLogin回调获取
 */
-(int)loginWithAppID:(int)appId andAuthStr:(NSString *)authStr;


/**
 *  登出云端
 */
-(void)logout;


/**
 *  通过产品ID扫描本地内网设备
 *
 *  @param productID 产品ID
 *
 *  @return 0 为成功，其它失败。扫描结果通过onGotDeviceByScan异步返回。
 */
-(int)scanByDeviceProductID:(NSString *)productID;


/**
 *  设置内网中设备的授权码
 *
 *  @param device  设备实体
 *  @param oldAuth 旧密码，如果设备本身并没有设置授权码的话，该参数置为@"";
 *  @param newAuth 新密码
 *
 *  @return 0 为成功，其它失败。设置结果通过onSetLocalDeviceAuthorizeCode返回
 */
-(int)setLocalDeviceAuthorizeCode:(DeviceEntity *)device andOldAuthCode:(NSNumber *)oldAuth andNewAuthCode:(NSNumber *)newAuth;


/**
 *  通过云端设置设备的授权码
 *
 *  @param device  设备实体
 *  @param oldAuth 旧密码，如果设备本身并没有设置授权码的话，该参数置为@"";
 *  @param newAuth 新密码
 *
 *  @return 0 为成功，其它失败。设置结果通过onSetDeviceAuthorizeCode返回
 */
-(int)setDeviceAuthorizeCode:(DeviceEntity *)device andOldAuthKey:(NSNumber *)oldAuth andNewAuthKey:(NSNumber *)newAuth;


/**
 *  向内网中的设备发送透传数据
 *
 *  @param device  设备实体
 *  @param payload 数据值，二进制的。
 *
 *  @return >0 为成功，<0 失败。其发送结果通过onSendLocalPipeData回调返回。
 */
-(int)sendLocalPipeData:(DeviceEntity *)device andPayload:(NSData *)payload;

/**
 *  应答设备向app发送的本地pipe包
 *
 *  @param deviceID 设备id
 *  @param msgID    消息id
 *  @param code     结果
 *
 *  @return 成功:0 其它错误
 */
-(int)sendLocalPipeReplyPacketWithDeviceID:(UInt32)deviceID withMsgID:(UInt16)msgID withCode:(int8_t)code;

/**
 *  通过云向设备发送透传数据
 *
 *  @param device  设备实体
 *  @param payload 数据值，二进制的。
 *
 *  @return >0 为成功，<0 失败。其发送结果通过onSendLocalPipeData回调返回。
 */
-(int)sendPipeData:(DeviceEntity *)device andPayload:(NSData *)payload;

/**
 *  应答云端向app发送的云端pipe包
 *
 *  @param deviceID 设备id
 *  @param msgID    消息id
 *  @param code     结果
 *
 */
-(void)sendPipeReplyPacketWithDeviceID:(UInt32)deviceID withMsgID:(UInt16)msgID withCode:(int8_t)code;

/**
 *  初始化（更新）某个设备的基本信息。用在从APP缓存设置到SDK中时使用。
 *
 *  @param device 设备实体
 *
 *  @return 0 成功，其它失败
 */
-(int)initDevice:(DeviceEntity *)device;


/**
 *  探测设备状态
 *
 *  @param device 设备实体
 *
 *  @return 0 为成功，其他失败。探测结果异步通过onDeviceProbe回调
 */
-(int)probeDevice:(DeviceEntity *)device;


/**
 *  初始化设备时设置设备的AccessKey
 *
 *  @param accessKey 要设置的AccessKey
 *  @param device    被设置的设备
 *
 *  @return 0 为成功，其他失败。
 */
-(int)setAccessKey:(NSNumber *)accessKey withDevice:(DeviceEntity *)device;


/**
 *  连接设备，在控制前需要连接设备，统一使用该入口连接设备
 *
 *  @param device  设备实体
 *  @param authKey 设备授权码
 *
 *  @return 0 为成功，其它失败。连接结果通过onConnectDevice回调
 */
-(int)connectDevice:(DeviceEntity *)device andAuthKey:(NSNumber *)authKey;


/**
 *  与设备断开，不再接受该设备发送过来的任何数据
 *  注意：调用该函数，并不会把设备实体直接从SDK内删除，只是作为一个标志量，不再把数据回调到外面
 *
 *  @param device   设备实体
 *  @param reason   断开类型，预留，现在填0即可
 *
 *  @return 0 为成功，其他失败。
 */
-(int)disconnectDevice:(DeviceEntity *)device withReason:(int)reason;


/**
 *  清理SDK内的所有设备列表
 */
//-(void)clearDeviceList;



/**
 *  设置SDK运行属性
 *
 *  @param object 值
 *  @param key    名称
 *
 *  @return 0 成功；其他失败
 */
-(int)setSDKProperty:(id)object withKey:(NSString *)key;

/**
 *  获取SDK运行属性
 *
 *  @param key 名称
 *
 *  @return 值
 */
-(NSObject *)getSDKProperty:(NSString *)key;

/**
 *  通过本地设置设备DataPoint
 *
 *  @param dataPoint 设备的DataPoint
 *  @param device    要设置的设备
 *
 *  @return 失败：0， 成功：msgID
 *
 */
-(unsigned short)setLocalDataPoints:(NSArray <DataPointEntity *> *)dataPoints withDevice:(DeviceEntity *)device;


/**
 *  通过云端设置设备DataPoint
 *
 *  @param dataPoint 设备的DataPoint
 *  @param device    要设置的设备
 *
 *  @return 失败：0， 成功：msgID
 *
 */
-(unsigned short)setCloudDataPoints:(NSArray <DataPointEntity *> *)dataPoints withDevice:(DeviceEntity *)device;

/**
 *  订阅设备
 *
 *  @param device  要订阅的设备实体
 *  @param authKey 认证码
 *  @param flag    1:订阅 0:取消订阅
 *
 *  @return 0:成功 其他:失败
 */
-(int)subscribeDevice:(DeviceEntity *)device andAuthKey:(NSNumber *)authKey andFlag:(int8_t)flag;

/**
 *  获取subkey（需要在内网使用）
 *
 *  @param device @param device 设备实体
 *  @param ack    @param ack    accesskey
 *
 *  @return 0成功 其他失败
 */
-(int)getSubKeyWithDevice:(DeviceEntity *)device withAccesskey:(NSNumber *)ack;

@end
