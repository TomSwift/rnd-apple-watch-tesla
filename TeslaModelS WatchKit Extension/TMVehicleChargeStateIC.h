//
//  TMVihicleChargeStateIC.h
//  TeslaModeS
//
//  Created by Oleksandr Bolhovetskyy on 11/27/14.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import <WatchKit/WatchKit.h>

#import "TeslaModelSKit.h"
#import "TMConstants.h"

@interface TMVehicleChargeStateIC : WKInterfaceController
{
    NSInteger chargeLimit;
}

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargingState;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargePercent;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargeRange;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargingTime;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblRangeTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargeLimitTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargeLimit;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *groupCurrentCharge;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *groupTotalCharge;

- (IBAction)btnChargeLimitDownTouch;
- (IBAction)btnChargeLimitUpTouch;

@end
