//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import "BaseModel.h"


@implementation BaseModel {

}


- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {

    }

    return self;
}


- (id)NSNullReplacingForObject:(id)object {
    id result;

    if ([object isEqual:[NSNull null]]) {
        result = nil;
    }
    else {
        result = object;
    }

    return result;
}


- (NSData *)cleanJSONForMockServerResponse:(NSData *)data {
    NSString *inputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *reg = @"//(.*?)\\r?\\n";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *outputString = [regularExpression stringByReplacingMatchesInString:inputString options:0 range:NSMakeRange(0, inputString.length) withTemplate:@"\n"];
    NSData *result = [outputString dataUsingEncoding:NSUTF8StringEncoding];

    return result;
}

@end