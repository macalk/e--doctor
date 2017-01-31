//
//  AppointIllModel.h
//  enuoDoctor
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointIllModel : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *mb_id;
@property (nonatomic,copy) NSString *hos_id;
@property (nonatomic,copy) NSString *ill;
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *treat;
@property (nonatomic,copy) NSString *photo;
@property (nonatomic,copy) NSString *heightprice;
@property (nonatomic,copy) NSString *wechat_url;
@property (nonatomic,assign) NSInteger is_activity;
@property (nonatomic,assign) NSInteger price;

+ (id)AppointIllModelWithDic:(NSDictionary *)dic;

@end
