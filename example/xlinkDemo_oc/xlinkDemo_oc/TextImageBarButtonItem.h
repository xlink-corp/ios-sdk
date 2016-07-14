//
//  TextImageBarButtonItem.h
//  LEEDARSON_SmartHome
//
//  Created by xtmac on 15/7/15.
//  Copyright (c) 2015年 xtmac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    LeftTextRightImageModel,
    LeftImageRightTextModel
}TextImageBarButtonItemMode;

@interface TextImageBarButtonItem : UIBarButtonItem

@property (assign, nonatomic) TextImageBarButtonItemMode textImaheBarButtonItemMode;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;


-(id)initWithText:(NSString*)text;
-(id)initWithImage:(UIImage*)image;
-(id)initWithText:(NSString*)text withImage:(UIImage*)image;
-(id)initWithText:(NSString*)text withTarget:(id)target withAction:(SEL)action;
-(id)initWithImage:(UIImage*)image withTarget:(id)target withAction:(SEL)action;
-(id)initWithText:(NSString*)text withImage:(UIImage*)image withTarget:(id)target withAction:(SEL)action;


@end
