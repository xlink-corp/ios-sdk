//
//  EventNotifyRetPacket.h
//  xlinksdklib
//
//  Created by 黄 庆超 on 2016/12/12.
//  Copyright © 2016年 xtmac02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventNotifyRetPacket : NSObject

@property (nonatomic, assign) UInt8     notifyFlag;
@property (nonatomic, assign) int32_t   fromID;
@property (nonatomic, assign) UInt16    msgID;
@property (nonatomic, assign) UInt16    msgType;
@property (nonatomic, strong) NSData    *notifyData;

-(instancetype)initWithData:(NSData *)data;

@end
