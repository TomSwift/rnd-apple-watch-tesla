//
// Created by Oleksandr Malyarenko on 11/25/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import "WebServiceLayer.h"


// Define HTTP response codes
typedef NS_ENUM(NSInteger, HTTPStatus) {
    HTTPStatusOK = 200,
    HTTPStatusBadRequest = 400,
    HTTPStatusNotFound = 404,
    HTTPStatusRequestTimeout = 408,
    HTTPStatusInternalServerError = 500,
    HTTPStatusNotImplemented = 501,
    HTTPStatusBadGateway = 502,
    HTTPStatusServiceUnavailable = 503,
    HTTPStatusGatewayTimeout = 504,
    HTTPStatusOtherError = 999
};

// Define custom error domain and errors localized strings
NSString *const kTMWebServiceErrorDomain = @"TMWebServiceErrorDomain";
NSString *const kTMWebServiceErrorBadRequest = @"Bad Request";
NSString *const kTMWebServiceErrorNotFound = @"Not Found";
NSString *const kTMWebServiceErrorRequestTimeout = @"Request Timeout";
NSString *const kTMWebServiceErrorInternalServerError = @"Internal Server Error";
NSString *const kTMWebServiceErrorNotImplemented = @"Not Implemented";
NSString *const kTMWebServiceErrorBadGateway = @"Bad Gateway";
NSString *const kTMWebServiceErrorServiceUnavailable = @"Service Unavailable";
NSString *const kTMWebServiceErrorGatewayTimeout = @"Gateway Timeout";
NSString *const kTMWebServiceErrorOtherError = @"Other Error";

static WebServiceLayer *sharedInstance = nil;


@interface WebServiceLayer ()


@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSDictionary *serviceURLs;
@property (nonatomic, strong) NSDictionary *commandURLs;
@property (nonatomic, strong) NSString *carID;

@end


@implementation WebServiceLayer {

}


#pragma mark Singleton Methods


+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        NSString *commandResourcePath = [[NSBundle mainBundle] pathForResource:@"Commands" ofType:@"plist"];
        self.commandURLs = [NSDictionary dictionaryWithContentsOfFile:commandResourcePath];
        NSString *serviceResourcePath = [[NSBundle mainBundle] pathForResource:@"Services" ofType:@"plist"];
        self.serviceURLs = [NSDictionary dictionaryWithContentsOfFile:serviceResourcePath];
//        TODO: for real service needs to get car ID from service after login
        self.carID = @"123456";
    }
    return self;
}


- (void)dealloc {
// Should never be called, but just here for clarity really.
}


#pragma mark Session configuration


- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.allowsCellularAccess = YES;
        sessionConfiguration.networkServiceType = NSURLNetworkServiceTypeBackground;
        sessionConfiguration.timeoutIntervalForRequest = 60.0;
        sessionConfiguration.timeoutIntervalForResource = 60.0;
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;

        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }

    return _session;
}


#pragma mark Web-service methods


- (void)getCombinedVehicleState:(void (^)(NSDictionary *states, NSError *error))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __block NSMutableDictionary *retrievedStates = [[NSMutableDictionary alloc] init];
        __block NSError *globalError = nil;
        dispatch_group_t downloadGroup = dispatch_group_create();
        dispatch_group_enter(downloadGroup);
        [self getGUISettingsWithCompletionHandler:^(VehicleGUISettingsModel *model, NSError *error) {
            if (!error) {
                retrievedStates[VehicleGUI] = model;
            }
            else {
                globalError = error;
            }
            dispatch_group_leave(downloadGroup);
        }];
        dispatch_group_enter(downloadGroup);
        [self getChargeStateWithCompletionHandler:^(VehicleChargeStateModel *model, NSError *error) {
            if (!error) {
                retrievedStates[VehicleCharging] = model;
            }
            else {
                globalError = error;
            }
            dispatch_group_leave(downloadGroup);
        }];
        dispatch_group_enter(downloadGroup);
        [self getClimateStateWithCompletionHandler:^(VehicleClimateStateModel *model, NSError *error) {
            if (!error) {
                retrievedStates[VehicleClimate] = model;
            }
            else {
                globalError = error;
            }
            dispatch_group_leave(downloadGroup);
        }];
        dispatch_group_enter(downloadGroup);
        [self getVehicleStateWithCompletionHandler:^(VehicleStateModel *model, NSError *error) {
            if (!error) {
                retrievedStates[VehicleState] = model;
            }
            else {
                globalError = error;
            }
            dispatch_group_leave(downloadGroup);
        }];
        dispatch_group_enter(downloadGroup);
        [self getVehicleLocationWithCompletionHandler:^(VehicleLocationModel *model, NSError *error) {
            if (!error) {
                retrievedStates[VehicleLocation] = model;
            }
            else {
                globalError = error;
            }
            dispatch_group_leave(downloadGroup);
        }];

        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(retrievedStates, nil);
        });
    });
}


- (void)getGUISettingsWithCompletionHandler:(void (^)(VehicleGUISettingsModel *model, NSError *error))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMGetGUICommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(nil, error);
        }
        VehicleGUISettingsModel *model = [[VehicleGUISettingsModel alloc] initWithData:data];
        if (!model.error) {
            completionHandler(model, nil);
        }
        else {
            completionHandler(nil, model.error);
        }
    }];
    [dataTask resume];
}


- (void)getVehicleStateWithCompletionHandler:(void (^)(VehicleStateModel *model, NSError *error))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMGetVehicleStateCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(nil, error);
        }

        VehicleStateModel *model = [[VehicleStateModel alloc] initWithData:data];
        if (!model.error) {
            completionHandler(model, nil);
        }
        else {
            completionHandler(nil, model.error);
        }
    }];
    [dataTask resume];
}


- (void)getClimateStateWithCompletionHandler:(void (^)(VehicleClimateStateModel *model, NSError *error))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMGetClimateCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(nil, error);
        }
        VehicleClimateStateModel *model = [[VehicleClimateStateModel alloc] initWithData:data];
        if (!model.error) {
            completionHandler(model, nil);
        }
        else {
            completionHandler(nil, model.error);
        }
    }];
    [dataTask resume];
}


- (void)getChargeStateWithCompletionHandler:(void (^)(VehicleChargeStateModel *model, NSError *error))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMGetChargingCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(nil, error);
        }
        VehicleChargeStateModel *model = [[VehicleChargeStateModel alloc] initWithData:data];
        if (!model.error) {
            completionHandler(model, nil);
        }
        else {
            completionHandler(nil, model.error);
        }
    }];
    [dataTask resume];
}


- (void)getVehicleLocationWithCompletionHandler:(void (^)(VehicleLocationModel *model, NSError *error))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMGetLocationCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(nil, error);
        }
        VehicleLocationModel *model = [[VehicleLocationModel alloc] initWithData:data];
        if (!model.error) {
            completionHandler(model, nil);
        }
        else {
            completionHandler(nil, model.error);
        }
    }];
    [dataTask resume];
}


- (void)openChargingPortWithCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMOpenChargingPortCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)setChargeLimit:(float)limit withCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMSetChargingLimitCommand"];
    NSDictionary *parameters = @{@"percent" : @(limit)};
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:parameters];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)startChargingWithCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMStartChargingCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)stopChargingWithCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMStopChargingCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)flashLightsOnceWithCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMFlashlightsCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)honkHornOnceWithCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMHonkHornCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)lockDoorWithCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMLockVehicleCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)unlockDoorWithCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMUnlockVehicleCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)setTemperatureForDriver:(float)driverTemperature forPassenger:(float)passengerTemperature withCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMSetTemperatureCommand"];
    NSDictionary *parameters = @{@"driver_temp" : @(driverTemperature), @"passenger_temp" : @(passengerTemperature)};
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:parameters];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)startAutoConditioningWithCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMStartAutoconditioningCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)stopAutoConditioningWithCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMStopAutoconditioningCommand"];
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:nil];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


- (void)setSunRoofState:(VehicleRoofState)state withCompletionHandler:(void (^)(BOOL status))completionHandler {
    NSString *urlString = [self URLStringBuilder:@"TMSetSunRoofStateCommand"];
    NSDictionary *parameters = @{@"state" : [VehicleStateModel roofStateValueForName:state]};
    NSURLRequest *request = [self createRequestWithURL:urlString requestMethod:@"GET" requestBody:nil parameters:parameters];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL status = [self checkServiceResponse:(NSHTTPURLResponse *) response andError:&error];
        if (!status) {
            NSLog(@"%@: %@", error.domain, error.localizedDescription);
            completionHandler(NO);
        }
        CommandResponseModel *model = [[CommandResponseModel alloc] initWithData:data];
        if (!model.error /*TODO: for real server needs uncomment next code */ /*&& model.commandResult*/) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    }];
    [dataTask resume];
}


#pragma mark Web-service helper methods


- (BOOL)checkServiceResponse:(NSHTTPURLResponse *)response andError:(NSError **)error {
    BOOL result = NO;

    switch (response.statusCode) {
        case HTTPStatusOK: {
            result = YES;
            break;
        }
        case HTTPStatusBadGateway: {
            if (!*error) {
                *error = [NSError errorWithDomain:kTMWebServiceErrorDomain code:HTTPStatusBadGateway userInfo:@{NSLocalizedDescriptionKey : kTMWebServiceErrorBadGateway}];
            }
            break;
        }
        case HTTPStatusBadRequest: {
            if (!*error) {
                *error = [NSError errorWithDomain:kTMWebServiceErrorDomain code:HTTPStatusBadRequest userInfo:@{NSLocalizedDescriptionKey : kTMWebServiceErrorBadRequest}];
            }
            break;
        }
        case HTTPStatusGatewayTimeout: {
            if (!*error) {
                *error = [NSError errorWithDomain:kTMWebServiceErrorDomain code:HTTPStatusGatewayTimeout userInfo:@{NSLocalizedDescriptionKey : kTMWebServiceErrorGatewayTimeout}];
            }
            break;
        }
        case HTTPStatusInternalServerError: {
            if (!*error) {
                *error = [NSError errorWithDomain:kTMWebServiceErrorDomain code:HTTPStatusInternalServerError userInfo:@{NSLocalizedDescriptionKey : kTMWebServiceErrorInternalServerError}];
            }
            break;
        }
        case HTTPStatusNotFound: {
            if (!*error) {
                *error = [NSError errorWithDomain:kTMWebServiceErrorDomain code:HTTPStatusNotFound userInfo:@{NSLocalizedDescriptionKey : kTMWebServiceErrorNotFound}];
            }
            break;
        }
        case HTTPStatusNotImplemented: {
            if (!*error) {
                *error = [NSError errorWithDomain:kTMWebServiceErrorDomain code:HTTPStatusNotImplemented userInfo:@{NSLocalizedDescriptionKey : kTMWebServiceErrorNotImplemented}];
            }
            break;
        }
        case HTTPStatusRequestTimeout: {
            if (!*error) {
                *error = [NSError errorWithDomain:kTMWebServiceErrorDomain code:HTTPStatusRequestTimeout userInfo:@{NSLocalizedDescriptionKey : kTMWebServiceErrorRequestTimeout}];
            }
            break;
        }
        case HTTPStatusServiceUnavailable: {
            if (!*error) {
                *error = [NSError errorWithDomain:kTMWebServiceErrorDomain code:HTTPStatusServiceUnavailable userInfo:@{NSLocalizedDescriptionKey : kTMWebServiceErrorServiceUnavailable}];
            }
            break;
        }
        default: {
            if (!*error) {
                *error = [NSError errorWithDomain:kTMWebServiceErrorDomain code:HTTPStatusOtherError userInfo:@{NSLocalizedDescriptionKey : kTMWebServiceErrorOtherError}];
            }
            break;
        }
    }

    return result;

}


- (NSURLRequest *)createRequestWithURL:(NSString *)url requestMethod:(NSString *)requestMethod requestBody:(NSData *)requestBody parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    NSMutableString *URLString = [[NSMutableString alloc] initWithString:url];
    NSArray *keys = parameters.allKeys;
    if ([keys count] > 0) {
        [URLString appendString:@"?"];
    }
    for (NSString *key in keys) {
        [URLString appendFormat:@"%@=%@", key, parameters[key]];
        if ([keys indexOfObject:key] < ([keys count] - 1)) {
            [URLString appendFormat:@"&"];
        }
    }

    NSURL *requestURL = [[NSURL alloc] initWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [request setURL:requestURL];
    [request setHTTPMethod:requestMethod];
    if (requestBody) {
        [request setHTTPBody:requestBody];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [requestBody length]] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    }

    return request;
}


- (NSString *)URLStringBuilder:(NSString *)method {
//    TODO: for real service needs to use TMRealServerURL
    NSString *serviceURL = self.serviceURLs[@"TMMockServerURL"];
    NSString *commandURL = self.commandURLs[method];
    NSString *result = [NSString stringWithFormat:@"%@/vehicles/%@/%@", serviceURL, self.carID, commandURL];

    return result;
}

@end