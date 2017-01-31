//
//  OrderCancelReasonView.h
//  enuoDoctor
//
//  Created by apple on 17/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCancelReasonView : UIView

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIButton *sureBtn;

- (void)createCancelReasonView;

@end
