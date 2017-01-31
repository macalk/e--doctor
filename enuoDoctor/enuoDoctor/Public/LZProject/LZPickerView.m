//
//  LZPickerView.m
//  enuoDoctor
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LZPickerView.h"

@interface LZPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation LZPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createPickerViewWithArr:(NSArray *)dataArr {
    
    self.dataArr = dataArr;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = window.bounds;
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [window addSubview:bgView];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeigth, kScreenWidth, 246)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteView];
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 216)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [whiteView addSubview:pickerView];
    [UIView animateWithDuration:0.5 animations:^{
        whiteView.frame = CGRectMake(0, kScreenHeigth-246, kScreenWidth, 246);
    }];
    
    NSArray *btnArr = @[@"取消",@"确定"];
    for (int i = 0; i<2; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.frame = CGRectMake((kScreenWidth-80)*i, 0, 80, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:[NSString stringWithFormat:@"%@",btnArr[i]] forState:normal];
        [button setTitleColor:[UIColor stringTOColor:@"#22ccc6"] forState:normal];
        if (i == 0) {
            self.cancelBtn = button;
        }else {
            self.sureBtn = button;
        }
        [whiteView addSubview:button];
    }

    
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.dataArr.count;
    
    
}
//设置组件中每行的标题row:行
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.text = [NSString stringWithFormat:@"%@",self.dataArr[row]];
    
    return textLabel;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.selectData = self.dataArr[row];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
