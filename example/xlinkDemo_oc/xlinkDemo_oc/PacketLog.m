//
//  PacketLog.m
//  xlinkDemo
//
//  Created by xtmac on 21/7/15.
//  Copyright (c) 2015年 xtmac. All rights reserved.
//

#import "PacketLog.h"

@implementation PacketLog

-(NSString *)toLogString{
    if (_data && _data.length) {
        return [NSString stringWithFormat:@"%@ - %@\r\n%@", _date, _title, _data];
    }
    return [NSString stringWithFormat:@"%@ - %@", _date, _title];
}

@end
