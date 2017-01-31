//
//  AppointIllModel.m
//  enuoDoctor
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AppointIllModel.h"

@implementation AppointIllModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (id)AppointIllModelWithDic:(NSDictionary *)dic {
    return [[AppointIllModel alloc]initWithDic:dic];
}


@end
