//
//  ChangeLoginPasswordVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ChangeLoginPasswordVC.h"

@interface ChangeLoginPasswordVC ()

@property (nonatomic,strong) UITextField *oldPWTextField;
@property (nonatomic,strong) UITextField *pwTextField;
@property (nonatomic,strong) UITextField *rePWTextField;


@end

@implementation ChangeLoginPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"修改登录密码" andRightImage:nil withRightTitle:nil];
    
    //取消键盘
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [tapGes addTarget:self action:@selector(cancelKeyBoard)];
    [self.view addGestureRecognizer:tapGes];
    
    NSArray *titleArr = @[@"原密码",@"新密码",@"确认密码"];
    NSArray *textFieldArr = @[@"请输入原密码",@"请输入新密码",@"请再次输入新密码"];
    for (int i = 0; i<3; i++) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = [NSString stringWithFormat:@"%@",titleArr[i]];
        titleLabel.frame = CGRectMake(15, 20+44*i, 60, 15);
        [self.view addSubview:titleLabel];
        
        UITextField *textField = [[UITextField alloc]init];
        textField.font = [UIFont systemFontOfSize:13];
        textField.textColor = [UIColor blackColor];
        textField.placeholder = [NSString stringWithFormat:@"%@",textFieldArr[i]];
        [self.view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.left.equalTo(self.view).with.offset(100);
            make.size.mas_equalTo(CGSizeMake(150, 30));
        }];
        
        if (i == 0) {
            self.oldPWTextField = textField;
        }else if (i == 1) {
            self.pwTextField = textField;
            textField.secureTextEntry = YES;
        }else {
            self.rePWTextField = textField;
            textField.secureTextEntry = YES;
        }
        
        if (i<2) {
            UILabel *lineLabel = [[UILabel alloc]init];
            lineLabel.backgroundColor = [UIColor lightGrayColor];
            lineLabel.frame = CGRectMake(0, 50+44*i, kScreenWidth, 0.5);
            [self.view addSubview:lineLabel];
        }else {
            UIButton *sureBtn = [[UIButton alloc]init];
            [sureBtn setTitle:@"确认" forState:normal];
            sureBtn.layer.cornerRadius = 5;
            sureBtn.clipsToBounds = YES;
            [sureBtn setTitleColor:[UIColor whiteColor] forState:normal];
            sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            sureBtn.backgroundColor = [UIColor stringTOColor:@"#63ade9"];
            [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:sureBtn];
            [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).with.offset(50);
                make.left.equalTo(self.view).with.offset(15);
                make.right.equalTo(self.view).with.offset(-15);
                make.height.mas_equalTo(@30);
            }];
        }
    }
    
}
- (void)leftItemBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureBtnClick:(UIButton *)sender {
    if ([self.oldPWTextField.text isEqualToString:@""] || [self.pwTextField.text isEqualToString:@""] || [self.rePWTextField.text isEqualToString:@""]) {
        [self createAlterViewWithMessage:@"内容不能为空" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
    }else if (![self.pwTextField.text isEqualToString:self.rePWTextField.text]) {
        [self createAlterViewWithMessage:@"请保持确认密码与新密码一致" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
    }else {
        [self requestData];
    }
}

- (void)cancelKeyBoard {
    [self.view endEditing:YES];
}

#pragma mark --- request
- (void)requestData {
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/change_pwd"];
    NSDictionary *dic = @{@"username":userName,@"ypassword":self.oldPWTextField.text,@"password":self.pwTextField.text,@"repassword":self.rePWTextField.text};
    
    NSLog(@"%@",dic);
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dataOfRequest:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)dataOfRequest:(NSDictionary *)dic {
    NSLog(@"%@",dic);
    
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
