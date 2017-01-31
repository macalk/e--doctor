//
//  DrawMoneyModel.m
//  enuoDoctor
//
//  Created by apple on 17/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DrawMoneyModel.h"

@implementation DrawMoneyModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (id)DrawMoneyModelWithDic:(NSDictionary *)dic {
    return [[DrawMoneyModel alloc]initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
