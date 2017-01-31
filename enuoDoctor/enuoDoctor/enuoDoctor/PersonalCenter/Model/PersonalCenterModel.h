//
//  PersonalCenterModel.h
//  enuoDoctor
//
//  Created by apple on 16/12/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalCenterModel : NSObject

+ (id)PersonalCenterModelWithDic:(NSDictionary *)dic;

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *photo;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *professional;
@property (nonatomic,copy)NSString *nuo;
@property (nonatomic,copy)NSString *username;
@property (nonatomic,assign)NSInteger comment_num;
@property (nonatomic,assign)NSInteger guanzhu;
@property (nonatomic,copy)NSString *chat_token;


@end
