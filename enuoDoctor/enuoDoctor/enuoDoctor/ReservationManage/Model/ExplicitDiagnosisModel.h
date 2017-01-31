//
//  ExplicitDiagnosisModel.h
//  enuoDoctor
//
//  Created by apple on 17/1/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ExplicitDiagnosisModel : NSObject

+ (id)ExplicitDiagnosisModelWithDictionry:(NSDictionary *)dic;

@property (nonatomic,copy) NSString *effectStr;
@property (nonatomic,copy) NSString *understandStr;

//以下后台返回
@property (nonatomic,strong) NSArray * effect_list;
@property (nonatomic,strong) NSArray * understand_list;
@property (nonatomic,copy) NSString *cycle;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *hos_id;
@property (nonatomic,copy) NSString *lowprice;
@property (nonatomic,copy) NSString *heightprice;
@property (nonatomic,assign) NSInteger is_activity;

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *ill;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *treat;

@property (nonatomic,copy) NSString *mb_id;

@end
