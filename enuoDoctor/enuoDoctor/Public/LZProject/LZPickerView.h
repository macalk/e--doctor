//
//  LZPickerView.h
//  enuoDoctor
//
//  Created by apple on 17/1/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZPickerView : UIView

@property (nonatomic,copy) NSString *selectData;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *sureBtn;
- (void)createPickerViewWithArr:(NSArray *)dataArr;

@end
