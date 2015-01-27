//
//  TMLocationIC.h
//  TeslaModeS
//
//  Created by Oleksandr Bolhovetskyy on 11/28/14.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import <WatchKit/WatchKit.h>

#import "TeslaModelSKit.h"
#import "TMConstants.h"

@interface TMLocationIC : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceGroup *groupSpeed;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblSpeed;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblSpeedTitle;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblMph;
@property (strong, nonatomic) IBOutlet WKInterfaceMap *mapVehicleLocation;

@end
