//
//  Car.m
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import "Car.h"

@implementation Car
+ (NSDictionary *)defaultPropertyValues {
    NSDictionary *defaultValues = @{
                                    @"uuid"             : [[NSUUID UUID] UUIDString],
                                    @"name"             : @"vehicle name",
                                    @"make"             : @"vehicle make",
                                    @"VIN"              : @"VIN Number",
                                    @"year"             : @2015,
                                    @"currentMileage"   : @1,
                                    @"driverID"         : @"0000",
                                    @"oilChangeMiles"   : @3000,
                                    @"nextOilChange"    : @3001,
                                    @"nonFillUpGallons" : @0.0,
                                    };
    return defaultValues;
}

+ (NSString *)primaryKey {
    return @"uuid";
}
@end
