//
//  PersonalCenterModel.m
//  enuoDoctor
//
//  Created by apple on 16/12/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonalCenterModel.h"

@implementation PersonalCenterModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (id)PersonalCenterModelWithDic:(NSDictionary *)dic {
    NSLog(@"%@",dic);
    return [[PersonalCenterModel alloc]initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
