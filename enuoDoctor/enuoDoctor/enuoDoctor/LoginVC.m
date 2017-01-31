//
//  LoginVC.m
//  enuoDoctor
//
//  Created by apple on 16/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTextLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextLabel;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.accountView.layer.cornerRadius = 22;
    self.accountView.clipsToBounds = YES;
    self.passwordView.layer.cornerRadius = 22;
    self.passwordView.clipsToBounds = YES;
    self.loginBtn.layer.cornerRadius = 22;
    self.loginBtn.clipsToBounds = YES;
    
}

//登录按钮
- (IBAction)loginBtnClick:(UIButton *)sender {
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/log"];
    NSDictionary *dic = @{@"username":self.accountTextLabel.text,@"password":self.passwordTextLabel.text};
    
    BaseRequest *manager = [[BaseRequest alloc]init];
    [manager POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [self loginDate:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
- (void)loginDate:(NSDictionary *)dic {
    NSString *errcode = dic[@"data"][@"errcode"];
    NSString *message = dic[@"data"][@"message"];
    
    if ([errcode integerValue] == 0) {
        
        NSDictionary *contentDic = dic[@"data"][@"content"];
        [[NSUserDefaults standardUserDefaults]setObject:contentDic[@"doc_id"] forKey:@"docID"];
        [[NSUserDefaults standardUserDefaults]setObject:contentDic[@"name"] forKey:@"name"];
        [[NSUserDefaults standardUserDefaults]setObject:contentDic[@"hos_id"] forKey:@"hosID"];
        [[NSUserDefaults standardUserDefaults]setObject:contentDic[@"yb"] forKey:@"yb"];
        
        [[NSUserDefaults standardUserDefaults]setObject:self.accountTextLabel.text forKey:@"token"];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [RootTabBarViewController new];
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];

    }else {
        [self createAlterViewWithMessage:message withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
        
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
