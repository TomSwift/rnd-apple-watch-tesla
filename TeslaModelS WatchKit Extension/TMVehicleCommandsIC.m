//
//  TMCarCommandsIC.m
//  TeslaModeS
//
//  Created by Oleksandr Bolhovetskyy on 11/27/14.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import "TMVehicleCommandsIC.h"

@implementation TMVehicleCommandsIC

- (instancetype)initWithContext:(id)context
{
    self = [super initWithContext:context];
    if (self)
    {
        // Initialize variables here.
        // Configure interface objects here.
        NSLog(@"%@ initWithContext", self);
        
        [self getVehicleState];
    }
    return self;
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    NSLog(@"%@ will activate", self);
    
    [self getVehicleState];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    NSLog(@"%@ did deactivate", self);
}

- (void)getVehicleState
{
    [[WebServiceLayer sharedInstance] getVehicleStateWithCompletionHandler:^(VehicleStateModel *model, NSError *error) {
        if (!error)
        {
            [self.btnLock setEnabled:model.carLocked];
            [self.btnUnlock setEnabled:!model.carLocked];
            
            if (model.roofInstalled)
            {
                [self.btnSunRoofState setHidden:NO];
                
                NSString *roofState = [NSString string];
                switch (self.sunRoofState)
                {
                    case RoofStateClose:
                        roofState = @"close";
                        break;
                    case RoofStateComfort:
                        roofState = @"open";
                        break;
                    case RoofStateOpen:
                        roofState = @"conform";
                        break;
                    case RoofStateVent:
                        roofState = @"vent";
                        break;
                    default:
                        break;
                }
                [self.btnSunRoofState setTitle:[NSString stringWithFormat:@"Sun roof: %@", roofState]];
            }
            else
            {
                [self.btnSunRoofState setHidden:YES];
            }
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
            [self.btnSunRoofState setHidden:YES];
        }
        
    }];
}

#pragma mark Segue
- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier
{
    if ([segueIdentifier isEqualToString:@"sunRoofStateSelect"])
    {
        return [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:self.sunRoofState] forKey:@"state"];
    }
    return nil;
}

#pragma mark Buttons
- (IBAction)btnLockTouch
{
    [self.btnLock setEnabled:NO];
    [[WebServiceLayer sharedInstance] lockDoorWithCompletionHandler:^(BOOL status) {
        if (status)
        {
            [self.btnUnlock setEnabled:YES];
        }
        else
        {
            [self.btnLock setEnabled:YES];
        }
    }];
}

- (IBAction)btnUnlockTouch
{
    [self.btnUnlock setEnabled:NO];
    [[WebServiceLayer sharedInstance] unlockDoorWithCompletionHandler:^(BOOL status) {
        if (status)
        {
            [self.btnLock setEnabled:YES];
        }
        else
        {
            [self.btnUnlock setEnabled:YES];
        }
    }];
}

- (IBAction)btnLightTouch
{
    [self.btnLight setEnabled:NO];
    [[WebServiceLayer sharedInstance] flashLightsOnceWithCompletionHandler:^(BOOL status) {
        [self.btnLight setEnabled:YES];
    }];
}

- (IBAction)btnBeepTouch
{
    [self.btnBeep setEnabled:NO];
    [[WebServiceLayer sharedInstance] honkHornOnceWithCompletionHandler:^(BOOL status) {
        [self.btnBeep setEnabled:YES];
    }];
}

@end
