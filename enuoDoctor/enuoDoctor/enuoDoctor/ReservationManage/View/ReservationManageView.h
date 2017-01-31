//
//  ReservationManageView.h
//  enuoDoctor
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReservationManageModel.h"

@protocol RMViewBtnDelegae <NSObject>

- (void)RMViewBtnClick:(UIButton *)sender;

@end

@interface ReservationManageView : UIView

@property (nonatomic,assign) id <RMViewBtnDelegae> RMViewBtnDelegae;
@property (nonatomic,strong) UIButton *rankBtn;//排号
@property (nonatomic,strong) UILabel *appointmentTimeLabel;//预约日期
@property (nonatomic,strong) UIButton *changeDateBtn;//修改日期

@property (nonatomic,strong) ReservationManageModel *model;

- (void)createCustomViewWithModel:(ReservationManageModel *)model withStatus:(NSString *)status;

@end
