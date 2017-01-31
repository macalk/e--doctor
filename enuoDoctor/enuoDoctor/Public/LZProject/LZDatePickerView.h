//
//  LZDatePickerView.h
//  enuoDoctor
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZDatePickerView : UIView

/***
 在需要使用的VC里添加以下代码（创建一个变量接收）
 
 @property (nonatomic,strong) LZDatePickerView *lzDatePickerView;
 
 LZDatePickerView *datePickerView = [[LZDatePickerView alloc]init];
 self.lzDatePickerView = datePickerView;
 
 ***/
@property (nonatomic,copy) NSString *currentTimestamp;//当前时间戳
@property (nonatomic,copy) NSString *selectTimestamp;//选中的时间戳
@property (nonatomic,copy) NSString *currentDate;//当前时间
@property (nonatomic,copy) NSString *selectDate;//选择时间

@property (nonatomic,strong) UIButton *datePickerCancelBtn;
@property (nonatomic,strong) UIButton *datePickerSureBtn;

@property (nonatomic,copy) NSString *yearStr;
@property (nonatomic,copy) NSString *monthStr;
@property (nonatomic,copy) NSString *dayStr;
@property (nonatomic,copy) NSString *hourStr;

- (void)createDatePickerView;

@end
