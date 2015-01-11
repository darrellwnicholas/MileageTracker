//
//  FuelEntry.h
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import <Realm/Realm.h>
#import "PhotoObject.h"

@interface FuelEntry : RLMObject

@property NSDate *date;
@property NSInteger mileage;
@property double price;
@property double gallons;
@property BOOL fillUp;
@property RLMArray<PhotoObject> *receipts;

+ (NSDictionary *)defaultPropertyValues;

@end
