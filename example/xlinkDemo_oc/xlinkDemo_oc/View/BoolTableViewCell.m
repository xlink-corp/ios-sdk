//
//  BoolTableViewCell.m
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/6/8.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "BoolTableViewCell.h"

@implementation BoolTableViewCell{
    __weak  IBOutlet    UILabel *_indexLabel;
    __weak  IBOutlet    UILabel *_nameLanel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIndex:(uint8_t)index{
    _index = index;
    _indexLabel.text = @(index).stringValue;
}

-(void)setName:(NSString *)name{
    _name = name;
    _nameLanel.text = name;
}

-(IBAction)switchBtnValueChange{
    if ([_delegate respondsToSelector:@selector(boolTableViewCell:onSwitchValueChange:)]) {
        [_delegate boolTableViewCell:self onSwitchValueChange:_switchBtn];
    }
}

@end
