//
//  NextCheckVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NextCheckVC.h"

@interface NextCheckVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) NSMutableArray *cellDataCountArr;//cell的数量
@property (nonatomic,strong) NSMutableArray *cellDataArr;//cell上的内容
@property (nonatomic,assign) BOOL addOrDeleteStatus;
@property (nonatomic,strong) UIButton *addOrDeleteBtn;

@property (nonatomic,copy) NSString *addOrDeleteBtnTitle;
@property (nonatomic,strong) UITextView *mainSayTextView;//主诉
@property (nonatomic,strong) UITextView *nowDiseaseTextView;//现病史
@property (nonatomic,strong) UITextField *moneyTextField;//预交费用


@property (nonatomic,copy) NSString *publicKey;

@property (nonatomic,strong) OrderCancelReasonView *cancelOrderView;
@property (nonatomic,strong) UIButton *cancelOrderBtn;

@end

                               /******
                                textView.tag = section+200;
                                检查项目.tag = 10+row;
                                检查内容.tag = 100+row;
                                ******/

@implementation NextCheckVC
- (NSMutableArray *)cellDataCountArr {
    if (!_cellDataCountArr) {
        _cellDataCountArr = [NSMutableArray array];
    }return _cellDataCountArr;
}

- (NSMutableArray *)cellDataArr {
    if (!_cellDataArr) {
        _cellDataArr = [NSMutableArray array];
    }return _cellDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]init];
    gesture.cancelsTouchesInView = NO;
    [gesture addTarget:self action:@selector(gestureClick)];
    [self.view addGestureRecognizer:gesture];
    
    //键盘监控
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"进一步检查" andRightImage:nil withRightTitle:nil];
    
    
    NextCheckModel *model = [[NextCheckModel alloc]init];
    [self.cellDataCountArr addObject:model];
    
    [self getPublicKey];
    
    [self createTableView];
}

- (void)leftItemBack {
    [self.navigationController popViewControllerAnimated:YES];
}

//键盘弹出
- (void)keyboardFrameChange:(NSNotification *)noti {
    NSLog(@"%@",noti);
    NSDictionary *dic = [noti userInfo];
    CGRect rect = [[dic objectForKey:@"UIKeyboardBoundsUserInfoKey"]CGRectValue];
    float keyboardHeight = rect.size.height;
    
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64-keyboardHeight);
}

#pragma mark----创建tableview 以及代理方法
- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.editing = YES;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.cellDataCountArr.count;
    }
    
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    }else if (section == 3) {
        return 55;
    }
    return 130;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *typeArr = @[@"主诉：",@"现病史：",@"实验室/辅助检查",@"合计："];
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, kScreenHeigth, 130);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:titleLabel];
    
    if (section == 0) {
        
        NSArray *titleStrArr = @[@"患者姓名：",@"约定病种："];
        NSArray *titleTextArr = @[self.nameStr,self.illStr];
        for (int i = 0; i<2; i++) {
            UILabel *topTitleLabel = [[UILabel alloc]init];
            topTitleLabel.font = [UIFont systemFontOfSize:13];
            topTitleLabel.text = [NSString stringWithFormat:@"%@",titleStrArr[i]];
            [view addSubview:topTitleLabel];
            [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).with.offset(15);
                make.top.equalTo(view).with.offset(20+30*i);
            }];
            
            UILabel *topTitleTextLabel = [[UILabel alloc]init];
            topTitleTextLabel.font = [UIFont systemFontOfSize:13];
            topTitleTextLabel.text = [NSString stringWithFormat:@"%@",titleTextArr[i]];
            [view addSubview:topTitleTextLabel];
            [topTitleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(topTitleLabel);
                make.left.equalTo(topTitleLabel.mas_right).with.offset(5);
            }];
            
        }
    }else if (section == 1 || section == 2) {
        
        
        UITextView *textView = [[UITextView alloc]init];
        textView.font = [UIFont systemFontOfSize:13];
        textView.text = @"请填写内容";
        textView.delegate = self;
        textView.tag = 200+section;
        self.textView = textView;
        textView.textColor = [UIColor stringTOColor:@"#565656"];
        [view addSubview:textView];
        
        if (section == 1) {
            self.mainSayTextView = textView;
        }else {
            self.nowDiseaseTextView = textView;
        }
        
        titleLabel.text = typeArr[section-1];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(15);
            make.top.equalTo(view).with.offset(8);
        }];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(15);
            make.right.equalTo(view).with.offset(-15);
            make.top.equalTo(titleLabel.mas_bottom).with.offset(8);
            make.height.mas_equalTo(@90);
        }];

    }else if (section == 3) {
        
        titleLabel.text = typeArr[section-1];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(15);
            make.top.equalTo(view).with.offset(8);
        }];
        
        UILabel *exampleLabel = [[UILabel alloc]init];
        exampleLabel.font = [UIFont systemFontOfSize:12];
        exampleLabel.textColor = [UIColor stringTOColor:@"#989898"];
        exampleLabel.text = @"例：B超：检查是否有肿瘤等";
        [view addSubview:exampleLabel];
        [exampleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(15);
            make.top.equalTo(titleLabel.mas_bottom).with.offset(8);
        }];
        
        UIButton *addOrDeleteBtn = [[UIButton alloc]init];
        addOrDeleteBtn.backgroundColor = [UIColor stringTOColor:@"#ffab2e"];
        addOrDeleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        addOrDeleteBtn.layer.cornerRadius = 5;
        addOrDeleteBtn.clipsToBounds = YES;
        self.addOrDeleteBtn = addOrDeleteBtn;
        if (self.addOrDeleteBtnTitle == nil) {
            [addOrDeleteBtn setTitle:@"移除检查" forState:normal];
        }else {
            [addOrDeleteBtn setTitle:self.addOrDeleteBtnTitle forState:normal];
        }
        [addOrDeleteBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [view addSubview:addOrDeleteBtn];
        [addOrDeleteBtn addTarget:self action:@selector(addOrDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [addOrDeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(exampleLabel);
            make.right.equalTo(view).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(80, 25));
        }];

        
    }else if (section == 4) {
        
        view.frame = CGRectMake(0, 0, kScreenWidth, 120);
        view.backgroundColor = [UIColor clearColor];
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        topView.backgroundColor = [UIColor whiteColor];
        [view addSubview:topView];
        
        UILabel *totalLabel = [[UILabel alloc]init];
        totalLabel.font = [UIFont systemFontOfSize:13];
        totalLabel.text = typeArr[section-1];
        [topView addSubview:totalLabel];
        [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView).with.offset(15);
            make.top.equalTo(topView).with.offset(8);
        }];
        
        UILabel *moneyLabel = [[UILabel alloc]init];
        moneyLabel.font = [UIFont systemFontOfSize:13];
        moneyLabel.text = @"预交费用：";
        moneyLabel.textColor = [UIColor stringTOColor:@"#2b2b2b"];
        [topView addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView).with.offset(15);
            make.top.equalTo(totalLabel.mas_bottom).with.offset(15);
        }];
        
        UILabel *moneyLineLabel = [[UILabel alloc]init];
        moneyLineLabel.backgroundColor = [UIColor lightGrayColor];
        [topView addSubview:moneyLineLabel];
        [moneyLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(moneyLabel);
            make.left.equalTo(moneyLabel.mas_right).with.offset(2);
            make.size.mas_equalTo(CGSizeMake(80, 0.5));
        }];
        
        UILabel *moneyViewLabel = [[UILabel alloc]init];
        moneyViewLabel.font = [UIFont systemFontOfSize:13];
        moneyViewLabel.textColor = [UIColor stringTOColor:@"#2b2b2b"];
        moneyViewLabel.text = @"¥";
        [topView addSubview:moneyViewLabel];
        [moneyViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyLineLabel);
            make.bottom.mas_equalTo(moneyLineLabel);
        }];
        
        UITextField *moneyTextField = [[UITextField alloc]init];
        moneyTextField.font = [UIFont systemFontOfSize:13];
        moneyTextField.textColor = [UIColor stringTOColor:@"#2b2b2b"];
        if (self.moneyTextField.text == nil || [self.moneyTextField.text isEqualToString:@""]) {
            self.moneyTextField.text = @"0";
        }
        moneyTextField.text = self.moneyTextField.text;
        self.moneyTextField = moneyTextField;
        [topView addSubview:moneyTextField];
        [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyViewLabel.mas_right).with.offset(5);
            make.right.equalTo(moneyLineLabel);
            make.bottom.equalTo(moneyViewLabel);
        }];
        
        NSArray *btnTitleArr = @[@"取消订单",@"提交订单"];
        for (int i = 0; i<2; i++) {
            UIButton *titleBtn = [[UIButton alloc]init];
            titleBtn.layer.cornerRadius = 5;
            titleBtn.clipsToBounds = YES;
            titleBtn.backgroundColor = [UIColor stringTOColor:@"#63ade9"];
            [titleBtn setTitle:[NSString stringWithFormat:@"%@",btnTitleArr[i]] forState:normal];
            [titleBtn setTitleColor:[UIColor whiteColor] forState:normal];
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [view addSubview:titleBtn];
            
            [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(100, 30));
                make.top.equalTo(topView.mas_bottom).with.offset(25);
                if (i == 0) {
                    [titleBtn addTarget:self action:@selector(cancelOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    make.right.equalTo(view.mas_centerX).with.offset(-25);
                }else {
                    [titleBtn addTarget:self action:@selector(sendOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    make.left.equalTo(view.mas_centerX).with.offset(25);
                }
            }];
            
        }
        
    }

    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NextCheckModel *model;
    if (self.cellDataCountArr.count>0) {
        model = self.cellDataCountArr[indexPath.row];
    }
    
    for (int i = 0; i<2; i++) {

        UILabel *lineLable = [[UILabel alloc]init];
        lineLable.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineLable];
        
        UITextField *textField = [[UITextField alloc]init];
        textField.textColor = [UIColor stringTOColor:@"#464646"];
        textField.font = [UIFont systemFontOfSize:13];
        textField.delegate = self;
        self.textField = textField;
        textField.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:textField];
        
        if (i == 0) {
            textField.tag = 10+indexPath.row;
            textField.text = model.checkProject;
            textField.placeholder = @"检查项目";
            [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(57, 0.5));
            }];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(lineLable.mas_top);
                make.left.equalTo(lineLable);
                make.size.mas_equalTo(CGSizeMake(57, 30));
            }];
            
        }else {
            textField.text = model.checkContent;
            textField.tag = 100+indexPath.row;
            textField.placeholder = @"检查内容";
            [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).with.offset(85);
                make.right.equalTo(cell.contentView).with.offset(-15);
                make.height.mas_equalTo(@0.5);
            }];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(lineLable.mas_top);
                make.left.equalTo(lineLable);
                make.right.equalTo(cell.contentView).with.offset(-15);
                make.height.mas_equalTo(@30);
            }];
        }
        
    }
    
    return cell;
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (self.addOrDeleteStatus) {
            return UITableViewCellEditingStyleDelete;
        }else {
            return UITableViewCellEditingStyleInsert;
        }
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleInsert) {
        
        NextCheckModel *model = [[NextCheckModel alloc]init];
        //现在数据源里添加进去数据然后在刷表
        [self.cellDataCountArr insertObject:model atIndex:indexPath.row];
        
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
    [tableView reloadData];
}

//实现cell移动的代理方法
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //移动的时候也是要把数据源对应的交换位置,sourceIndexPath是原来所在的位置,destinationIndexPath是你想要移动的目的地的位置(行号)
    NSLog(@"%ld,,%ld",(long)sourceIndexPath.row,destinationIndexPath.row);
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteBtn=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //先删除在刷表
        [self.cellDataCountArr removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView reloadData];

    }];
    
    return @[deleteBtn];
}

//  移除检查-添加检查 按钮点击事件
- (void)addOrDeleteBtnClick:(UIButton *)sender {
    self.tableView.editing = YES;
    if ([sender.currentTitle isEqualToString:@"移除检查"]) {
        self.addOrDeleteStatus = YES;
        self.addOrDeleteBtnTitle = @"添加检查";
    }else {
        self.addOrDeleteStatus = NO;
        self.addOrDeleteBtnTitle = @"移除检查";
        
        NextCheckModel *model = [[NextCheckModel alloc]init];
        if (self.cellDataCountArr.count == 0) {
            [self.cellDataCountArr addObject:model];
        }
    }
    [self.tableView reloadData];
}

#pragma mark ---textView代理事件
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

#pragma mark ---textField代理事件
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tableView.editing = NO;
    [self.addOrDeleteBtn setTitle:@"添加检查" forState:normal];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {

    self.addOrDeleteBtnTitle = @"添加检查";
    
    
    for (int i = 0; i<self.cellDataCountArr.count; i++) {
        NextCheckModel *model;
        if (textField.tag<100) {
            model = self.cellDataCountArr[textField.tag-10];
            model.checkProject = textField.text;
        }else {
            model = self.cellDataCountArr[textField.tag-100];
            model.checkContent = textField.text;
        }
    }
}

#pragma mark -- 取消订单，提交订单事件
//取消订单
- (void)cancelOrderBtnClick:(UIButton *)sender {
    
    self.cancelOrderBtn = sender;
    self.cancelOrderView = [[OrderCancelReasonView alloc]init];
    [self.view addSubview:self.cancelOrderView];
    [self.cancelOrderView createCancelReasonView];
    [self.cancelOrderView.sureBtn addTarget:self action:@selector(cancelOrderSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"取消订单");
}
- (void)cancelOrderSureBtn:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
    
    if ([self.cancelOrderView.textView.text isEqualToString:@""]) {
        [self createAlterViewWithMessage:@"取消原因不能为空" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
    }else {
        
        [self cancelOrderRequestWithDnumber:self.dnumberStr andCancelReason:self.cancelOrderView.textView.text];
    }

    NSLog(@"1111");
}
//提交订单
- (void)sendOrderBtnClick:(UIButton *)sender {
    
    //使用字符串格式的公钥私钥加密解密
    NSString *dnumber = [RSAEncryptor encryptString:self.dnumberStr publicKey:self.publicKey];
    
    NSMutableArray *checkNameArr = [NSMutableArray array];
    NSMutableArray *checkProArr = [NSMutableArray array];
    NextCheckModel *model;
    BOOL empty;
    for (int i = 0; i<self.cellDataCountArr.count; i++) {
        model = self.cellDataCountArr[i];
        
        if (model.checkProject == nil || [model.checkProject isEqualToString:@""] ||model.checkContent == nil || [model.checkContent isEqualToString:@""]) {
            empty = YES;
            break;
        }
        
        [checkNameArr addObject:model.checkProject];
        [checkProArr addObject:model.checkContent];
    }
    
    if (empty) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"检查项目/检查内容 不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alter addAction:sureAction];
        
        [self presentViewController:alter animated:YES completion:nil];
    }else {
        if (self.mainSayTextView.text == nil ||[self.mainSayTextView.text isEqualToString:@""] ||[self.moneyTextField.text floatValue]<=0) {
            
            if (self.mainSayTextView.text == nil ||[self.mainSayTextView.text isEqualToString:@""]) {
                [self createAlterViewWithMessage:@"主诉不能为空" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
                
            }
            if (self.cellDataCountArr.count == 0) {
                [self createAlterViewWithMessage:@"检查不能为空" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
            }
            
            if ([self.moneyTextField.text floatValue]<=0) {
                [self createAlterViewWithMessage:@"预交费用不能为0" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
            }
        }else {
            
            [self sendOrderRequestWithDnumber:dnumber andMainSay:self.mainSayTextView.text andNowDisease:self.nowDiseaseTextView.text andPrepaid:self.moneyTextField.text andCheckNameArr:checkNameArr andCheckProArr:checkProArr];
            NSLog(@"提交订单");
            
        }
    }
}


- (void)gestureClick {
    
    [self.view endEditing:YES];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);
}

#pragma mark---数据请求
//获得公钥
- (void)getPublicKey {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://www.enuo120.com/Public/rsa/pub.key" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        self.publicKey = str;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"shibai!!!");
        
    }];
    
}

//取消订单请求
- (void)cancelOrderRequestWithDnumber:(NSString *)dnumber andCancelReason:(NSString *)reasonStr {
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/cancel_appoint"];
    NSDictionary *dic = @{@"dnumber":dnumber,@"delete_reason":reasonStr};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self cancelOrderRequestDate:responseObject];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
- (void)cancelOrderRequestDate:(NSDictionary *)dic {
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alter addAction:sureAction];
    
    [self presentViewController:alter animated:YES completion:nil];
    
}
//提交订单请求
- (void)sendOrderRequestWithDnumber:(NSString *)dnumber andMainSay:(NSString *)mainSayStr andNowDisease:(NSString *)nowDiseaseStr andPrepaid:(NSString *)prepaidStr andCheckNameArr:(NSArray *)checkNameArr andCheckProArr:(NSArray *)checkProArr {
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/sub_check_result"];
    NSDictionary *dic = @{@"dnumber":dnumber,@"main_say":mainSayStr,@"now_disease":nowDiseaseStr,@"prepaid":prepaidStr,@"check_name":checkNameArr,@"check_pro":checkProArr};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self sendOrderRequestWithData:responseObject];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)sendOrderRequestWithData:(NSDictionary *)dic {
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([dic[@"data"][@"errcode"] integerValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
        }
        
    }];
    
    [alter addAction:sureAction];
    
    [self presentViewController:alter animated:YES completion:nil];
    NSLog(@"dic----%@",dic);
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
