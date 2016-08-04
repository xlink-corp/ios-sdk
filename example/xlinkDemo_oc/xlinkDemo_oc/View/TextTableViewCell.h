//
//  TextTableViewCell.h
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/6/8.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextTableViewCell;

@protocol TextTableViewCellDelegate <NSObject>

-(void)textTableViewCell:(TextTableViewCell *)cell onSetWithText:(NSString *)text;

@end

@interface TextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField    *textFiled;

@property (assign, nonatomic) id <TextTableViewCellDelegate> delegate;
@property (assign, nonatomic) uint8_t   index;
@property (strong, nonatomic) NSString  *name;

@end
