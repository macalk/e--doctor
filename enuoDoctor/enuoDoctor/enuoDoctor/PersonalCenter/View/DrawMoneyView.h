//
//  DrawMoneyView.h
//  enuoDoctor
//
//  Created by apple on 17/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawMoneyView : UIView

@property (nonatomic,strong) UIButton *bankCardBtn;
@property (nonatomic,strong) UIButton *drawAllMoneyBtn;
@property (nonatomic,strong) UITextField *myMoneyTextField;

- (void)createViewWithMoney:(NSString *)money ;
@end
