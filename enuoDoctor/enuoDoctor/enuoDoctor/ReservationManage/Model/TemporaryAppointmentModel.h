//
//  TemporaryAppointmentModel.h
//  enuoDoctor
//
//  Created by apple on 17/1/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemporaryAppointmentModel : NSObject

+ (id)TemporaryAppointmentModelWithDictionry:(NSDictionary *)dic;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *name;


@end
