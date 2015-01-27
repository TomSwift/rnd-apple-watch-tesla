//
//  TMChargeLimitIC.h
//  TeslaModeS
//
//  Created by Oleksandr Bolhovetskyy on 11/27/14.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import <WatchKit/WatchKit.h>

#import "TeslaModelSKit.h"

@interface TMChargeLimitIC : WKInterfaceController
{
    float chargeLimit;
}

@property (strong, nonatomic) IBOutlet WKInterfaceSlider *sliderChargeLimit;
@property (strong, nonatomic) IBOutlet WKInterfaceButton *btnApplyChargeLimit;

- (IBAction)btnApplyChargeLimitTouch;
- (IBAction)sliderChargeLimitValueChanged:(float)value;

@end
