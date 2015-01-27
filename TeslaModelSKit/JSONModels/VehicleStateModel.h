//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


static NSString *const VehicleDriverSideFrontDoorOpen = @"df";
static NSString *const VehicleDriverSideRearDoorOpen = @"dr";
static NSString *const VehiclePassengerSideFrontDoorOpen = @"pf";
static NSString *const VehiclePassengerSideRearDoorOpen = @"pr";
static NSString *const VehicleFrontTrunkOpen = @"ft";
static NSString *const VehicleRearTrunkOpen = @"rt";
static NSString *const VehicleCarVersion = @"car_verson";
static NSString *const VehicleIsLocked = @"locked";
static NSString *const VehicleSunRoofInstalled = @"sun_roof_installed";
static NSString *const VehicleSunRoofState = @"sun_roof_state";
static NSString *const VehicleSunRoofPercentOpen = @"sun_roof_percent_open";
static NSString *const VehicleDarkRims = @"dark_rims";
static NSString *const VehicleWheelType = @"wheel_type";
static NSString *const VehicleHasSpoiler = @"has_spoiler";
static NSString *const VehicleRoofColor = @"roof_color";
static NSString *const VehiclePerformanceConfig = @"perf_config";

// Sun roof states enum
typedef NS_ENUM(NSUInteger, VehicleRoofState) {
    RoofStateUnknown,
    RoofStateClose,
    RoofStateOpen,
    RoofStateComfort,
    RoofStateVent
};
// Sun roof states
static NSString *const VehicleSunRoofStateUnknown = @"unknown";
static NSString *const VehicleSunRoofStateClose = @"close";
static NSString *const VehicleSunRoofStateOpen = @"open";
static NSString *const VehicleSunRoofStateComfort = @"comfort";
static NSString *const VehicleSunRoofStateVent = @"vent";


@interface VehicleStateModel : BaseModel


@property (nonatomic, assign) VehicleRoofState roofState;
@property (nonatomic, assign) BOOL driverSideFrontDoorOpened;
@property (nonatomic, assign) BOOL driverSideRearDoorOpened;
@property (nonatomic, assign) BOOL passengerSideFrontDoorOpened;
@property (nonatomic, assign) BOOL passengerSideRearDoorOpened;
@property (nonatomic, assign) BOOL frontTrunkOpened;
@property (nonatomic, assign) BOOL rearTrunkOpened;
@property (nonatomic, assign) BOOL carLocked;
@property (nonatomic, assign) BOOL roofInstalled;

+ (NSString *)roofStateValueForName:(VehicleRoofState)state;

@end