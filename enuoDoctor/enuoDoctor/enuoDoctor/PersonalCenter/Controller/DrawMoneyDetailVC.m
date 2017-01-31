//
//  DrawMoneyDetailVC.m
//  enuoDoctor
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DrawMoneyDetailVC.h"

@interface DrawMoneyDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *monthArr;
@property (nonatomic,copy) NSString *yearAndMonthDateStr;
@property (nonatomic,copy) NSString *monthDateStr;
@property (nonatomic,strong) NSMutableArray *cellNumArr;//cell总量数组
@property (nonatomic,strong) NSMutableArray *cellNumOfRowsInSectionArr;

@end

@implementation DrawMoneyDetailVC
- (NSMutableArray *)cellNumOfRowsInSectionArr {
    if (!_cellNumOfRowsInSectionArr) {
        _cellNumOfRowsInSectionArr = [NSMutableArray array];
    }return _cellNumOfRowsInSectionArr;
}

- (NSMutableArray *)cellNumArr {
    if (!_cellNumArr) {
        _cellNumArr = [NSMutableArray array];
    }return _cellNumArr;
}

- (NSMutableArray *)monthArr {
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
    }return _monthArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"账单明细" andRightImage:nil withRightTitle:nil];
    
    [self createTableView];
    [self drawMoneyDetailRequest];
}
#pragma mark---创建tableview
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.monthArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    for (int i = 0; i<self.cellNumArr.count; i++) {
        if (section == i) {
            NSArray *numArr = self.cellNumArr[i];
            return numArr.count;
        }
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DrawMoneyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"DrawMoneyDetailCell" owner:self options:nil];
        for (id tempCell in array) {
            if ([tempCell isKindOfClass:[DrawMoneyDetailCell class]]) {
                cell = tempCell;
            }
        }
    }
    
    NSArray *celldataArr = self.cellNumArr[indexPath.section];
    DrawMoneyDetailModel *model = celldataArr[indexPath.row];
    cell.model = model;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 33;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
    bgView.backgroundColor = [UIColor stringTOColor:@"#f4f4f4"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40,bgView.center.y-10 , 100, 20)];
    label.text = [NSString stringWithFormat:@"%@月",self.monthArr[section]];
    label.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:label];
    
    return bgView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- request
- (void)drawMoneyDetailRequest {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/bill_detail"];
    NSDictionary *dic = @{@"username":username};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self drawMoneyDetailRequestData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)drawMoneyDetailRequestData:(NSDictionary *)dic {
    
    if ([dic[@"data"] isKindOfClass:[NSNull class]]) {
        
    }else {
        NSArray *dataArr = dic[@"data"];
        
        for (int i = 0; i<dataArr.count; i++) {
            
            DrawMoneyDetailModel *model = [DrawMoneyDetailModel DrawMoneyDetailModelWithDic:dataArr[i]];
            NSString *dateStr = model.act_time;//时间戳
            
            NSTimeInterval time=[dateStr doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
            NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            //实例化一个NSDateFormatter对象
            NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
            
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy MM"];
            NSString *yearAndMonthDateStr = [dateFormatter stringFromDate: detaildate];
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *yearDateStr = [dateFormatter stringFromDate: detaildate];
            [dateFormatter setDateFormat:@"MM"];
            NSString *monthDateStr = [dateFormatter stringFromDate: detaildate];
            
            
            if (![self.yearAndMonthDateStr isEqualToString:yearAndMonthDateStr]) {
                if ([yearDateStr isEqualToString:@"2017"]) {
                    [self.monthArr addObject:monthDateStr];
                }else {
                    [self.monthArr addObject:yearAndMonthDateStr];
                }
                
                NSMutableArray *numCellOfSectionArr = [NSMutableArray array];
                self.cellNumOfRowsInSectionArr = numCellOfSectionArr;
                [self.cellNumArr addObject:numCellOfSectionArr];
                
            }
            
            [self.cellNumOfRowsInSectionArr addObject:model];
            
            self.yearAndMonthDateStr = yearAndMonthDateStr;
            
        }
        
        [self.tableView reloadData];
    }
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
