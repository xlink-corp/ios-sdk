//
//  TextImageBarButtonItem.m
//  LEEDARSON_SmartHome
//
//  Created by xtmac on 15/7/15.
//  Copyright (c) 2015年 xtmac. All rights reserved.
//

#import "TextImageBarButtonItem.h"

#define BARBUTTONITEMHEIGHT 30
#define IMAGEVIEWSIZE 15
#define INTERVAL 0
#define FONTSIZE 22
#define SPACING 3

@implementation TextImageBarButtonItem{
    UIControl *_mainControl;
    UILabel *_textLabel;
    UIImageView *_imageView;
    
    NSLayoutConstraint *_leftMarginConstraint, *_spacingConstraint;
}

-(id)initWithText:(NSString *)text{
    return [self initWithText:text withImage:nil];
}

-(id)initWithImage:(UIImage *)image{
    return [self initWithText:nil withImage:image];
}

-(id)initWithText:(NSString *)text withImage:(UIImage *)image{
    return [self initWithText:text withImage:image withTarget:nil withAction:nil];
}

-(id)initWithText:(NSString *)text withTarget:(id)target withAction:(SEL)action{
    return [self initWithText:text withImage:nil withTarget:target withAction:action];
}

-(id)initWithImage:(UIImage *)image withTarget:(id)target withAction:(SEL)action{
    return [self initWithText:nil withImage:image withTarget:target withAction:action];
}

-(id)initWithText:(NSString *)text withImage:(UIImage *)image withTarget:(id)target withAction:(SEL)action{
    _mainControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 0, BARBUTTONITEMHEIGHT)];
    
    [_mainControl addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (self = [super initWithCustomView:_mainControl]) {
        [self setText:text];
        [self setImage:image];
    }
    return self;
}

-(void)setTextImaheBarButtonItemMode:(TextImageBarButtonItemMode)textImaheBarButtonItemMode{
    [_mainControl removeConstraint:_leftMarginConstraint];
    [_mainControl removeConstraint:_spacingConstraint];
    _textImaheBarButtonItemMode = textImaheBarButtonItemMode;
    
    UIView *v1, *v2;
    if (_textImaheBarButtonItemMode == LeftTextRightImageModel) {
        v1 = _textLabel;
        v2 = _imageView;
    }else{
        v1 = _imageView;
        v2 = _textLabel;
    }
    
    
    
    if (v1 && v2) {
        _leftMarginConstraint = [NSLayoutConstraint constraintWithItem:v1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_mainControl attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        _spacingConstraint = [NSLayoutConstraint constraintWithItem:v2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:v1 attribute:NSLayoutAttributeRight multiplier:1 constant:SPACING];
        [_mainControl addConstraint:_spacingConstraint];
    }else if (v1){
        _leftMarginConstraint = [NSLayoutConstraint constraintWithItem:v1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_mainControl attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        _spacingConstraint = nil;
    }else if (v2){
        _leftMarginConstraint = [NSLayoutConstraint constraintWithItem:v2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_mainControl attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        _spacingConstraint = nil;
    }
    [_mainControl addConstraint:_leftMarginConstraint];
}

-(void)setText:(NSString *)text{
    if (text && text.length) {
        if (!_textLabel) {
            _textLabel = [[UILabel alloc] init];
            _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [_mainControl addSubview:_textLabel];
            
            [_textLabel setTextColor:[UIColor whiteColor]];
            
            //y轴中心
            [_mainControl addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_mainControl attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            
            [self setTextImaheBarButtonItemMode:_textImaheBarButtonItemMode];
            [self mainViewSizeOfSize];
        }
        _textLabel.text = text;
        [_textLabel sizeToFit];
    }else{
        [_textLabel removeFromSuperview];
        _textLabel = nil;
    }
}

-(NSString *)text{
    return _textLabel.text;
}

-(void)setImage:(UIImage *)image{
    if (image) {
        if (!_imageView) {
            _imageView = [[UIImageView alloc] init];
            
            _imageView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [_mainControl addSubview:_imageView];
            
            //高度
            [_imageView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:IMAGEVIEWSIZE]];
            //宽度
            [_imageView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:IMAGEVIEWSIZE]];
            //y轴中心
            [_mainControl addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_mainControl attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            
            [self setTextImaheBarButtonItemMode:_textImaheBarButtonItemMode];
            [self mainViewSizeOfSize];
        }
        _imageView.image = image;
    }else{
        [_imageView removeFromSuperview];
        _imageView = nil;
    }
}

-(UIImage *)image{
    return _imageView.image;
}

-(void)mainViewSizeOfSize{
    
    if (_imageView && _textLabel) {
        _mainControl.frame = CGRectMake(0, 0, _textLabel.frame.size.width + IMAGEVIEWSIZE + SPACING, BARBUTTONITEMHEIGHT);
    }else if (_imageView){
        _mainControl.frame = CGRectMake(0, 0, IMAGEVIEWSIZE, BARBUTTONITEMHEIGHT);
    }else if (_textLabel){
        _mainControl.frame = CGRectMake(0, 0, _textLabel.frame.size.width, BARBUTTONITEMHEIGHT);
    }
    
    
    
    
}

@end
