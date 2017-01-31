//
//  ReservationManageModel.m
//  enuoDoctor
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ReservationManageModel.h"

@implementation ReservationManageModel

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:[NSDictionary changeType:dic]];
    }
    return self;
}

+ (id)ReservationManageModelWithDictionry:(NSDictionary *)dic {
    return [[ReservationManageModel alloc]initWithDic:dic];
}


@end
