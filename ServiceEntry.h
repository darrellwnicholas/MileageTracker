//
//  ServiceEntry.h
//  
//
//  Created by Darrell Nicholas on 1/1/15.
//
//

#import <Realm/Realm.h>

@interface ServiceEntry : RLMObject
@property NSDate *date;
@property float mileage;
@property NSString *notes;
@property NSData *serviceReceiptPhotoData;
@end
