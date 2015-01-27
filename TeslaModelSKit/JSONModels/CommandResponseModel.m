//
// Created by Oleksandr Malyarenko on 11/26/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import "CommandResponseModel.h"


@implementation CommandResponseModel {

}


- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSError *error = nil;
//  TODO: remove next line for real server, its only for work with mock
        data = [self cleanJSONForMockServerResponse:data];

        NSDictionary *deserializedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if ([deserializedObject isEqual:[NSNull null]] || error) {
            NSLog(@"error");
            self.error = error;
            return self;
        }
        self.commandResult = [deserializedObject[CommandResult] boolValue];
        self.reason = [[self NSNullReplacingForObject:deserializedObject[FailureReason]] description];
    }

    return self;
}

@end