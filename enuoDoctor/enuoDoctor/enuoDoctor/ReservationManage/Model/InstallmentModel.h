//
//  InstallmentModel.h
//  enuoDoctor
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstallmentModel : NSObject

@property (nonatomic,copy) NSString *appointMoney;//预约金额
@property (nonatomic,copy) NSString *appointDate;//预约日期

@property (nonatomic,copy) NSString *ybMoney;//医保后的金额

@property (nonatomic,assign) BOOL ybYES;


@end
