//
//  CarTableViewController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/9/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "CarTableViewController.h"
#import "CarDetailTVController.h"
#import "Car.h"

@interface CarTableViewController ()
@property RLMResults *cars;


@end

@implementation CarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
    RLMResults *myCars = [Car allObjects];
    _cars = myCars;
    RLMResults *activeCarsInRealm = [Car objectsInRealm:[RLMRealm defaultRealm] where:@"activeCar = YES"];
    if (activeCarsInRealm.count == 1) {
        _activeCar = [activeCarsInRealm firstObject];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Active Vehicle";
    } else {
        return @"Vehicle List";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else {
    
        return self.cars.count - 1;
    }
}

- (IBAction)insertNewObject:(id)sender {
    /*
     Car *car = [[Car alloc] init];
     car.name = @"First Vehicle";
     car.activeCar = @YES;
     
     RLMRealm *realm = [RLMRealm defaultRealm];
     [realm beginWriteTransaction];
     [realm addObject:car];
     [realm commitWriteTransaction];
     */
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create New Vehicle" message:@"Enter Vehicle Name" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        Car *car = [[Car alloc] init];
        UITextField *textField = alert.textFields[0];
        car.name = textField.text;
        [realm beginWriteTransaction];
        [realm addObject:car];
        [realm commitWriteTransaction];
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.autocapitalizationType = YES;
    }];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        RLMResults *activeCars = [self.cars objectsWhere:@"activeCar = YES"];
        Car *ac = [activeCars objectAtIndex:indexPath.row];
        NSString *miles = [NSString stringWithFormat:@"%li", (long)ac.currentMileage];
        cell.textLabel.text = ac.name;
        cell.detailTextLabel.text = miles;
        return cell;
    } else {
        RLMResults *nonActiveCars = [self.cars objectsWhere:@"activeCar = NO"];
        Car *car = [nonActiveCars objectAtIndex:indexPath.row];
        NSString *miles = [NSString stringWithFormat:@"%li", (long)car.currentMileage];
        cell.textLabel.text = car.name;
        cell.detailTextLabel.text = miles;
        return cell;
    }
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (indexPath.section != 0) {
            RLMResults *results = [self.cars objectsWhere:@"activeCar = NO"];
            Car *objToDelete = [results objectAtIndex:indexPath.row];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm deleteObject:objToDelete];
            [realm commitWriteTransaction];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    NSIndexPath *path = [self.tableView indexPathForCell:sender];
    CarDetailTVController *ctvc = [segue destinationViewController];
    ctvc.currentActiveCar = self.activeCar;
    if (path.section == 0) {
        Car *selectedCar = [self.cars objectAtIndex:path.row];
        ctvc.selectedCar = selectedCar;
    } else {
        Car *selectedCar = [self.cars objectAtIndex:path.row + 1];
        ctvc.selectedCar = selectedCar;
    }
}


@end
