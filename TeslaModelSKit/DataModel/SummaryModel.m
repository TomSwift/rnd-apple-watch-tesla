//
// Created by Oleksandr Malyarenko on 11/28/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import "SummaryModel.h"


@interface SummaryModel () <NSCoding>
@end


@implementation SummaryModel {

}


- (instancetype)initWithSummaryInfo:(NSDictionary *)summaryInfo {
    self = [super init];
    if (self) {
        VehicleChargeStateModel *chargingModel = summaryInfo[VehicleCharging];
        VehicleClimateStateModel *climateModel = summaryInfo[VehicleClimate];
        VehicleStateModel *stateModel = summaryInfo[VehicleState];

        self.carLocked = stateModel.carLocked;
        self.chargingState = chargingModel.chargingState;
        self.batteryLevel = chargingModel.batteryLevel;
        self.estimatedBatteryRange = chargingModel.estimateBatteryRange;
        self.insideTemperature = climateModel.insideTemperature;
        self.outsideTemperature = climateModel.outsideTemperature;
        self.timeToFullCharge = chargingModel.timeToFullCharge;
    }

    return self;
}


#pragma mark - NSCoding protocol methods


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:self.carLocked forKey:@"carLocked"];
    [coder encodeBool:self.chargingState forKey:@"chargingState"];
    [coder encodeObject:self.batteryLevel forKey:@"batteryLevel"];
    [coder encodeObject:self.estimatedBatteryRange forKey:@"estimatedBatteryRange"];
    [coder encodeObject:self.insideTemperature forKey:@"insideTemperature"];
    [coder encodeObject:self.outsideTemperature forKey:@"outsideTemperature"];
    [coder encodeInteger:self.timeToFullCharge forKey:@"timeToFullCharge"];
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.carLocked = [coder decodeBoolForKey:@"carLocked"];
        self.chargingState = [coder decodeBoolForKey:@"chargingState"];
        self.batteryLevel = [coder decodeObjectForKey:@"batteryLevel"];
        self.estimatedBatteryRange = [coder decodeObjectForKey:@"estimatedBatteryRange"];
        self.insideTemperature = [coder decodeObjectForKey:@"insideTemperature"];
        self.outsideTemperature = [coder decodeObjectForKey:@"outsideTemperature"];
        self.timeToFullCharge = [coder decodeIntegerForKey:@"timeToFullCharge"];
    }

    return self;
}

@end