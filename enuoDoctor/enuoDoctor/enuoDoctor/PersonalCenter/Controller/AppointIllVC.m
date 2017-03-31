//
//  AppointIllVC.m
//  enuoDoctor
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AppointIllVC.h"

@interface AppointIllVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *deskArr;
@property (nonatomic,strong) NSMutableArray *illArr;
@property (nonatomic,strong) UIView *QRbgView;

@end

@implementation AppointIllVC

- (NSMutableArray *)illArr {
    if (!_illArr) {
        _illArr = [NSMutableArray array];
    }return _illArr;
}
- (NSMutableArray *)deskArr {
    if (!_deskArr) {
        _deskArr = [NSMutableArray array];
    }return _deskArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getIllRequest];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCustomNavViewWithTitle:nil andLeftImage:@"白色返回" withLeftTitle:@"约定病种" andRightImage:nil withRightTitle:nil];
    
    [self createTableView];
}
- (void)leftItemBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark---tableView
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth-64) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.deskArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, kScreenWidth, 40);
    
    view.backgroundColor = [UIColor stringTOColor:@"#f4f4f4"];
    
    UILabel *deskLabel = [[UILabel alloc]init];
    deskLabel.font = [UIFont systemFontOfSize:13];
    deskLabel.textColor = [UIColor blackColor];
    deskLabel.text = [NSString stringWithFormat:@"%@",self.deskArr[section]];
    deskLabel.frame = CGRectMake(13, 20, 100, 15);
    [view addSubview:deskLabel];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *dataArr = self.illArr[indexPath.section];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    scrollView.contentSize = CGSizeMake(133*dataArr.count+15, 0);
    [cell.contentView addSubview:scrollView];
    
    for (int i = 0; i<dataArr.count; i++) {
        
        AppointIllModel *model = dataArr[i];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15+133*i, 11, 113, 70)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:urlPicture,model.photo]]];
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        [scrollView addSubview:imageView];
        
        UILabel *illLabel = [[UILabel alloc]init];
        illLabel.text = model.ill;
        illLabel.font = [UIFont systemFontOfSize:13];
        illLabel.textColor = [UIColor stringTOColor:@"#00b1a1"];
        [scrollView addSubview:illLabel];
        
        //二维码
        LZQRCodeBtn *QRCodeBtn = [[LZQRCodeBtn alloc]init];
        QRCodeBtn.tag = indexPath.section*100+i;
        [QRCodeBtn createQRCodeViewWithUrl:model.wechat_url];
        [scrollView addSubview:QRCodeBtn];
        [QRCodeBtn addTarget:self action:@selector(QRBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *illTreatLabel = [[UILabel alloc]init];
        illTreatLabel.text = model.category;
        illTreatLabel.font = [UIFont systemFontOfSize:10];
        [scrollView addSubview:illTreatLabel];

        UILabel *cureStyleLabel = [[UILabel alloc]init];
        cureStyleLabel.font = [UIFont systemFontOfSize:10];
        cureStyleLabel.text = @"治疗方式：";
        cureStyleLabel.textColor = [UIColor stringTOColor:@"#434343"];
        [scrollView addSubview:cureStyleLabel];
        UILabel *cureStyleTextLabel = [[UILabel alloc]init];
        cureStyleTextLabel.font = [UIFont systemFontOfSize:10];
        cureStyleTextLabel.text = model.treat;
        cureStyleTextLabel.textColor = [UIColor stringTOColor:@"#434343"];
        [scrollView addSubview:cureStyleTextLabel];
        
        UILabel *priceleLabel = [[UILabel alloc]init];
        priceleLabel.font = [UIFont systemFontOfSize:10];
        priceleLabel.text = @"约定价格：";
        priceleLabel.textColor = [UIColor stringTOColor:@"#434343"];
        [scrollView addSubview:priceleLabel];
        UILabel *priceleTextLabel = [[UILabel alloc]init];
        priceleTextLabel.font = [UIFont systemFontOfSize:10];
        if (model.is_activity == 1) {
            priceleTextLabel.text = [NSString stringWithFormat:@"¥%@",model.heightprice];
        }else {
            priceleTextLabel.text = [NSString stringWithFormat:@"不高于 ¥%@",model.heightprice];
        }
        priceleTextLabel.textColor = [UIColor stringTOColor:@"#434343"];
        [scrollView addSubview:priceleTextLabel];
        
        [illLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).with.offset(10);
        }];
        
        [QRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        [illTreatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(illLabel);
            make.top.equalTo(illLabel.mas_bottom).with.offset(14);
        }];
        [cureStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(illTreatLabel);
            make.top.equalTo(illTreatLabel.mas_bottom).with.offset(6);
        }];
        [cureStyleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cureStyleLabel);
            make.left.equalTo(cureStyleLabel.mas_right).with.offset(3);
        }];
        [priceleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cureStyleLabel);
            make.top.equalTo(cureStyleLabel.mas_bottom).with.offset(6);
        }];
        [priceleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(priceleLabel);
            make.left.equalTo(priceleLabel.mas_right).with.offset(3);
        }];
        
        
    }
    
    return cell;
}

- (void)QRBtnClick:(UIButton *)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgView = [[UIView alloc]initWithFrame:window.bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.QRbgView = bgView;
    [window addSubview:bgView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];
    [tapGesture addTarget:self action:@selector(removeQRView)];
    [bgView addGestureRecognizer:tapGesture];
    
    UIView *whitView = [[UIView alloc]init];
    whitView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whitView];
    [whitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = sender.currentImage;
    [whitView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"扫一扫 快速预约";
    titleLabel.textColor = [UIColor stringTOColor:@"#22ccc6"];
    [whitView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whitView);
        make.top.equalTo(whitView).with.offset(25);
    }];
    
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whitView);
        make.centerY.equalTo(whitView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
}

- (void)removeQRView {
    [self.QRbgView removeFromSuperview];
}

#pragma mark ---request
- (void)getIllRequest {
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/get_doc_app_mb_list"];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSDictionary *dic = @{@"username":username};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self getIllRequestData:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)getIllRequestData:(NSDictionary *)dic {
    
    if ([dic[@"data"] isKindOfClass:[NSNull class]]) {
        
    }else {
        NSArray *dataArr = dic[@"data"];
        
        for (int i = 0; i<dataArr.count; i++) {
            NSDictionary *dataDic = dataArr[i];
            [self.deskArr addObject:dataDic[@"name"]];
            
            NSMutableArray *illCountArr = [NSMutableArray array];
            
            NSArray *mbListArr = dataDic[@"mb_list"];
            for (int i = 0; i<mbListArr.count; i++) {
                AppointIllModel *model = [AppointIllModel AppointIllModelWithDic:mbListArr[i]];
                [illCountArr addObject:model];
            }
            
            [self.illArr addObject:illCountArr];
            
        }
        
        [self.tableView reloadData];
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
