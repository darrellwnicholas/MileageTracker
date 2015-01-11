//
//  MonthlyMilesEntry.h
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//
#import <Realm/Realm.h>


@interface MonthlyMilesEntry : RLMObject

@property NSString *month;
@property NSDate *date;
@property NSInteger beginningMileage;
@property NSInteger endingMileage;
@property NSInteger personalMiles;
@property NSInteger businessMiles;
@property NSInteger totalMiles;

@end
