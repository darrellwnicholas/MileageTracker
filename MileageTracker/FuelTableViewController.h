//
//  FuelTableViewController.h
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/9/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"
#import "CarTableViewController.h"
#import "FuelDetailViewController.h"

@interface FuelTableViewController : UITableViewController //<UITabBarControllerDelegate>
@property Car *activeCar;
@end
