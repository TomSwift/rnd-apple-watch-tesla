//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


static NSString *const VehicleInsideTemperature = @"inside_temp";
static NSString *const VehicleOutsideTemperature = @"outside_temp";
static NSString *const VehicleDriverTemperatureSettings = @"driver_temp_setting";
static NSString *const VehiclePassengerTemperatureSettings = @"passenger_temp_setting";
static NSString *const VehicleIsAutoConditioningOn = @"is_auto_conditioning_on";
static NSString *const VehicleIsFrontDefrosterOn = @"is_front_defroster_on";
static NSString *const VehicleIsRearDefrosterOn = @"is_rear_defroster_on";
static NSString *const VehicleFanStatus = @"fan_status";


@interface VehicleClimateStateModel : BaseModel


@property (nonatomic, strong) NSString *insideTemperature;
@property (nonatomic, strong) NSString *outsideTemperature;
@property (nonatomic, strong) NSString *driverTemperatureSettings;
@property (nonatomic, strong) NSString *passengerTemperatureSettings;
@property (nonatomic, strong) NSString *fanSpeed;
@property (nonatomic, assign) BOOL isAutoConditioningOn;
@property (nonatomic, assign) BOOL isFrontDefrosterOn;
@property (nonatomic, assign) BOOL isRearDefrosterOn;

@end