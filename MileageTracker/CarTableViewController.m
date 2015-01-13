//
//  CarTableViewController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/9/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "CarTableViewController.h"
#import "CarDetailTVController.h"
#import "CustomCarTableViewCell.h"
#import "Car.h"

@interface CarTableViewController ()
@property RLMResults *cars;


@end

@implementation CarTableViewController

static NSString *CellIdentifier = @"customCarCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tabBarController.tabBar setTintColor:[UIColor redColor]];
    self.tableView = (id)[self.view viewWithTag:17];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCarTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
    
    //[self.tableView registerClass:[CustomCarTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    RLMResults *myCars = [Car allObjects];
    _cars = myCars;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setOrderOfCars
//{
//    
//    RLMArray *newList = [self.cars copy];
//    NSInteger activeIndex;
//    for (Car *car in self.cars) {
//        if (car.activeCar == YES) {
//            activeIndex = [self.cars indexOfObject:car];
//        }
//        Car *nCar = [car copy];
//        [newList addObject:nCar];
//    }
//    for (int i=0; i < newList.count - 1; i++) {
//        if (i >= activeIndex) {
//            newList[i] = newList[i-activeIndex];
//            i++;
//        } else {
//            int t = i - @(activeIndex + newList.count).intValue;
//            newList[t] = @(i - activeIndex + newList.count);
//            i++;
//        }
//    }
//    self.cars = newList;
//    
//}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        return @"Vehicle List";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.cars.count;
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
        NSString *nameOfCar = @"theStandardCarPhoto.png";
        PhotoObject *defaultCarPhoto = [[PhotoObject alloc] init];
        defaultCarPhoto.imageName = nameOfCar;
        
        
        [realm beginWriteTransaction];
        [car.carPhoto addObject:defaultCarPhoto];
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
    CustomCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.carActiveCarLabel.hidden = YES;
    Car *car = [self.cars objectAtIndex:indexPath.row];
    PhotoObject *img = [car.carPhoto firstObject];
    NSString *miles = [NSString stringWithFormat:@"Current Miles: %@", @(car.currentMileage)];
    cell.thumbnailImage.image = [UIImage imageNamed:img.imageName]; //carPhoto.firstObject is a string, that represents a path to an image, which is then loaded from the sandbox, not the database and hopefully displayed on the screen.
    cell.carTextLabel.text = car.name;
    cell.carDetailTextLabel.text = miles;
    if (car.activeCar == YES) {
        cell.carActiveCarLabel.hidden = NO;
    }
    return cell;
    //[UIImage imageNamed:@"greenCar"];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        if (indexPath.row > 0) {
            RLMResults *results = [Car allObjects];
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

// segue to CarDetailTableViewController = @"showCarDetail" in case it's needed for anything.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    if ([segue.identifier isEqualToString:@"showCarDetail"]) {
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        CarDetailTVController *ctvc = [segue destinationViewController];
        ctvc.currentActiveCar = self.activeCar;
        
        Car *selectedCar = [self.cars objectAtIndex:path.row];
        ctvc.selectedCar = selectedCar;
        

    }
    
}


@end
