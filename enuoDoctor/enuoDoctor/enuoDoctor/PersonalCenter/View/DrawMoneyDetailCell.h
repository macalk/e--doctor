//
//  DrawMoneyDetailCell.h
//  enuoDoctor
//
//  Created by apple on 17/1/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrawMoneyDetailModel;

@interface DrawMoneyDetailCell : UITableViewCell

@property (nonatomic,strong) DrawMoneyDetailModel *model;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
