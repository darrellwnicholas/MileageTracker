//
//  MonthlyTableViewController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/9/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "MonthlyTableViewController.h"

@interface MonthlyTableViewController ()

@end
static NSString *CellIdentifier = @"monthlyEntryCell";
@implementation MonthlyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIImage *background = [UIImage imageNamed:@"monthlyTableBG"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.alpha = 0.2;
    [self.tableView setBackgroundView:imageView];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.title = self.activeCar.name;
    //    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}

- (NSString *)activeCarID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"activeCar"];
}

- (IBAction)insertNewObject:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Monthly Mileage" message:@"Enter Your Ending Odomoter Reading" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        Car *activeCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
        
        MonthlyMilesEntry *entry = [[MonthlyMilesEntry alloc] init];
        UITextField *textField1 = alert.textFields[0];

        entry.endingMileage = [textField1.text integerValue];

        
        
        [realm beginWriteTransaction];
        
        [[NSUserDefaults standardUserDefaults] setInteger:activeCar.currentMileage forKey:@"LastKnownMileage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        activeCar.currentMileage = entry.endingMileage;
        [activeCar.monthlyMilesEntries addObject:entry];
        [realm commitWriteTransaction];
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad; //UIKeyboardTypeDefault
        textField.placeholder = @"Enter Odometer Reading";
    }];
    //might not put this in..----
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.keyboardType = UIKeyboardTypeDecimalPad; //UIKeyboardTypeDefault
//        textField.leftViewMode = YES;
//        textField.placeholder = @"Price (ex. 12.34)";
//    }];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.keyboardType = UIKeyboardTypeDefault; //UIKeyboardTypeDefault
//        textField.autocapitalizationType = YES;
//        textField.placeholder = @"Service Facility";
//    }];
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
    return [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]].monthlyMilesEntries.count;
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
    NSString *debbersString = [NSString stringWithFormat:@"%@ Monthly Entries", [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]].name];
    tempLabel.text = debbersString; // variable named after my wife
    tempLabel.textColor = [UIColor redColor];
    
    
    //Avenir Next Regular 16.0
    [tempView addSubview:tempLabel];
    
    return tempView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Car *activeCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
    RLMResults *myEntries = [activeCar.monthlyMilesEntries sortedResultsUsingProperty:@"date" ascending:NO];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        MonthlyMilesEntry *entry = [myEntries objectAtIndex:indexPath.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.doesRelativeDateFormatting = YES;
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li miles", (long)entry.endingMileage];
        cell.detailTextLabel.text = [formatter stringFromDate:entry.date];
        //TODO: Add Labels for totalMileage for the month
    } else {
        MonthlyMilesEntry *entry = [myEntries objectAtIndex:indexPath.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.doesRelativeDateFormatting = YES;
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%li miles", (long)entry.endingMileage];
        cell.detailTextLabel.text = [formatter stringFromDate:entry.date];
        //TODO: Add Labels for totalMileage for the month
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
        RLMResults *myEntries = [aCar.monthlyMilesEntries sortedResultsUsingProperty:@"date" ascending:NO];
        RLMRealm *realm = [RLMRealm defaultRealm];
        MonthlyMilesEntry *objToDelete = [myEntries objectAtIndex:indexPath.row];
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

//TODO: Implement a detail screen and the prepare for segue method!

@end
