//
//  TMChargeLimitIC.m
//  TeslaModeS
//
//  Created by Oleksandr Bolhovetskyy on 11/27/14.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import "TMChargeLimitIC.h"

@implementation TMChargeLimitIC

- (instancetype)initWithContext:(id)context
{
    self = [super initWithContext:context];
    if (self)
    {
        // Initialize variables here.
        // Configure interface objects here.
        NSLog(@"%@ initWithContext", self);
        
        chargeLimit = 0;
        [self.sliderChargeLimit setValue:0];
    }
    return self;
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    NSLog(@"%@ will activate", self);    
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    NSLog(@"%@ did deactivate", self);
}

#pragma mark Button
- (IBAction)btnApplyChargeLimitTouch
{
    [self.btnApplyChargeLimit setEnabled:NO];
    [[WebServiceLayer sharedInstance] setChargeLimit:chargeLimit withCompletionHandler:^(BOOL status) {
        [self.btnApplyChargeLimit setEnabled:YES];
        [self dismissController];
    }];
}

- (IBAction)sliderChargeLimitValueChanged:(float)value
{
    chargeLimit = value;
}

@end
