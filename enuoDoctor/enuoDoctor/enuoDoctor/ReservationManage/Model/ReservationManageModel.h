//
//  ReservationManageModel.h
//  enuoDoctor
//
//  Created by apple on 16/12/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReservationManageModel : NSObject

+ (id)ReservationManageModelWithDictionry:(NSDictionary *)dic;

@property (nonatomic,strong) NSString *dnumber;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *doctor;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *hospital;
@property (nonatomic,strong) NSString *ill;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) NSString *treat;
@property (nonatomic,strong) NSString *nowdate;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *yue_time;
@property (nonatomic,strong) NSString *is_check;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *yue_date;
@property (nonatomic,strong) NSString *yue_noon;
@property (nonatomic,strong) NSString *type_name;
@property (nonatomic,strong) NSString *dsort;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *delete_table;
@property (nonatomic,strong) NSString *delete_reason;
@property (nonatomic,strong) NSString *hos_id;
@property (nonatomic,strong) NSString *type_id;
@property (nonatomic,assign) NSInteger is_activity;

@property (nonatomic,assign) float viewHeght;

@end
