//
//  ExplicitDiagnosisVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年 apple. All rights reserved.
//

//诊断明确VC
#import "ExplicitDiagnosisVC.h"
#import "RSAEncryptor.h"

@interface ExplicitDiagnosisVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *appointIllLabel;//预定病种
@property (nonatomic,copy) NSString *selectIllID;//疾病ID
@property (nonatomic,strong) NSMutableArray *illListArr;
@property (nonatomic,strong) NSMutableArray *illIDListArr;
@property (nonatomic,strong) LZPickerView *pickerView;

@property (nonatomic,assign) BOOL addOrDeleteFirstStatus;//添加或删除
@property (nonatomic,assign) BOOL addOrDeleteSecondStatus;//添加或删除
@property (nonatomic,assign) BOOL is_activity;//是否活动

@property (nonatomic,strong) UIButton *addOrDeleteBtn;//添加或删除按钮

@property (nonatomic,strong) NSMutableArray *curativeEffectArr;//约定疗效数组
@property (nonatomic,strong) NSMutableArray *understandArr;//谅解数组

@property (nonatomic,strong) UIButton *addOrDeleteOneBtn;
@property (nonatomic,strong) UIButton *addOrDeleteTwoBtn;

@property (nonatomic,strong) UITextField *selectTextField;
@property (nonatomic,strong) UITextView *editTextView;

@property (nonatomic,strong) UITextView *diagnoseTextView;
@property (nonatomic,strong) UITextView *mainSayTextView;
@property (nonatomic,strong) UITextView *historyIllTextView;
@property (nonatomic,strong) UITextView *healthCheckupTextView;
@property (nonatomic,strong) UITextView *laboratoryTextView;
@property (nonatomic,strong) UITextView *assistTextView;
@property (nonatomic,strong) UITextField *priceTextField;
@property (nonatomic,strong) UITextField *dateTextField;

@property (nonatomic,copy) NSString *pricePlaceholderStr;//价格提示
@property (nonatomic,copy) NSString *datePlaceholderStr;//周期提示
@property (nonatomic,copy) NSString *priceStr;//价格
@property (nonatomic,copy) NSString *dateStr;//周期

@property (nonatomic,copy) NSString *publicKey;


@end

/***
 
 说明：  textField.tag = indexPath.section*100+indexPath.row;
 
 ***/

@implementation ExplicitDiagnosisVC

- (NSMutableArray *)curativeEffectArr {
    if (!_curativeEffectArr) {
        _curativeEffectArr = [NSMutableArray array];
    }return _curativeEffectArr;
}
- (NSMutableArray *)understandArr {
    if (!_understandArr) {
        _understandArr = [NSMutableArray array];
    }return _understandArr;
}

- (NSMutableArray *)illIDListArr {
    if (!_illIDListArr) {
        _illIDListArr = [NSMutableArray array];
    }return _illIDListArr;
}

- (NSMutableArray *)illListArr {
    if (!_illListArr) {
        _illListArr = [NSMutableArray array];
    }return _illListArr;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);
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
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"诊断明确" andRightImage:nil withRightTitle:@"临时预约"];
    
    [self getPublicKey];
    [self getIllListRequest];
    [self getCurativeEffectWithDnumber:self.dnumber];
    [self createTableView];
    
}
- (void)leftItemBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick {
    
    [self.view endEditing:YES];
    
    TemporaryAppointmentVC *tempVC = [[TemporaryAppointmentVC alloc]init];
    tempVC.nameStr = self.nameStr;
    tempVC.hos_id = self.hos_id;
    tempVC.dnumber = self.dnumber;
    tempVC.username = self.username;
    [self.navigationController pushViewController:tempVC animated:YES];
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
    tableView.tableFooterView = nil;
    tableView.editing = YES;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 8) {
        return self.curativeEffectArr.count;
    }else if (section == 9) {
        return self.understandArr.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 11;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 80;
    }else if (section == 7) {
        return 70;
    }else if (section == 8 || section == 9) {
        return 40;
    }else if (section == 10) {
        return 80;
    }
    return 130;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *typeArr = @[@"诊断",@"主诉：",@"现病史：",@"体格检查：",@"实验室检查：",@"辅助检查：",@"",@"约定疗效：",@"谅解："];
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, kScreenHeigth, 130);
    view.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        
        NSArray *titleStrArr = @[@"患者姓名：",@"约定病种："];
        if (self.pickerView.selectData != nil) {
            self.illStr = self.pickerView.selectData;
        }
        NSArray *titleTextArr = @[self.nameStr,self.illStr];
        for (int i = 0; i<2; i++) {
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.text = [NSString stringWithFormat:@"%@",titleStrArr[i]];
            [view addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).with.offset(15);
                make.top.equalTo(view).with.offset(20+30*i);
                make.width.mas_offset(@70);
            }];
            
            UILabel *titleTextLabel = [[UILabel alloc]init];
            titleTextLabel.font = [UIFont systemFontOfSize:13];
            titleTextLabel.text = [NSString stringWithFormat:@"%@",titleTextArr[i]];
            [view addSubview:titleTextLabel];
            [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLabel);
                make.left.equalTo(titleLabel.mas_right);
                make.right.equalTo(view).with.offset(-95);
            }];
            
            if (i == 1) {
                self.appointIllLabel = titleTextLabel;
                UIButton *temporaryBtn = [[UIButton alloc]init];
                temporaryBtn.backgroundColor = [UIColor stringTOColor:@"#ffab2e"];
                temporaryBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                temporaryBtn.layer.cornerRadius = 5;
                temporaryBtn.clipsToBounds = YES;
                [temporaryBtn setTitle:@"修改病种" forState:normal];
                [temporaryBtn setTitleColor:[UIColor whiteColor] forState:normal];
                [temporaryBtn addTarget:self action:@selector(ChangeIllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:temporaryBtn];
                [temporaryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(titleTextLabel);
                    make.right.equalTo(view).with.offset(-15);
                    make.size.mas_equalTo(CGSizeMake(80, 25));
                }];
                
            }
            
        }
    }else {
        if (section == 7) {
            NSArray *titleStrArr = @[@"约定价格：",@"约定周期："];
            for (int i = 0; i<2; i++) {
                UILabel *titleLabel = [[UILabel alloc]init];
                titleLabel.font = [UIFont systemFontOfSize:13];
                titleLabel.text = [NSString stringWithFormat:@"%@",titleStrArr[i]];
                [view addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).with.offset(15);
                    make.top.equalTo(view).with.offset(10+35*i);
                }];
                
                UITextField *textField = [[UITextField alloc]init];
                textField.font = [UIFont systemFontOfSize:13];
                textField.tag = section*100+i;
                textField.delegate = self;
                [view addSubview:textField];
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(titleLabel);
                    make.left.equalTo(titleLabel.mas_right).with.offset(5);
                    make.width.mas_equalTo(@200);
                }];
                
                if (i == 0) {
                    if (self.is_activity == 0) {
                        textField.placeholder = [NSString stringWithFormat:@"价格范围 %@",self.pricePlaceholderStr];
                        textField.text = self.priceTextField.text;
                    }else {
                        textField.text = self.priceStr;
                    }
                    self.priceTextField = textField;
                    
                    UILabel *lineLabel = [[UILabel alloc]init];
                    lineLabel.backgroundColor = [UIColor stringTOColor:@"#f4f4f4"];
                    lineLabel.frame = CGRectMake(15, 35, kScreenWidth-15, 1);
                    [view addSubview:lineLabel];
                }else {
                    textField.placeholder = self.datePlaceholderStr;
                    textField.text = self.dateTextField.text;
                    self.dateTextField = textField;

                }
            }
            
        }else {
            
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.font = [UIFont systemFontOfSize:13];
            if (section<10) {
                titleLabel.text = typeArr[section-1];
            }
            [view addSubview:titleLabel];
            
            UITextView *textView = [[UITextView alloc]init];
            textView.font = [UIFont systemFontOfSize:13];
            textView.text = @"请填写内容";
            textView.delegate = self;
            textView.textColor = [UIColor stringTOColor:@"#565656"];
            [view addSubview:textView];
            
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
            
            if (section ==  1) {
                if (self.diagnoseTextView != nil) {
                    textView.text = self.diagnoseTextView.text;
                }
                self.diagnoseTextView = textView;
            }else if (section == 2){
                if (self.mainSayTextView != nil) {
                    textView.text = self.mainSayTextView.text;
                }
                self.mainSayTextView = textView;
            }else if (section == 3) {
                if (self.historyIllTextView != nil) {
                    textView.text = self.historyIllTextView.text;
                }
                self.historyIllTextView = textView;
            }else if (section == 4) {
                if (self.healthCheckupTextView != nil) {
                    textView.text = self.healthCheckupTextView.text;
                }
                self.healthCheckupTextView = textView;
            }else if (section == 5) {
                if (self.laboratoryTextView != nil) {
                    textView.text = self.laboratoryTextView.text;
                }
                self.laboratoryTextView = textView;
            }else if (section == 6) {
                if (self.assistTextView != nil) {
                    textView.text = self.assistTextView.text;
                }
                self.assistTextView = textView;
            }
            if (section == 8 || section == 9) {
                
                [textView removeFromSuperview];
                
                UIButton *addOrDeleteBtn = [[UIButton alloc]init];
                addOrDeleteBtn.backgroundColor = [UIColor stringTOColor:@"#ffab2e"];
                addOrDeleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                addOrDeleteBtn.layer.cornerRadius = 5;
                addOrDeleteBtn.clipsToBounds = YES;
                [addOrDeleteBtn setTitleColor:[UIColor whiteColor] forState:normal];
                [view addSubview:addOrDeleteBtn];
                if (section == 8) {
                    [addOrDeleteBtn setTitle:@"移除/添加 疗效" forState:normal];

                }else if(section == 9) {
                    [addOrDeleteBtn setTitle:@"移除/添加 谅解" forState:normal];
                }
                [addOrDeleteBtn addTarget:self action:@selector(addOrDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [addOrDeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(titleLabel);
                    make.right.equalTo(view).with.offset(-15);
                    make.size.mas_equalTo(CGSizeMake(100, 25));
                }];

            }
            
            if (section == 10) {
                
                view.frame = CGRectMake(0, 0, kScreenHeigth, 80);
                view.backgroundColor = [UIColor clearColor];
                [textView removeFromSuperview];
                
                UIButton *sendOrderBtn = [[UIButton alloc]init];
                sendOrderBtn.layer.cornerRadius = 5;
                sendOrderBtn.clipsToBounds = YES;
                sendOrderBtn.backgroundColor = [UIColor stringTOColor:@"#63ade9"];
                [sendOrderBtn setTitle:@"提交订单" forState:normal];
                [sendOrderBtn setTitleColor:[UIColor whiteColor] forState:normal];
                sendOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [sendOrderBtn addTarget:self action:@selector(sendOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:sendOrderBtn];
                
                [sendOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(@30);
                    make.left.equalTo(view).with.offset(40);
                    make.right.equalTo(view).with.offset(-40);
                    make.top.equalTo(view).with.offset(25);
                    make.centerX.equalTo(view);
                }];
                
            }
            
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
    
    UITextField *textField = [[UITextField alloc]init];
    textField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    textField.font = [UIFont systemFontOfSize:13];
    textField.textColor = [UIColor blackColor];
    textField.delegate = self;
    textField.tag = indexPath.section*100+indexPath.row;
    [cell.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).with.offset(15);
        make.right.equalTo(cell.contentView).with.offset(-15);
        make.center.equalTo(cell.contentView);
    }];
    
    
    ExplicitDiagnosisModel *model;
    if (indexPath.section == 8) {
        
        if ([self.curativeEffectArr[indexPath.row] isKindOfClass:[ExplicitDiagnosisModel class]]) {
            model = self.curativeEffectArr[indexPath.row];
            textField.text = model.effectStr;
        }else {
            textField.text = self.curativeEffectArr[indexPath.row];
        }
        
        
    }else if (indexPath.section == 9) {
        
        if ([self.understandArr[indexPath.row] isKindOfClass:[ExplicitDiagnosisModel class]]) {
            model = self.understandArr[indexPath.row];
            textField.text = model.understandStr;
        }else {
            textField.text = self.understandArr[indexPath.row];
        }
        
    }
    

    return cell;
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 8) {
        if (self.addOrDeleteFirstStatus) {
            return UITableViewCellEditingStyleDelete;
        }else {
            return UITableViewCellEditingStyleInsert;
        }
    }
    if (indexPath.section == 9) {
        if (self.addOrDeleteSecondStatus) {
            return UITableViewCellEditingStyleDelete;
        }else {
            return UITableViewCellEditingStyleInsert;
        }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleInsert) {
        //现在数据源里添加进去数据然后在刷表
        ExplicitDiagnosisModel *model = [[ExplicitDiagnosisModel alloc]init];
        if (indexPath.section == 8) {
            [self.curativeEffectArr insertObject:model atIndex:indexPath.row+1];
        }else if (indexPath.section == 9) {
            [self.understandArr insertObject:model atIndex:indexPath.row+1];

        }
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [tableView reloadData];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteBtn=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //先删除在刷表
        if (indexPath.section == 8) {
            [self.curativeEffectArr removeObjectAtIndex:indexPath.row];
        }else {
            [self.understandArr removeObjectAtIndex:indexPath.row];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView reloadData];
        
    }];
    
    return @[deleteBtn];
}


//移除或添加按钮
- (void)addOrDeleteBtnClick:(UIButton *)sender {
    
    self.addOrDeleteBtn = sender;
    ExplicitDiagnosisModel *model = [[ExplicitDiagnosisModel alloc]init];

    if ([sender.currentTitle isEqualToString:@"移除/添加 疗效"]) {
        if (self.curativeEffectArr.count == 0) {
            [self.curativeEffectArr addObject:model];
            self.addOrDeleteFirstStatus = NO;
        }else {
            self.addOrDeleteFirstStatus = !self.addOrDeleteFirstStatus;
        }
    }else {
        if (self.understandArr.count == 0) {
            [self.understandArr addObject:model];
            self.addOrDeleteSecondStatus = NO;
        }else {
            self.addOrDeleteSecondStatus = !self.addOrDeleteSecondStatus;
        }
    }
    
    [self.tableView reloadData];

}

//修改病种
- (void)ChangeIllBtnClick:(UIButton *)sender {
    LZPickerView *pickerView = [[LZPickerView alloc]init];
    [pickerView createPickerViewWithArr:self.illListArr];
    [pickerView.cancelBtn addTarget:self action:@selector(pickerCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickerView.sureBtn addTarget:self action:@selector(pickerSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.pickerView = pickerView;
}

//picerview 按钮点击事件
- (void)pickerCancelBtnClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
}
- (void)pickerSureBtnClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
    
    if (self.pickerView.selectData == nil) {
        self.appointIllLabel.text = self.illListArr[0];
        self.pickerView.selectData = self.illListArr[0];
    }else {
        self.appointIllLabel.text = self.pickerView.selectData;
    }
    
    NSInteger index = [self.illListArr indexOfObject:self.pickerView.selectData];
    NSString *illID = self.illIDListArr[index];
    self.selectIllID = illID;
    [self getCurativeEffectWithIll:illID];
}

//提交订单按钮点击事件
- (void)sendOrderBtnClick:(UIButton *)sender {
    if ([self judgeIsNull]) {
        
        NSMutableArray *curativeEffectArr = [NSMutableArray array];
        NSMutableArray *understandArr = [NSMutableArray array];
        
        for (int i = 0; i<self.curativeEffectArr.count; i++) {
            if ([self.curativeEffectArr[i] isKindOfClass:[ExplicitDiagnosisModel class]]) {
                
                ExplicitDiagnosisModel *model = self.curativeEffectArr[i];
                [curativeEffectArr addObject:model.effectStr];
                
            }else {
                [curativeEffectArr addObject:self.curativeEffectArr[i]];
            }
        }
        
        for (int i = 0; i<self.understandArr.count; i++) {
            if ([self.understandArr[i] isKindOfClass:[ExplicitDiagnosisModel class]]) {
                
                ExplicitDiagnosisModel *model = self.understandArr[i];
                [understandArr addObject:model.understandStr];
                
            }else {
                [understandArr addObject:self.understandArr[i]];
            }
        }

        if (self.selectIllID == nil) {
            self.selectIllID = self.illIDListArr[0];
        }

        //使用字符串格式的公钥私钥加密解密
        NSString *dnumberStr = [RSAEncryptor encryptString:self.dnumber publicKey:self.publicKey];
        
        NSLog(@"%@~~~%@~~~%@",self.dnumber,self.publicKey,dnumberStr);
        
        [self sendOrderRequestWithDnumber:dnumberStr andHos_id:self.hos_id andName:self.nameStr andUsername:self.username andMb_id:self.selectIllID andZhenDuan:self.diagnoseTextView.text andMain_say:self.mainSayTextView.text andNow_disease:self.historyIllTextView.text andBoby_check:self.healthCheckupTextView.text andLab_check:self.laboratoryTextView.text andHe_check:self.assistTextView.text andPrice:self.priceTextField.text andCycle:self.dateTextField.text andEffect:curativeEffectArr andUnderstand:understandArr];
    }
}

//判断是否为空
- (BOOL)judgeIsNull {
    
    if (self.appointIllLabel.text == nil || [self.appointIllLabel.text isEqualToString:@""]) {
        [self alertWithStr:@"疾病不能为空"];
        return NO;
    }else if (self.diagnoseTextView.text == nil || [self.diagnoseTextView.text isEqualToString:@""]) {
        [self alertWithStr:@"诊断不能为空"];
        return NO;
    }else if (self.mainSayTextView.text == nil || [self.mainSayTextView.text isEqualToString:@""]) {
        [self alertWithStr:@"主诉不能为空"];
        return NO;
    }else if (self.historyIllTextView.text == nil || [self.historyIllTextView.text isEqualToString:@""]) {
        [self alertWithStr:@"现病史不能为空"];
        return NO;
    }else if (self.healthCheckupTextView.text == nil || [self.healthCheckupTextView.text isEqualToString:@""]) {
        [self alertWithStr:@"体格检查不能为空"];
        return NO;
    }else if (self.priceTextField.text == nil || [self.priceTextField.text isEqualToString:@""]) {
        [self alertWithStr:@"约定价格不能为空"];
        return NO;
    }else if (self.dateTextField.text == nil || [self.dateTextField.text isEqualToString:@""]) {
        [self alertWithStr:@"约定周期不能为空"];
        return NO;
    }else if (self.curativeEffectArr.count == 0 ) {
        [self alertWithStr:@"约定疗效不能为空"];
        return NO;
    }else if (self.understandArr.count == 0 ) {
        [self alertWithStr:@"谅解不能为空"];
        return NO;
    }
    
    
    for (int i = 0; i<self.curativeEffectArr.count; i++) {
        if ([self.curativeEffectArr[i] isKindOfClass:[ExplicitDiagnosisModel class]]) {
            
            ExplicitDiagnosisModel *model = self.curativeEffectArr[i];
            if (model.effectStr == nil || [model.effectStr isEqualToString:@""]) {
                [self alertWithStr:@"约定疗效内容不能为空"];
                return NO;
            }
            
        }else {
            if (self.curativeEffectArr[i] == nil ||[self.curativeEffectArr[i] isEqualToString:@""]) {
                [self alertWithStr:@"约定疗效内容不能为空"];
                return NO;
            }
        }
    }
    
    for (int i = 0; i<self.understandArr.count; i++) {
        if ([self.understandArr[i] isKindOfClass:[ExplicitDiagnosisModel class]]) {
            
            ExplicitDiagnosisModel *model = self.understandArr[i];
            if (model.understandStr == nil || [model.understandStr isEqualToString:@""]) {
                [self alertWithStr:@"谅解内容不能为空"];
                return NO;
            }
            
        }else {
            if (self.understandArr[i] == nil ||[self.understandArr[i] isEqualToString:@""]) {
                [self alertWithStr:@"谅解内容不能为空"];
                return NO;
            }
        }
    }
    
    
    return YES;
}
- (void)alertWithStr:(NSString *)str {
    [self createAlterViewWithMessage:str withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
}

#pragma mark----textView的代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    
    return YES;
}

#pragma mark ---textField代理事件

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag==700) {
        if (self.is_activity == 0) {
            return YES;
        }else {
            return NO;
        }
    }else if (textField.tag == 701) {
        return YES;
    }else {
        self.selectTextField = textField;
        [self createEditView];
        
        return NO;
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 700) {
        self.priceStr = textField.text;
    }else if (textField.tag == 701) {
        self.dateStr = textField.text;
    }
}

//编辑视图
- (void)createEditView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgView = [[UIView alloc]initWithFrame:window.bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [window addSubview:bgView];
    
    UIView *whitView = [[UIView alloc]init];
    whitView.layer.cornerRadius = 10;
    whitView.clipsToBounds = YES;
    whitView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whitView];
    [whitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView).with.offset(-100);
        make.centerX.equalTo(bgView);
        make.size.mas_offset(CGSizeMake(240, 200));
    }];

    
    UITextView *editTextView = [[UITextView alloc]init];
    self.editTextView = editTextView;
    editTextView.text = self.selectTextField.text;
    [editTextView becomeFirstResponder];
    editTextView.font = [UIFont systemFontOfSize:13];
    editTextView.textColor = [UIColor blackColor];
    [bgView addSubview:editTextView];
    [editTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(whitView);
        make.top.equalTo(whitView).with.offset(10);
        make.bottom.equalTo(whitView.mas_bottom).with.offset(-50);
    }];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"确认" forState:normal];
    sureBtn.backgroundColor = [UIColor stringTOColor:@"#64aeea"];
    [whitView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(editSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whitView);
        make.bottom.equalTo(whitView).with.offset(-10);
        make.size.mas_offset(CGSizeMake(100, 30));
    }];
}
- (void)editSureBtnClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);

    ExplicitDiagnosisModel *model;
    
    if (self.selectTextField.tag>=800 && self.selectTextField.tag<900) {
        
        for (int i = 0; i<self.curativeEffectArr.count; i++) {
            
            if ([self.curativeEffectArr[self.selectTextField.tag-800] isKindOfClass:[ExplicitDiagnosisModel class]]) {
                model = self.curativeEffectArr[self.selectTextField.tag-800];
                model.effectStr = self.editTextView.text;
                
            }else {
                [self.curativeEffectArr replaceObjectAtIndex:self.selectTextField.tag-800 withObject:self.editTextView.text];
            }
            
        }
    }else if (self.selectTextField.tag>=900) {
        for (int i = 0; i<self.understandArr.count; i++) {
            
            if ([self.understandArr[self.selectTextField.tag-900] isKindOfClass:[ExplicitDiagnosisModel class]]) {
                model = self.understandArr[self.selectTextField.tag-900];
                model.understandStr = self.editTextView.text;
            }else {
                [self.understandArr replaceObjectAtIndex:self.selectTextField.tag-900 withObject:self.editTextView.text];
            }
        }
    }

    [self.tableView reloadData];
}

#pragma mark---request

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

//获得病种
- (void)getIllListRequest {
    
    NSString *docID = [[NSUserDefaults standardUserDefaults]objectForKey:@"docID"];
    NSLog(@"%@",docID);
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/get_yue_doc_mb_list"];
    NSDictionary *dic = @{@"did":docID};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self illListRequestData:responseObject];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
- (void)illListRequestData:(NSDictionary *)dic {
    
    if ([dic[@"data"] isKindOfClass:[NSNull class]]) {
        
    }else {
        NSArray *dataArr = dic[@"data"];
        for (int i = 0; i<dataArr.count; i++) {
            ExplicitDiagnosisModel *model = [ExplicitDiagnosisModel ExplicitDiagnosisModelWithDictionry:dataArr[i]];
            NSString *illStr = [NSString stringWithFormat:@"%@ %@ %@",model.ill,model.category,model.treat];
            [self.illListArr addObject:illStr];
            [self.illIDListArr addObject:model.ID];
        }
    }
    
}

//根据订单获得约定疗效
- (void)getCurativeEffectWithDnumber:(NSString *)dnumber {
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/ill_agreement"];
    NSDictionary *dic = @{@"dnumber":dnumber};
    NSLog(@"%@",dnumber);
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self CurativeEffectWithData:responseObject];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//根据疾病获得约定疗效
- (void)getCurativeEffectWithIll:(NSString *)illID {
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"mb/get_yue_mb_info"];
    NSDictionary *dic = @{@"mb_id":illID};
    NSLog(@"%@",illID);
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self CurativeEffectWithData:responseObject];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
- (void)CurativeEffectWithData:(NSDictionary *)dic {
    
    ExplicitDiagnosisModel *model = [ExplicitDiagnosisModel ExplicitDiagnosisModelWithDictionry:dic[@"data"]];
    
    if (![dic[@"data"][@"effect_list"] isKindOfClass:[NSNull class]]) {
        self.curativeEffectArr = [NSMutableArray arrayWithArray:model.effect_list];
    }
    if (![dic[@"data"][@"understand_list"] isKindOfClass:[NSNull class]]) {
        self.understandArr = [NSMutableArray arrayWithArray:model.understand_list];
    }
    
    self.is_activity = model.is_activity;
    
    self.selectIllID = model.mb_id;
    
    if (model.is_activity == 0) {
        self.pricePlaceholderStr = [NSString stringWithFormat:@"%@~%@",model.lowprice,model.heightprice];

    }else {
        self.priceStr = model.price;
    }
    
    self.datePlaceholderStr = model.cycle;
    
    [self.tableView reloadData];
    
    NSLog(@"%ld",(long)self.curativeEffectArr.count);
    NSLog(@"1111");
    
}

//提交订单请求
- (void)sendOrderRequestWithDnumber:(NSString *)dnumber andHos_id:(NSString *)hos_id andName:(NSString *)name andUsername:(NSString *)username andMb_id:(NSString *)mb_id andZhenDuan:(NSString *)zhenduan andMain_say:(NSString *)main_say andNow_disease:(NSString *)now_disease andBoby_check:(NSString *)dody_check andLab_check:(NSString *)lab_check andHe_check:(NSString *)he_check andPrice:(NSString *)price andCycle:(NSString *)cycle andEffect:(NSArray *)effectArr andUnderstand:(NSArray *)understandArr {
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/agree_ill"];
    
    NSDictionary *dic = @{@"dnumber":dnumber,@"hos_id":hos_id,@"name":name,@"username":username,@"mb_id":mb_id,@"zhenduan":zhenduan,@"main_say":main_say,@"now_disease":now_disease,@"dody_check":dody_check,@"lab_check":lab_check,@"he_check":he_check,@"price":price,@"cycle":cycle,@"effect":effectArr,@"understand":understandArr};

    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self sendOrderRequestData:responseObject];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)sendOrderRequestData:(NSDictionary *)dic {
    
    NSLog(@"%@",dic);
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        if ([dic[@"data"][@"errcode"] integerValue] == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    [alertVC addAction:sureAC];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
    
    NSLog(@"%@",dic);
}
- (void)gestureClick {
    [self.view endEditing:YES];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);
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
