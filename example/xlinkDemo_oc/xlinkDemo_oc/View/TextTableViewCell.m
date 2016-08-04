//
//  TextTableViewCell.m
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/6/8.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "TextTableViewCell.h"

@interface TextTableViewCell ()<UITextFieldDelegate>

@end

@implementation TextTableViewCell{
    __weak  IBOutlet    UILabel *_indexLabel;
    __weak  IBOutlet    UILabel *_nameLanel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _textFiled.delegate = self;
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

-(IBAction)setBtnAction{
    [self endEditing:YES];
    if ([_delegate respondsToSelector:@selector(textTableViewCell:onSetWithText:)]) {
        [_delegate textTableViewCell:self onSetWithText:_textFiled.text];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return NO;
}

@end
