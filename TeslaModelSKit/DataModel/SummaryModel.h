//
// Created by Oleksandr Malyarenko on 11/28/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"


@interface SummaryModel : NSObject


@property (nonatomic, assign) BOOL chargingState;
@property (nonatomic, assign) BOOL carLocked;
@property (nonatomic, strong) NSString *batteryLevel;
@property (nonatomic, strong) NSString *estimatedBatteryRange;
@property (nonatomic, strong) NSString *insideTemperature;
@property (nonatomic, strong) NSString *outsideTemperature;
@property (nonatomic, assign) NSTimeInterval timeToFullCharge;


- (instancetype)initWithSummaryInfo:(NSDictionary *)summaryInfo;

@end