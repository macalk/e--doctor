//
//  PersonalInformationVC.m
//  enuoDoctor
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonalInformationVC.h"

@interface PersonalInformationVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)NSArray *cellTitleArr;

@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)NSArray *sexArr;
@property (nonatomic,strong)NSArray *professionArr;
@property (nonatomic,copy)NSString *selectSexStr;
@property (nonatomic,copy)NSString *selectProfessionStr;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

                              /********
                               
                               说明：
                               cell上的所有textField 都加了tag值
                               第一个区的为10+indexPath.row
                               第一个区的为20+indexPath.row
                               
                               PickerView.tag = 当前TextField.tag+100
                               
                               **********/

@implementation PersonalInformationVC

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"个人信息" andRightImage:nil withRightTitle:@"修改"];
    
    self.cellTitleArr = @[@"姓名：",@"性别：",@"职称：",@"手机：",@"邮箱："];
    self.sexArr = @[@"男",@"女"];
    self.professionArr = @[@"主任医师",@"副主任医师",@"主治医师",@"医师",@"医士"];
    
    [self requestData];
    [self createTableView];
    
    
    //取消键盘
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
    [tapGes addTarget:self action:@selector(cancelKeyBoard)];
    [self.view addGestureRecognizer:tapGes];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//弹出键盘
- (void)keyBoardFrameChange:(NSNotification *)noti {
    NSDictionary *dic = [noti userInfo];
    CGRect rect = [[dic objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    float keyBoardHeight = rect.size.height;
    NSLog(@"%f",keyBoardHeight);
    
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-keyBoardHeight-64);
   
}
//修改按钮点击事件
- (void)rightItemClick {
        
    [self.view endEditing:YES];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);
    [self changeInformationRequest];
    
}

#pragma mark---创建tableView
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor redColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor stringTOColor:@"#f4f4f4"];
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 10;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *cellTitleLabel = [[UILabel alloc]init];
    [cell.contentView addSubview:cellTitleLabel];
    cellTitleLabel.font = [UIFont systemFontOfSize:13];
    
    UITextField *cellTextField = [[UITextField alloc]init];
    cellTextField.tag = 10+indexPath.section*10+indexPath.row;
    cellTextField.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:cellTextField];
    
    if (indexPath.section == 0) {
        cellTitleLabel.text = [NSString stringWithFormat:@"%@",self.cellTitleArr[indexPath.row]];
        if (self.dataArr.count == 0) {
            cellTextField.text = @"";
        }else {
            cellTextField.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
        }
        
        if (indexPath.row == 1) {
            cellTextField.delegate = self;
        }
    }else {
        if (indexPath.row == 0) {
            cellTextField.delegate = self;
        }
        cellTitleLabel.text = [NSString stringWithFormat:@"%@",self.cellTitleArr[indexPath.row+2]];
        if (self.dataArr.count == 0) {
            cellTextField.text = @"";
        }else {
            cellTextField.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row+2]];
        }

    }
    
    
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).with.offset(15);
        make.centerY.equalTo(cell.contentView);
    }];
    
    [cellTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cellTitleLabel);
        make.left.equalTo(cellTitleLabel.mas_right).with.offset(10);
        make.width.mas_offset(@200);
    }];
    
    return cell;
}

#pragma mark---textField代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self cancelKeyBoard];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = window.bounds;
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [window addSubview:bgView];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeigth, kScreenWidth, 246)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteView];
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 216)];
    self.pickerView = pickerView;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.tag = textField.tag+100;
    
    if (pickerView.tag == 111) {
        [pickerView selectRow:1 inComponent:0 animated:YES];//默认选中行数
        self.selectSexStr = @"女";
    }else {
        [pickerView selectRow:2 inComponent:0 animated:YES];//默认选中行数
        self.selectProfessionStr = @"主治医师";
    }
    
    [whiteView addSubview:pickerView];
    [UIView animateWithDuration:0.5 animations:^{
        whiteView.frame = CGRectMake(0, kScreenHeigth-246, kScreenWidth, 246);
    }];
    
    NSArray *btnArr = @[@"取消",@"确定"];
    for (int i = 0; i<2; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.frame = CGRectMake((kScreenWidth-80)*i, 0, 80, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:[NSString stringWithFormat:@"%@",btnArr[i]] forState:normal];
        [button setTitleColor:[UIColor stringTOColor:@"#22ccc6"] forState:normal];
        if (i == 0) {
            [button addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [button addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [whiteView addSubview:button];
    }
    
    return NO;
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView.tag == 111) {
        return 2;
    }else {
        return 5;
    }
    
}
//设置组件中每行的标题row:行
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:15];
    
    
    if (pickerView.tag == 111) {
        textLabel.text = self.sexArr[row];
    }else {
        textLabel.text = self.professionArr[row];
    }

    return textLabel;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView.tag == 111) {
        self.selectSexStr = self.sexArr[row];
    }else {
        self.selectProfessionStr = self.professionArr[row];
    }
    
}

- (void)cancelBtnClick:(UIButton *)sender {
    [self.pickerView.superview.superview removeFromSuperview];
    
}
- (void)sureBtnClick:(UIButton *)sender {
    [self.pickerView.superview.superview removeFromSuperview];
    
    for (id tempView in sender.superview.subviews) {
        if ([tempView isKindOfClass:[UIPickerView class]]) {
            UIPickerView *pickerView = (UIPickerView *)tempView;
            
            if (pickerView.tag == 111) {
                UITextField *textField = [self.view viewWithTag:pickerView.tag-100];
                textField.text = self.selectSexStr;
            }else {
                UITextField *textField = [self.view viewWithTag:pickerView.tag-100];
                textField.text = self.selectProfessionStr;
            }
        }
    }
}

//取消键盘
- (void)cancelKeyBoard {
    
    [self.view endEditing:YES];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64);

}

- (void)requestData {
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/personal_data"];
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSDictionary *dic = @{@"username":userName};
    BaseRequest *request = [[BaseRequest alloc]init];
    
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dataOfRequest:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark-- 数据请求
- (void)dataOfRequest:(NSDictionary *)dic {
    NSDictionary *dataDic = dic[@"data"];
    NSString *name = dataDic[@"name"];
    NSString *sex = dataDic[@"sex"];
    if ([sex isKindOfClass:[NSNull class]]) {
        sex = @"男";
    }
    NSString *professional = dataDic[@"professional"];
    NSString *phone = dataDic[@"phone"];
    NSString *email = dataDic[@"email"];
    self.dataArr = [NSMutableArray arrayWithObjects:name,sex,professional,phone,email, nil];
    
    
    [self.tableView reloadData];
}

- (void)changeInformationRequest {
    UITextField *nameTextField = [self.view viewWithTag:10];
    UITextField *sexTextField = [self.view viewWithTag:11];
    UITextField *professionalTextField = [self.view viewWithTag:20];
    UITextField *phoneTextField = [self.view viewWithTag:21];
    UITextField *emailTextField = [self.view viewWithTag:22];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    if ([nameTextField.text isEqualToString:@""] ||[sexTextField.text isEqualToString:@""] || [professionalTextField.text isEqualToString:@""] || [phoneTextField.text isEqualToString:@""] || [emailTextField.text isEqualToString:@""]) {
        [self createAlterViewWithMessage:@"请补全信息" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
    }else {
        NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/change_information"];
        NSDictionary *dic = @{@"username":username,@"name":nameTextField.text,@"sex":sexTextField.text,@"professional":professionalTextField.text,@"phone":phoneTextField.text,@"email":emailTextField.text};
        
        BaseRequest *request = [[BaseRequest alloc]init];
        [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            [self dataOfChangeInformationRequest:responseObject];
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
 
    }
}

- (void)dataOfChangeInformationRequest:(NSDictionary *)dic {
    NSString *errcode = dic[@"data"][@"errcode"];
    if ([errcode integerValue] == 0) {
        UIAlertController *alterView = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alterView addAction:sureAction];
        [self presentViewController:alterView animated:YES completion:nil];
        
    }else {
        [self createAlterViewWithMessage:dic[@"message"] withSureBtn:YES withCancelBtn:NO withDeleteBtn:NO];
    }
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
