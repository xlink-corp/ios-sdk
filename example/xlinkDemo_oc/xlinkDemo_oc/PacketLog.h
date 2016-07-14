//
//  PacketLog.h
//  xlinkDemo
//
//  Created by xtmac on 21/7/15.
//  Copyright (c) 2015年 xtmac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PacketLog : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *data;

-(NSString*)toLogString;

@end
