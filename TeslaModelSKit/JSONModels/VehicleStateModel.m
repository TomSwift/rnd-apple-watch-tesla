//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import "VehicleStateModel.h"


@implementation VehicleStateModel {

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
        self.roofState = [self getRoofStateForString:[[self NSNullReplacingForObject:deserializedObject[VehicleSunRoofState]] description]];
        self.driverSideFrontDoorOpened = [[self NSNullReplacingForObject:deserializedObject[VehicleDriverSideFrontDoorOpen]] boolValue];
        self.driverSideRearDoorOpened = [[self NSNullReplacingForObject:deserializedObject[VehicleDriverSideRearDoorOpen]] boolValue];
        self.passengerSideFrontDoorOpened = [[self NSNullReplacingForObject:deserializedObject[VehiclePassengerSideFrontDoorOpen]] boolValue];
        self.passengerSideRearDoorOpened = [[self NSNullReplacingForObject:deserializedObject[VehiclePassengerSideRearDoorOpen]] boolValue];
        self.frontTrunkOpened = [[self NSNullReplacingForObject:deserializedObject[VehicleFrontTrunkOpen]] boolValue];
        self.rearTrunkOpened = [[self NSNullReplacingForObject:deserializedObject[VehicleRearTrunkOpen]] boolValue];
        self.carLocked = [[self NSNullReplacingForObject:deserializedObject[VehicleIsLocked]] boolValue];
        self.roofInstalled = [[self NSNullReplacingForObject:deserializedObject[VehicleSunRoofInstalled]] boolValue];
    }

    return self;
}


- (VehicleRoofState)getRoofStateForString:(NSString *)string {
    VehicleRoofState state = RoofStateUnknown;
    __strong NSString **pointer = (NSString **) &VehicleSunRoofStateUnknown;
    for (int i = 0; i < 5; i++) {
        pointer += i;
        if ([string isEqualToString:*pointer]) {
            state = i;
            break;
        }
    }

    return state;
}


+ (NSString *)roofStateValueForName:(VehicleRoofState)state {
    __strong NSString **pointer = (NSString **) &VehicleSunRoofStateUnknown;
    pointer += state;
    return *pointer;
}

@end