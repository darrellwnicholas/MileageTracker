//
//  FilePath.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/5/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "FilePath.h"

@implementation FilePath

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
