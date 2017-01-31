//
//  DrawMoneyVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DrawMoneyVC.h"

@interface DrawMoneyVC ()

@property (nonatomic,strong) DrawMoneyView *drawMoneyView;
@property (nonatomic,strong) NSMutableArray *myCardArr;
@property (nonatomic,copy) NSString *myCardID;

@end

@implementation DrawMoneyVC
- (NSMutableArray *)myCardArr {
    if (!_myCardArr) {
        _myCardArr = [NSMutableArray array];
    }return _myCardArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor stringTOColor:@"#f4f4f4"];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"提现金额" andRightImage:nil withRightTitle:nil];
    
    [self myBankCardRequest];
    [self createView];
    
}

- (void)createView {
    DrawMoneyView *view = [[DrawMoneyView alloc]init];
    self.drawMoneyView = view;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(self.view).with.offset(15);
        make.height.mas_equalTo(@170);
    }];
    [view createViewWithMoney:self.currentMoney];
    [view.bankCardBtn addTarget:self action:@selector(bankCardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.drawAllMoneyBtn addTarget:self action:@selector(drawAllMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *drawMoneyBtn = [[UIButton alloc]init];
    drawMoneyBtn.layer.cornerRadius = 5;
    drawMoneyBtn.clipsToBounds = YES;
    drawMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [drawMoneyBtn setBackgroundColor:[UIColor stringTOColor:@"#57a4e3"]];
    [drawMoneyBtn setTitle:@"提现" forState:normal];
    [self.view addSubview:drawMoneyBtn];
    [drawMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(view.mas_bottom).with.offset(50);
        make.height.mas_equalTo(@40);
    }];
    [drawMoneyBtn addTarget:self action:@selector(drawMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

//选择银行卡Btn
- (void)bankCardBtnClick:(UIButton *)sender {
    SelectBankCardVC *selectBankCardVC = [[SelectBankCardVC alloc]init];
    
    selectBankCardVC.myBlock = ^(SelectBankCardModel *selectModel) {
        
        NSRange index = [selectModel.h_card rangeOfString:@"-"];//匹配得到的下标
        NSString *str = [selectModel.h_card substringToIndex:index.location];
        
        NSString *numStr = [selectModel.card substringFromIndex:selectModel.card.length-4];
        
        self.myCardID = selectModel.ID;
        
        [self.drawMoneyView.bankCardBtn setTitle:[NSString stringWithFormat:@"%@ (%@)",str,numStr] forState:normal];
    };
    
    
    [self.navigationController pushViewController:selectBankCardVC animated:YES];
}
//全部提现Btn
- (void)drawAllMoneyBtnClick:(UIButton *)sender {
    self.drawMoneyView.myMoneyTextField.text = [self.currentMoney substringFromIndex:2];

}
//确认提现Btn
- (void)drawMoneyBtnClick:(UIButton *)sender {
    
    if (self.myCardID == nil) {
        [self createAlterViewWithMessage:@"请选择银行卡" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
    }else if (self.drawMoneyView.myMoneyTextField.text == nil || [self.drawMoneyView.myMoneyTextField.text isEqualToString:@"0"] ||[self.drawMoneyView.myMoneyTextField.text isEqualToString:@""]) {
        [self createAlterViewWithMessage:@"提现金额不能为0" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
    }else {
        [self drawMoneyRequest];
    }
}

#pragma mark----request
//银行卡
- (void)myBankCardRequest {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/doc_card"];
    NSDictionary *dic = @{@"username":username};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self myBankCardRequestData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)myBankCardRequestData:(NSDictionary *)dic {
    
    
    if ([dic[@"data"] isEqual:[NSNull null]]) {
        [self.drawMoneyView.bankCardBtn setTitle:@"添加银行卡" forState:normal];
    }else {
        NSArray *dataArr = dic[@"data"];
        
        for (int i = 0; i<dataArr.count; i++) {
            NSDictionary *dic = dataArr[i];
            DrawMoneyModel *model = [DrawMoneyModel DrawMoneyModelWithDic:dic];
            
            NSRange index = [model.h_card rangeOfString:@"-"];//匹配得到的下标
            NSString *str = [model.h_card substringToIndex:index.location];
            
            NSString *numStr = [model.card substringFromIndex:model.card.length-4];
            
            self.myCardID = model.ID;
            
            [self.drawMoneyView.bankCardBtn setTitle:[NSString stringWithFormat:@"%@ (%@)",str,numStr] forState:normal];
            
            [self.myCardArr addObject:model];
        }
    }
    
}

//提现
- (void)drawMoneyRequest {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *usernameStr = [RSAEncryptor encryptString:username publicKey:self.publicKey];
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/get_money"];
    NSDictionary *dic = @{@"username":usernameStr,@"card_id":self.myCardID,@"withdraw_money":self.drawMoneyView.myMoneyTextField.text};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self drawMoneyRequestData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)drawMoneyRequestData:(NSDictionary *)dic {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([dic[@"data"][@"errcode"] integerValue] == 0) {
            
            [self.navigationController pushViewController:[DrawingMoneyVC new] animated:YES];
            
        }
    }];
    
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
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
