//
//  AboutViewController.m
//  xlinkDemo_oc
//
//  Created by 黄 庆超 on 16/4/15.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController{
    __weak IBOutlet UIImageView *_iconImageView;
    __weak IBOutlet UILabel *_verLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 15;
    
    NSDictionary *localInfo = [[NSBundle mainBundle] infoDictionary];
    _verLabel.text = [NSString stringWithFormat:@"ver %@", [localInfo objectForKey:@"CFBundleShortVersionString"]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
