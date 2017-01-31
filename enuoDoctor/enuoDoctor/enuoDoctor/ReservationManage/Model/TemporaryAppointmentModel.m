//
//  TemporaryAppointmentModel.m
//  enuoDoctor
//
//  Created by apple on 17/1/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TemporaryAppointmentModel.h"

@implementation TemporaryAppointmentModel


- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (id)TemporaryAppointmentModelWithDictionry:(NSDictionary *)dic {
    return [[TemporaryAppointmentModel alloc]initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}



@end
