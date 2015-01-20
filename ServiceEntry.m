//
//  ServiceEntry.m
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import "ServiceEntry.h"

@implementation ServiceEntry

+ (NSDictionary *)defaultPropertyValues {
    NSDictionary *defaultValues = @{
                                    @"date"  : [NSDate date],
                                    @"price"            : @0.0,
                                    @"serviceLocation"  : @"",
                                    @"notes" : @"",
                                    };
    return defaultValues;
}
@end
