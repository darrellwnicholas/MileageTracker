//
//  Car.h
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import <Realm/Realm.h>

#import "OilChange.h"
#import "FuelEntry.h"
#import "ServiceEntry.h"
#import "MonthlyMilesEntry.h"
#import "PhotoObject.h"

RLM_ARRAY_TYPE(OilChange)
RLM_ARRAY_TYPE(FuelEntry)
RLM_ARRAY_TYPE(MonthlyMilesEntry)
RLM_ARRAY_TYPE(ServiceEntry)


@interface Car : RLMObject
@property NSString *uuid;
@property NSString *name;
@property NSString *make;
@property NSString *VIN;
@property NSInteger year;
//@property BOOL activeCar;
@property NSInteger currentMileage;
@property NSString *driverID;
@property NSInteger oilChangeMiles;
@property NSInteger nextOilChange;

@property RLMArray<PhotoObject> *carPhoto;
@property RLMArray<OilChange> *oilChanges;
@property RLMArray<FuelEntry> *fuelEntries;
@property RLMArray<ServiceEntry> *serviceEntries;
@property RLMArray<MonthlyMilesEntry> *monthlyMilesEntries;

+ (NSDictionary *)defaultPropertyValues;
+ (NSString *)primaryKey;

@end
