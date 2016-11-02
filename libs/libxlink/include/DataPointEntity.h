//
//  DataPointEntity.h
//  xlinksdklib
//
//  Created by 黄 庆超 on 16/7/5.
//  Copyright © 2016年 xtmac02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPointEntity : NSObject

@property (assign, nonatomic) uint8_t   index;
@property (assign, nonatomic) uint8_t   type;
@property (assign, nonatomic) uint16_t  len;
@property (strong, nonatomic) id        value;

-(void)setValueData:(NSData *)data;
-(NSData *)getDataPointData;

@end
