//
//  AddPacketViewController.m
//  xlinkDemo
//
//  Created by xtmac on 27/6/15.
//  Copyright (c) 2015年 xtmac. All rights reserved.
//

#import "AddPacketViewController.h"

@interface AddPacketViewController (){
    __weak IBOutlet UITextView *_hexCodeTextView;
    NSMutableString *_hexCode;
}

@end

@implementation AddPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _hexCode = [NSMutableString string];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveItemAction)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    _hexCodeTextView.layoutManager.allowsNonContiguousLayout = NO;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setHexCodeTextView:(NSString*)str{
    NSMutableString *hexCode = [NSMutableString string];
    for (NSUInteger i = 0; i < str.length; i++) {
        if (i && !(i % 2)) {
            [hexCode appendString:@" "];
        }
        [hexCode appendString:[str substringWithRange:NSMakeRange(i, 1)]];
    }
    _hexCodeTextView.text = hexCode;
}

- (IBAction)hexCodeBtnAction:(UIButton *)sender {
    [_hexCode appendString:sender.titleLabel.text];
    [self setHexCodeTextView:_hexCode];
}

- (IBAction)backSpaceBtnAction{
    if (_hexCode.length) {
        [_hexCode deleteCharactersInRange:NSMakeRange(_hexCode.length - 1, 1)];
        [self setHexCodeTextView:_hexCode];
    }
}

- (IBAction)sendNowBtnAction {
    do {
        if (!_hexCode.length) {
            [self showWarningAlert:@"要发送的数据不能为空" didFinish:nil];
            break;
        }
        
        if (_hexCode.length % 2) {
            [self showWarningAlert:@"发送的数据格式错误，数据必须要是偶数位" didFinish:nil];
            break;
        }
        
        if ([_delegate respondsToSelector:@selector(sendNowWithHexCode:)]) {
            [_delegate sendNowWithHexCode:_hexCode];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } while (0);
    
    
    
}

-(void)saveItemAction{
    
    do {
        if (!_hexCode.length) {
            [self showWarningAlert:@"要发送的数据不能为空" didFinish:nil];
            break;
        }
        
        if (_hexCode.length % 2) {
            [self showWarningAlert:@"要发送的数据不能为空" didFinish:nil];            break;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入指令名称" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入指令的名称";
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        __weak id weakSelf = self;
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *name = ((UITextField*)alertController.textFields.firstObject).text;
            [weakSelf saveWithName:name];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } while (0);
    
    
}

#pragma mark
#pragma mark UIAlertController Action
-(void)saveWithName:(NSString*)name{
    do {
        if (!name || !name.length) {
            [self showWarningAlert:@"要发送的数据不能为空" didFinish:nil];
            break;
        }
        
        if (name.length > 20) {
            [self showWarningAlert:@"要发送的数据不能为空" didFinish:nil];
            break;
        }
        
        NSMutableArray *hexCodePacketArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"hexCodePacket"]];
        
        NSMutableArray *allName = [NSMutableArray array];
        for (NSDictionary *hexCodePacketDic in hexCodePacketArr) {
            [allName addObject:[hexCodePacketDic objectForKey:@"name"]];
        }
        
        if ([allName containsObject:name]) {
            [self showWarningAlert:@"要发送的数据不能为空" didFinish:nil];
            break;
        }
        
        NSDictionary *hexCodePacketDic = @{@"name" : name, @"hexCode" : _hexCode};
        
        [hexCodePacketArr addObject:hexCodePacketDic];
        
        [[NSUserDefaults standardUserDefaults] setObject:hexCodePacketArr forKey:@"hexCodePacket"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } while (0);
}

-(void)showWarningAlert:(NSString *)msg{
    [self showWarningAlert:msg didFinish:nil];
}

-(void)showWarningAlert:(NSString *)msg didFinish:(void (^)(void))finish{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (finish != nil) {
            finish();
        }
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:true completion:nil];
}

@end
