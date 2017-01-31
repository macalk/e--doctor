//
//  LZDatePickerView.m
//  enuoDoctor
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LZDatePickerView.h"

@interface LZDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) NSArray *yearArr;
@property (nonatomic,strong) NSMutableArray *dayArr;

@property (nonatomic,assign) NSInteger dayNumOfCurrentMonth;


@end


@implementation LZDatePickerView

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

- (void)createDatePickerView {
    
    //当前时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSInteger a=[dat timeIntervalSince1970]*1000;
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)a];//转为字符型
    self.currentTimestamp = timestamp;
    
    //2. 获取当前年份和月份和天数
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger iCurYear = [components year];  //当前的年份
    
    NSInteger iCurMonth = [components month];  //当前的月份
    
    NSInteger iCurDay = [components day];  // 当前的日数
    
    self.currentDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)iCurYear,(long)iCurMonth,(long)iCurDay];
    NSLog(@"%@",self.currentDate);
    
    self.yearArr = @[[NSString stringWithFormat:@"%ld",(long)iCurYear],[NSString stringWithFormat:@"%ld",(long)iCurYear+1]];
    
    NSMutableArray *firstYearArr = [NSMutableArray array];
    NSMutableArray *secondYearArr = [NSMutableArray array];
    [firstYearArr removeAllObjects];
    [secondYearArr removeAllObjects];
    for (int i = 0; i<12; i++) {
        //年+月
        NSString *monthStr = [NSString stringWithFormat:@"%02d",i+1];
        NSString *firstYearMonthStr = [NSString stringWithFormat:@"%ld%@",(long)iCurYear,monthStr];
        NSString *secondYearMonthStr = [NSString stringWithFormat:@"%d%@",iCurYear+1,monthStr];
        
        
        //字符串转date
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [inputFormatter setDateFormat:@"yyyyMM"];
        NSDate* firstYearMonthDate = [inputFormatter dateFromString:firstYearMonthStr];
        NSDate* secondYearMonthDate = [inputFormatter dateFromString:secondYearMonthStr];
        //因为相差8个时区
        NSTimeInterval  timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
        firstYearMonthDate = [firstYearMonthDate  dateByAddingTimeInterval: timeZoneOffset];
        secondYearMonthDate = [secondYearMonthDate  dateByAddingTimeInterval: timeZoneOffset];
        
        
        //得出当前月份对应的天数。
        NSCalendar *curCalendar = [NSCalendar currentCalendar];
        NSRange numberOfDaysInMonthOfFirstYearRange = [curCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstYearMonthDate];
        NSRange numberOfDaysInMonthOfSecondYearRange = [curCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:secondYearMonthDate];
        
        NSUInteger numberOfDaysInMonthOfFirstYear = numberOfDaysInMonthOfFirstYearRange.length;
        NSUInteger numberOfDaysInMonthOfSecondYear = numberOfDaysInMonthOfSecondYearRange.length;
        
        [firstYearArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)numberOfDaysInMonthOfFirstYear]];
        [secondYearArr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)numberOfDaysInMonthOfSecondYear]];
        
    }
    
    [self.dayArr addObject:firstYearArr];
    [self.dayArr addObject:secondYearArr];

    
                      /*****1*****/
    
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
            self.datePickerCancelBtn = button;
        }else {
            self.datePickerSureBtn = button;
        }
        [whiteView addSubview:button];
    }
    
    
    self.yearStr = [NSString stringWithFormat:@"%@",self.yearArr[0]];
    self.monthStr = @"01";
    self.dayStr = @"01";
    self.hourStr = @"00";
    self.selectDate = [NSString stringWithFormat:@"%@-%@-%@ %@:00",self.yearStr,self.monthStr,self.dayStr,self.hourStr];
    
    //字符串转date
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* selectDate = [inputFormatter dateFromString:self.selectDate];
    
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[selectDate timeIntervalSince1970]*1000];
    self.selectTimestamp = timeSp;
    
}

#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return 2;
    }else if (component == 1) {
        return 12;
    }else if (component == 2) {
        
        //获取年所在行数
        NSInteger  yearIndex = [pickerView selectedRowInComponent:0];
        //获取月所在行数
        NSInteger monthIndex = [pickerView selectedRowInComponent:1];
        //当月的天数
        self.dayNumOfCurrentMonth = [self.dayArr[yearIndex][monthIndex] integerValue];
        
        return self.dayNumOfCurrentMonth;
        
    }else if (component == 3) {
        return 24;
    }
    
    return 0;
    
    
}
//设置组件中每行的标题row:行
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:15];
    
    if (component == 0) {
        textLabel.text = [NSString stringWithFormat:@"%@年",self.yearArr[row]];
    }else if (component == 1) {
        textLabel.text = [NSString stringWithFormat:@"%ld月",(long)row+1];
    }else if (component == 2) {
        textLabel.text = [NSString stringWithFormat:@"%ld日",(long)row+1];
    }else if (component == 3) {
        textLabel.text = [NSString stringWithFormat:@"%ld时",(long)row];
    }
    
    
    return textLabel;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component == 0) {
         self.yearStr = self.yearArr[row];
        [pickerView reloadComponent:component+1];
    }else if (component == 1) {
        self.monthStr = [NSString stringWithFormat:@"%02ld",(long)row+1];
        [pickerView reloadComponent:component+1];
    }else if (component == 2) {
        self.dayStr = [NSString stringWithFormat:@"%02ld",(long)row+1];
        [pickerView reloadComponent:component+1];
    }else if (component == 3) {
        self.hourStr = [NSString stringWithFormat:@"%02ld",(long)row];
    }
    
    self.selectDate = [NSString stringWithFormat:@"%@-%@-%@ %@:00",self.yearStr,self.monthStr,self.dayStr,self.hourStr];
    
    //字符串转date
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* selectDate = [inputFormatter dateFromString:self.selectDate];
    
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[selectDate timeIntervalSince1970]*1000];
    self.selectTimestamp = timeSp;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
