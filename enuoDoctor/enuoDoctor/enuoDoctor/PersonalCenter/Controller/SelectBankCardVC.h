//
//  SelectBankCardVC.h
//  enuoDoctor
//
//  Created by apple on 17/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"
#import "SelectBankCardModel.h"

@interface SelectBankCardVC : RootViewController

@property (nonatomic,copy) void(^myBlock) (SelectBankCardModel *) ;

@end
