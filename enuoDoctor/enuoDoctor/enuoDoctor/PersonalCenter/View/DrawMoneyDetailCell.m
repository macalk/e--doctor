//
//  DrawMoneyDetailCell.m
//  enuoDoctor
//
//  Created by apple on 17/1/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DrawMoneyDetailCell.h"

@implementation DrawMoneyDetailCell

- (DrawMoneyDetailModel *)model {
    if (!_model) {
        _model = [[DrawMoneyDetailModel alloc]init];
    }return _model;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    
    NSString *docPhoto = [[NSUserDefaults standardUserDefaults]objectForKey:@"docPhoto"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:urlPicture,docPhoto]]];
    self.headImageView.layer.cornerRadius = 21;
    self.headImageView.clipsToBounds = YES;
    
    if ([self.model.act_type integerValue] == 0) {
        self.moneyLabel.text = [NSString stringWithFormat:@"+ %@",self.model.money];
        self.statusLabel.text = @"来自打赏";
    }else {
        self.moneyLabel.text = [NSString stringWithFormat:@"- %@",self.model.money];
        if ([self.model.statue integerValue] == 0) {
            self.statusLabel.text = @"提现中";
        }else {
            self.statusLabel.text = @"提现成功";
        }
    }
    
    NSString *dateStr = self.model.act_time;//时间戳
    NSTimeInterval time=[dateStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *yearDateStr = [dateFormatter stringFromDate: detaildate];
    [dateFormatter setDateFormat:@"MM"];
    NSString *monthDateStr = [dateFormatter stringFromDate: detaildate];
    [dateFormatter setDateFormat:@"dd"];
    NSString *dayDateStr = [dateFormatter stringFromDate: detaildate];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeDateStr = [dateFormatter stringFromDate: detaildate];

    self.dayLabel.text = [NSString stringWithFormat:@"%@  日",dayDateStr];
    self.timeLabel.text = timeDateStr;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
