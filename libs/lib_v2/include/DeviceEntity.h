//
//  DeviceEntity.h
//  XLinkSdk
//
//  Created by xtmac02 on 15/1/8.
//  Copyright (c) 2015年 xtmac02. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : UInt8 {
    ConnectStatusConnecting                     =   0b0000,
    ConnectStatusLANConnectSuccessfully         =   0b0001,
    ConnectStatusLANConnectFailed               =   0b0010,
    ConnectStatusWANConnectSuccessfully         =   0b0100,
    ConnectStatusWANConnectFailed               =   0b1000,
    ConnectStatusLANAndWANConnectSuccessfully   =   ConnectStatusLANConnectSuccessfully |
                                                    ConnectStatusWANConnectSuccessfully,
    ConnectStatusLANAndWANConnectFailed         =   ConnectStatusLANConnectFailed |
                                                    ConnectStatusWANConnectFailed
}ConnectStatus;

@interface DeviceEntity : NSObject{

}

@property (nonatomic,assign)int messageType;            //发送的消息类型
@property (nonatomic,copy)NSString *fromIP;             //从那个IP得到的设备
@property (nonatomic,copy)NSString *deviceKey;          //设备Key str 长度为 16
@property (nonatomic,copy)NSData *macAddress;           //设备Mac地址，设备的硬件地址
@property (nonatomic,copy)NSString *productID;          //设备产品ID        扫描得到
@property (nonatomic,assign)int mcuHardVersion;         //mcu硬件版本号      <1byte
@property (nonatomic,assign)int mcuSoftVersion;         //mcu软件版本号      <2bytes
@property (nonatomic,assign)int devicePort;             //设备监听的端口号    <2bytes
@property (nonatomic,assign)int version;                //协议版本
@property (nonatomic,assign)int sessionID;              //会话的sessionID
@property (nonatomic,assign)int flag;                   //扫描回来的payload的消息标示
@property (nonatomic,assign)int deviceID;               //设备ID主要用来确认设备
@property (nonatomic,assign) ConnectStatus connectStatus; //连接状态
@property (nonatomic,assign)double lastGetPingReturn;   //获得ping回包的最近的时间，用来判断设备是否下线了
@property (nonatomic,assign) unsigned short deviceType; //设备类型
@property (strong, nonatomic) NSNumber *accessKey;
@property (strong, nonatomic) NSString *deviceName;     //设备名称

@property (assign, nonatomic, readonly) bool isConnected; //设备是否连接上
@property (assign, nonatomic, readonly) bool isConnecting;//设备是否正在连接
@property (assign, nonatomic, readonly) bool isLANOnline; //局域网是否在线
@property (assign, nonatomic, readonly) bool isWANOnline; //广域网是否在线


//扫描回包，或者同步包来设置设备的名字和datapoint的数据断电值
-(void)initPropertyWithData:(NSData *)data;
//设置对话的sessionID
-(void)setSessionID:(int)sessionID;
//获得对话的ID
-(int)getSessionID;
//老协议保留deprecated
-(void)setTicketString:(NSString *)ticket;
//获得ticketstring deprecated
-(NSString *)getTicketString;
//设置设备ID
-(void)setDeviceID:(int)deviceId;
//获得设备ID
-(int)getDeviceID;
//开始心跳
- (void)startHeatBeat;
- (void)stopHeatBeat;
//停止心跳
//- (void)stopBeat;
//设置最近的ping回包，主要用来判断设备是否下线
- (void)setLastgetPingReturn:(double)time;


/**
 *  将设备属性格式化成字典
 *
 *  @return 设备属性字典
 */
-(NSDictionary *)getDictionaryFormat;


/**
 *  将设备属性格式化成字典
 *
 *  @param protocol 字典协议，现在只支持protocol 1
 *
 *  @return 设备属性字典
 */
-(NSDictionary *)getDictionaryFormatWithProtocol:(int)protocol;

/**
 *  通过字典还原成设备实体
 *
 *  @param dict 设备字典；字典支持protocol 1格式的字典
 *
 *  @return 设备实体
 */
-(id)initWithDictionary:(NSDictionary *)dict;


/**
 *  通过MAC地址和ProductID初始化一个设备实体
 *
 *  @param mac MAC地址，格式：445566AABBCC
 *  @param pid 32位设备属性
 *
 *  @return 设备实体
 */
-(id)initWithMac:(NSString *)mac andProductID:(NSString *)pid;

/*
 *@discussion
 *  该函数的主要作用是获得指定索引的节点的值，index的索引从0开始
 *
 *@index
 *  指定的索引,如果索引的值大于理论值则 返回－1
 *
 */
//-(int)getValueForIndex:(int)index;

/*
 *@discussion
 *  该函数的作用是返回端点值的有效位的索引数组  通过有效位标示字节得到有效值索引的数组，从而得到指定索引的值，根据索引值就可以顺序读取指定索引的值了。
 */
//-(NSMutableArray *)getValidateFlag;

/*
 *@discussion
 *  获得设备key字符串
 */
-(NSString *)getDeviceKeyString;

/*
 *@discussion
 *  获得设备key字节
 */
-(NSData *)getDeviceKeyData;

/*
 *@discussion-setMethod
 * 设置指定索引的值，设置的值只是存储在一个设置缓存字典中，只有设置完成之后，就可以通过函数-(NSData *)getAfterSetDatapointData得到设置之后的bytes，可以通过resetDevice来清空设置的值和标示
 */
//-(void)setIndex:(int)aIndex withValue:(int)aValue;


/*
 *@discussion-getMethod
 * 获得设置之后的data payload设置之后的，如果你只设置了deviceName属性，返回的data只包含deviceName的字符串的长度长度和字符串＝ 2bytes＋deviceName ，如果你只设置了datapoint的话，通过解析模版得到有效位标示再加上datapint 的值 ：(validate flag)bytes + (datapoints set value)bytes
 */
//-(NSData *)getAfterSetDatapointData;


/*
 *@discussion-getMethod
 *  getSetFlag,主要是为了获得，设置之后的payload的值，如果为0标示没有设置deviceName和datapoint的值，如果为1标示只有deviceName字符串的设置，如果值为2只有datapoint的设置没有deviceName属性的设置，为3标示既有deviceName的设置也有datapoint的设置
 */
//-(int)getSettedFlag;

/*
 *@discussion-setMethod
 *  重新设置设备的状态,主要是重置设置的标示值，和移除设置的值
 */
-(void)resetDevice;

/**
 *  获得Mac地址的字符串形式，
 *
 *  @return 格式：00:00:11:aa:bb:cc
 */
-(NSString *)getMacAddressString;

/**
 *  获得Mac地址的字符串形式
 *
 *  @return 格式：000011AABBCC
 */
-(NSString *)getMacAddressSimple;

/**
 *  获取内网内设备的通讯地址；
 *  如果设备是云端设备，这个属性返回空
 *
 *  @return 设备内网IP地址，192.168.x.x格式；如果设备是云端设备，这个属性返回空
 */
-(NSString *)getLocalAddress;

#pragma mark
#pragma mark  下面的几个函数是为了在扫描时和同步包返回时用来判断设备的状态和属性的值


/**
 *  获取设备是否被初始化;
 *  初始化的设备可以直接用授权码去连接，默认授权码8888
 *
 *
 *  @return
 */
-(BOOL)getInitStatus;

/**
 *  设备是否被初始化过，也就是说认证码是否被设定过。
 *
 *  @return YES/NO
 */
-(BOOL)isDeviceInitted;

/**
 *  设备是否被绑定过
 *
 *  @return YES/NO
 */
-(BOOL)isDeviceBinded;

//判断设备是否有设备的名字
-(BOOL)isHaveDeviceName;

//判断设备是否有数据节点的值
-(BOOL)isHaveDataPoint;

#pragma mark !!!以下是内部函数，外部程序不要使用!!!

/**
 *  内部函数！设置设备初始化状态
 *
 *  @param init <#init description#>
 */
- (void)setDeviceInit:(BOOL)init;


/**
 *  开始重连这个设备了
 */
//- (void)onConnecting;


/**
 *  设备已经连接上
 */
- (void)onConnected;

/**
 *  设备连接失败
 */
//- (void)onDisconnect;

/**
 *  是否正在连接这个设备
 *
 *  @return YES 正在连接
 */
//- (BOOL)isConnecting;

/**
 *  是否已经和设备连接上
 *
 *  @return 
 */
//- (BOOL)isConnected;


/**
 *  网络状态改变了，全部非手动断开设备重连
 */
-(void)onNetworkChange;

/**
 *  APP重新登录成功，全部未连接上的并非手动断开的设备重新连接
 */
- (void)onAppLogined;

//APP下线，全部设备的云端断开
-(void)onAppLogout;

/**
 *  设置用户断开连接
 */
- (void)userDisconnect;

/**
 *  是否是用户断开连接
 *  如果是用户手动断开的设备，是不会在网络切换时自动连接的
 *
 *  @return YES / NO
 */
- (BOOL)isUserDisconnect;


/**
 *  获取本地Keepalive的时间
 *
 *  @return 
 */
- (int)getLocalKeepAlive;


/**
 *  设置设备的内网地址信息，在收到内网PING的返回包时设置
 */
- (void)setLocalAddress:(NSString *)ip;

@end
