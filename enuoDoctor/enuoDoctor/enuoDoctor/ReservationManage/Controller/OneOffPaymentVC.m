//
//  OneOffPaymentVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OneOffPaymentVC.h"

@interface OneOffPaymentVC ()

@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,copy) NSString *yb;

@property (nonatomic,strong) UILabel *lastPirceLabel;
@property (nonatomic,strong) UILabel *lineLabel;
@property (nonatomic,strong) UITextField *priceTextField;
@property (nonatomic,copy) NSString *publicKey;


@end

@implementation OneOffPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *yb = [[NSUserDefaults standardUserDefaults]objectForKey:@"yb"];
    self.yb = yb;
    
    [self getPublicKey];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"一次性支付" andRightImage:nil withRightTitle:nil];
    
    [self createView];
}
- (void)leftItemBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView {
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.textColor = [UIColor stringTOColor:@"#363636"];
    [priceLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    priceLabel.text = [NSString stringWithFormat:@"约 定 价 格 ：¥ %@",self.priceStr];
    [self.view addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.top.equalTo(self.view).with.offset(12);
    }];
    
    UILabel *ybLabel = [[UILabel alloc]init];
    ybLabel.font = [UIFont systemFontOfSize:13];
    ybLabel.text = @"医保选择：";
    [self.view addSubview:ybLabel];
    [ybLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.top.equalTo(priceLabel.mas_bottom).with.offset(15);
    }];
    
    
    for (int i = 0; i<2; i++) {
        UIButton *ybBtn = [[UIButton alloc]init];
        [ybBtn setImage:[UIImage imageNamed:@"未选"] forState:normal];
        [ybBtn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateSelected];
        ybBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [ybBtn addTarget:self action:@selector(ybBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [ybBtn setTitleColor:[UIColor blackColor] forState:normal];
        [self.view addSubview:ybBtn];
        if (i == 0) {
            [ybBtn setTitle:@" 是" forState:normal];
            self.selectBtn = ybBtn;
            ybBtn.selected = YES;
        }else {
            [ybBtn setTitle:@" 否" forState:normal];
        }
        
        [ybBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ybLabel.mas_right).with.offset(10+50*i);
            make.centerY.equalTo(ybLabel);
            make.size.mas_equalTo(CGSizeMake(40,20));
        }];
        
        if ([self.yb isEqualToString:@"无"]) {
            ybBtn.hidden = YES;
        }
    }
    
    UILabel *lastPriceLabel = [[UILabel alloc]init];
    self.lastPirceLabel = lastPriceLabel;
    lastPriceLabel.font = [UIFont systemFontOfSize:13];
    lastPriceLabel.text = @"预交金额： ¥";
    [self.view addSubview:lastPriceLabel];
    [lastPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.top.equalTo(ybLabel.mas_bottom).with.offset(15);
    }];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    self.lineLabel = lineLabel;
    lineLabel.backgroundColor = [UIColor stringTOColor:@"#9d9d9d"];
    [self.view addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastPriceLabel);
        make.left.equalTo(lastPriceLabel.mas_right).with.offset(-20);
        make.size.mas_offset(CGSizeMake(100, 0.5));
    }];
    
    UITextField *priceTextField = [[UITextField alloc]init];
    self.priceTextField = priceTextField;
    priceTextField.font = [UIFont systemFontOfSize:13];
    priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    priceTextField.placeholder = @"请输入金额";
    [self.view addSubview:priceTextField];
    [priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lastPriceLabel);
        make.left.equalTo(lastPriceLabel.mas_right).with.offset(5);
        make.right.equalTo(lineLabel);
    }];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn.backgroundColor = [UIColor stringTOColor:@"#63ade9"];
    [sureBtn setTitle:@"提交" forState:normal];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.clipsToBounds = YES;
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:normal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(@30);
        make.top.equalTo(priceLabel.mas_bottom).with.offset(88);
    }];
    
    
    if ([self.yb isEqualToString:@"无"]) {
        ybLabel.hidden = YES;
        lastPriceLabel.hidden = YES;
        lineLabel.hidden = YES;
        priceTextField.hidden = YES;
    }


}

- (void)ybBtnClick:(UIButton *)sender {
    self.selectBtn.selected = NO;
    sender.selected = YES;
    self.selectBtn = sender;
    
    if ([sender.currentTitle isEqualToString:@" 否"]) {
        self.lastPirceLabel.hidden = YES;
        self.lineLabel.hidden = YES;
        self.priceTextField.hidden = YES;
    }else {
        self.lastPirceLabel.hidden = NO;
        self.lineLabel.hidden = NO;
        self.priceTextField.hidden = NO;
    }
}
- (void)sureBtnClick:(UIButton *)sender {
    
    NSString *dnumberStr = [RSAEncryptor encryptString:self.dnumber publicKey:self.publicKey];
    
    if ([self.yb isEqualToString:@"无"]) {
        [self sendOrderReqeustWithDnumber:dnumberStr andMethod:@"0" andPrepaid:self.priceStr];
    }else {
        if ([self.selectBtn.currentTitle isEqualToString:@" 是"]) {
            if ([self.priceTextField.text floatValue]<=0) {
                [self createAlterViewWithMessage:@"金额不能为0" withSureBtn:YES withCancelBtn:NO withDeleteBtn:NO];
            }else {
                [self sendOrderReqeustWithDnumber:dnumberStr andMethod:@"0" andPrepaid:self.priceTextField.text];

            }
        }else {
            [self sendOrderReqeustWithDnumber:dnumberStr andMethod:@"0" andPrepaid:self.priceStr];

        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

#pragma mark ---request

//获得公钥
- (void)getPublicKey {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://www.enuo120.com/Public/rsa/pub.key" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        self.publicKey = str;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"shibai!!!");
        
    }];
    
}

//提交
- (void)sendOrderReqeustWithDnumber:(NSString *)dnumber andMethod:(NSString *)method andPrepaid:(NSString *)prepaid {
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/agree_pay"];
    NSDictionary *dic = @{@"dnumber":dnumber,@"pay_method":method,@"prepaid":prepaid};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self sendOrderReqeustData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)sendOrderReqeustData:(NSDictionary *)dic {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([dic[@"data"][@"errcode"] integerValue] == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
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
