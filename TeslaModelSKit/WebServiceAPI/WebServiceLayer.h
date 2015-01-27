//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"


@interface WebServiceLayer : NSObject <NSURLSessionDelegate>


+ (instancetype)sharedInstance;

- (void)getCombinedVehicleState:(void (^)(NSDictionary *states, NSError *error))completionHandler;
- (void)getGUISettingsWithCompletionHandler:(void (^)(VehicleGUISettingsModel *model, NSError *error))completionHandler;
- (void)getVehicleStateWithCompletionHandler:(void (^)(VehicleStateModel *model, NSError *error))completionHandler;
- (void)getClimateStateWithCompletionHandler:(void (^)(VehicleClimateStateModel *model, NSError *error))completionHandler;
- (void)getChargeStateWithCompletionHandler:(void (^)(VehicleChargeStateModel *model, NSError *error))completionHandler;
- (void)getVehicleLocationWithCompletionHandler:(void (^)(VehicleLocationModel *model, NSError *error))completionHandler;

- (void)openChargingPortWithCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)setChargeLimit:(float)limit withCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)startChargingWithCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)stopChargingWithCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)flashLightsOnceWithCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)honkHornOnceWithCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)lockDoorWithCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)unlockDoorWithCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)setTemperatureForDriver:(float)driverTemperature forPassenger:(float)passengerTemperature withCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)startAutoConditioningWithCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)stopAutoConditioningWithCompletionHandler:(void (^)(BOOL status))completionHandler;
- (void)setSunRoofState:(VehicleRoofState)state withCompletionHandler:(void (^)(BOOL status))completionHandler;

@end