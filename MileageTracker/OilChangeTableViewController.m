//
//  OilChangeTableViewController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/9/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "OilChangeTableViewController.h"


@interface OilChangeTableViewController ()

@end

static NSString *CellIdentifier = @"oilChangeEntryCell";

@implementation OilChangeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIImage *background = [UIImage imageNamed:@"oilTableBG"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.alpha = 0.2;
    [self.tableView setBackgroundView:imageView];
}

- (NSString *)activeCarID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"activeCar"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)insertNewObject:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Oil Change" message:@"Enter Odomoter, Price, Location" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        Car *activeCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
        
        OilChange *entry = [[OilChange alloc] init];
        UITextField *textField1 = alert.textFields[0];
        UITextField *textField2 = alert.textFields[1];
        UITextField *textField3 = alert.textFields[2];
        entry.mileage = [textField1.text integerValue];
        entry.price = [textField2.text doubleValue];
        entry.serviceLocation = textField3.text;
        //entry.date = [NSDate date]; //this is done with default entry from model
        
        [realm beginWriteTransaction];
        //        [realm addObject:entry];
        activeCar.currentMileage = entry.mileage;
        [activeCar.oilChanges addObject:entry];
        [realm commitWriteTransaction];
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad; //UIKeyboardTypeDefault
        textField.placeholder = @"mileage";
    }];
    //might not put this in..----
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad; //UIKeyboardTypeDefault
        UIImageView *dollar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dollarSign"]];
        [textField.leftView addSubview:dollar];
        textField.leftViewMode = YES;
        textField.placeholder = @"price";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeDefault; //UIKeyboardTypeDefault
        textField.autocapitalizationType = YES;
        UIImageView *dollar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dollarSign"]];
        [textField.leftView addSubview:dollar];
        textField.placeholder = @"Service Facility";
    }];
    //to here ----
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
    return [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]].oilChanges.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *priceLabel = (UILabel*)[cell.contentView viewWithTag:3];
    UILabel *locationLabel = (UILabel*)[cell.contentView viewWithTag:4];

    
    // Configure the cell...
    Car *activeCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
    
    RLMResults *myEntries = [activeCar.oilChanges sortedResultsUsingProperty:@"date" ascending:NO];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        OilChange *entry = [myEntries objectAtIndex:indexPath.row];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.doesRelativeDateFormatting = YES;
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li miles", entry.mileage];
        cell.detailTextLabel.text = [formatter stringFromDate:entry.date];
        priceLabel.text = [NSString stringWithFormat:@"$%.02f", entry.price];
        locationLabel.text = entry.serviceLocation;
    } else {
        OilChange *entry = [myEntries objectAtIndex:indexPath.row];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.doesRelativeDateFormatting = YES;
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li miles", entry.mileage];
        cell.detailTextLabel.text = [formatter stringFromDate:entry.date];
        priceLabel.text = [NSString stringWithFormat:@"$%.02f", entry.price];
        locationLabel.text = entry.serviceLocation;
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Car *aCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
        RLMResults *myEntries = [aCar.oilChanges sortedResultsUsingProperty:@"date" ascending:NO];
        RLMRealm *realm = [RLMRealm defaultRealm];
        FuelEntry *objToDelete = [myEntries objectAtIndex:indexPath.row];
        [realm beginWriteTransaction];
        [realm deleteObject:objToDelete];
        [realm commitWriteTransaction];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        RLMResults *newResults = [aCar.oilChanges sortedResultsUsingProperty:@"date" ascending:NO];
//        FuelEntry *newestEntry = [newResults objectAtIndex:0];
//        [realm beginWriteTransaction];
//        aCar.currentMileage = [newestEntry mileage];
//        [realm commitWriteTransaction];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
