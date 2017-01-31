//
//  ExplicitDiagnosisModel.m
//  enuoDoctor
//
//  Created by apple on 17/1/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ExplicitDiagnosisModel.h"

@implementation ExplicitDiagnosisModel

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:[NSDictionary changeType:dic]];
    }
    return self;
}

+ (id)ExplicitDiagnosisModelWithDictionry:(NSDictionary *)dic {
    return [[ExplicitDiagnosisModel alloc]initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}


@end
