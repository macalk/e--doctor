//
//  OrderDetailModel.m
//  enuoDoctor
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:[NSDictionary changeType:dic]];
    }
    return self;
}

+ (id)OrderDetailModelWithDictionry:(NSDictionary *)dic {
    return [[OrderDetailModel alloc]initWithDic:dic];
}


@end
