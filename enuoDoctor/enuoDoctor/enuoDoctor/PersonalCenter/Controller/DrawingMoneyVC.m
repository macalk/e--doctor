//
//  DrawingMoneyVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DrawingMoneyVC.h"

@interface DrawingMoneyVC ()

@end

@implementation DrawingMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"提现详情" andRightImage:nil withRightTitle:nil];
    
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.font = [UIFont systemFontOfSize:13];
    titleLable.textColor = [UIColor blackColor];
    titleLable.text = @"您已提交 处理中···";
    [self.view addSubview:titleLable];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"提现中"];
    [self.view addSubview:imageView];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(100);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleLable.mas_left).with.offset(-5);
        make.centerY.equalTo(titleLable);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

- (void)leftItemBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
