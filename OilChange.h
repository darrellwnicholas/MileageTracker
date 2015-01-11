//
//  OilChange.h
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import <Realm/Realm.h>
#import "PhotoObject.h"

@interface OilChange : RLMObject

@property NSDate *date;
@property NSInteger mileage;
@property RLMArray<PhotoObject> *receipts;

@end

