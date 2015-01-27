//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import "VehicleGUISettingsModel.h"


@implementation VehicleGUISettingsModel {

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
        self.GUITemperatureUnits = [[self NSNullReplacingForObject:deserializedObject[VehicleGUITemperatureUnits]] description];
        self.GUIDistanceUnits = [[self NSNullReplacingForObject:deserializedObject[VehicleGUIDistanceUnits]] description];
        self.GUIChargeRateUnits = [[self NSNullReplacingForObject:deserializedObject[VehicleGUIChargeRateUnits]] description];
        self.GUIRangeDisplay = [[self NSNullReplacingForObject:deserializedObject[VehicleGUIRangeDisplay]] description];
        self.TwentyFourHoursTimeEnabled = [deserializedObject[VehicleGUI24Hours] boolValue];
    }

    return self;
}

@end