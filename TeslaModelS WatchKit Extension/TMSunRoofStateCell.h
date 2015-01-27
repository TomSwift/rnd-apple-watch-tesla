//
//  TMSunRoofStateCell.h
//  TeslaModeS
//
//  Created by Oleksandr Bolhovetskyy on 11/27/14.
//  Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface TMSunRoofStateCell : NSObject

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lblState;
@property (strong, nonatomic) IBOutlet WKInterfaceImage *imgSelected;

@end
