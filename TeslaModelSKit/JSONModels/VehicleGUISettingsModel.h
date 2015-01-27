//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


static NSString *const VehicleGUIDistanceUnits = @"gui_distance_units";
static NSString *const VehicleGUITemperatureUnits = @"gui_temperature_units";
static NSString *const VehicleGUIChargeRateUnits = @"gui_charge_rate_units";
static NSString *const VehicleGUI24Hours = @"gui_24_hour_time";
static NSString *const VehicleGUIRangeDisplay = @"gui_range_display";


@interface VehicleGUISettingsModel : BaseModel


@property (nonatomic, strong) NSString *GUIDistanceUnits;
@property (nonatomic, strong) NSString *GUITemperatureUnits;
@property (nonatomic, strong) NSString *GUIChargeRateUnits;
@property (nonatomic, strong) NSString *GUIRangeDisplay;
@property (nonatomic, assign) BOOL TwentyFourHoursTimeEnabled;

@end