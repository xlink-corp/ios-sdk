//
//  DataPointEntity.h
//  xlinksdklib
//
//  Created by 黄 庆超 on 16/7/5.
//  Copyright © 2016年 xtmac02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPointEntity : NSObject


/*
 1	布尔类型
 2	单字节(无符号)
 3	16位短整型（有符号）
 4	32位整型（有符号）
 5	浮点
 6	字符串
 7	字节数组
 8	16位短整型（无符号）
 9	32位整型（无符号
 */


@property (assign, nonatomic) uint8_t   index;
@property (assign, nonatomic) uint8_t   type;
@property (assign, nonatomic) uint16_t  len;
@property (strong, nonatomic) id        value;

-(void)setValueData:(NSData *)data;
-(NSData *)getDataPointData;

@end
