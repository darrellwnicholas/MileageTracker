//
//  MonthlyMilesEntry.h
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//
#import <Realm/Realm.h>


@interface MonthlyMilesEntry : RLMObject
@property NSDate *date;
@property NSString *month;
@property double beginningMileage;

// ------TODO------ //
// set properties for business and personal use and calculate based on last month's mileage. Look up Realm docs
// to see if you can make a method to do this...

// decide whether or not to keep starting miles and ending miles
@end
