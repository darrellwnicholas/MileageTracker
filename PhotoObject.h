//
//  PhotoObject.h
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/9/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import <Realm/Realm.h>


@interface PhotoObject : RLMObject

@property NSString *imageName;

+ (NSDictionary *)defaultPropertyValues;

@end
RLM_ARRAY_TYPE(PhotoObject)
