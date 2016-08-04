//
//  SendAndRecvPacketViewController.m
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/4/15.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "SendAndRecvPacketViewController.h"
#import "AddPacketViewController.h"
#import "DeviceTabBarViewController.h"

#import "XLinkExportObject.h"
#import "DeviceEntity.h"
#import "TextImageBarButtonItem.h"
#import "PacketLog.h"

@interface SendAndRecvPacketViewController ()<UITableViewDelegate, UITableViewDataSource, AddPacketViewController>

@end

@implementation SendAndRecvPacketViewController{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UITextView *_logTextView;
    NSMutableArray  *_logArr;
    NSArray         *_hexCodePacketArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSendPipeData:) name:kOnSendPipeData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSendLocalPipeData:) name:kOnSendLocalPipeData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRecvLocalPipeData:) name:kOnRecvLocalPipeData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRecvPipeData:) name:kOnRecvPipeData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRecvSyncPipeData:) name:kOnRecvPipeSyncData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocalDataPoint2Update:) name:kOnLocalDataPoint2Update object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloudDataPoint2Update:) name:kOnCloudDataPoint2Update object:nil];
    
    _logArr = [NSMutableArray array];
    
    _logTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    [_tableView setSeparatorColor:[UIColor colorWithRed:0x7c / 255.0 green:0x9b / 255.0 blue:0xb1 / 255.0 alpha:1]];
    
//    TextImageBarButtonItem *statusItem = [[TextImageBarButtonItem alloc] initWithText:[NSString stringWithFormat:@"%@", title] withImage:[UIImage imageNamed:[NSString stringWithFormat:@"IsConnected_%d", _deviceEntity.connectStatus & ConnectStatusLANAndWANConnectSuccessfully]]];
//    [statusItem setTextImaheBarButtonItemMode:LeftImageRightTextModel];
//    self.navigationItem.rightBarButtonItem = statusItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _hexCodePacketArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"hexCodePacket"];
    [_tableView reloadData];
}

-(IBAction)addPacketBtnAction{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddPacketViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AddPacketViewController"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:true];
}

-(void)updateLogTextView{
    NSMutableString *log = [NSMutableString string];
    for (NSUInteger i = 0; i < _logArr.count - 1; i++) {
        PacketLog *packetLog = _logArr[i];
        [log appendString:[packetLog toLogString]];
        [log appendString:@"\r\n"];
    }
    PacketLog *packetLog = _logArr.lastObject;
    [log appendString:[packetLog toLogString]];
    [_logTextView setText:log];
    /*
     
     [_logTextView setContentOffset:CGPointMake(0, _logTextView.contentSize.height - 242 + 64)];
     NSLog(@"%f  -  %f  -  %f", _logTextView.contentSize.height, _logTextView.contentOffset.y, _logTextView.frame.size.height);
     */
    // 自动滚动到最下面的方法，出处：
    // http://stackoverflow.com/questions/3171563/ios4-cant-programmatically-scroll-to-bottom-of-uitextview
    [_logTextView scrollRangeToVisible:NSMakeRange([_logTextView.text length], 0)];
}

-(void)addLog:(NSString*)log withTitle:(NSString*)title {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    PacketLog *packetLog = [[PacketLog alloc] init];
    packetLog.date = [dateFormatter stringFromDate:[NSDate date]];
    packetLog.title = title;
    
    NSMutableString *temp = [NSMutableString string];
    for (NSUInteger i = 0; i < log.length; i++) {
        if (i && !(i % 2)) {
            [temp appendString:@" "];
        }
        [temp appendString:[log substringWithRange:NSMakeRange(i, 1)]];
    }
    packetLog.data = [NSString stringWithString:temp];
    [_logArr addObject:packetLog];
    while (_logArr.count > 50) {
        [_logArr removeObjectAtIndex:0];
    }
    
    [self updateLogTextView];
}

-(void)addRecvLog:(NSDictionary *)dict {
    NSString * log = [dict objectForKey:@"log"];
    NSString * from = [dict objectForKey:@"from"];
    [self addLog:log withTitle:[NSString stringWithFormat:@"Recv %@ data:", from]];
}

- (NSData*)hexToData:(NSString *)hexString {
    
    NSUInteger len = hexString.length / 2;
    const char *hexCode = [hexString UTF8String];
    char * bytes = (char *)malloc(len);
    
    char *pos = (char *)hexCode;
    for (NSUInteger i = 0; i < hexString.length / 2; i++) {
        sscanf(pos, "%2hhx", &bytes[i]);
        pos += 2 * sizeof(char);
    }
    
    NSData * data = [[NSData alloc] initWithBytes:bytes length:len];
    
    free(bytes);
    return data;
}

-(void)sendHexCode:(NSString*)hexCode{
    
    DeviceTabBarViewController *tabBar = (DeviceTabBarViewController *)self.tabBarController;
    
    NSData *data = [self hexToData:hexCode];
    
    int msgID = 0;
    if (tabBar.device.connectStatus & ConnectStatusLANConnectSuccessfully) {
        msgID = [[XLinkExportObject sharedObject] sendLocalPipeData:tabBar.device andPayload:data];
        if( msgID > 0 ) {
            // 发送成功
            [self addLog:hexCode withTitle:[NSString stringWithFormat:@"Send Local Data ID:%d", msgID]];
        } else {
            // 发送失败
            NSString * log = [NSString stringWithFormat:@"Fail(Code:%d)", msgID];
            [self addLog:nil withTitle:[NSString stringWithFormat:@"Send Local Data\r\n%@", log]];
        }
    }
    if (tabBar.device.connectStatus & ConnectStatusWANConnectSuccessfully) {
        msgID = [[XLinkExportObject sharedObject] sendPipeData:tabBar.device andPayload:data];
        if( msgID > 0 ) {
            // 发送成功
            [self addLog:hexCode withTitle:[NSString stringWithFormat:@"Send Cloud Data ID:%d", msgID]];
        } else {
            // 发送失败
            NSString * log = [NSString stringWithFormat:@"Fail(Code:%d)", msgID];
            [self addLog:nil withTitle:[NSString stringWithFormat:@"Send Cloud Data\r\n%@", log]];
        }
    }
}


-(void)handLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UITableViewCell *cell = (UITableViewCell*)gestureRecognizer.view;
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        
        [self showExtendMenu:indexPath];
    }
}

-(void)showExtendMenu:(NSIndexPath *)indexPath {
    UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *deviceCommandAction = [UIAlertAction actionWithTitle:@"删除该指令" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否删除此指令" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:_hexCodePacketArr];
            [temp removeObjectAtIndex:indexPath.row];
            _hexCodePacketArr = [NSArray arrayWithArray:temp];
            [[NSUserDefaults standardUserDefaults] setObject:_hexCodePacketArr forKey:@"hexCodePacket"];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    //    UIAlertAction *batchSendCommand = [UIAlertAction actionWithTitle:@"测试批量发送指令" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //
    //        NSDictionary *hexCodePacketDic = _hexCodePacketArr[indexPath.row];
    //        NSString *hexCode = [hexCodePacketDic objectForKey:@"hexCode"];
    //
    //        [self startSendHexCode:hexCode];
    //    }];
    
    [sheetController addAction:cancelAction];
    [sheetController addAction:deviceCommandAction];
    //    [sheetController addAction:batchSendCommand];
    
    [self presentViewController:sheetController animated:YES completion:nil];
}

#pragma mark
#pragma mark AddPacketViewController Delegate
-(void)sendNowWithHexCode:(NSString *)hexCode{
    [self sendHexCode:hexCode];
}

#pragma mark
#pragma mark UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _hexCodePacketArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handLongPress:)];
        [cell addGestureRecognizer:longPress];
        [cell setBackgroundColor:[UIColor clearColor]];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0x3a / 255.0 green:0xba / 255.0 blue:0xe4 / 255.0 alpha:1];
    }
    NSDictionary *hexCodePacketDic = _hexCodePacketArr[indexPath.row];
    
    cell.textLabel.text = [hexCodePacketDic objectForKey:@"name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *hexCodePacketDic = _hexCodePacketArr[indexPath.row];
    NSString *hexCode = [hexCodePacketDic objectForKey:@"hexCode"];
    
    [self sendHexCode:hexCode];
}

#pragma mark
#pragma mark XlinkExportObject Delegate Notification
-(void)onSendPipeData:(NSNotification*)notify {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:notify.object];
    [dict setValue:@"Cloud" forKeyPath:@"from"];
    [self performSelectorOnMainThread:@selector(notifySendPipeResult:) withObject:dict waitUntilDone:NO];
}

-(void)onSendLocalPipeData:(NSNotification*)notify {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:notify.object];
    [dict setValue:@"Local" forKeyPath:@"from"];
    [self performSelectorOnMainThread:@selector(notifySendPipeResult:) withObject:dict waitUntilDone:NO];
}

- (void)notifySendPipeResult:(NSMutableDictionary*)dict {
    
    int result = [[dict objectForKey:@"result"] intValue];
    NSString *from = [dict objectForKey:@"from"];
    if (result == 0){
        [self addLog:nil withTitle:[NSString stringWithFormat:@"Send %@ Data\r\nSuccess", from]];
        
    }else{
        NSString *log = [NSString stringWithFormat:@"Fail(Code:%d)", result];
        [self addLog:nil withTitle:[NSString stringWithFormat:@"Send %@ Data\r\n%@", from, log]];
    }
}

- (void)onRecvLocalPipeData:(NSNotification*)notify{
    [self notifyRecvData:notify from:@"Local"];
}

- (void)onRecvSyncPipeData:(NSNotification*)notify {
    [self notifyRecvData:notify from:@"Sync"];
}

- (void)onRecvPipeData:(NSNotification *)notify {
    [self notifyRecvData:notify from:@"Cloud"];
}

-(void)onLocalDataPoint2Update:(NSNotification *)noti{
//    [self notifyRecvData:noti from:@"Local DataPoint"];
}

-(void)onCloudDataPoint2Update:(NSNotification *)noti{
//    [self notifyRecvData:noti from:@"Cloud DataPoint"];
}

- (void)notifyRecvData:(NSNotification *)notify from:(NSString *)from {
    NSData *payload = [notify.object objectForKey:@"payload"];
    NSMutableString *hexCode = [NSMutableString string];
    NSMutableString *hexData = [NSMutableString string];
    for (NSUInteger i = 0; i < payload.length; i++) {
        const char chr = ((const char *)payload.bytes)[i];
        [hexCode appendFormat:@"%02hhX", chr];
        [hexData appendFormat:@"%02X", (Byte)chr];
    }
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:from, @"from", hexCode, @"log", nil];
    [self performSelectorOnMainThread:@selector(addRecvLog:) withObject:dict waitUntilDone:NO];
}

-(void)showWarningAlert:(NSString *)msg didFinish:(void (^)(void))finish{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (finish != nil) {
            finish();
        }
    }];
    [alertController addAction:okAction];
    [self.navigationController.topViewController presentViewController:alertController animated:true completion:nil];
}

@end

/*
 00 00 01 f8
 01 00 01 af
 02 10 02 32d5
 03 30 04 009896fd
 04 90 18 e794b5e9 a5ade994 85656c65 63747269 632063
 
 00 00 01 8e
 01 00 01 45
 02 10 02 326b
 03 30 04 00989693
 04 90 18 e794b5e9 a5ade994 85656c65 63747269 632063
 
 00 00 01 d7
 01 00 01 8e
 02 10 02 32b4
 03 30 04 009896dc
 04 90 18 e794b5e9 a5ade994 85656c65 63747269 6320636f 6f6b6572
 */
