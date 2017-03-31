//
//  ReservationManageVC.m
//  enuoDoctor
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ReservationManageVC.h"

@interface ReservationManageVC ()<LZtitleViewDelegate,LZFiltrateViewDelegate,RMViewBtnDelegae,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) LZTitleView *LZView;
@property (nonatomic,strong) LZDatePickerView *lzDatePickerView;
@property (nonatomic,strong) LZPickerView *lzPickerView;


@property (nonatomic,strong) UIButton *changeDateBtn;//修改日期
@property (nonatomic,strong) UIButton *cancelOrderBtn;//取消订单
@property (nonatomic,strong) UIButton *rankBtn;//排号
@property (nonatomic,strong) OrderCancelReasonView *cancelOrderView;//取消订单View


@property (nonatomic,strong) NSMutableArray *waitSureArr;//带确认
@property (nonatomic,strong) NSMutableArray *waitSeeDoctorArr;//带就诊
@property (nonatomic,strong) NSMutableArray *payWayArr;//付款方式
@property (nonatomic,strong) NSMutableArray *waitPayArr;//带付款
@property (nonatomic,strong) NSMutableArray *cancelOrderArr;//取消订单
@property (nonatomic,assign) BOOL orderUp;//下单时间排序
@property (nonatomic,assign) BOOL dateUp;//预约时间排序



@end

                                    /**********
                                     说明：
                                     预约确认、待就诊、待付款、、、、tag为：10+
                                     tableView 的tag为：20+
                                     
                                     *********/

@implementation ReservationManageVC

- (NSMutableArray *)waitSureArr {
    if (!_waitSureArr) {
        _waitSureArr = [NSMutableArray array];
    }return _waitSureArr;
}
- (NSMutableArray *)waitSeeDoctorArr {
    if (!_waitSeeDoctorArr) {
        _waitSeeDoctorArr = [NSMutableArray array];
    }return _waitSeeDoctorArr;
}
- (NSMutableArray *)payWayArr {
    if (!_payWayArr) {
        _payWayArr = [NSMutableArray array];
    }return _payWayArr;
}
- (NSMutableArray *)waitPayArr {
    if (!_waitPayArr) {
        _waitPayArr = [NSMutableArray array];
    }return _waitPayArr;
}
- (NSMutableArray *)cancelOrderArr {
    if (!_cancelOrderArr) {
        _cancelOrderArr = [NSMutableArray array];
    }return _cancelOrderArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataWithRequest];
    [self getNewInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createCustomNavViewWithTitle:@"预约管理" andLeftImage:nil withLeftTitle:nil andRightImage:@"筛选" withRightTitle:nil];
    
    [self createLZTitleView];
    self.tabBarController.tabBar.tintColor =  [UIColor colorWithRed:0/255.0 green:179/255.0 blue:163/255.0 alpha:1];
    
    [self getDataWithRequest];
    [self createScrollView];
}
//获取数据
- (void)getDataWithRequest {
    
    [self requestDataWithStatus:@"1" WithSort:@"nowdate:asc|yue_noon:asc"];
    [self requestDataWithStatus:@"2" WithSort:@"nowdate:asc|yue_noon:asc"];
    [self requestDataWithStatus:@"3" WithSort:@"nowdate:asc|yue_noon:asc"];
    [self requestDataWithStatus:@"4" WithSort:@"nowdate:asc|yue_noon:asc"];
    [self requestDataWithStatus:@"5" WithSort:@"nowdate:asc|yue_noon:asc"];

}
//刷新tableview
- (void)refreshTableView {
    for (int i = 0; i<5; i++) {
        UITableView *tableView = [self.view viewWithTag:20+i];
        [tableView reloadData];
    }
}

//rightItem(筛选)  点击事件(继承于父类)
- (void)rightItemClick {
    
    NSArray *filtrateBtnTitleArr = @[@"下单时间",@"预约日期"];
    LZFiltrateView *LZView = [[LZFiltrateView alloc]init];
    [self.view addSubview:LZView];
    LZView.LZFiltrateDelegate = self;
    [LZView createViewWithDataArr:filtrateBtnTitleArr];
    
}

- (void)LZFiltrateBtnClick:(UIButton *)sender {
    
    NSInteger status = self.scrollView.contentOffset.x/kScreenWidth+1;
    
    if ([sender.currentTitle isEqualToString:@"  下单时间"]) {
        self.orderUp = !self.orderUp;
        if (self.orderUp == YES) {
            [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)status] WithSort:@"nowdate:desc|yue_noon:desc"];
        }else {
            [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)status] WithSort:@"nowdate:asc|yue_noon:asc"];
        }
    }else {
        self.dateUp = !self.dateUp;
        if (self.dateUp == YES) {
            if (status == 1 || status == 5) {
                [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)status] WithSort:@"yue_date:asc|yue_noon:asc"];
            }else {
                [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)status] WithSort:@"yue_date:asc|yue_time:asc"];
            }
        }else {
            if (status == 1 || status == 5) {
                [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)status] WithSort:@"yue_date:desc|yue_noon:desc"];
            }else {
                [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)status] WithSort:@"yue_date:desc|yue_time:desc"];
            }
        }
        
        
    }
}

#pragma mark --- 创建LZTitleView 以及实现代理方法
- (void)createLZTitleView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *titleArr = @[@"预约待确认",@"待就诊",@"约定付款方式",@"患者待付款",@"取消订单"];
    LZTitleView *LZView = [[LZTitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
    LZView.LZDelegate = self;
    [LZView CreateCustomTitleViewWithTitleArr:titleArr];
    self.LZView = LZView;
    [self.view addSubview:LZView];
}
- (void)LZtitleBtnClick:(UIButton *)sender {
    self.scrollView.contentOffset = CGPointMake(kScreenWidth*(sender.tag-10), 0);
    
    //刷新当前界面
    [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)sender.tag-10] WithSort:@"nowdate:asc|yue_noon:asc"];
    [self.LZView hiddenRedLabelWithStatus:[NSString stringWithFormat:@"%ld",(long)sender.tag-10]];
}

#pragma mark---创建scrollview 和tableview
- (void)createScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 37, kScreenWidth, kScreenHeigth-64-37-50)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(kScreenWidth*5, 0);
    scrollView.pagingEnabled = YES;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i<5; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, scrollView.bounds.size.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = 20+i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [scrollView addSubview:tableView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        
        NSInteger index = scrollView.contentOffset.x/kScreenWidth;
        
        [self.LZView changeBtnFrameWithBtnTag:index];
        [self.LZView hiddenRedLabelWithStatus:[NSString stringWithFormat:@"%ld",(long)index]];
        
        //刷新当前界面
        [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)index] WithSort:@"nowdate:asc|yue_noon:asc"];
    }
}

#pragma mark -- tableView delegate和dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 20) {
        NSLog(@"%ld",(unsigned long)self.waitSureArr.count);
        return self.waitSureArr.count;
    }else if (tableView.tag == 21) {
        return self.waitSeeDoctorArr.count;
    }else if (tableView.tag == 22) {
        return self.payWayArr.count;
    }else if (tableView.tag == 23) {
        return self.waitPayArr.count;
    }else if (tableView.tag == 24) {
        return self.cancelOrderArr.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReservationManageModel *model;

    if (tableView.tag == 20) {
        model = self.waitSureArr[indexPath.row];
    }else if (tableView.tag == 21) {
        model = self.waitSeeDoctorArr[indexPath.row];
    }else if (tableView.tag == 22) {
        model = self.payWayArr[indexPath.row];
    }else if (tableView.tag == 23) {
        model = self.waitPayArr[indexPath.row];
    }else if (tableView.tag == 24) {
        model = self.cancelOrderArr[indexPath.row];
    }
    
    return model.viewHeght-1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    ReservationManageModel *model;
    NSString *status;
    if (tableView.tag == 20 && self.waitSureArr.count>0) {
        model = self.waitSureArr[indexPath.row];
        status = @"1";
    }else if (tableView.tag == 21 && self.waitSeeDoctorArr.count>0) {
        model = self.waitSeeDoctorArr[indexPath.row];
        status = @"2";
    }else if (tableView.tag == 22 && self.payWayArr.count>0) {
        model = self.payWayArr[indexPath.row];
        status = @"3";
    }else if (tableView.tag == 23 && self.waitPayArr.count>0) {
        model = self.waitPayArr[indexPath.row];
        status = @"4";
    }else if (tableView.tag == 24 && self.cancelOrderArr.count>0) {
        model = self.cancelOrderArr[indexPath.row];
        status = @"5";
    }
    
    ReservationManageView *reserView = [[ReservationManageView alloc]init];
    reserView.RMViewBtnDelegae = self;
    [cell.contentView addSubview:reserView];
    [reserView createCustomViewWithModel:model withStatus:status];
    reserView.frame = CGRectMake(0, 0, kScreenWidth, model.viewHeght);
    
    if (tableView.tag == 20) {
        [reserView.rankBtn addTarget:self action:@selector(rankBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [reserView.changeDateBtn addTarget:self action:@selector(changeDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}

#pragma mark---ReservationManageView代理方法  （取消订单，提交订单等）点击事件
- (void)RMViewBtnClick:(UIButton *)sender {
    
    //获得该按钮所在视图
    ReservationManageView *RMView;
    for (UIView *next = [sender superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[ReservationManageView class]]) {
            RMView = (ReservationManageView *)nextResponder;
            }
    }
    
    if ([sender.currentTitle isEqualToString:@"取消订单"]) {
        
        self.cancelOrderBtn = sender;
        self.cancelOrderView = [[OrderCancelReasonView alloc]init];
        [self.view addSubview:self.cancelOrderView];
        [self.cancelOrderView createCancelReasonView];
        [self.cancelOrderView.sureBtn addTarget:self action:@selector(cancelOrderSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else if ([sender.currentTitle isEqualToString:@"提交订单"]) {
        
        NSString *lastChatStr = [RMView.appointmentTimeLabel.text substringFromIndex:RMView.appointmentTimeLabel.text.length-1];//最后一个字符
        
        if ([RMView.rankBtn.currentTitle isEqualToString:@"请排号"] || [lastChatStr isEqualToString:@"m"]  ) {
            [self createAlterViewWithMessage:@"未对患者排号或未设置预约时间" withSureBtn:YES withCancelBtn:NO withDeleteBtn:NO];
        }else {
            NSString *noonStr;
            if ([self.lzDatePickerView.hourStr integerValue]>11) {
                noonStr = @"pm";
            }else {
                noonStr = @"am";
                
            }
            
            
            [self submitOrderRequestWithDnumber:RMView.model.dnumber andDsort:self.lzPickerView.selectData andYueTime:[NSString stringWithFormat:@"%@:00",self.lzDatePickerView.hourStr] andYueDate:[NSString stringWithFormat:@"%@-%@-%@",self.lzDatePickerView.yearStr,self.lzDatePickerView.monthStr,self.lzDatePickerView.dayStr] andYueNoon:noonStr];
        }
        
    }else if ([sender.currentTitle isEqualToString:@"进一步检查"]) {
        NextCheckVC *nextCheckVC = [[NextCheckVC alloc]init];
        nextCheckVC.nameStr = RMView.model.name;
        nextCheckVC.illStr = RMView.model.ill;
        nextCheckVC.dnumberStr = RMView.model.dnumber;
        nextCheckVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nextCheckVC animated:YES];
                
    }else if ([sender.currentTitle isEqualToString:@"诊断明确"]) {
        ExplicitDiagnosisVC *explicitDiagnosisVC = [[ExplicitDiagnosisVC alloc]init];
        explicitDiagnosisVC.nameStr = RMView.model.name;
        explicitDiagnosisVC.illStr = RMView.model.ill;
        explicitDiagnosisVC.dnumber = RMView.model.dnumber;
        explicitDiagnosisVC.hos_id = RMView.model.hos_id;
        explicitDiagnosisVC.username = RMView.model.username;
        explicitDiagnosisVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:explicitDiagnosisVC animated:YES];
        
    }else if ([sender.currentTitle isEqualToString:@"分期支付"]) {
        InstallmentVC *installVC = [[InstallmentVC alloc]init];
        installVC.appointMoney = RMView.model.price;
        installVC.dnumber = RMView.model.dnumber;
        installVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:installVC animated:YES];
    }else if ([sender.currentTitle isEqualToString:@"一次性支付"]) {
        OneOffPaymentVC *oneoffPayVC = [[OneOffPaymentVC alloc]init];
        oneoffPayVC.priceStr = RMView.model.price;
        oneoffPayVC.dnumber = RMView.model.dnumber;
        [self.navigationController pushViewController:oneoffPayVC animated:YES];
    }
}


//排号按钮
- (void)rankBtnClick:(UIButton *)sender {
    self.rankBtn = sender;
    NSMutableArray *dataArr = [NSMutableArray array];
    NSString *data;
    for (int i = 0; i<100; i++) {
        data = [NSString stringWithFormat:@"%d",i+1];
        [dataArr addObject:data];
    }
    
    LZPickerView *lzPickerView = [[LZPickerView alloc]init];
    self.lzPickerView = lzPickerView;
    [self.view addSubview:lzPickerView];
    [lzPickerView createPickerViewWithArr:dataArr];
    [lzPickerView.cancelBtn addTarget:self action:@selector(LZPickerViewCancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [lzPickerView.sureBtn addTarget:self action:@selector(LZPickerViewSureClick:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)LZPickerViewCancelClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
}
- (void)LZPickerViewSureClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
    if (self.lzPickerView.selectData == nil) {
        [self.rankBtn setTitle:@"排号：1" forState:normal];
    }else {
        [self.rankBtn setTitle:[NSString stringWithFormat:@"排号：%@",self.lzPickerView.selectData] forState:normal];
    }
    
}
//修改日期按钮
- (void)changeDateBtnClick:(UIButton *)sender {
    
    self.changeDateBtn = sender;
    
    LZDatePickerView *datePickerView = [[LZDatePickerView alloc]init];
    self.lzDatePickerView = datePickerView;
    
    [datePickerView createDatePickerView];
    [datePickerView.datePickerCancelBtn addTarget:self action:@selector(datePickerCancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [datePickerView.datePickerSureBtn addTarget:self action:@selector(datePickerSureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
//DatePickerView 取消按钮
- (void)datePickerCancelBtnClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
}
//DatePickerView 确认按钮
- (void)datePickerSureBtnClick:(UIButton *)sender {
    
    [sender.superview.superview removeFromSuperview];
    
    if (self.lzDatePickerView.selectDate == nil) {
        [self createAlterViewWithMessage:@"请选择正确的时间" withSureBtn:YES withCancelBtn:NO withDeleteBtn:NO];
    }else {
        
        for (UIView *next = [self.changeDateBtn superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[ReservationManageView class]]) {
                ReservationManageView *RMView = (ReservationManageView *)nextResponder;
                RMView.appointmentTimeLabel.text = self.lzDatePickerView.selectDate;
            }
        }
        
    }
    
    NSLog(@"%@~~~>>>>>",self.lzDatePickerView.selectDate);
    
    NSLog(@"确认~~~");
}

//取消原因确认按钮
- (void)cancelOrderSureBtn:(UIButton *)sender {
    
    [sender.superview.superview removeFromSuperview];
    
    if ([self.cancelOrderView.textView.text isEqualToString:@""]) {
        [self createAlterViewWithMessage:@"取消原因不能为空" withSureBtn:YES withCancelBtn:NO withDeleteBtn:NO];
    }else {
        
        for (UIView *next = [self.cancelOrderBtn superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[ReservationManageView class]]) {
                ReservationManageView *RMView = (ReservationManageView *)nextResponder;
                
                [self cancelOrderRequestWithDnumber:RMView.model.dnumber andCancelReason:self.cancelOrderView.textView.text];
            }
        }

    }
}
#pragma mark---数据请求
- (void)requestDataWithStatus:(NSString *)status WithSort:(NSString *)sort {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    if (sort == nil) {
        sort = @"";
    }
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/guahao_order"];
    NSDictionary *dic = @{@"username":username,@"statue":status,@"sort":sort};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self DataOfRequest:responseObject WithStatus:status];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)DataOfRequest:(NSDictionary *)dic WithStatus:(NSString *)status {
    
    if ([status isEqualToString:@"1"]) {
        [self.waitSureArr removeAllObjects];
    }else if ([status isEqualToString:@"2"]) {
        [self.waitSeeDoctorArr removeAllObjects];
    }else if ([status isEqualToString:@"3"]) {
        [self.payWayArr removeAllObjects];
    }else if ([status isEqualToString:@"4"]) {
        [self.waitPayArr removeAllObjects];
    }else if ([status isEqualToString:@"5"]) {
        [self.cancelOrderArr removeAllObjects];
    }
    
    NSDictionary *dataDic = dic[@"data"];
    if ([dataDic isKindOfClass:[NSNull class]]) {
        NSLog(@"灭有数据");
    }else {
        NSArray *dataArr = dic[@"data"];
        for (int i = 0; i<dataArr.count; i++) {
            ReservationManageModel *model = [ReservationManageModel ReservationManageModelWithDictionry:dataArr[i]];
            
            if ([status isEqualToString:@"1"]) {
                [self.waitSureArr addObject:model];
            }else if ([status isEqualToString:@"2"]) {
                [self.waitSeeDoctorArr addObject:model];
            }else if ([status isEqualToString:@"3"]) {
                [self.payWayArr addObject:model];
            }else if ([status isEqualToString:@"4"]) {
                [self.waitPayArr addObject:model];
            }else if ([status isEqualToString:@"5"]) {
                [self.cancelOrderArr addObject:model];
            }
        }
        
        [self refreshTableView];
    }
    
}

//获取新消息数量
- (void)getNewInfo {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/pre_guahao_order_list"];
    NSDictionary *dic = @{@"username":username};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self getNewInfoData:responseObject];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)getNewInfoData:(NSDictionary *)dic {
    
    NSDictionary *dataDic = dic[@"data"];
    NSInteger holdSureNum = [dataDic[@"guahao_confirm_num"] integerValue];
    NSInteger holdSeeDoctorNum = [dataDic[@"guahao_yue_num"] integerValue];
    NSInteger payWayNum = [dataDic[@"pay_method_num"] integerValue];
    
    if (holdSureNum>0) {
        [self.LZView showRedLabelWithStatus:@"0" andNum:[NSString stringWithFormat:@"%ld",(long)holdSureNum]];
    }
    if (holdSeeDoctorNum>0) {
        [self.LZView showRedLabelWithStatus:@"1" andNum:[NSString stringWithFormat:@"%ld",(long)holdSeeDoctorNum]];

    }
    if (payWayNum>0) {
        [self.LZView showRedLabelWithStatus:@"2" andNum:[NSString stringWithFormat:@"%ld",(long)payWayNum]];

    }
    
}

//取消订单
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
        [self getDataWithRequest];
    }];
    [alter addAction:sureAction];
    
    [self presentViewController:alter animated:YES completion:nil];
    
}

//提交订单
- (void)submitOrderRequestWithDnumber:(NSString *)dnumber andDsort:(NSString *)dsort andYueTime:(NSString *)yue_time andYueDate:(NSString *)yue_date andYueNoon:(NSString *)yue_noon {
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/appoint_ok"];
    NSDictionary *dic = @{@"dnumber":dnumber,@"dsort":dsort,@"yue_time":yue_time,@"yue_date":yue_date,@"yue_noon":yue_noon};
    
    NSLog(@"dic == %@",dic);
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self submitOrderRequestData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)submitOrderRequestData:(NSDictionary *)dic {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:dic[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert removeFromParentViewController];
        if ([dic[@"data"][@"message"] integerValue] == 0) {
            [self getDataWithRequest];
        }
    }];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
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
