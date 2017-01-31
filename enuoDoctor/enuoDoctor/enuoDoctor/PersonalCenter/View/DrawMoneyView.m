//
//  DrawMoneyView.m
//  enuoDoctor
//
//  Created by apple on 17/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DrawMoneyView.h"

@implementation DrawMoneyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createViewWithMoney:(NSString *)money {
    
    UILabel *bankCardLabel = [[UILabel alloc]init];
    bankCardLabel.textColor = [UIColor blackColor];
    bankCardLabel.font = [UIFont systemFontOfSize:10];
    bankCardLabel.text = @"银行卡";
    [self addSubview:bankCardLabel];
    
    UIButton *bankCardBtn = [[UIButton alloc]init];
    self.bankCardBtn = bankCardBtn;
    bankCardBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [bankCardBtn setTitleColor:[UIColor stringTOColor:@"#6a9df4"] forState:normal];
    [bankCardBtn setTitle:@"" forState:normal];
    [self addSubview:bankCardBtn];
    
    UILabel *drawMoneyLabel = [[UILabel alloc]init];
    drawMoneyLabel.font = [UIFont systemFontOfSize:10];
    drawMoneyLabel.textColor = [UIColor blackColor];
    drawMoneyLabel.text = @"提现金额";
    [self addSubview:drawMoneyLabel];
    
    UILabel *RMBlabel = [[UILabel alloc]init];
    RMBlabel.text = @"¥";
    RMBlabel.font = [UIFont systemFontOfSize:15];
    RMBlabel.textColor = [UIColor blackColor];
    [self addSubview:RMBlabel];
    
    UITextField *moneyTextField = [[UITextField alloc]init];
    self.myMoneyTextField = moneyTextField;
    moneyTextField.placeholder = @"请输入提现金额";
    moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    moneyTextField.font = [UIFont systemFontOfSize:15];
    moneyTextField.textColor = [UIColor blackColor];
    [self addSubview:moneyTextField];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor stringTOColor:@"#c0c0c0"];
    [self addSubview:lineLabel];
    
    UILabel *residueMoneyLabel = [[UILabel alloc]init];
    residueMoneyLabel.font = [UIFont systemFontOfSize:10];
    residueMoneyLabel.textColor = [UIColor stringTOColor:@"#000000"];
    
    residueMoneyLabel.text = [NSString stringWithFormat:@"我的打赏总额%@元",money];
    [self addSubview:residueMoneyLabel];
    
    UIButton *drawAllMoneyBtn = [[UIButton alloc]init];
    self.drawAllMoneyBtn = drawAllMoneyBtn;
    drawAllMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [drawAllMoneyBtn setTitleColor:[UIColor stringTOColor:@"#6a9fd4"] forState:normal];
    [drawAllMoneyBtn setTitle:@"全部提现" forState:normal];
    [self addSubview:drawAllMoneyBtn];
    
    [bankCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(self).with.offset(22);
    }];
    [bankCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bankCardLabel);
        make.left.equalTo(bankCardLabel.mas_right).with.offset(50);
    }];
    
    [drawMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankCardLabel);
        make.top.equalTo(bankCardLabel.mas_bottom).with.offset(27);
    }];
    
    [RMBlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(drawMoneyLabel);
        make.top.equalTo(drawMoneyLabel.mas_bottom).with.offset(22);
    }];
    [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(RMBlabel);
        make.left.equalTo(RMBlabel.mas_right).with.offset(10);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(RMBlabel);
        make.right.equalTo(self).with.offset(-15);
        make.height.mas_equalTo(@1);
        make.top.equalTo(RMBlabel.mas_bottom).with.offset(10);
    }];
    
    [residueMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineLabel);
        make.top.equalTo(lineLabel.mas_bottom).with.offset(7);
    }];
    [drawAllMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(residueMoneyLabel);
        make.left.equalTo(residueMoneyLabel.mas_right).with.offset(3);
    }];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
