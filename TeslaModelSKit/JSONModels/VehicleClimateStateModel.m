//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import "VehicleClimateStateModel.h"


@implementation VehicleClimateStateModel {

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
        self.insideTemperature = [[self NSNullReplacingForObject:deserializedObject[VehicleInsideTemperature]] description];
        self.outsideTemperature = [[self NSNullReplacingForObject:deserializedObject[VehicleOutsideTemperature]] description];
        self.driverTemperatureSettings = [[self NSNullReplacingForObject:deserializedObject[VehicleDriverTemperatureSettings]] description];
        self.passengerTemperatureSettings = [[self NSNullReplacingForObject:deserializedObject[VehiclePassengerTemperatureSettings]] description];
        self.fanSpeed = [[self NSNullReplacingForObject:deserializedObject[VehicleFanStatus]] description];
        self.isAutoConditioningOn = [[self NSNullReplacingForObject:deserializedObject[VehicleIsAutoConditioningOn]] boolValue];
        self.isFrontDefrosterOn = [[self NSNullReplacingForObject:deserializedObject[VehicleIsFrontDefrosterOn]] boolValue];
        self.isRearDefrosterOn = [[self NSNullReplacingForObject:deserializedObject[VehicleIsRearDefrosterOn]] boolValue];
    }

    return self;
}

@end