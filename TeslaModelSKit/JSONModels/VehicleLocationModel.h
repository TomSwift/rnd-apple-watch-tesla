//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


static NSString *const VehicleShiftState = @"shift_state";
static NSString *const VehicleSpeed = @"speed";
static NSString *const VehicleLatitude = @"latitude";
static NSString *const VehicleLongitude = @"longitude";
static NSString *const VehicleHeading = @"heading";
static NSString *const VehicleGPSAsOf = @"gps_as_of";


@interface VehicleLocationModel : BaseModel


@property (nonatomic, assign) BOOL shiftState;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float heading;
@property (nonatomic, assign) NSTimeInterval GPSAsOf;

@end