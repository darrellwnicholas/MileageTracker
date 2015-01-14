//
//  FuelTableViewController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/9/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "FuelTableViewController.h"


@interface FuelTableViewController ()

@end

static NSString *CellIdentifier = @"fuelEntryCell";

@implementation FuelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
    CarTableViewController *c = [nav.viewControllers firstObject];
    self.activeCar = c.activeCar;
    NSLog(@"active car name = %@", c.activeCar.name);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)insertNewObject:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Insert Fuel Entry" message:@"Enter Odomoter" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        FuelEntry *entry = [[FuelEntry alloc] init];
        UITextField *textField = alert.textFields[0];
        entry.mileage = [textField.text integerValue];
        entry.date = [NSDate date];
        
        [realm beginWriteTransaction];
//        [realm addObject:entry];
        self.activeCar.currentMileage = entry.mileage;
        [self.activeCar.fuelEntries addObject:entry];
        [realm commitWriteTransaction];
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad; //UIKeyboardTypeDefault
    }];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.activeCar.fuelEntries.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    RLMResults *myEntries = [self.activeCar.fuelEntries sortedResultsUsingProperty:@"date" ascending:NO];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        FuelEntry *entry = [myEntries objectAtIndex:indexPath.row];
       
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.doesRelativeDateFormatting = YES;
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li miles", entry.mileage];
        cell.detailTextLabel.text = [formatter stringFromDate:entry.date];
    } else {
        FuelEntry *entry = [myEntries objectAtIndex:indexPath.row];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.doesRelativeDateFormatting = YES;
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li miles", entry.mileage];
        cell.detailTextLabel.text = [formatter stringFromDate:entry.date];
    }
    
    return cell;
}


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showFuelEntryDetail"]) {
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        FuelDetailViewController *fdvc = [segue destinationViewController];
        RLMResults *myEntries = [self.activeCar.fuelEntries sortedResultsUsingProperty:@"date" ascending:NO];
        fdvc.activeCar = self.activeCar;
        fdvc.selectedEntry = [myEntries objectAtIndex:path.row];
        
        

}
}


@end
