//
//  OrderDetailView.h
//  enuoDoctor
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface OrderDetailView : UIView

@property (nonatomic,strong) UILabel *appointmentTimeLabel;//预约日期

@property (nonatomic,strong) OrderDetailModel *model;

- (void)createCustomViewWithModel:(OrderDetailModel *)model withStatus:(NSString *)status;

@end
