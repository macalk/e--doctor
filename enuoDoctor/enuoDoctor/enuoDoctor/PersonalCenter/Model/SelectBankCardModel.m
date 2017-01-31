//
//  SelectBankCardModel.m
//  enuoDoctor
//
//  Created by apple on 17/1/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SelectBankCardModel.h"

@implementation SelectBankCardModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (id)SelectBankCardModelWithDic:(NSDictionary *)dic {
    return [[SelectBankCardModel alloc]initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}


@end
