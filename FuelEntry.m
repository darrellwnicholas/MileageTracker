//
//  FuelEntry.m
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import "FuelEntry.h"

@implementation FuelEntry

+ (NSDictionary *)defaultPropertyValues {
    NSDictionary *defaultValues = @{
                                    @"date"             : [NSDate date],
                                    @"mileage"          : @00000,
                                    @"price"            : @0.0,
                                    @"gallons"          : @0.0,
                                    @"fillUp"           : @NO,
                                    };
    return defaultValues;
}

@end
