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

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)makeVehicleActive:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:self.selectedCar.uuid forKey:@"activeCar"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.activeVehicleLabel.text = @"Yes";
}

- (IBAction)takeOrChoosePhoto:(id)sender {
}

- (IBAction)saveChanges:(id)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.selectedCar.name = self.carNameTextField.text;
    self.selectedCar.make = self.carMakeTextField.text;
    self.selectedCar.VIN = self.carVINTextField.text;
    self.selectedCar.currentMileage = [[NSString stringWithFormat:@"%@",self.carMileageTextField.text]integerValue];
    self.selectedCar.driverID = self.fuelCardPINTextField.text;
    self.selectedCar.oilChangeMiles = [[NSString stringWithFormat:@"%@", self.carOilChangeMileageTextField.text] integerValue];
    [realm commitWriteTransaction];
    
}
@end
