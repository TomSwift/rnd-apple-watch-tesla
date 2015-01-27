//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BaseModel : NSObject


@property (nonatomic, strong) NSError *error;

- (instancetype)initWithData:(NSData *)data;

- (id)NSNullReplacingForObject:(id)object;

- (NSData *)cleanJSONForMockServerResponse:(NSData *)data;

@end