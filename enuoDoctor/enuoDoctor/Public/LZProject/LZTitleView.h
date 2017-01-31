//
//  LZTitleView.h
//  enuoDoctor
//
//  Created by apple on 16/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LZtitleViewDelegate <NSObject>

- (void)LZtitleBtnClick:(UIButton *)sender;

@end

@interface LZTitleView : UIView

@property (nonatomic,weak) id <LZtitleViewDelegate> LZDelegate;
@property (nonatomic,strong) UIScrollView *scrolView;
@property (nonatomic,strong) UILabel *redLabel;

//显示红点的数量
- (void)showRedLabelWithStatus:(NSString *)status andNum:(NSString *)num;
//隐藏红点的数量
- (void)hiddenRedLabelWithStatus:(NSString *)status;

// 创建视图，导入标题
- (void)CreateCustomTitleViewWithTitleArr:(NSArray *)titleArr;

//外部改变当前的tbn
- (void)changeBtnFrameWithBtnTag:(NSInteger)btnTag;

@end
