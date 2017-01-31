//
//  LZFiltrateView.h
//  enuoDoctor
//
//  Created by apple on 17/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LZFiltrateViewDelegate <NSObject>

- (void)LZFiltrateBtnClick:(UIButton *)sender;

@end

@interface LZFiltrateView : UIView

- (void)createViewWithDataArr:(NSArray *)dataArr;

@property (nonatomic,weak) id <LZFiltrateViewDelegate> LZFiltrateDelegate;
@property (nonatomic,strong) UIView *filtrateBgView;

@end
