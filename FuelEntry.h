//
//  FuelEntry.h
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import <Realm/Realm.h>



@interface FuelEntry : RLMObject
@property NSDate *date;
@property float mileage;
@property double price;
@property double gallons;
@property BOOL fillUp;
@property NSData *fuelReceiptPhotoData;

@end
