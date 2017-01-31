//
//  LZFiltrateView.m
//  enuoDoctor
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LZFiltrateView.h"

@implementation LZFiltrateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createViewWithDataArr:(NSArray *)dataArr {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *filtrateBgView = [[UIView alloc]initWithFrame:window.bounds];
    self.filtrateBgView = filtrateBgView;
    filtrateBgView.backgroundColor = [UIColor clearColor];
    [window addSubview:filtrateBgView];
    
    UITapGestureRecognizer *gesTure = [[UITapGestureRecognizer alloc]init];
    [gesTure addTarget:self action:@selector(removeFiltrateBgView)];
    [filtrateBgView addGestureRecognizer:gesTure];
    
    UIImageView *filtrateImageView = [[UIImageView alloc]init];
    filtrateImageView.userInteractionEnabled = YES;
    filtrateImageView.image = [UIImage imageNamed:@"筛选背景"];
    [filtrateBgView addSubview:filtrateImageView];
    [filtrateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(filtrateBgView).with.offset(64);
        make.right.equalTo(filtrateBgView).with.offset(-17);
        make.size.mas_equalTo(CGSizeMake(143, 118));
    }];
    
    for (int i = 0; i<2; i++) {
        UIButton *filtrateBtn = [[UIButton alloc]init];
        [filtrateImageView addSubview:filtrateBtn];
        filtrateBtn.frame = CGRectMake(0, 10+i*54, 143, 54);
        [filtrateBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dataArr[i]]] forState:normal];
        [filtrateBtn setTitle:[NSString stringWithFormat:@"  %@",dataArr[i]] forState:normal];
        [filtrateBtn addTarget:self action:@selector(filtrateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 64, 103, 0.5)];
    lineLabel.backgroundColor = [UIColor stringTOColor:@"#a2a1a3"];
    [filtrateImageView addSubview:lineLabel];

}

- (void)filtrateBtnClick:(UIButton *)sender {
    [self.filtrateBgView removeFromSuperview];
    [self.LZFiltrateDelegate LZFiltrateBtnClick:sender];
}

- (void)removeFiltrateBgView {
    [self.filtrateBgView removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
