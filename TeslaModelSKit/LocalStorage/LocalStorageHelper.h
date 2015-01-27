//
// Created by Oleksandr Malyarenko on 11/28/14.
// Copyright (c) 2014 Eleks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SummaryModel.h"


@interface LocalStorageHelper : NSObject


+ (void)saveSummaryModel:(SummaryModel *)summaryModel;
+ (SummaryModel *)loadSummaryModel;

@end