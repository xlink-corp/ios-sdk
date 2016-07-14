//
//  AddPacketViewController.h
//  xlinkDemo
//
//  Created by xtmac on 27/6/15.
//  Copyright (c) 2015年 xtmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddPacketViewController <NSObject>

-(void)sendNowWithHexCode:(NSString*)hexCode;

@end

@interface AddPacketViewController : UIViewController

@property (assign, nonatomic) id <AddPacketViewController> delegate;

@end
