//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import "VehicleLocationModel.h"


@implementation VehicleLocationModel {

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
        self.shiftState = [[self NSNullReplacingForObject:deserializedObject[VehicleShiftState]] boolValue];
        self.speed = [[self NSNullReplacingForObject:deserializedObject[VehicleSpeed]] floatValue];
        self.latitude = [[self NSNullReplacingForObject:deserializedObject[VehicleLatitude]] floatValue];
        self.longitude = [[self NSNullReplacingForObject:deserializedObject[VehicleLongitude]] floatValue];
        self.heading = [[self NSNullReplacingForObject:deserializedObject[VehicleHeading]] floatValue];
        self.GPSAsOf = [[self NSNullReplacingForObject:deserializedObject[VehicleGPSAsOf]] unsignedIntegerValue];
    }

    return self;
}

@end