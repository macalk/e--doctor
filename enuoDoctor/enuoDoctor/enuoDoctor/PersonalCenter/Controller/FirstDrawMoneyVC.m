//
//  FirstDrawMoneyVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FirstDrawMoneyVC.h"

@interface FirstDrawMoneyVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation FirstDrawMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"添加新卡" andRightImage:nil withRightTitle:nil];
    
    self.addBtn.layer.cornerRadius = 5;
    self.addBtn.clipsToBounds = YES;
    
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.cardNumberTextField.borderStyle = UITextBorderStyleNone;
    self.cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
}
- (IBAction)addBtnClick:(UIButton *)sender {
    if (self.nameTextField.text == nil || [self.nameTextField.text isEqualToString:@""]) {
        [self createAlterViewWithMessage:@"持卡人不能为空" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
    }else {
        [self addBankCardRequest];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)addBankCardRequest {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/doc_add_card"];
    NSDictionary *dic = @{@"username":username,@"u_card":self.nameTextField.text,@"card":self.cardNumberTextField.text};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self addBankCardRequestData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)addBankCardRequestData:(NSDictionary *)dic {
    NSLog(@"%@",dic);
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([dic[@"data"][@"errcode"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
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
