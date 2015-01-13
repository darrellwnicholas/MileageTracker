//
//  CarDetailTVController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/11/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "CarDetailTVController.h"

@interface CarDetailTVController ()

@end

@implementation CarDetailTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _carNameTextField.text  = _selectedCar.name;
    _carMakeTextField.text  = _selectedCar.make;
    _carVINTextField.text   = _selectedCar.VIN;
    NSString *yearString = [NSString stringWithFormat:@"%li", _selectedCar.year];
    _carYearTextField.text  = yearString;
    _carActiveVehicleSwitch.on = _selectedCar.activeCar;
    NSString *milesString = [NSString stringWithFormat:@"%li", _selectedCar.currentMileage];
    _carMileageTextField.text = milesString;
    _fuelCardPINTextField.text = _selectedCar.driverID;
    NSString *oilChangeMiles = [NSString stringWithFormat:@"%li", _selectedCar.oilChangeMiles];
    _carOilChangeMileageTextField.text = oilChangeMiles;
    _carPhotoImageView.image = [UIImage imageNamed:@"greenCarFull.png"];
    
    /*@property (weak, nonatomic) IBOutlet UITextField *carNameTextField;
     @property (weak, nonatomic) IBOutlet UITextField *carMakeTextField;
     @property (weak, nonatomic) IBOutlet UITextField *carVINTextField;
     @property (weak, nonatomic) IBOutlet UITextField *carYearTextField;
     @property (weak, nonatomic) IBOutlet UISwitch *carActiveVehicleSwitch;
     @property (weak, nonatomic) IBOutlet UITextField *carMileageTextField;
     @property (weak, nonatomic) IBOutlet UITextField *fuelCardPINTextField;
     @property (weak, nonatomic) IBOutlet UITextField *carOilChangeMileageTextField;
     @property (weak, nonatomic) IBOutlet UIImageView *carPhotoImageView;*/
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

- (IBAction)toggleActiveVehicle:(UISwitch *)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    if (self.selectedCar.activeCar == NO) {
        self.currentActiveCar.activeCar = NO;
        self.selectedCar.activeCar = YES;
    } else {
        self.carActiveVehicleSwitch.enabled = NO;
    }
    [realm commitWriteTransaction];
}

- (IBAction)takeOrChoosePhoto:(id)sender {
}

- (IBAction)saveChanges:(id)sender {
}
@end
