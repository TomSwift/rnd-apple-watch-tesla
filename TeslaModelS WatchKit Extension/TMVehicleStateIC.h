//
//  InterfaceController.h
//  TeslaModeS WatchKit Extension
//
//  Created by Oleksandr Malyarenko on 11/25/2014.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

#import "TeslaModelSKit.h"
#import "TMConstants.h"

@interface TMVehicleStateIC : WKInterfaceController
{
    BOOL isLocked;
}

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargingState;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargePercent;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargeRange;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargingTime;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblLockState;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblOutsideTemperature;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblRangeTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *groupCurrentCharge;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *groupTotalCharge;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnVehicleState;
@end
