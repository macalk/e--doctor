//
//  OrderDetailVC.m
//  enuoDoctor
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrderDetailVC.h"

@interface OrderDetailVC ()<titleButtonDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,LZFiltrateViewDelegate>

@property (nonatomic,strong) TitleButtomView *LZView;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) NSMutableArray *noPaymentArr;//未付款
@property (nonatomic,strong) NSMutableArray *onPaymentArr;//付款中
@property (nonatomic,strong) NSMutableArray *didPaymentArr;//已付款

@property (nonatomic,assign) BOOL orderUp;
@property (nonatomic,assign) BOOL dateUp;

@end

@implementation OrderDetailVC

- (NSMutableArray *)noPaymentArr {
    if (!_noPaymentArr) {
        _noPaymentArr = [NSMutableArray array];
    }return _noPaymentArr;
}
- (NSMutableArray *)onPaymentArr {
    if (!_onPaymentArr) {
        _onPaymentArr = [NSMutableArray array];
    }return _onPaymentArr;
}
- (NSMutableArray *)didPaymentArr {
    if (!_didPaymentArr) {
        _didPaymentArr = [NSMutableArray array];
    }return _didPaymentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createCustomNavViewWithTitle:@"订单详情" andLeftImage:nil withLeftTitle:nil andRightImage:@"筛选" withRightTitle:nil];

    [self createLZTitleView];
    [self createScrollView];
    [self getDataWithRequest];
}
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
            [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)status] WithSort:@"yue_date:asc|yue_noon:asc"];
        }else {
            [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)status] WithSort:@"yue_date:desc|yue_time:desc"];
        }
        
        
    }
}


//获取数据
- (void)getDataWithRequest {
    [self requestDataWithStatus:@"1" WithSort:nil];
    [self requestDataWithStatus:@"2" WithSort:nil];
    [self requestDataWithStatus:@"3" WithSort:nil];
}
//刷新tableview
- (void)refreshTableView {
    for (int i = 0; i<3; i++) {
        UITableView *tableView = [self.view viewWithTag:20+i];
        [tableView reloadData];
    }
}


#pragma mark --- 创建LZTitleView 以及实现代理方法
- (void)createLZTitleView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *titleArr = @[@"未付款",@"付款中",@"已付款"];
    TitleButtomView *LZView = [[TitleButtomView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
    LZView.delegate = self;
    [LZView createTitleBtnWithBtnArray:titleArr];
    self.LZView = LZView;
    [self.view addSubview:LZView];
}

- (void)titleButtonClickDelegate:(NSInteger)btnTag {
    self.scrollView.contentOffset = CGPointMake(kScreenWidth*btnTag, 0);
    [self requestDataWithStatus:[NSString stringWithFormat:@"%ld",(long)btnTag+1] WithSort:nil];
}
#pragma mark---创建scrollview 和tableview
- (void)createScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 37, kScreenWidth, kScreenHeigth-64-37-50)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(kScreenWidth*3, 0);
    scrollView.pagingEnabled = YES;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i<3; i++) {
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
        [self.LZView changeButtonState:index];
        [self requestDataWithStatus:[NSString stringWithFormat:@"%d",index+1] WithSort:nil];

    }
}

#pragma mark -- tableView delegate和dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 20) {
        NSLog(@"%ld",(unsigned long)self.noPaymentArr.count);
        return self.noPaymentArr.count;
    }else if (tableView.tag == 21) {
        return self.onPaymentArr.count;
    }else if (tableView.tag == 22) {
        return self.didPaymentArr.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReservationManageModel *model;
    
    if (tableView.tag == 20) {
        model = self.noPaymentArr[indexPath.row];
    }else if (tableView.tag == 21) {
        model = self.onPaymentArr[indexPath.row];
    }else if (tableView.tag == 22) {
        model = self.didPaymentArr[indexPath.row];
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
    
    
    OrderDetailModel *model;
    NSString *status;
    if (tableView.tag == 20 && self.noPaymentArr.count>0) {
        model = self.noPaymentArr[indexPath.row];
        status = @"1";
    }else if (tableView.tag == 21 && self.onPaymentArr.count>0) {
        model = self.onPaymentArr[indexPath.row];
        status = @"2";
    }else if (tableView.tag == 22 && self.didPaymentArr.count>0) {
        model = self.didPaymentArr[indexPath.row];
        status = @"3";
    }
    
    OrderDetailView *orderDetailView = [[OrderDetailView alloc]init];
    [cell.contentView addSubview:orderDetailView];
    [orderDetailView createCustomViewWithModel:model withStatus:status];
    orderDetailView.frame = CGRectMake(0, 0, kScreenWidth, model.viewHeght);
    
    
    return cell;
}


#pragma mark---数据请求
- (void)requestDataWithStatus:(NSString *)status WithSort:(NSString *)sort {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    if (sort == nil) {
        sort = @"";
    }
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/order"];
    NSDictionary *dic = @{@"username":username,@"statue":status,@"sort":sort};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self DataOfRequest:responseObject WithStatus:status];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)DataOfRequest:(NSDictionary *)dic WithStatus:(NSString *)status {
    
    if ([status isEqualToString:@"1"]) {
        [self.noPaymentArr removeAllObjects];
    }else if ([status isEqualToString:@"2"]) {
        [self.onPaymentArr removeAllObjects];
    }else if ([status isEqualToString:@"3"]) {
        [self.didPaymentArr removeAllObjects];
    }
    
    NSDictionary *dataDic = dic[@"data"];
    if ([dataDic isKindOfClass:[NSNull class]]) {
        NSLog(@"灭有数据");
    }else {
        NSArray *dataArr = dic[@"data"];
        for (int i = 0; i<dataArr.count; i++) {
            OrderDetailModel *model = [OrderDetailModel OrderDetailModelWithDictionry:dataArr[i]];
            
            if ([status isEqualToString:@"1"]) {
                [self.noPaymentArr addObject:model];
            }else if ([status isEqualToString:@"2"]) {
                [self.onPaymentArr addObject:model];
            }else if ([status isEqualToString:@"3"]) {
                [self.didPaymentArr addObject:model];
            }
        }
        
        [self refreshTableView];
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
