//
//  DrawMoneyDetailModel.m
//  enuoDoctor
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DrawMoneyDetailModel.h"

@implementation DrawMoneyDetailModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (id)DrawMoneyDetailModelWithDic:(NSDictionary *)dic {
    return [[DrawMoneyDetailModel alloc]initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}



@end
