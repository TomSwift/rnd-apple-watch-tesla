//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


static NSString *const VehicleChargingState = @"charging_state";
static NSString *const VehicleChargeToMaxState = @"charge_to_max_range";
static NSString *const VehicleMaxRangeChargeCounter = @"max_range_charge_counter";
static NSString *const VehicleFastChargingState = @"fast_charger_present";
static NSString *const VehicleBatteryRange = @"battery_range";
static NSString *const VehicleEstimatedBatteryRange = @"est_battery_range";
static NSString *const VehicleIdealBatteryRange = @"ideal_battery_range";
static NSString *const VehicleBatteryLevel = @"battery_level";
static NSString *const VehicleBatteryCurrent = @"battery_current";
static NSString *const VehicleChargeStartingRange = @"charge_starting_range";
static NSString *const VehicleChargeStartingSOC = @"charge_starting_soc";
static NSString *const VehicleChargerVoltage = @"charger_voltage";
static NSString *const VehicleChargerPilotCurrent = @"charger_pilot_current";
static NSString *const VehicleChargerActualCurrent = @"charger_actual_current";
static NSString *const VehicleChargerPower = @"charger_power";
static NSString *const VehicleTimeToFullCharge = @"time_to_full_charge";
static NSString *const VehicleChargeRate = @"charge_rate";
static NSString *const VehicleChargePortDoorOpen = @"charge_port_door_open";


@interface VehicleChargeStateModel : BaseModel


@property (nonatomic, assign) BOOL chargingState;
@property (nonatomic, strong) NSString *batteryRange;
@property (nonatomic, strong) NSString *estimateBatteryRange;
@property (nonatomic, strong) NSString *batteryLevel;
@property (nonatomic, strong) NSString *chargerVoltage;
@property (nonatomic, assign) NSTimeInterval timeToFullCharge;
@property (nonatomic, assign) BOOL chargePortOpen;
@property (nonatomic, assign) float chargeRate;

@end