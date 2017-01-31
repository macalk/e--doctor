//
//  MyRewardVC.m
//  enuoDoctor
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyRewardVC.h"

@interface MyRewardVC ()

@property (weak, nonatomic) IBOutlet UILabel *monyTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *drawMoneyBtn;

@end

@implementation MyRewardVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self myMoneyRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.drawMoneyBtn.layer.cornerRadius = 5;
    self.drawMoneyBtn.clipsToBounds = YES;
    
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"我的打赏" andRightImage:nil withRightTitle:@"提现明细"];
    
    [self.drawMoneyBtn addTarget:self action:@selector(drawMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

//提现按钮
- (void)drawMoneyBtnClick:(UIButton *)sender {
//    FirstDrawMoneyVC *firstDrawMoneyVC = [[FirstDrawMoneyVC alloc]init];
//    [self.navigationController pushViewController:firstDrawMoneyVC animated:YES];
    
    DrawMoneyVC *drawMoneyVC = [[DrawMoneyVC alloc]init];
    drawMoneyVC.currentMoney = self.monyTextLabel.text;
    [self.navigationController pushViewController:drawMoneyVC animated:YES];

}

- (void)rightItemClick {
    [self.navigationController pushViewController:[DrawMoneyDetailVC new] animated:YES];
}

#pragma mark--- request
- (void)myMoneyRequest {
    
    NSString *ursername = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/doc_money"];
    
    NSDictionary *dic = @{@"username":ursername};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self myMoneyRequestData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)myMoneyRequestData:(NSDictionary *)dic {
    NSString *money = dic[@"data"];
    
    self.monyTextLabel.text = [NSString stringWithFormat:@"¥ %@",money];
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
