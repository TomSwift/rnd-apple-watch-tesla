//
//  TMCarCommandsIC.h
//  TeslaModeS
//
//  Created by Oleksandr Bolhovetskyy on 11/27/14.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import <WatchKit/WatchKit.h>

#import "TeslaModelSKit.h"

@interface TMVehicleCommandsIC : WKInterfaceController

@property (nonatomic) VehicleRoofState sunRoofState;

@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnLock;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnUnlock;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnSunRoofState;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnLight;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnBeep;

- (IBAction)btnLockTouch;
- (IBAction)btnUnlockTouch;
- (IBAction)btnLightTouch;
- (IBAction)btnBeepTouch;

@end
