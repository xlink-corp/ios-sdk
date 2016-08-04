//
//  ValueTableViewCell.m
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/6/8.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "ValueTableViewCell.h"

@implementation ValueTableViewCell{
    __weak  IBOutlet    UILabel     *_indexLabel;
    __weak  IBOutlet    UILabel     *_nameLanel;
    __weak  IBOutlet    UISlider    *_valueSlider;
    __weak  IBOutlet    UILabel     *_valueLabel;
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

-(NSNumber *)value{
    NSNumber *value = @(1);
    if (_type == 2){
        //unsigned char
        value = @(_valueSlider.value * (_max.unsignedCharValue - _min.unsignedCharValue) + _min.unsignedCharValue);
        value = @(value.unsignedCharValue);
    }else if (_type == 3){
        //Int16
        value = @(_valueSlider.value * (_max.shortValue - _min.shortValue) + _min.shortValue);
        value = @(value.shortValue);
    }else if (_type == 8){
        //unsigned Int16
        value = @(_valueSlider.value * (_max.unsignedShortValue - _min.unsignedShortValue) + _min.unsignedShortValue);
        value = @(value.unsignedShortValue);
    }else if (_type == 4){
        //Int32
        value = @(_valueSlider.value * (_max.intValue - _min.intValue) + _min.intValue);
        value = @(value.intValue);
    }else if (_type == 9){
        //unsigned Int32
        value = @(_valueSlider.value * (_max.unsignedIntValue - _min.unsignedIntValue) + _min.unsignedIntValue);
        value = @(value.unsignedIntValue);
    }else if (_type == 5){
        //float
        value = @(_valueSlider.value * (_max.floatValue - _min.floatValue) + _min.floatValue);
    }
    
    return value;
}

-(void)setValue:(NSNumber *)value{
    
    [self setValueLabelText:value];
    
    float sliderValue = 0;
    
    if (_type == 2){
        //unsigned char
        sliderValue = (value.unsignedCharValue - _min.unsignedCharValue) / 1.0 / (_max.unsignedCharValue - _min.unsignedCharValue);
    }else if (_type == 3){
        //Int16
        sliderValue = (value.shortValue - _min.shortValue) / 1.0 / (_max.shortValue - _min.shortValue);
    }else if (_type == 8){
        //unsigned Int16
        sliderValue = (value.unsignedShortValue - _min.unsignedShortValue) / 1.0 / (_max.unsignedShortValue - _min.unsignedShortValue);
    }else if (_type == 4){
        //Int32
        sliderValue = (value.intValue - _min.intValue) / 1.0 / (_max.intValue - _min.intValue);
    }else if (_type == 9){
        //unsigned Int32
        sliderValue = (value.unsignedIntValue - _min.unsignedIntValue) / 1.0 / (_max.unsignedIntValue - _min.unsignedIntValue);
    }else if (_type == 5){
        //float
        sliderValue = (value.floatValue - _min.floatValue) / (_max.floatValue - _min.floatValue);
    }
    
    _valueSlider.value = sliderValue;
}

-(uint8_t)len{
    uint8_t len = 0;
    
    if (_type == 2) {
        len = 1;
    }else if (_type == 3 || _type == 8){
        len = 2;
    }else if (_type == 4 || _type == 9 || _type == 5){
        len = 4;
    }
    
    return len;
}

-(void)setValueLabelText:(NSNumber *)number{
    if (_type == 2){
        //unsigned char
        _valueLabel.text = number.stringValue;
    }else if (_type == 3){
        //Int16
        _valueLabel.text = [NSString stringWithFormat:@"%d", number.shortValue];
    }else if (_type == 8){
        //unsigned Int16
        _valueLabel.text = number.stringValue;
    }else if (_type == 4){
        //Int32
        NSString *t = [NSString stringWithFormat:@"%d", number.intValue];
        NSLog(@"~~~~~%@", t);
        _valueLabel.text = t;
    }else if (_type == 9){
        //unsigned Int32
        _valueLabel.text = number.stringValue;
    }else if (_type == 5){
        //float
        _valueLabel.text = number.stringValue;
    }
}

-(IBAction)sliderValueChange{
    [self setValueLabelText:[self value]];
}

-(IBAction)sliderTouchUp{
    [self setValueLabelText:[self value]];
    if ([_delegate respondsToSelector:@selector(valueChangeWithTableViewCell:)]) {
        [_delegate valueChangeWithTableViewCell:self];
    }
}

@end
