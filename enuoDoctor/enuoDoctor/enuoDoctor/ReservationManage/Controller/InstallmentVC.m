//
//  InstallmentVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 apple. All rights reserved.
//

//分期付款
#import "InstallmentVC.h"

@interface InstallmentVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *cellDataCountArr;
@property (nonatomic,strong) UIButton *addOrDeleteBtn;
@property (nonatomic,strong) LZDatePickerView *datePickerView;
@property (nonatomic,strong) UITextField *dateTextField;
@property (nonatomic,assign) BOOL addOrDeleteStatus;
@property (nonatomic,copy) NSString *yb;

@end

/******
 约定金额.tag = 10+indexPath.row
 预约日期.tag = 100+indexPath.row
 医保后的金额.tag = 200+indexPath.row;
 医保是.tag = 300+indexPath.row;
 医保否.tag = 400+indexPath.row;
 ******/

@implementation InstallmentVC

- (UIButton *)addOrDeleteBtn {
    if (!_addOrDeleteBtn) {
        _addOrDeleteBtn = [[UIButton alloc]init];
    }return _addOrDeleteBtn;
}
- (NSMutableArray *)cellDataCountArr {
    if (!_cellDataCountArr) {
        _cellDataCountArr = [NSMutableArray array];
    }return _cellDataCountArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *yb = [[NSUserDefaults standardUserDefaults]objectForKey:@"yb"];
    self.yb = yb;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]init];
    gesture.cancelsTouchesInView = NO;
    [gesture addTarget:self action:@selector(gestureClick)];
    [self.view addGestureRecognizer:gesture];
    
    //键盘监控
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"分期付款" andRightImage:nil withRightTitle:nil];
    
    InstallmentModel *model = [[InstallmentModel alloc]init];
    [self.cellDataCountArr addObject:model];
    
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
    if (section == 1) {
        return self.cellDataCountArr.count;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 55;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.yb isEqualToString:@"无"]) {
        return 182;
    }
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    if (section == 0) {
        
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.text = @"约定金额：";
            [bgView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView).with.offset(15);
                make.top.equalTo(bgView).with.offset(20);
            }];
            
            UILabel *titleTextLabel = [[UILabel alloc]init];
            titleTextLabel.font = [UIFont systemFontOfSize:13];
            titleTextLabel.textColor = [UIColor blackColor];
            titleTextLabel.text = self.appointMoney;
            [bgView addSubview:titleTextLabel];
            [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLabel);
                make.left.equalTo(titleLabel.mas_right);
            }];

        
    }else if(section == 1) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"分期详情：";
        [bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView).with.offset(20);
            make.left.equalTo(bgView).with.offset(15);
        }];
        
        self.addOrDeleteBtn.backgroundColor = [UIColor stringTOColor:@"#ffab2e"];
        self.addOrDeleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.addOrDeleteBtn.layer.cornerRadius = 5;
        self.addOrDeleteBtn.clipsToBounds = YES;
        if (self.addOrDeleteBtn.currentTitle == nil ||[self.addOrDeleteBtn.currentTitle isEqualToString:@""]) {
            [self.addOrDeleteBtn setTitle:@"移除分期" forState:normal];
        }else {
            [self.addOrDeleteBtn setTitle:self.addOrDeleteBtn.currentTitle forState:normal];
        }
        [self.addOrDeleteBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [bgView addSubview:self.addOrDeleteBtn];
        [self.addOrDeleteBtn addTarget:self action:@selector(addOrDeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.addOrDeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(bgView).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(80, 25));
        }];

        
    }else {
        bgView.backgroundColor = [UIColor clearColor];
        
        UIButton *sendDataBtn = [[UIButton alloc]init];
        [sendDataBtn setTitle:@"提交" forState:normal];
        sendDataBtn.layer.cornerRadius = 5;
        sendDataBtn.clipsToBounds = YES;
        sendDataBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        sendDataBtn.backgroundColor = [UIColor stringTOColor:@"#57a4e3"];
        [sendDataBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [sendDataBtn addTarget:self action:@selector(sendDataBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:sendDataBtn];
        [sendDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).with.offset(15);
            make.right.equalTo(bgView).with.offset(-15);
            make.top.equalTo(bgView).with.offset(25);
            make.height.mas_equalTo(@30);
        }];
    }
    
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    InstallmentModel *model = self.cellDataCountArr[indexPath.row];
    
    UILabel *cellTitleLabel;
    for (int i = 0; i<5; i++) {
        cellTitleLabel = [[UILabel alloc]init];
        cellTitleLabel.font = [UIFont systemFontOfSize:13];
        cellTitleLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:cellTitleLabel];
        
        UITextField *cellTitleTextField = [[UITextField alloc]init];
        cellTitleTextField.font = [UIFont systemFontOfSize:13];
        cellTitleTextField.textColor = [UIColor blackColor];
        cellTitleTextField.delegate = self;
        
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        
        
        UILabel *moneyViewLabel;
        moneyViewLabel = [[UILabel alloc]init];
        moneyViewLabel.text = @"¥";
        moneyViewLabel.font = [UIFont systemFontOfSize:13];
        moneyViewLabel.textColor = [UIColor blackColor];
        
        UILabel *deleteLine = [[UILabel alloc]init];
        deleteLine.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:deleteLine];
        
        if (i == 0) {
            cellTitleLabel.text = [NSString stringWithFormat:@"第%d期",indexPath.row+1];
        }else if (i == 1) {
            cellTitleTextField.tag = 10+indexPath.row;
            cellTitleLabel.text = @"约定金额：";
            cellTitleTextField.text = model.appointMoney;
            [cell.contentView addSubview:lineLabel];
            [cell.contentView addSubview:cellTitleTextField];

            [cell.contentView addSubview:moneyViewLabel];
            
        }else if(i == 2){
            cellTitleTextField.tag = 100+indexPath.row;
            cellTitleLabel.text = @"预定日期：";
            
            //时间戳转时间的方法
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.appointDate integerValue]/1000];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            NSLog(@"confromTimespStr =  %@",confromTimespStr);
            if (model.appointDate == nil) {
                cellTitleTextField.text = @"";
            }else {
                cellTitleTextField.text = confromTimespStr;
            }
            
            [cell.contentView addSubview:lineLabel];
            [cell.contentView addSubview:cellTitleTextField];

        }else if (i == 3) {
            if (![self.yb isEqualToString:@"无"]) {
                cellTitleLabel.font = [UIFont systemFontOfSize:10];
                cellTitleLabel.text = @"医保选择：";
            }
        }else if (i == 4) {
            if (![self.yb isEqualToString:@"无"]) {
                cellTitleLabel.text = @"预交金额：";
                cellTitleTextField.tag = indexPath.row+200;
                cellTitleTextField.text = model.ybMoney;
                
                if (model.ybYES == NO) {
                    cellTitleLabel.textColor = [UIColor lightGrayColor];
                    [cell.contentView addSubview:deleteLine];
                }
                [cell.contentView addSubview:lineLabel];
                [cell.contentView addSubview:cellTitleTextField];
                
                [cell.contentView addSubview:moneyViewLabel];
            }
            
        }
        
        
        
        [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).with.offset(10+28*i);
            if (i == 3) {
                make.top.equalTo(cell.contentView).with.offset(10+28*i+10);
                make.left.equalTo(cell.contentView).with.offset(43);
            }else {
                if (i == 4 || ![self.yb isEqualToString:@"无"]) {
                    make.top.equalTo(cell.contentView).with.offset(10+28*i+10);
                }
                make.left.equalTo(cell.contentView).with.offset(30);
            }
        }];
        
        
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 1 || i==2 ||(i==4 && ![self.yb isEqualToString:@"无"])) {
                make.bottom.equalTo(cellTitleLabel.mas_bottom);
                make.left.equalTo(cellTitleLabel.mas_right);
                make.size.mas_equalTo(CGSizeMake(120, 0.5));
            }
            
        }];
        
        [moneyViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 1 ||(i ==4 && ![self.yb isEqualToString:@"无"])) {
                make.left.equalTo(lineLabel);
                make.width.mas_equalTo(@10);
                make.centerY.equalTo(cellTitleLabel);
            }
            
        }];
        
        [cellTitleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==1 || i==2 ||(i == 4 && ![self.yb isEqualToString:@"无"])) {
                make.centerY.equalTo(cellTitleLabel);
                make.right.equalTo(lineLabel);
                if (i == 1|| (i == 4 && ![self.yb isEqualToString:@"无"])) {
                    make.left.equalTo(moneyViewLabel.mas_right);
                }else if (i == 2) {
                    make.left.equalTo(cellTitleLabel.mas_right);
                }
            }
            
        }];
        
        
        [deleteLine mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 4 && model.ybYES == NO && ![self.yb isEqualToString:@"无"]) {
                make.left.equalTo(cellTitleLabel);
                make.right.equalTo(moneyViewLabel);
                make.centerY.equalTo(cellTitleLabel);
                make.height.mas_equalTo(@1);
            }
            
        }];
        
        if (i == 3 && ![self.yb isEqualToString:@"无"]) {
            for (int i = 0; i<2; i++) {
                UIButton *ybBtn = [[UIButton alloc]init];
                [ybBtn setImage:[UIImage imageNamed:@"未选"] forState:normal];
                [ybBtn setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateSelected];
                ybBtn.titleLabel.font = [UIFont systemFontOfSize:10];
                [ybBtn addTarget:self action:@selector(ybBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [ybBtn setTitleColor:[UIColor blackColor] forState:normal];
                [cell.contentView addSubview:ybBtn];
                if (i == 0) {
                    ybBtn.tag = 300+indexPath.row;
                    [ybBtn setTitle:@" 是" forState:normal];
                    if (model.ybYES == YES) {
                        ybBtn.selected = YES;
                    }
                    
                }else {
                    ybBtn.tag = 400+indexPath.row;
                    [ybBtn setTitle:@" 否" forState:normal];
                    if (model.ybYES == NO) {
                        ybBtn.selected = YES;
                    }
                }
                [ybBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cellTitleLabel.mas_right).with.offset(10+40*i);
                    make.centerY.equalTo(cellTitleLabel);
                    make.size.mas_equalTo(CGSizeMake(30, 15));
                }];
            }

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
        
        InstallmentModel *model = [[InstallmentModel alloc]init];
        //现在数据源里添加进去数据然后在刷表
        [self.cellDataCountArr insertObject:model atIndex:indexPath.row+1];
        
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

//医保btn 点击事件
- (void)ybBtnClick:(UIButton *)sender {
    
    InstallmentModel *model;

    if (sender.tag>=300 && sender.tag<400) {
        
        model = self.cellDataCountArr[sender.tag-300];
        model.ybYES = YES;
    }else {
        
        model = self.cellDataCountArr[sender.tag-400];
        model.ybMoney = model.appointMoney;
        model.ybYES = NO;
    }
    
    NSLog(@"%d",model.ybYES);
    [self.tableView reloadData];
}

//移除分期、添加分期按钮点击事件
- (void)addOrDeleteBtnClick:(UIButton *)sender{
    
    self.tableView.editing = YES;
    
    if ([sender.currentTitle isEqualToString:@"移除分期"]) {
        [sender setTitle:@"添加分期" forState:normal];
        self.addOrDeleteStatus = YES;
        
    }else if ([sender.currentTitle isEqualToString:@"添加分期"]) {
        [sender setTitle:@"移除分期" forState:normal];
        self.addOrDeleteStatus = NO;
        
        InstallmentModel *model = [[InstallmentModel alloc]init];
        if (self.cellDataCountArr.count == 0) {
            [self.cellDataCountArr addObject:model];
        }
    }
    
    NSLog(@"%@",sender.currentTitle);
    [self.tableView reloadData];

}

#pragma mark --- textField代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.tableView.editing = NO;
    [self.addOrDeleteBtn setTitle:@"添加分期" forState:normal];
    
    if (textField.tag>=100 &&textField.tag<200) {
        
        [self.view endEditing:YES];
        LZDatePickerView *datePickerView = [[LZDatePickerView alloc]init];
        self.datePickerView = datePickerView;
        
        [datePickerView createDatePickerView];
        [datePickerView.datePickerCancelBtn addTarget:self action:@selector(datePickerCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [datePickerView.datePickerSureBtn addTarget:self action:@selector(datePickerSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
        self.dateTextField = textField;

        
        return NO;
    }else if (textField.tag>=200 &&textField.tag<300) {
        InstallmentModel *model = self.cellDataCountArr[textField.tag-200];
        if (model.ybYES == NO) {
            return NO;
        }
    }
    
    return YES;
    
}
//DatePickerView 取消按钮
- (void)datePickerCancelBtnClick:(UIButton *)sender {
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);
    [sender.superview.superview removeFromSuperview];
}
//DatePickerView 确认按钮
- (void)datePickerSureBtnClick:(UIButton *)sender {
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);
    [sender.superview.superview removeFromSuperview];
    
    
    NSLog(@"%@~~~%@",self.datePickerView.selectTimestamp,self.datePickerView.currentTimestamp);
    if ([self.datePickerView.selectTimestamp integerValue]<[self.datePickerView.currentTimestamp integerValue]) {
        [self createAlterViewWithMessage:@"分期时间不能小于当前时间" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
    }else {
        InstallmentModel *model;
        model = self.cellDataCountArr[self.dateTextField.tag-100];
        self.dateTextField.text = self.datePickerView.selectDate;
        model.appointDate = self.datePickerView.selectTimestamp;
    }
    
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSLog(@"tag===%ld",(long)textField.tag);
    
    InstallmentModel *model;
    if (textField.tag<100) {
        model = self.cellDataCountArr[textField.tag-10];
        model.appointMoney = textField.text;
        
        if ([textField.text floatValue] == 0) {
            textField.text = @"";
            [self createAlterViewWithMessage:@"金额不能为0" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
        }else if ([textField.text floatValue]>[self.appointMoney floatValue]) {
            [self createAlterViewWithMessage:@"分期金额不能大于总金额" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
            textField.text = @"";
        }
        
    }else if(textField.tag>=100 && textField.tag<200){
        model = self.cellDataCountArr[textField.tag-100];
        model.appointDate = self.datePickerView.selectDate;
    }else if(textField.tag>=200 && textField.tag<300){
        model = self.cellDataCountArr[textField.tag-200];
        model.ybMoney = textField.text;
    }
    
    
}

- (void)gestureClick {
    
    [self.view endEditing:YES];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);
}

//提交按钮点击事件
- (void)sendDataBtnClick:(UIButton *)sender {
    NSLog(@"提交！！");
    
    NSMutableArray *priceArr = [NSMutableArray array];
    NSMutableArray *dateArr = [NSMutableArray array];
    NSMutableArray *prepaidArr = [NSMutableArray array];
    
    if ([self isNull]) {
        for (int i = 0; i<self.cellDataCountArr.count; i++) {
            InstallmentModel *model = self.cellDataCountArr[i];
            
            [priceArr addObject:model.appointMoney];
            if (![self.yb isEqualToString:@"无"]) {
                if (model.ybMoney) {
                    [prepaidArr addObject:model.ybMoney];
                }else {
                    [prepaidArr addObject:model.appointMoney];
                }
            }
            //时间戳转时间的方法
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.appointDate integerValue]/1000];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            NSLog(@"%@",confromTimespStr);
            [dateArr addObject:confromTimespStr];
            
        }
        
        
        
        NSString *dnumberStr = [RSAEncryptor encryptString:self.dnumber publicKey:self.publicKey];
        
        NSLog(@"%@",prepaidArr);
        
        [self sendOrderRequestWithDnumber:dnumberStr andPayMethod:@"1" andPrice:priceArr andPrepaid:prepaidArr andYueTimeArr:dateArr];
    }
    
}
//判断是否为空
- (BOOL)isNull {
    for (int i = 0; i<self.cellDataCountArr.count; i++) {
        InstallmentModel *model = self.cellDataCountArr[i];
        
        if ([model.appointMoney isEqualToString:@""] || model.appointMoney == nil) {
            [self createAlterViewWithMessage:@"约定金额不能为0" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
            NSLog(@"111");
            return NO;
        }
        if (model.appointDate == nil||[model.appointDate isEqualToString:@""]) {
            [self createAlterViewWithMessage:@"还款日期不能为空" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
            NSLog(@"222");

            return NO;

        }
        if (i<self.cellDataCountArr.count-1) {
            InstallmentModel *nextModel = self.cellDataCountArr[i+1];
            if ([model.appointDate integerValue]>=[nextModel.appointDate integerValue]) {
                [self createAlterViewWithMessage:[NSString stringWithFormat:@"第%d期约定时间不能小于或等于上一期",i+2] withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
                return NO;
            }
            
        }
        
        if (![self.yb isEqualToString:@"无"] && model.ybYES == YES ) {
            if ([model.ybMoney isEqualToString:@""] ||[model.ybMoney isEqualToString:@"0"] || model.ybMoney == nil) {
                [self createAlterViewWithMessage:@"预交金额不能为0" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
                NSLog(@"444");

                return NO;
            }
            
        }
    }
        return YES;
}

#pragma mark --- request

//提交分期
- (void)sendOrderRequestWithDnumber:(NSString *)dnumber andPayMethod:(NSString *)pay_method andPrice:(NSArray *)priceArr andPrepaid:(NSArray *)prepaidArr andYueTimeArr:(NSArray *)yueTimeArr {
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/agree_pay"];
    NSDictionary *dic = @{@"dnumber":dnumber,@"pay_method":pay_method,@"price":priceArr,@"prepaid":prepaidArr,@"yuetime":yueTimeArr};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self sendOrderRequestData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
- (void)sendOrderRequestData:(NSDictionary *)dic {
    
    NSLog(@"%@",dic);
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
