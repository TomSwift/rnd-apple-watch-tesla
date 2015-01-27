//
//  GlanceController.h
//  TeslaModeS WatchKit Extension
//
//  Created by Oleksandr Malyarenko on 11/25/2014.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

#import "TeslaModelSKit.h"
#import "TMConstants.h"

@interface GlanceController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblVehicleState;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargeTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblCharge;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblChargeTime;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblRangeTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblRange;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblMph;
@property (strong, nonatomic) IBOutlet WKInterfaceImage *imgVehicle;

@end
