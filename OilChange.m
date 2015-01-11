//
//  OilChange.m
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import "OilChange.h"

@implementation OilChange

+ (NSDictionary *)defaultPropertyValues {
    NSDictionary *defaultValues = @{
                                    @"date"             : [NSDate date],
                                    };
    return defaultValues;
}
@end
