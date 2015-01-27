//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import "VehicleChargeStateModel.h"


@implementation VehicleChargeStateModel {

}


- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSError *error = nil;
//  TODO: remove next line for real server, its only for work with mock
        data = [self cleanJSONForMockServerResponse:data];

        NSDictionary *deserializedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if ([deserializedObject isEqual:[NSNull null]] || error) {
            NSLog(@"error: %@", error.localizedDescription);
            self.error = error;
            return self;
        }
        NSString *state = [[self NSNullReplacingForObject:deserializedObject[VehicleChargingState]] description];
        self.chargingState = [state isEqualToString:@"Charging"];
        self.batteryLevel = [[self NSNullReplacingForObject:deserializedObject[VehicleBatteryLevel]] description];
        self.batteryRange = [[self NSNullReplacingForObject:deserializedObject[VehicleBatteryRange]] description];
        self.estimateBatteryRange = [[self NSNullReplacingForObject:deserializedObject[VehicleEstimatedBatteryRange]] description];
        self.chargerVoltage = [[self NSNullReplacingForObject:deserializedObject[VehicleChargerVoltage]] description];
        self.timeToFullCharge = [[self NSNullReplacingForObject:deserializedObject[VehicleTimeToFullCharge]] unsignedIntegerValue];
        self.chargePortOpen = [[self NSNullReplacingForObject:deserializedObject[VehicleChargePortDoorOpen]] boolValue];
        self.chargeRate = [[self NSNullReplacingForObject:deserializedObject[VehicleChargeRate]] floatValue];
    }

    return self;
}

@end