//
//  CarDetailTVController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/11/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "CarDetailTVController.h"
#import "CarTableViewController.h"

@interface CarDetailTVController ()
@property (nonatomic, assign) id currentResponder;
@end

@implementation CarDetailTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // UITextFieldDelegate assignments
    _carNameTextField.delegate = self;
    _carMakeTextField.delegate = self;
    _carVINTextField.delegate = self;
    _carYearTextField.delegate = self;
    _carMileageTextField.delegate = self;
    _fuelCardPINTextField.delegate = self;
    _carOilChangeMileageTextField.delegate = self;
    
    // Textfield value assignments
    _carNameTextField.text  = _selectedCar.name;
    _carMakeTextField.text  = _selectedCar.make;
    _carVINTextField.text   = _selectedCar.VIN;
    NSString *yearString = [NSString stringWithFormat:@"%li", (long)_selectedCar.year];
    _carYearTextField.text  = yearString;
    if ([self.selectedCar.uuid isEqualToString:[self activeCarID]]) {
        _activeVehicleLabel.text = @"Yes";
    } else {
        _activeVehicleLabel.text = @"No";
    }
    NSString *milesString = [NSString stringWithFormat:@"%li", (long)_selectedCar.currentMileage];
    _carMileageTextField.text = milesString;
    _fuelCardPINTextField.text = _selectedCar.driverID;
    NSString *oilChangeMiles = [NSString stringWithFormat:@"%li", (long)_selectedCar.oilChangeMiles];
    _carOilChangeMileageTextField.text = oilChangeMiles;
    PhotoObject *obj = [self.selectedCar.carPhoto firstObject];
    
    _carPhotoImageView.image = [UIImage imageNamed:obj.imageName];
    
    NSLog(@"self.selectedCar.name = %@", self.selectedCar.name);
    NSLog(@"self.activeCar.name = %@", self.currentActiveCar.name);

}

- (void)dealloc {
    // unset the delegates because the textField delegate uses assign, not necessary if it uses weak reference
    // this is how it is defined in the header: @property(nonatomic, assign) id<UITextFieldDelegate> delegate
    _carNameTextField.delegate = nil;
    _carMakeTextField.delegate = nil;
    _carVINTextField.delegate = nil;
    _carYearTextField.delegate = nil;
    _carMileageTextField.delegate = nil;
    _fuelCardPINTextField.delegate = nil;
    _carOilChangeMileageTextField.delegate = nil;
}
- (NSString *)activeCarID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"activeCar"];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeVehicleActive:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:self.selectedCar.uuid forKey:@"activeCar"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.selectedCar.currentMileage forKey:@"LastKnownMileage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.activeVehicleLabel.text = @"Yes";
}

- (IBAction)takeOrChoosePhoto:(id)sender {
}

- (IBAction)saveChanges:(id)sender {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save" message:@"Save all changes?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        self.selectedCar.name = self.carNameTextField.text;
        self.selectedCar.make = self.carMakeTextField.text;
        self.selectedCar.VIN = self.carVINTextField.text;
        self.selectedCar.year = [[NSString stringWithFormat:@"%@", self.carYearTextField.text]integerValue];
        self.selectedCar.currentMileage = [[NSString stringWithFormat:@"%@",self.carMileageTextField.text]integerValue];
        self.selectedCar.driverID = self.fuelCardPINTextField.text;
        self.selectedCar.oilChangeMiles = [[NSString stringWithFormat:@"%@", self.carOilChangeMileageTextField.text] integerValue];
        [realm commitWriteTransaction];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
     
@end
