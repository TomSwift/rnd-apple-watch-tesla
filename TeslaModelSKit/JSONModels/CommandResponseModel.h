//
// Created by Oleksandr Malyarenko on 11/26/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


static NSString *const CommandResult = @"result";
static NSString *const FailureReason = @"reason";


@interface CommandResponseModel : BaseModel


@property (nonatomic, assign) BOOL commandResult;
@property (nonatomic, strong) NSString *reason;

@end