//
//  ServiceTableViewController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/9/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "ServiceTableViewController.h"

@interface ServiceTableViewController ()

@end
static NSString *cellIdentifier = @"serviceEntryCell";
@implementation ServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIImage *background = [UIImage imageNamed:@"serviceTableBG"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.alpha = 0.2;
    [self.tableView setBackgroundView:imageView];
}

- (NSString *)activeCarID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"activeCar"];
}
- (IBAction)insertNewObject:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Service Entry" message:@"Enter Odomoter, Price, Location" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        Car *activeCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
        
        ServiceEntry *entry = [[ServiceEntry alloc] init];
        UITextField *textField1 = alert.textFields[0];
        UITextField *textField2 = alert.textFields[1];
        UITextField *textField3 = alert.textFields[2];
        entry.mileage = [textField1.text integerValue];
        entry.price = [textField2.text doubleValue];
        entry.serviceLocation = textField3.text;

        
        [realm beginWriteTransaction];

        [[NSUserDefaults standardUserDefaults] setInteger:activeCar.currentMileage forKey:@"LastKnownMileage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        activeCar.currentMileage = entry.mileage;
        [activeCar.serviceEntries addObject:entry];
        [realm commitWriteTransaction];
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad; //UIKeyboardTypeDefault
        textField.placeholder = @"Enter Odometer";
    }];
    //might not put this in..----
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad; //UIKeyboardTypeDefault
        textField.leftViewMode = YES;
        textField.placeholder = @"Price (ex. 12.34)";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeDefault; //UIKeyboardTypeDefault
        textField.autocapitalizationType = YES;
        textField.placeholder = @"Service Facility";
    }];
    //to here ----
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]].serviceEntries.count;
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
    NSString *debbersString = [NSString stringWithFormat:@"%@ Service Entries", [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]].name];
    tempLabel.text = debbersString; // variable named after my wife
    tempLabel.textColor = [UIColor redColor];
    
    
    //Avenir Next Regular 16.0
    [tempView addSubview:tempLabel];
    
    return tempView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UILabel *priceLabel = (UILabel*)[cell.contentView viewWithTag:3];
    UILabel *locationLabel = (UILabel*)[cell.contentView viewWithTag:4];

    // Configure the cell...
    Car *activeCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
    RLMResults *myEntries = [activeCar.serviceEntries sortedResultsUsingProperty:@"date" ascending:NO];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        ServiceEntry *entry = [myEntries objectAtIndex:indexPath.row];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.doesRelativeDateFormatting = YES;
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li miles", (long)entry.mileage];
        cell.detailTextLabel.text = [formatter stringFromDate:entry.date];
        priceLabel.text = [NSString stringWithFormat:@"$%.02f", entry.price];
        locationLabel.text = entry.serviceLocation;
    } else {
        ServiceEntry *entry = [myEntries objectAtIndex:indexPath.row];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.doesRelativeDateFormatting = YES;
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li miles", (long)entry.mileage];
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
        RLMResults *myEntries = [aCar.serviceEntries sortedResultsUsingProperty:@"date" ascending:NO];
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
