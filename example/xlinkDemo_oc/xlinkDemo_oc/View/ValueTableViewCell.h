//
//  ValueTableViewCell.h
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/6/8.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ValueTableViewCell;

@protocol ValueTableViewCellDelegate <NSObject>

-(void)valueChangeWithTableViewCell:(ValueTableViewCell *)cell;

@end

@interface ValueTableViewCell : UITableViewCell

@property (assign, nonatomic) id <ValueTableViewCellDelegate> delegate;
@property (assign, nonatomic) uint8_t   index;
@property (assign, nonatomic) uint8_t   type;
@property (strong, nonatomic) NSString  *name;

@property (strong, nonatomic) NSNumber *min;
@property (strong, nonatomic) NSNumber *max;
@property (assign, nonatomic, readonly) uint8_t len;
@property (strong, nonatomic) NSNumber *value;

@end
