//
//  CarDetailTVController.h
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/11/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"

@interface CarDetailTVController : UITableViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property Car *selectedCar;
@property Car *currentActiveCar;

@property (weak, nonatomic) IBOutlet UITextField *carNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *carMakeTextField;
@property (weak, nonatomic) IBOutlet UITextField *carVINTextField;
@property (weak, nonatomic) IBOutlet UITextField *carYearTextField;
@property (weak, nonatomic) IBOutlet UILabel *activeVehicleLabel;
@property (weak, nonatomic) IBOutlet UITextField *carMileageTextField;
@property (weak, nonatomic) IBOutlet UITextField *fuelCardPINTextField;
@property (weak, nonatomic) IBOutlet UITextField *carOilChangeMileageTextField;
@property (weak, nonatomic) IBOutlet UIImageView *carPhotoImageView;
@property (weak, nonatomic) IBOutlet UITextField *nextOilChangeTextField;


- (IBAction)makeVehicleActive:(id)sender;

- (IBAction)takeOrChoosePhoto:(id)sender;
- (IBAction)saveChanges:(id)sender;

@end
