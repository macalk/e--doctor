//
//  SelectBankCardVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SelectBankCardVC.h"

@interface SelectBankCardVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *myBankCardArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger selectRow;

@end

@implementation SelectBankCardVC
- (NSMutableArray *)myBankCardArr {
    if (!_myBankCardArr) {
        _myBankCardArr = [NSMutableArray array];
    }return _myBankCardArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self myBankCardRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"选择银行卡" andRightImage:nil withRightTitle:nil];
    
    [self createTableView];
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    self.selectRow = -1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 38;
    }else {
        return 90;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
        bgView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.text = @"到账银行";
        [bgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).with.offset(15);
            make.bottom.equalTo(bgView).with.offset(-10);
        }];
        
        return bgView;
    }else {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        bgView.backgroundColor = [UIColor clearColor];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 50, kScreenWidth-30, 40)];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        sureBtn.layer.cornerRadius = 5;
        sureBtn.clipsToBounds = YES;
        [sureBtn setTitle:@"确认" forState:normal];
        [sureBtn setBackgroundColor:[UIColor stringTOColor:@"#57a4e3"]];
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:sureBtn];
        
        return bgView;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.myBankCardArr.count+1;
    }else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == self.selectRow) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    SelectBankCardModel *model;
    
    if (indexPath.row<self.myBankCardArr.count) {
        model = self.myBankCardArr[indexPath.row];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    if (indexPath.row == self.myBankCardArr.count) {
        cell.textLabel.text = @"使用新卡提现";

    }else {
        
        NSRange index = [model.h_card rangeOfString:@"-"];//匹配得到的下标
        NSString *str = [model.h_card substringToIndex:index.location];
        
        NSString *numStr = [model.card substringFromIndex:model.card.length-4];
                
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",str,numStr];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectRow = indexPath.row;
    
    [tableView reloadData];
}

- (void)sureBtnClick:(UIButton *)sendre {
    
    if (self.selectRow<0) {
        [self createAlterViewWithMessage:@"请选择银行卡" withSureBtn:YES withCancelBtn:nil withDeleteBtn:nil];
    }else {
        if (self.selectRow == self.myBankCardArr.count) {
            FirstDrawMoneyVC *firstVC = [[FirstDrawMoneyVC alloc]init];
            [self.navigationController pushViewController:firstVC animated:YES];
        }else {
            
            SelectBankCardModel *model = self.myBankCardArr[self.selectRow];
            
            NSLog(@"%@",model.ID);
            
            if (self.myBlock) {
                self.myBlock(model);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
    
}

#pragma mark----request
- (void)myBankCardRequest {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/doc_card"];
    NSDictionary *dic = @{@"username":username};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self myBankCardRequestData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)myBankCardRequestData:(NSDictionary *)dic {
    
    [self.myBankCardArr removeAllObjects];
    
    if ([dic[@"data"] isKindOfClass:[NSNull class]]) {
        
    }else {
        NSArray *dataArr = dic[@"data"];
        
        for (int i = 0; i<dataArr.count; i++) {
            NSDictionary *dic = dataArr[i];
            SelectBankCardModel *model = [SelectBankCardModel SelectBankCardModelWithDic:dic];
            [self.myBankCardArr addObject:model];
        }

    }
    
    [self.tableView reloadData];
    
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
