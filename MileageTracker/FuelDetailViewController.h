//
//  FuelDetailCollectionViewController.h
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/14/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"

@interface FuelDetailViewController : UIViewController
@property (strong, nonatomic) Car *activeCar;
@property FuelEntry *selectedEntry;

@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *pricePerGallonTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberGallonsPumpedTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isFillUpSwitch;

- (IBAction)toggleFuelEntryFillUp:(UISwitch *)sender;
@end
