//
//  ReservationManageView.m
//  enuoDoctor
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ReservationManageView.h"

@interface ReservationManageView ()
@property (nonatomic,strong) NSArray *yearArr;
@property (nonatomic,strong) NSMutableArray *dayArr;

@property (nonatomic,assign) NSInteger dayNumOfCurrentMonth;
@end

@implementation ReservationManageView

- (NSMutableArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSMutableArray array];
    }return _dayArr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (ReservationManageModel *)model {
    if (!_model) {
        _model = [[ReservationManageModel alloc]init];
    }return _model;
}

- (void)createCustomViewWithModel:(ReservationManageModel *)model withStatus:(NSString *)status {
    
    self.model = model;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, kScreenWidth, model.viewHeght);
    [self addSubview:bgView];
    
    UILabel *pointLabel = [[UILabel alloc]init];
    pointLabel.backgroundColor = [UIColor stringTOColor:@"#22ccc6"];
    pointLabel.center = CGPointMake(8, 24);
    pointLabel.bounds = CGRectMake(0, 0, 6, 6);
    pointLabel.layer.cornerRadius = 3;
    pointLabel.clipsToBounds = YES;
    [bgView addSubview:pointLabel];
    
    UILabel *orderLabel = [[UILabel alloc]init];
    orderLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:orderLabel];
    UILabel *orderTextLabel = [[UILabel alloc]init];
    orderLabel.text = model.dnumber;
    [bgView addSubview:orderTextLabel];
    
    UIButton *rankBtn = [[UIButton alloc]init];
    self.rankBtn = rankBtn;
    rankBtn.layer.cornerRadius = 3;
    rankBtn.clipsToBounds = YES;
    rankBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rankBtn setBackgroundColor:[UIColor clearColor]];
    [rankBtn setTitle:[NSString stringWithFormat:@"排号：%@",model.dsort] forState:normal];
    [rankBtn setTitleColor:[UIColor blackColor] forState:normal];
    [bgView addSubview:rankBtn];
    
    UIImageView *nextImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"详情"]];
    [bgView addSubview:nextImageView];
    
    UILabel *topLine = [[UILabel alloc]init];
    topLine.backgroundColor = [UIColor lightGrayColor];
    topLine.frame = CGRectMake(0, 48, kScreenWidth, 1);
    [bgView addSubview:topLine];
    
    
    [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pointLabel);
        make.left.equalTo(bgView).with.offset(15);
    }];
    [orderTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderLabel);
        make.left.equalTo(orderLabel).with.offset(5);
    }];
    [nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderTextLabel);
        make.right.equalTo(bgView).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    [rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextImageView);
        if ([status isEqualToString:@"1"]) {
            make.right.equalTo(bgView).with.offset(-15);
        }else {
            make.right.equalTo(nextImageView.mas_left).with.offset(-5);
        }
        make.size.mas_equalTo(CGSizeMake(78, 25));
    }];
    
    
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[model.nowdate doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];

    
    NSArray *titleArr = @[@"患者姓名：",@"联系电话：",@"约定病种：",@"约定种类：",@"治疗方式：",@"预约日期：",@"下单时间："];
    
    NSArray *titleTextArr = @[model.name,model.phone,model.ill,model.category,model.treat,model.date,dateString];
    
    
    if ([status isEqualToString:@"2"]) {
        titleTextArr = @[model.name,model.phone,model.ill,model.category,model.treat,[NSString stringWithFormat:@"%@ %@",model.yue_date,model.yue_time],dateString];
    }else if ([status isEqualToString:@"3"] || [status isEqualToString:@"4"]) {
        titleArr = @[@"患者姓名：",@"联系电话：",@"约定病种：",@"约定种类：",@"治疗方式：",@"约定价格：",@"预约日期：",@"下单时间："];
        titleTextArr = @[model.name,model.phone,model.ill,model.category,model.treat,model.price,[NSString stringWithFormat:@"%@ %@",model.yue_date,model.yue_time],dateString];
    }else if ([status isEqualToString:@"5"]) {
        titleArr = @[@"患者姓名：",@"联系电话：",@"约定病种：",@"约定种类：",@"治疗方式：",@"预约日期：",@"下单时间：",@"取消原因："];
        
        NSString *deleteReason;
        if ([model.delete_table isEqualToString:@"patient"]) {
            deleteReason = [NSString stringWithFormat:@"患者%@",model.delete_reason];
        }else {
            deleteReason = [NSString stringWithFormat:@"医生%@",model.delete_reason];
        }
        titleTextArr = @[model.name,model.phone,model.ill,model.category,model.treat,model.date,dateString,deleteReason];

    }
    
    
    UILabel *titleLabel;
    UILabel *titleTextLabel;
    for (int i = 0; i<titleArr.count; i++) {
        titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(15, 58+30*i, 70, 15);
        titleLabel.textColor = [UIColor stringTOColor:@"#717171"];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.text = [NSString stringWithFormat:@"%@",titleArr[i]];
        [bgView addSubview:titleLabel];
        
        titleTextLabel = [[UILabel alloc]init];
        titleTextLabel.text = [NSString stringWithFormat:@"%@",titleTextArr[i]];
        titleTextLabel.font = [UIFont systemFontOfSize:13];
        titleTextLabel.textColor = [UIColor stringTOColor:@"#717171"];
        [bgView addSubview:titleTextLabel];
        [titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.left.equalTo(titleLabel.mas_right).with.offset(5);
        }];
        
        if ([status isEqualToString:@"1"] && i == 5) {//预约日期
            self.appointmentTimeLabel = titleTextLabel;
            titleLabel.textColor = [UIColor stringTOColor:@"#232323"];
            titleTextLabel.textColor = [UIColor stringTOColor:@"#232323"];
            
            UIButton *changeDateBtn = [[UIButton alloc]init];
            self.changeDateBtn = changeDateBtn;
            changeDateBtn.layer.cornerRadius=  3;
            changeDateBtn.clipsToBounds = YES;
            changeDateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [changeDateBtn setTitle:@"修改日期" forState:normal];
            [changeDateBtn setBackgroundColor:[UIColor stringTOColor:@"#ffab2e"]];
            [changeDateBtn setTitleColor:[UIColor whiteColor] forState:normal];
            [bgView addSubview:changeDateBtn];
            [changeDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLabel);
                make.right.equalTo(bgView).with.offset(-15);
                make.size.mas_equalTo(CGSizeMake(60, 24));
            }];
        }
        
        if ([status isEqualToString:@"5"] && i == 0) {//已取消
            UILabel *hadCancelLabel = [[UILabel alloc]init];
            [bgView addSubview:hadCancelLabel];
            hadCancelLabel.text = @"已取消";
            hadCancelLabel.font = [UIFont systemFontOfSize:13];
            hadCancelLabel.textColor = [UIColor stringTOColor:@"#ffab2e"];
            [hadCancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLabel);
                make.right.equalTo(bgView).with.offset(-30);
            }];
        }

    }

    
    UILabel *centerLine = [[UILabel alloc]init];
    centerLine.backgroundColor = [UIColor lightGrayColor];
    if (![status isEqualToString:@"5"]) {
        [bgView addSubview:centerLine];
        [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-15, 1));
            make.top.equalTo(titleLabel.mas_bottom).with.offset(10);
        }];
    }
    
    

    UIButton *leftOrRightBtn;
    for (int i = 0; i<2; i++) {
        leftOrRightBtn = [[UIButton alloc]init];
        leftOrRightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        leftOrRightBtn.layer.cornerRadius = 5;
        leftOrRightBtn.clipsToBounds = YES;
        leftOrRightBtn.backgroundColor = [UIColor stringTOColor:@"#64aeea"];
        [leftOrRightBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [leftOrRightBtn addTarget:self action:@selector(leftOrRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:leftOrRightBtn];
        
        if (![status isEqualToString:@"5"]) {
            [leftOrRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(centerLine.mas_bottom).with.offset(20);
                make.size.mas_equalTo(CGSizeMake(100, 30));
                if (i == 0) {
                    make.right.mas_equalTo(self.mas_centerX).with.offset(-25);
                    [leftOrRightBtn setTitle:@"取消订单" forState:normal];
                    if ([status isEqualToString:@"2"]) {
                        if ([model.is_check isEqualToString:@"1"] || model.is_activity == 1) {
                            leftOrRightBtn.hidden = YES;
                        }else {
                            [leftOrRightBtn setTitle:@"进一步检查" forState:normal];
                        }
                    }else if ([status isEqualToString:@"3"]) {
                        [leftOrRightBtn setTitle:@"分期支付" forState:normal];
                    }else if ([status isEqualToString:@"4"]) {
                        leftOrRightBtn.hidden = YES;
                    }
                }else {
                    make.left.mas_equalTo(self.mas_centerX).with.offset(25);
                    [leftOrRightBtn setTitle:@"提交订单" forState:normal];
                    if ([status isEqualToString:@"2"]) {
                        [leftOrRightBtn setTitle:@"诊断明确" forState:normal];
                        if ([model.is_check isEqualToString:@"1"] || model.is_activity == 1) {
                            make.left.equalTo(self.mas_centerX).with.offset(-50);
                        }
                    }else if ([status isEqualToString:@"3"]) {
                        [leftOrRightBtn setTitle:@"一次性支付" forState:normal];
                    }else if ([status isEqualToString:@"4"]) {
                        [leftOrRightBtn setTitle:@"取消订单" forState:normal];
                    }
                }
            }];

        }
        
    }
    
    
    UILabel *bottomLine = [[UILabel alloc]init];
    bottomLine.backgroundColor = [UIColor stringTOColor:@"#f4f4f4"];
    [bgView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([status isEqualToString:@"5"]) {
            make.top.equalTo(titleLabel.mas_bottom).with.offset(20);
        }else {
            make.top.equalTo(leftOrRightBtn.mas_bottom).with.offset(20);
        }
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 20));
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(bottomLine.mas_bottom);
    }];
    
    
    if ([status isEqualToString:@"1"]) {
        [rankBtn setBackgroundColor:[UIColor stringTOColor:@"#ffab2e"]];
        [rankBtn setTitle:@"请排号" forState:normal];
        [rankBtn setTitleColor:[UIColor whiteColor] forState:normal];
        nextImageView.hidden = YES;
    }else if ([status isEqualToString:@"2"]) {
        
    }else if ([status isEqualToString:@"3"]) {
        
    }else if ([status isEqualToString:@"4"]) {
        
    }else if ([status isEqualToString:@"5"]) {
        rankBtn.hidden = YES;
    }
    
    
    [self layoutIfNeeded];
    model.viewHeght = bgView.frame.size.height;
     
    
}

- (void)leftOrRightBtn:(UIButton *)sender {
    [self.RMViewBtnDelegae RMViewBtnClick:sender];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
