//
//  ViewController.m
//  WMUIVersionUpdate
//
//  Created by 吳梓杭 on 2019/8/15.
//  Copyright © 2019 吳梓杭. All rights reserved.
//

#import "ViewController.h"
#import "WMUIVersionUpdateCheck.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColor.redColor;
    [button setTitle:@"检查更新" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button addTarget:self action:@selector(drawIndexed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)drawIndexed {
    [WMUIVersionUpdateCheck checkResult];
}


@end
