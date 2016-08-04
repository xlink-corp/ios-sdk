//
//  BoolTableViewCell.h
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/6/8.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoolTableViewCell;

@protocol BoolTableViewCellDelegate <NSObject>

-(void)boolTableViewCell:(BoolTableViewCell *)cell onSwitchValueChange:(UISwitch *)switchBtn;

@end

@interface BoolTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch   *switchBtn;

@property (assign, nonatomic) id <BoolTableViewCellDelegate> delegate;

@property (assign, nonatomic) uint8_t   index;
@property (strong, nonatomic) NSString  *name;

@end
