//
//  MonthlyMilesEntry.m
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import "MonthlyMilesEntry.h"

@implementation MonthlyMilesEntry

+ (NSDictionary *)defaultPropertyValues {
    NSDictionary *defaultValues = @{
                                    @"date"  : [NSDate date],
                                    @"month"            : @"",
                                    @"beginningMileage" : @0,
                                    @"endingMileage"    : @0,
                                    @"personalMiles"    : @0,
                                    @"businessMiles"    : @0,
                                    @"totalMiles"       : @0,
                                    };
    return defaultValues;
}


@end
