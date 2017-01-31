//
//  OrderCancelReasonView.m
//  enuoDoctor
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OrderCancelReasonView.h"

@interface OrderCancelReasonView ()<UITextViewDelegate>

@end

@implementation OrderCancelReasonView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createCancelReasonView {
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = window.bounds;
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [window addSubview:bgView];
    
    
    UIView *whitView = [[UIView alloc]init];
    whitView.layer.cornerRadius = 5;
    whitView.clipsToBounds = YES;
    whitView.center = CGPointMake(bgView.center.x, bgView.center.y-60);
    whitView.bounds = CGRectMake(0, 0, kScreenWidth-40, 170);
    whitView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whitView];

    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor stringTOColor:@"#383838"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"取消原因";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [whitView addSubview:titleLabel];
    
    UIButton *Xbtn = [[UIButton alloc]init];
    [Xbtn setImage:[UIImage imageNamed:@"取消原因"] forState:normal];
    [Xbtn addTarget:self action:@selector(XbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [whitView addSubview:Xbtn];
    
    UITextView *textView = [[UITextView alloc]init];
    textView.delegate = self;
    self.textView = textView;
    textView.layer.borderColor = [[UIColor stringTOColor:@"#c5c5c5"]CGColor];
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 5;
    textView.clipsToBounds = YES;
    textView.font = [UIFont systemFontOfSize:13];
    textView.textColor = [UIColor stringTOColor:@"#888888"];
    textView.text = @"请与患者预定后在取消订单";
    [whitView addSubview:textView];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    self.sureBtn = sureBtn;
    sureBtn.backgroundColor = [UIColor stringTOColor:@"#22ccc6"];
    [sureBtn setTitle:@"确认" forState:normal];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.clipsToBounds = YES;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:normal];
    [whitView addSubview:sureBtn];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whitView);
        make.top.equalTo(whitView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    [Xbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.right.equalTo(whitView).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(whitView).with.offset(15);
        make.right.equalTo(whitView).with.offset(-15);
        make.height.mas_equalTo(@90);
    }];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whitView);
        make.top.equalTo(textView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];
    
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor = [UIColor stringTOColor:@"#383838"];
    textView.text = @"";
}

- (void)XbtnClick:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
