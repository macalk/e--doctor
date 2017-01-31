//
//  OrderDetailView.m
//  enuoDoctor
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OrderDetailView.h"

@interface OrderDetailView ()

@property (nonatomic,strong) NSArray *yearArr;
@property (nonatomic,strong) NSMutableArray *dayArr;

@property (nonatomic,assign) NSInteger dayNumOfCurrentMonth;


@end

@implementation OrderDetailView

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

- (OrderDetailModel *)model {
    if (!_model) {
        _model = [[OrderDetailModel alloc]init];
    }return _model;
}

- (void)createCustomViewWithModel:(OrderDetailModel *)model withStatus:(NSString *)status {
    
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
    
    UILabel *rankLabel = [[UILabel alloc]init];
    rankLabel.font = [UIFont systemFontOfSize:13];
    [rankLabel setBackgroundColor:[UIColor clearColor]];
    rankLabel.text = [NSString stringWithFormat:@"排号：%@",model.dsort];
    rankLabel.textColor = [UIColor blackColor];
    [bgView addSubview:rankLabel];
    
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
    [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextImageView);
        make.right.equalTo(nextImageView.mas_left).with.offset(-5);
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
    
    
    NSArray *titleArr = @[@"患者姓名：",@"联系电话：",@"约定病种：",@"约定种类：",@"治疗方式：",@"约定金额：",@"预约日期：",@"下单时间："];
    
    NSString *priceStr;
    if (model.step  == 0) {//一次性付款
        priceStr = [NSString stringWithFormat:@"¥ %@ (一次性支付)",model.price];
        if ([status isEqualToString:@"2"]) {
            priceStr = [NSString stringWithFormat:@"¥ %@ (患者已支付待确认)",model.price];
        }
    }else {
        priceStr = [NSString stringWithFormat:@"¥ %@ (%ld/%ld期)",model.price,(long)model.step,model.sum_step];
    }
    
    if ([status integerValue] == 3) {
        priceStr = [NSString stringWithFormat:@"¥ %@ (已完成)",model.price];
    }
    
    NSArray *titleTextArr = @[model.name,model.phone,model.ill,model.category,model.treat,priceStr,[NSString stringWithFormat:@"%@ %@",model.yue_date,model.yue_time],dateString];
    
    
//    if ([status isEqualToString:@"2"]) {
//        titleTextArr = @[model.name,model.phone,model.ill,model.category,model.treat,[NSString stringWithFormat:@"%@ %@",model.yue_date,model.yue_time],dateString];
//    }else if ([status isEqualToString:@"3"]) {
//        titleArr = @[@"患者姓名：",@"联系电话：",@"约定病种：",@"约定种类：",@"治疗方式：",@"约定价格：",@"预约日期：",@"下单时间："];
//        titleTextArr = @[model.name,model.phone,model.ill,model.category,model.treat,model.price,[NSString stringWithFormat:@"%@ %@",model.yue_date,model.yue_time],dateString];
//    }
    
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
        
        
//        if ([status isEqualToString:@"5"] && i == 0) {//已取消
//            UILabel *hadCancelLabel = [[UILabel alloc]init];
//            [bgView addSubview:hadCancelLabel];
//            hadCancelLabel.text = @"已取消";
//            hadCancelLabel.font = [UIFont systemFontOfSize:13];
//            hadCancelLabel.textColor = [UIColor stringTOColor:@"#ffab2e"];
//            [hadCancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(titleLabel);
//                make.right.equalTo(bgView).with.offset(-30);
//            }];
//        }
        
    }
    
    
//    UILabel *centerLine = [[UILabel alloc]init];
//    centerLine.backgroundColor = [UIColor lightGrayColor];
//    if (![status isEqualToString:@"5"]) {
//        [bgView addSubview:centerLine];
//        [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(bgView).with.offset(15);
//            make.size.mas_equalTo(CGSizeMake(kScreenWidth-15, 1));
//            make.top.equalTo(titleLabel.mas_bottom).with.offset(10);
//        }];
//    }
    
    UILabel *bottomLine = [[UILabel alloc]init];
    bottomLine.backgroundColor = [UIColor stringTOColor:@"#f4f4f4"];
    [bgView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 20));
    }];
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(bottomLine.mas_bottom);
    }];
    
    
    [self layoutIfNeeded];
    model.viewHeght = bgView.frame.size.height;
    
    
}

//- (void)leftOrRightBtn:(UIButton *)sender {
//    [self.RMViewBtnDelegae RMViewBtnClick:sender];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
