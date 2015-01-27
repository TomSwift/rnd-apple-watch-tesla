//
//  TMBlowingIC.h
//  TeslaModeS
//
//  Created by Oleksandr Bolhovetskyy on 11/27/14.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import <WatchKit/WatchKit.h>

#import "TeslaModelSKit.h"
#import "TMConstants.h"

@interface TMTemperatureIC : WKInterfaceController
{
    float driverTemperature;
    float passengerTemperature;
}

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblDriversZone;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblPassengersZone;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblDriverZoneTemperature;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblPassengerZoneTemperature;

- (IBAction)btnDriverTemperatureDown;
- (IBAction)btnDriverTemperatureUp;
- (IBAction)btnPassengerTemperatureDown;
- (IBAction)btnPassengerTemperatureUp;

@end
