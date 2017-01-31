//
//  LZTitleView.m
//  enuoDoctor
//
//  Created by 鲁振 on 16/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LZTitleView.h"

@interface LZTitleView ()
@property (nonatomic,assign) float scrollMaxOffset;//可偏移最大量
@property (nonatomic,strong) UILabel *underline;//下划线
@property (nonatomic,strong) UIButton *selectBtn;//选中的btn
@end

@implementation LZTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)CreateCustomTitleViewWithTitleArr:(NSArray *)titleArr {
    //横线
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor stringTOColor:@"#f4f4f4"];
    lineLabel.frame = CGRectMake(0, self.frame.size.height-1, kScreenWidth, 1);
    [self addSubview:lineLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height)];
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrolView = scrollView;
    [self addSubview:scrollView];
    
    //下滑线
    UILabel *underline = [[UILabel alloc]init];
    self.underline = underline;
    underline.backgroundColor = [UIColor stringTOColor:@"#22ccc6"];
    [scrollView addSubview:underline];
    
    
    //设置每个按钮的长度
    float buttonWidth;
    float titleBtnX = 0.0;
    
    for (int i = 0; i<titleArr.count; i++) {
        NSString *titleStr = titleArr[i];
        CGRect rect = [titleStr boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        buttonWidth = rect.size.width+40;
        
        UIButton *titleBtn = [[UIButton alloc]init];
        [titleBtn setTitle:titleArr[i] forState:normal];
        [titleBtn setTitleColor:[UIColor stringTOColor:@"#6f6f6f"] forState:normal];
        [titleBtn setTitleColor:[UIColor stringTOColor:@"#22ccc6"] forState:UIControlStateSelected];
        titleBtn.tag = 10+i;
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.frame = CGRectMake(titleBtnX, 0, buttonWidth, self.frame.size.height);
        titleBtnX = buttonWidth+titleBtnX;
        [scrollView addSubview:titleBtn];
        
        if (i==0) {
            titleBtn.selected = YES;
            self.selectBtn = titleBtn;
            underline.frame = CGRectMake(titleBtn.center.x-rect.size.width/2,self.frame.size.height-1 , rect.size.width, 1);
        }
        
        //红点
        UILabel *redLabel = [[UILabel alloc]init];
        self.redLabel = redLabel;
        redLabel.backgroundColor = [UIColor stringTOColor:@"#ff010f"];
        redLabel.textColor = [UIColor whiteColor];
        redLabel.text = @"5";
        redLabel.tag = 100+i;
        redLabel.textAlignment = NSTextAlignmentCenter;
        redLabel.font = [UIFont systemFontOfSize:10];
        redLabel.frame = CGRectMake(titleBtnX-20, 5, 14, 14);
        redLabel.layer.cornerRadius = 7;
        redLabel.clipsToBounds = YES;
        redLabel.hidden = YES;
        [scrollView addSubview:redLabel];
        
    }
    
    self.scrollMaxOffset = titleBtnX-kScreenWidth;//可偏移最大量
    scrollView.contentSize = CGSizeMake(titleBtnX, 0);
    
    
}

//显示红点的数量
- (void)showRedLabelWithStatus:(NSString *)status andNum:(NSString *)num {
    NSInteger tag = [status integerValue]+100;
    UILabel *redLabel = [self viewWithTag:tag];
    redLabel.text = num;
    redLabel.hidden = NO;
}
//隐藏红点的数量
- (void)hiddenRedLabelWithStatus:(NSString *)status {
    NSInteger tag = [status integerValue]+100;
    UILabel *redLabel = [self viewWithTag:tag];
    redLabel.hidden = YES;
}


//自己改变btn状态
- (void)titleBtnClick:(UIButton *)sender {
    
    //实现代理方法
    [self.LZDelegate LZtitleBtnClick:sender];
    
    //改变btn颜色
    self.selectBtn.selected = NO;
    sender.selected = YES;
    self.selectBtn = sender;
    
    CGRect rect = [sender.currentTitle boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    //需要改变的偏移量
    float scrollOffset = sender.center.x-self.center.x;

    if (sender.center.x>=self.center.x) {//偏移增加(或减少)
        
        if (scrollOffset>self.scrollMaxOffset) {
            scrollOffset = self.scrollMaxOffset;
        }
        
    }else {
        
        scrollOffset = 0;
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.underline.frame = CGRectMake(sender.center.x-rect.size.width/2,self.frame.size.height-1 , rect.size.width, 1);
        self.scrolView.contentOffset = CGPointMake(scrollOffset, 0);
    }];
}

//外部改变当前的tbn状态
- (void)changeBtnFrameWithBtnTag:(NSInteger)btnTag {
    UIButton *currentBtn = [self viewWithTag:btnTag+10];
    
    
    //改变btn颜色
    self.selectBtn.selected = NO;
    currentBtn.selected = YES;
    self.selectBtn = currentBtn;
    
    CGRect rect = [currentBtn.currentTitle boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    //需要改变的偏移量
    float scrollOffset = currentBtn.center.x-self.center.x;
    
    if (currentBtn.center.x>=self.center.x) {//偏移增加(或减少)
        
        if (scrollOffset>self.scrollMaxOffset) {
            scrollOffset = self.scrollMaxOffset;
        }
        
    }else {
        
        scrollOffset = 0;
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.underline.frame = CGRectMake(currentBtn.center.x-rect.size.width/2,self.frame.size.height-1 , rect.size.width, 1);
        self.scrolView.contentOffset = CGPointMake(scrollOffset, 0);
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
