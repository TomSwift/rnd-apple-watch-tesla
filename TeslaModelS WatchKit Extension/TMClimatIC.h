//
//  TMClimatIC.h
//  TeslaModeS
//
//  Created by Oleksandr Bolhovetskyy on 11/27/14.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import <WatchKit/WatchKit.h>

#import "TeslaModelSKit.h"
#import "TMConstants.h"

@interface TMClimatIC : WKInterfaceController
{
    float driverTemperature;
    float passengerTemperature;
    
    VehicleRoofState roofState;
}

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblOutsideTemperature;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblFanState;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *groupCurrentFanState;
@property (strong, nonatomic) IBOutlet WKInterfaceGroup *groupTotalFanState;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnDefrosters;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnSetRoofState;

@end
