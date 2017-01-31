//
//  OrderDetailModel.h
//  enuoDoctor
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (nonatomic,strong) NSString *dnumber;
@property (nonatomic,strong) NSString *dsort;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *doctor;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *hospital;
@property (nonatomic,strong) NSString *ill;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *treat;
@property (nonatomic,strong) NSString *nowdate;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *yue_time;
@property (nonatomic,strong) NSString *yue_date;
@property (nonatomic,strong) NSString *yue_noon;
@property (nonatomic,strong) NSString *type_id;
@property (nonatomic,strong) NSString *type_name;
@property (nonatomic,assign) NSInteger step;
@property (nonatomic,assign) NSInteger sum_step;



@property (nonatomic,assign) float viewHeght;

+ (id)OrderDetailModelWithDictionry:(NSDictionary *)dic;

@end
