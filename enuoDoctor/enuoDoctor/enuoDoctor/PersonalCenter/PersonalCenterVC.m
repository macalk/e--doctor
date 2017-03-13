//
//  PersonalCenterVC.m
//  enuoDoctor
//
//  Created by apple on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonalCenterVC.h"
#import "NIMSessionListViewController.h"
#import "MyInforCustomVC.h"

@interface PersonalCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)PersonalCenterModel *model;
@property (nonatomic,strong)NSArray *cellImageArr;

@property (nonatomic,assign)NSInteger numMessage;

@end

@implementation PersonalCenterVC

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
    [self recentlyConversation];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self requestData];
    self.cellImageArr = @[@"我的打赏",@"我的消息",@"个人信息",@"约定病种",@"设置",@"退出"];
    [self createTableView];
    
}

#pragma mark---创建tableView 实现代理方法
- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeigth+20) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.tableHeaderView = [self customTableHeadeView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.cellImageArr[indexPath.row]]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.cellImageArr[indexPath.row]];
        
        if (indexPath.row == 1) {
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            
            UIImageView *redImageView = [[UIImageView alloc]init];
            redImageView.image = [UIImage imageNamed:@"红点"];
            [cell.contentView addSubview:redImageView];
            [redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.textLabel);
                make.left.equalTo(cell.textLabel).with.offset(60);
                make.size.mas_equalTo(CGSizeMake(6, 6));
            }];
            
            if (self.numMessage>0) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld条新消息",(long)self.numMessage];
            }else {
                redImageView.hidden = YES;
                cell.detailTextLabel.text = @"暂无新消息";
            }
        }
        
    }else {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.cellImageArr[indexPath.row+3]]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.cellImageArr[indexPath.row+3]];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

//自定义表头
- (UIView *)customTableHeadeView {
    UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 237)];
    tableHeadView.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 187)];
    topView.backgroundColor = [UIColor stringTOColor:@"#22ccc6"];
    [tableHeadView addSubview:topView];
    
    UIImageView *headImageView = [[UIImageView alloc]init];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:urlPicture,self.model.photo]] placeholderImage:[UIImage imageNamed:@"个人中心"]];
    headImageView.layer.cornerRadius = 25;
    headImageView.clipsToBounds = YES;
    [topView addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = self.model.name;
    nameLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:nameLabel];
    
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.text = @"职称:";
    numberLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:numberLabel];
    UILabel *numberTextLabel = [[UILabel alloc]init];
    numberTextLabel.text = self.model.professional;
    numberTextLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:numberTextLabel];
    
    //评论，关注，我的e诺
    float space = kScreenWidth/3; //间距
    NSArray *imageArr = @[@"评论",@"关注",@"我的诺"];
    NSString *commentNum = [NSString stringWithFormat:@"%ld",(long)self.model.comment_num];
    NSString *guanZhuNum = [NSString stringWithFormat:@"%ld",(long)self.model.guanzhu];
    NSString *nuo = self.model.nuo;

    if (nuo == nil) {
        nuo = @"";
    }
    NSArray *textArr = @[commentNum,guanZhuNum,nuo];
    
    
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.center = CGPointMake(space/2+space*i, 207);
        imageView.bounds = CGRectMake(0, 0, 17, 17);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[i]]];
        [tableHeadView addSubview:imageView];
        
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.font = [UIFont systemFontOfSize:11];
        textLabel.textColor = [UIColor stringTOColor:@"#555555"];
        [tableHeadView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).with.offset(5);
        }];
        
        if (i<2) {
            textLabel.text = [NSString stringWithFormat:@"%@ %@",imageArr[i],textArr[i]];
            
            UILabel *spaceLabel = [[UILabel alloc]init];
            spaceLabel.backgroundColor = [UIColor stringTOColor:@"#bababa"];
            spaceLabel.center = CGPointMake(space+space*i, 212);
            spaceLabel.bounds = CGRectMake(0, 0, 1, 30);
            [tableHeadView addSubview:spaceLabel];
        }else {
            textLabel.text = [NSString stringWithFormat:@"%@",imageArr[i]];
            
            UILabel *nuoLabel = [[UILabel alloc]init];
            nuoLabel.textColor = [UIColor orangeColor];
            nuoLabel.text = textArr[i];
            nuoLabel.font = [UIFont systemFontOfSize:11];
            [tableHeadView addSubview:nuoLabel];
            [nuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageView);
                make.left.equalTo(imageView.mas_right).with.offset(2);
            }];
        }
    }
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).with.offset(63);
        make.left.equalTo(topView).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView);
        make.left.equalTo(nameLabel);
    }];
    [numberTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numberLabel);
        make.left.equalTo(numberLabel.mas_right).with.offset(10);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(numberLabel.mas_top).with.offset(-11);
        make.left.equalTo(headImageView.mas_right).with.offset(15);
    }];
    
    return tableHeadView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    MyRewardVC *myReward = [MyRewardVC new];
//    NIMSessionListViewController *myIFVC = [[NIMSessionListViewController alloc] init];
    MyInforCustomVC *myIFVC = [MyInforCustomVC new];
    PersonalInformationVC *infoVC = [PersonalInformationVC new];
    AppointIllVC *appointIllVC = [AppointIllVC new];
    SettingVC *setVC = [SettingVC new];
    NSArray *VCArr = @[myReward,myIFVC,infoVC,appointIllVC,setVC];
    
    UIViewController *VC;
    
    if (indexPath.section == 0) {
        VC = VCArr[indexPath.row];
        [VC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:VC animated:YES];
    }else {
        if (indexPath.row == 2) {//退出
            UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认退出？" preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [UIApplication sharedApplication].keyWindow.rootViewController = [LoginVC new];
                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"token"];
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alterController addAction:sureAction];
            [alterController addAction:cancelAction];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alterController animated:YES completion:nil];
            });
            
        }else {
            VC = VCArr[indexPath.row+3];
            [VC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

//请求数据
- (void)requestData {
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSLog(@"---%@",userName);
    
    //如果不存在，就重新登录
    if ([userName isEqualToString:@""] || [userName integerValue]<0 || userName == nil) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [LoginVC new];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"token"];
    }
    
    NSString *urlStr = [NSString stringWithFormat:DocUrl,@"doctor/center"];
    NSDictionary *dic = @{@"username":userName};
    BaseRequest *request = [[BaseRequest alloc]init];
    [request POST:urlStr params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self dataOfRequeset:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)dataOfRequeset:(NSDictionary *)dic {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *accid = [NSString stringWithFormat:@"%@-doctor",username];
    
    self.model = [PersonalCenterModel PersonalCenterModelWithDic:dic[@"data"]];
    self.tableView.tableHeaderView = [self customTableHeadeView];
    
    if (self.model.chat_token == nil) {
        [self registUserNameWithName:self.model.name];
    }else {
        //登录云信
        [[[NIMSDK sharedSDK] loginManager] login:accid
                                           token:self.model.chat_token
                                      completion:^(NSError *error) {
                                          NSLog(@"error===%@",error);
//                                          if (error == nil) {
//                                              [[NIMSDK sharedSDK].userManager notifyForNewMsg:accid];
//                                          }
                                      }];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:self.model.photo forKey:@"docPhoto"];

}

- (BOOL)notifyForNewMsg:(NSString *)userId {
    return YES;
}

//注册IM账号
- (void)registUserNameWithName:(NSString *)name {
    
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *accid = [NSString stringWithFormat:@"%@-doctor",username];
    
    NSLog(@"accid==%@",accid);
    
    NSString *url = @"http://www.enuo120.com/index.php/app/chat/create_user";
    
    NSDictionary *dic = @{@"accid":accid,@"name":name};
    
    BaseRequest *request = [[BaseRequest alloc]init];
    
    [request POST:url params:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self registUserNameIDDate:responseObject];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"失败0.0");
    }];
}
- (void)registUserNameIDDate:(NSDictionary *)dic {
    NSDictionary *infoDic = dic[@"data"][@"info"];
    NSString *token = infoDic[@"token"];
    NSString *accid = infoDic[@"accid"];
    
    NSLog(@"token==%@",token);
    
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];
    
    //登录云信
    [[[NIMSDK sharedSDK] loginManager] login:accid
                                       token:token
                                  completion:^(NSError *error) {
                                      NSLog(@"error===%@",error);
//                                      if (error == nil) {
//                                          [[NIMSDK sharedSDK].userManager updateNotifyState:YES forUser:accid completion:nil];
//                                      }
                                  }];
    
}

#pragma mark----最近会话
- (void)recentlyConversation {
    
    NSInteger allInfo = [[NIMSDK sharedSDK].conversationManager allUnreadCount];
    
    self.numMessage = allInfo;
    
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
