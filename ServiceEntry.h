//
//  ServiceEntry.h
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import <Realm/Realm.h>
#import "PhotoObject.h"

@interface ServiceEntry : RLMObject

@property NSDate *date;
@property NSInteger mileage;
@property NSString *notes;
@property RLMArray<PhotoObject> *receipts;

+ (NSDictionary *)defaultPropertyValues;

@end
