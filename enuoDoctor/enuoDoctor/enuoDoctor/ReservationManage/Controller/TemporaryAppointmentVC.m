//
//  TemporaryAppointmentVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TemporaryAppointmentVC.h"

@interface TemporaryAppointmentVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) LZPickerView *pickerView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL addOrDeleteStatus;
@property (nonatomic,strong) NSMutableArray *cellDataCountArr;

@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *deskTextField;
@property (nonatomic,strong) UITextField *sunDeskTextField;
@property (nonatomic,strong) UITextField *illTextField;

@property (nonatomic,strong) UITextField *priceTextField;
@property (nonatomic,strong) UITextField *dateTextField;
@property (nonatomic,strong) UITextView *editTextView;
@property (nonatomic,strong) UITextField *selectTextField;
@property (nonatomic,strong) UITextField *categoryTextField;
@property (nonatomic,strong) UITextField *treatTextField;


@property (nonatomic,strong) UITextView *diagnoseTextView;
@property (nonatomic,strong) UITextView *mainSayTextView;
@property (nonatomic,strong) UITextView *historyIllTextView;
@property (nonatomic,strong) UITextView *healthCheckupTextView;
@property (nonatomic,strong) UITextView *laboratoryCheckTextView;
@property (nonatomic,strong) UITextView *assistCheckTextView;

@property (nonatomic,strong) NSMutableArray *curativeEffectArr;
@property (nonatomic,strong) NSMutableArray *understandArr;

@property (nonatomic,assign) BOOL addOrDeleteFirstStatus;
@property (nonatomic,assign) BOOL addOrDeleteSecondStatus;

@property (nonatomic,strong) UIButton *addOrDeleteBtn;

@property (nonatomic,strong) NSMutableArray *deskNameArr;
@property (nonatomic,strong) NSMutableArray *deskIDArr;

@property (nonatomic,strong) NSMutableArray *sunDeskNameArr;
@property (nonatomic,strong) NSMutableArray *sunDeskIDArr;

@property (nonatomic,strong) NSString *dep_id;
@property (nonatomic,strong) NSString *sdep_id;
@property (nonatomic,strong) NSString *publicKey;

@end

@implementation TemporaryAppointmentVC
- (NSMutableArray *)deskNameArr {
    if (!_deskNameArr) {
        _deskNameArr = [NSMutableArray array];
    }return _deskNameArr;
}
- (NSMutableArray *)deskIDArr {
    if (!_deskIDArr) {
        _deskIDArr = [NSMutableArray array];
    }return _deskIDArr;
}
- (NSMutableArray *)sunDeskNameArr {
    if (!_sunDeskNameArr) {
        _sunDeskNameArr = [NSMutableArray array];
    }return _sunDeskNameArr;
}
- (NSMutableArray *)sunDeskIDArr {
    if (!_sunDeskIDArr) {
        _sunDeskIDArr = [NSMutableArray array];
    }return _sunDeskIDArr;
}
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sdep_id = @"0";
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]init];
    gesture.cancelsTouchesInView = NO;
    [gesture addTarget:self action:@selector(gestureClick)];
    [self.view addGestureRecognizer:gesture];
    
    //键盘监控
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"临时预约" andRightImage:nil withRightTitle:nil];
    
    [self createTableView];
    [self getPublicKey];
    [self selectDeskRequest];
}

- (void)leftItemBack {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
//键盘弹出
- (void)keyboardFrameChanged:(NSNotification *)noti {
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
        return 200;
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
    
    NSArray *typeArr = @[@"诊断：",@"主诉：",@"现病史：",@"体格检查：",@"实验室检查：",@"辅助检查：",@"",@"约定疗效：",@"谅解："];
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, kScreenHeigth, 130);
    view.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        
        NSArray *titleStrArr = @[@"患者姓名：",@"约定科室：",@"子  科  室：",@"约定病种：",@"详细分类：",@"治疗方式："];
        for (int i = 0; i<6; i++) {
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.text = [NSString stringWithFormat:@"%@",titleStrArr[i]];
            [view addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).with.offset(15);
                make.top.equalTo(view).with.offset(20+30*i);
                make.size.mas_equalTo(CGSizeMake(70, 15));
            }];
            
            UITextField *titleTextField = [[UITextField alloc]init];
            titleTextField.font = [UIFont systemFontOfSize:13];
            titleTextField.textAlignment = NSTextAlignmentLeft;
            titleTextField.delegate = self;
            [view addSubview:titleTextField];
            [titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLabel);
                make.left.equalTo(titleLabel.mas_right).with.offset(5);
                make.right.equalTo(view).with.offset(-110);
            }];
            
            if (i == 0) {
                if (self.nameTextField.text == nil || [self.nameTextField.text isEqualToString:@""]) {
                    titleTextField.text = self.nameStr;
                }else {
                    titleTextField.text = self.nameTextField.text;
                }
                self.nameTextField = titleTextField;

            }else if (i == 1||i == 2) {
                UIButton *deskBtn = [[UIButton alloc]init];
                deskBtn.layer.cornerRadius = 5;
                deskBtn.clipsToBounds = YES;
                deskBtn.backgroundColor = [UIColor stringTOColor:@"#ffab2e"];
                [deskBtn setTitleColor:[UIColor whiteColor] forState:normal];
                deskBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [deskBtn addTarget:self action:@selector(selectDeskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:deskBtn];
                [deskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(titleTextField);
                    make.right.equalTo(view).with.offset(-15);
                    make.size.mas_equalTo(CGSizeMake(80, 20));
                }];
                
                if (i == 1) {
                    titleTextField.text = self.deskTextField.text;
                    self.deskTextField = titleTextField;
                    titleTextField.placeholder = @"请选择科室";
                    [deskBtn setTitle:@"选择科室" forState:normal];
                }else {
                    titleTextField.text = self.sunDeskTextField.text;
                    self.sunDeskTextField = titleTextField;
                    titleTextField.placeholder = @"请选择子科室";
                    [deskBtn setTitle:@"选择子科室" forState:normal];
                }
                
            }else if (i == 3) {
                titleTextField.text = self.illTextField.text;
                self.illTextField = titleTextField;
                titleTextField.placeholder = @"请输入病种";
            }else if (i == 4) {
                titleTextField.text = self.categoryTextField.text;
                self.categoryTextField = titleTextField;
                titleTextField.placeholder = @"请输入分类";
            }else if (i == 5) {
                titleTextField.text = self.treatTextField.text;
                self.treatTextField = titleTextField;
                titleTextField.placeholder = @"请输入方式";
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
                textField.delegate = self;
                textField.font = [UIFont systemFontOfSize:13];
                [view addSubview:textField];
                [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(titleLabel);
                    make.left.equalTo(titleLabel.mas_right).with.offset(5);
                    make.width.mas_equalTo(@200);
                }];
                
                if (i == 0) {
                    textField.text = self.priceTextField.text;
                    self.priceTextField = textField;
                    textField.placeholder = @"输入约定价格";
                    UILabel *lineLabel = [[UILabel alloc]init];
                    lineLabel.backgroundColor = [UIColor stringTOColor:@"#f4f4f4"];
                    lineLabel.frame = CGRectMake(15, 35, kScreenWidth-15, 1);
                    [view addSubview:lineLabel];
                }else {
                    textField.text = self.dateTextField.text;
                    self.dateTextField = textField;
                    textField.placeholder = @"输入约定周期";
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
            
            if (section == 1) {
                if (self.diagnoseTextView.text != nil) {
                    textView.text = self.diagnoseTextView.text;
                }
                self.diagnoseTextView = textView;
            }else if (section ==2 ) {
                if (self.mainSayTextView.text != nil) {
                    textView.text = self.mainSayTextView.text;
                }
                self.mainSayTextView = textView;
            }else if (section == 3) {
                if (self.historyIllTextView.text != nil) {
                    textView.text = self.historyIllTextView.text;
                }
                self.historyIllTextView = textView;
            }else if (section == 4) {
                if (self.healthCheckupTextView.text != nil) {
                    textView.text = self.healthCheckupTextView.text;
                }
                self.healthCheckupTextView = textView;
            }else if (section == 5) {
                if (self.laboratoryCheckTextView.text != nil) {
                    textView.text = self.laboratoryCheckTextView.text;
                }
                self.laboratoryCheckTextView = textView;
            }else if (section == 6) {
                if (self.assistCheckTextView.text != nil) {
                    textView.text = self.assistCheckTextView.text;
                }
                self.assistCheckTextView = textView;
            }else if (section == 8 || section == 9) {
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

            }else if (section == 10) {
                
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

#pragma mark----textField,textView的代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.priceTextField || textField == self.dateTextField || textField == self.nameTextField ||textField == self.illTextField ||textField == self.categoryTextField || textField == self.treatTextField) {
        return YES;
    }else {
        
        if (textField != self.deskTextField && textField != self.sunDeskTextField ) {
            self.selectTextField = textField;
            [self createEditView];
        }
        
        return NO;
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


//选择科室按钮点击事件
- (void)selectDeskBtnClick:(UIButton *)sender {
    
    LZPickerView *pickerView = [[LZPickerView alloc]init];
    self.pickerView = pickerView;

    
    if ([sender.currentTitle isEqualToString:@"选择科室"]) {
        [pickerView createPickerViewWithArr:self.deskNameArr];
        [pickerView.cancelBtn addTarget:self action:@selector(pickerViewCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [pickerView.sureBtn addTarget:self action:@selector(deskPickerViewSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }else {
        if (self.sunDeskNameArr.count == 0) {
            [self createAlterViewWithMessage:@"该科室没有子科室" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
        }else {
            [pickerView createPickerViewWithArr:self.sunDeskNameArr];
            [pickerView.cancelBtn addTarget:self action:@selector(pickerViewCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [pickerView.sureBtn addTarget:self action:@selector(sunDeskPickerViewSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}

- (void)pickerViewCancelBtnClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
}
- (void)deskPickerViewSureBtnClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
    if (self.pickerView.selectData == nil) {
        self.dep_id = self.deskIDArr[0];
        self.pickerView.selectData = self.deskNameArr[0];
    }else {
        NSInteger index = [self.deskNameArr indexOfObject:self.pickerView.selectData];
        self.dep_id = self.deskIDArr[index];
    }
    
    self.deskTextField.text = self.pickerView.selectData;
    self.sunDeskTextField.text = @"";
    
    //请求子科室
    [self selectSunDeskRequestWithDepID:self.dep_id];

}
- (void)sunDeskPickerViewSureBtnClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
    if (self.pickerView.selectData == nil) {
        self.pickerView.selectData = self.sunDeskNameArr[0];
        self.sdep_id = @"0";
    }else {
        NSInteger index = [self.sunDeskNameArr indexOfObject:self.pickerView.selectData];
        self.sdep_id = self.sunDeskIDArr[index];
    }

    self.sunDeskTextField.text = self.pickerView.selectData;
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
        
        //使用字符串格式的公钥私钥加密解密
        NSString *dnumberStr = [RSAEncryptor encryptString:self.dnumber publicKey:self.publicKey];
        
        
        [self sendOrderRequestWithDnumber:dnumberStr andHos_id:self.hos_id andName:self.nameStr andUsername:self.username andDep_id:self.dep_id andSdep_id:self.sdep_id andIll:self.illTextField.text andCategory:self.categoryTextField.text andTreat:self.treatTextField.text andZhenDuan:self.diagnoseTextView.text andMain_say:self.mainSayTextView.text andNow_disease:self.historyIllTextView.text andBoby_check:self.healthCheckupTextView.text andLab_check:self.laboratoryCheckTextView.text andHe_check:self.assistCheckTextView.text andPrice:self.priceTextField.text andCycle:self.dateTextField.text andEffect:curativeEffectArr andUnderstand:understandArr];
        
    }
}

//判断是否为空
- (BOOL)judgeIsNull {
    
    if (self.nameTextField.text == nil || [self.nameTextField.text isEqualToString:@""]) {
        [self alertWithStr:@"患者姓名不能为空"];
        return NO;
    }else if (self.deskTextField.text == nil || [self.deskTextField.text isEqualToString:@""]) {
        [self alertWithStr:@"科室不能为空"];
        return NO;
    }else if (self.illTextField.text == nil || [self.illTextField.text isEqualToString:@""]) {
        [self alertWithStr:@"约定病种不能为空"];
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

- (void)gestureClick {
    [self.view endEditing:YES];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);
}

#pragma mark --- request 数据请求

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


//请求科室
- (void)selectDeskRequest {
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"mb/get_all_dep_list"];
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self selectDeskData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)selectDeskData:(NSDictionary *)dic {
    
    NSArray *dataArr = dic[@"data"];
    
    for (int i = 0; i<dataArr.count; i++) {
        [self.deskNameArr addObject:dataArr[i][@"name"]];
        [self.deskIDArr addObject:dataArr[i][@"id"]];
    }
}

//请求子科室
- (void)selectSunDeskRequestWithDepID:(NSString *)dep_id {
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"mb/get_sdep_list"];
    
    BaseRequest *request = [[BaseRequest alloc]init];
    NSDictionary *dic = @{@"dep_id":dep_id};
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self selectSunDeskData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)selectSunDeskData:(NSDictionary *)dic {
    
    [self.sunDeskNameArr removeAllObjects];
    [self.sunDeskIDArr removeAllObjects];
    
    if (dic[@"data"] == nil ||[dic[@"data"] isKindOfClass:[NSNull class]]) {
        
    }else {
        NSArray *dataArr = dic[@"data"];
        
        for (int i = 0; i<dataArr.count; i++) {
            [self.sunDeskNameArr addObject:dataArr[i][@"name"]];
            [self.sunDeskIDArr addObject:dataArr[i][@"id"]];
        }
    }
}


//提交订单请求
- (void)sendOrderRequestWithDnumber:(NSString *)dnumber andHos_id:(NSString *)hos_id andName:(NSString *)name andUsername:(NSString *)username andDep_id:(NSString *)dep_id  andSdep_id:(NSString *)sdep_id andIll:(NSString *)ill andCategory:(NSString *)category andTreat:(NSString *)treat andZhenDuan:(NSString *)zhenduan andMain_say:(NSString *)main_say andNow_disease:(NSString *)now_disease andBoby_check:(NSString *)dody_check andLab_check:(NSString *)lab_check andHe_check:(NSString *)he_check andPrice:(NSString *)price andCycle:(NSString *)cycle andEffect:(NSArray *)effectArr andUnderstand:(NSArray *)understandArr {
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/agree_tempory"];
    
    
    NSDictionary *dic = @{@"dnumber":dnumber,@"hos_id":hos_id,@"name":name,@"username":username,@"dep_id":dep_id,@"sdep_id":sdep_id,@"ill":ill,@"category":category,@"treat":treat,@"zhenduan":zhenduan,@"main_say":main_say,@"now_disease":now_disease,@"dody_check":dody_check,@"lab_check":lab_check,@"he_check":he_check,@"price":price,@"cycle":cycle,@"effect":effectArr,@"understand":understandArr};
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@>>>",dataStr);
    
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
