//
//  DrawMoneyDetailModel.h
//  enuoDoctor
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawMoneyDetailModel : NSObject

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *doc_id;
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *act_time;
@property (nonatomic,copy) NSString *act_type;
@property (nonatomic,copy) NSString *statue;
@property (nonatomic,copy) NSString *check_time;
@property (nonatomic,copy) NSString *relate_dnumber;
@property (nonatomic,copy) NSString *card_id;

+ (id)DrawMoneyDetailModelWithDic:(NSDictionary *)dic;
@end
