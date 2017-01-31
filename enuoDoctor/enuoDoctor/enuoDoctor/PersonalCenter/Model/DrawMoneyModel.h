//
//  DrawMoneyModel.h
//  enuoDoctor
//
//  Created by apple on 17/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawMoneyModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *doc_id;
@property (nonatomic,copy) NSString *h_card;
@property (nonatomic,copy) NSString *u_card;
@property (nonatomic,copy) NSString *card;

+ (id)DrawMoneyModelWithDic:(NSDictionary *)dic;

@end
