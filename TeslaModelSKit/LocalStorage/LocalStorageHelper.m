//
// Created by Oleksandr Malyarenko on 11/28/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import "LocalStorageHelper.h"


static NSString *const SummaryModelKey = @"summaryModel";


@implementation LocalStorageHelper {

}


+ (void)saveSummaryModel:(SummaryModel *)summaryModel {
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:summaryModel];
    NSUserDefaults *defaults = [LocalStorageHelper getSharedDefaults];
    [defaults setObject:archivedData forKey:SummaryModelKey];
    [defaults synchronize];
}


+ (SummaryModel *)loadSummaryModel {
    NSUserDefaults *defaults = [LocalStorageHelper getSharedDefaults];
    NSData *archivedData = [defaults dataForKey:SummaryModelKey];
    SummaryModel *summaryModel = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];

    return summaryModel;
}

+ (NSUserDefaults *)getSharedDefaults {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.eleks.TeslaModelS"];
    return sharedDefaults;
}

@end