//
//  FuelTableViewController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/9/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "FuelTableViewController.h"


@interface FuelTableViewController ()
//@property NSInteger tempMileage;
@end

static NSString *CellIdentifier = @"fuelEntryCell";


@implementation FuelTableViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImage *background = [UIImage imageNamed:@"fuelTableBG"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.alpha = 0.2;
    [self.tableView setBackgroundView:imageView];
//    _tempMileage = 0;
    
    
}

- (NSString *)activeCarID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"activeCar"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.title = self.activeCar.name;
//    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)insertNewObject:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Insert Fuel Entry" message:@"Enter Odomoter" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        Car *activeCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
        
        FuelEntry *entry = [[FuelEntry alloc] init];
        UITextField *textField = alert.textFields[0];
        entry.mileage = [textField.text integerValue];
        entry.date = [NSDate date];
        
        [realm beginWriteTransaction];
//        [realm addObject:entry];
        // Do this on every page
        [[NSUserDefaults standardUserDefaults] setInteger:activeCar.currentMileage forKey:@"LastKnownMileage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //--to here--//
        activeCar.currentMileage = entry.mileage;
        [activeCar.fuelEntries addObject:entry];
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
    return [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]].fuelEntries.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //CGRectMake(0,200,300,244)]
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0, 200, 300, 22)];
    tempView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,22)];
    tempLabel.backgroundColor=[UIColor clearColor];
    
    
    //tempLabel.shadowColor = [UIColor blackColor];
    //tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor redColor]; //here you can change the text color of header.
    //tempLabel.font = [UIFont fontWithName:@"Avenir Next" size:18.0];
    NSDictionary *attributes = @{@"NSFontFamilyAttribute": @"Avenir Next",
                                 @"NSFontStyle": @"Light",
                                 };

    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:attributes];
    tempLabel.font = [UIFont fontWithDescriptor:fontDescriptor size:18.0];
    NSString *debbersString = [NSString stringWithFormat:@"%@ Fuel Entries", [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]].name];
    tempLabel.text = debbersString; // variable named after my wife
    tempLabel.textColor = [UIColor redColor];
    
    
    //Avenir Next Regular 16.0
    [tempView addSubview:tempLabel];
    
    return tempView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Car *activeCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
    
    RLMResults *myEntries = [activeCar.fuelEntries sortedResultsUsingProperty:@"date" ascending:NO];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        FuelEntry *entry = [myEntries objectAtIndex:indexPath.row];
       
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.doesRelativeDateFormatting = YES;
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li miles", (long)entry.mileage];
        cell.detailTextLabel.text = [formatter stringFromDate:entry.date];
    } else {
        FuelEntry *entry = [myEntries objectAtIndex:indexPath.row];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.doesRelativeDateFormatting = YES;
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li miles", (long)entry.mileage];
        cell.detailTextLabel.text = [formatter stringFromDate:entry.date];
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
        RLMResults *myEntries = [aCar.fuelEntries sortedResultsUsingProperty:@"date" ascending:NO];
        RLMRealm *realm = [RLMRealm defaultRealm];
        FuelEntry *objToDelete = [myEntries objectAtIndex:indexPath.row];
        [realm beginWriteTransaction];
        if (indexPath.row == 0) {
            aCar.currentMileage = [[NSUserDefaults standardUserDefaults] integerForKey:@"LastKnownMileage"];
        }
        [realm deleteObject:objToDelete];
        [realm commitWriteTransaction];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        RLMResults *newResults = [aCar.fuelEntries sortedResultsUsingProperty:@"date" ascending:NO];
//        if (newResults.count != 0) {
//            [realm beginWriteTransaction];
//            aCar.currentMileage = [[NSUserDefaults standardUserDefaults] integerForKey:@"LastKnownMileage"];
//            [realm commitWriteTransaction];
//        } else {
//            [realm beginWriteTransaction];
//            aCar.currentMileage = [[NSUserDefaults standardUserDefaults] integerForKey:@"LastKnownMileage"];
//            [realm commitWriteTransaction];
//        }
        
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
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showFuelEntryDetail"]) {
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        FuelDetailViewController *fdvc = [segue destinationViewController];
        Car *aCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
        RLMResults *myEntries = [aCar.fuelEntries sortedResultsUsingProperty:@"date" ascending:NO];
        fdvc.activeCar = aCar;
        fdvc.selectedEntry = [myEntries objectAtIndex:path.row];
        
        

}
}


@end
