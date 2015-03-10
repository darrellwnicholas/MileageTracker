//
//  CarTableViewController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/9/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "CarTableViewController.h"
#import "CarDetailTVController.h"
#import "PNChart.h"
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
//    UITableView *tableView = (id)[self.view viewWithTag:17];
//    [tableView registerClass:[CustomCarTableViewCell class] forCellReuseIdentifier:CellIdentifier];
//    
    //[self.tableView registerClass:[CustomCarTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    UIImage *background = [UIImage imageNamed:@"carTableBG"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.alpha = 0.2;
    [self.tableView setBackgroundView:imageView];
    
    RLMResults *myCars = [Car allObjects];
    

    
    
    
    _cars = myCars;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.view setNeedsDisplay];

    
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
    NSString *debbersString = @"Vehicle List";
    tempLabel.text = debbersString; // variable named after my wife
    tempLabel.textColor = [UIColor redColor];
    
    
    //Avenir Next Regular 16.0
    [tempView addSubview:tempLabel];
    
    return tempView;
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create New Vehicle" message:@"Enter Vehicle Name & Odometer" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        Car *car = [[Car alloc] init];
        UITextField *textField = alert.textFields[0];
        UITextField *odometerField = alert.textFields[1];
        car.name = textField.text;
        car.currentMileage = [[NSString stringWithFormat:@"%@",odometerField.text]integerValue];
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
        textField.placeholder = @"Enter a vehicle name";
        textField.autocapitalizationType = YES;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"Enter current odomoter";
    }];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)activeCarID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"activeCar"];
}



- (NSUInteger)getCurrentOilLifeForCar:(Car *)car {
    if (car.currentMileage >= car.nextOilChange) {
        return 0;
    } else {
        float cMiles = car.currentMileage;
        float nOilChange = car.nextOilChange;
        float difference = nOilChange - cMiles;
        float mpchange = car.oilChangeMiles;
        float percent = (difference / mpchange) * 100;
        NSUInteger theNumber = [[NSNumber numberWithFloat:percent] integerValue];
        return theNumber;
          
    }
    /*  at this point you have how many miles are left before your next oil change. 1000 miles between changes. you have drove 300. You would have 700.
        at this point you can return milesleftOnOilChange / milesBetweenChanges * 100. You multiply by 100 because you would get 700 / 1000 = .7 so multiply by 100 and return that as
        an NSNumber with the value of 70 which would represent 70% oil life left.
     */
//    
//    NSNumber *milesLeftUntilOilChange;
//    [NSDecimalSubtract((__bridge NSDecimal *)(milesLeftUntilOilChange), car.nextOilChange, car.currentMileage, NSRoundPlain)];
//    NSNumber *percentOilLife = milesLeftUntilOilChange / milesBetweenChanges;
//    
//    return percentOilLife;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *activeCarLabel = (UILabel*)[cell.contentView viewWithTag:4];
    UILabel *mpgLabel = (UILabel*)[cell.contentView viewWithTag:5];
    UIView *oilLifeView = (UIView*)[cell.contentView viewWithTag:40];
    UILabel *carNameLabel = (UILabel*)[cell.contentView viewWithTag:20];
    UILabel *odometerLabel = (UILabel*)[cell.contentView viewWithTag:30];
    UIImageView *carImageView = (UIImageView*)[cell.contentView viewWithTag:10];
    UIVisualEffectView *blurView = (UIVisualEffectView*)[cell.contentView viewWithTag:99];
    [cell.contentView addSubview:carImageView];
    [cell.contentView addSubview:blurView];
    
    // For Circle Chart of Oil Life
    
    
    /*
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 80.0, SCREEN_WIDTH, 100.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:60] clockwise:NO shadow:NO];
    circleChart.backgroundColor = [UIColor clearColor];
    [circleChart setStrokeColor:PNGreen];
    [circleChart strokeChart];
     
     - (id)initWithFrame:(CGRect)frame
     total:(NSNumber *)total
     current:(NSNumber *)current
     clockwise:(BOOL)clockwise
     shadow:(BOOL)hasBackgroundShadow
     shadowColor:(UIColor *)backgroundShadowColor
     displayCountingLabel:(BOOL)displayCountingLabel;
     */
//    UILabel *carTextLabel = (UILabel*)[cell.contentView viewWithTag:2];
//    UILabel *carDetailTextLabel = (UILabel*)[cell.contentView viewWithTag:3];
//    UIImageView *thumbnailImageView = (UIImageView*)[cell.contentView viewWithTag:1];
//    [cell addSubview:activeCarLabel];
//    [cell addSubview:mpgLabel];
//    [cell addSubview:odometerLabel];
//    [cell addSubview:carNameLabel];
    //cell.imageView.image = thumbnailImageView.image;
    RLMResults *myCars = [Car allObjects];
    self.cars = myCars;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        activeCarLabel.hidden = YES;
        Car *car = [self.cars objectAtIndex:indexPath.row]; // get the car for this row
        PhotoObject *img = [car.carPhoto lastObject];      // get the image for the car
        carImageView.image = [UIImage imageWithContentsOfFile:img.imageName];
        // oil life chart
        PNCircleChart *oilLifeChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, oilLifeView.bounds.size.height, oilLifeView.bounds.size.height - 4) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt: [self getCurrentOilLifeForCar:car]] clockwise:YES shadow:NO shadowColor:nil displayCountingLabel:YES]; // TODO: Change current to calculation on oil life
        oilLifeChart.backgroundColor = [UIColor clearColor];
        [oilLifeChart setStrokeColor:PNGreen];
        [oilLifeChart strokeChart];
        [oilLifeChart setChartType:PNChartFormatTypePercent];
        oilLifeChart.center = CGPointMake(oilLifeView.bounds.size.width/2, oilLifeView.bounds.size.height/2);
        oilLifeView.backgroundColor = [UIColor clearColor];
        [oilLifeView addSubview:oilLifeChart];
        
        // Car Name Label
        carNameLabel.text = car.name;
        
        // Get the current mileage, and set the odometer label
        NSString *miles = [NSString stringWithFormat:@"%@", @(car.currentMileage)];
        odometerLabel.text = miles;
        
        // TODO: add a property to the Car class for "mpg"
        // For the time being, we will set this at a constant value, just for testing
        mpgLabel.text = @"mpg: 22.52";
        
        // if this is the active car, make the label visible
        if ([car.uuid isEqualToString:[self activeCarID]]) {
            activeCarLabel.hidden = NO;
        }

    } else {
        activeCarLabel.hidden = YES;
        Car *car = [self.cars objectAtIndex:indexPath.row]; // get the car for this row
        PhotoObject *img = [car.carPhoto lastObject];      // get the image for the car
        carImageView.image = [UIImage imageWithContentsOfFile:img.imageName];
        // oil life chart
        PNCircleChart *oilLifeChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, oilLifeView.bounds.size.height, oilLifeView.bounds.size.height - 4) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt: [self getCurrentOilLifeForCar:car]] clockwise:YES shadow:NO shadowColor:nil displayCountingLabel:YES];// TODO: Change current to calculation on oil life
        oilLifeChart.backgroundColor = [UIColor clearColor];
        [oilLifeChart setStrokeColor:PNGreen];
        [oilLifeChart strokeChart];
        [oilLifeChart setChartType:PNChartFormatTypePercent];
        oilLifeChart.center = CGPointMake(oilLifeView.bounds.size.width/2, oilLifeView.bounds.size.height/2);
        oilLifeView.backgroundColor = [UIColor clearColor];
        [oilLifeView addSubview:oilLifeChart];
        
        // Car Name Label
        carNameLabel.text = car.name;
        
        // Get the current mileage, and set the odometer label
        NSString *miles = [NSString stringWithFormat:@"%@", @(car.currentMileage)];
        odometerLabel.text = miles;
        
        // TODO: add a property to the Car class for "mpg"
        // For the time being, we will set this at a constant value, just for testing
        mpgLabel.text = @"mpg: 22.52";
        
        // if this is the active car, make the label visible
        if ([car.uuid isEqualToString:[self activeCarID]]) {
            activeCarLabel.hidden = NO;
        }
        
    }
    
    
    
    return cell;

}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    RLMResults *results = [Car allObjects];
    if ([[results objectAtIndex:indexPath.row] isEqualToObject:[Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]]]) {
        return NO;
    } else {
        return YES;
    }
    
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    UITableViewController *toViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"carDetailID"];
////    UIStoryboardSegue *segue = [[UIStoryboardSegue segueWithIdentifier:@"showCarDetail" source:self destination:toViewController performHandler:nil]];
//    
//    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"showCarDetail" source:self destination:toViewController];
//
//    [self.navigationController prepareForSegue:segue sender:self];
//    //[segue perform];
//}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        
            RLMResults *results = [Car allObjects];
            Car *objToDelete = [results objectAtIndex:indexPath.row];
            RLMRealm *realm = [RLMRealm defaultRealm];
            if (objToDelete.uuid != [[NSUserDefaults standardUserDefaults] valueForKey:@"activeCar"]) {
                [realm beginWriteTransaction];
                [realm deleteObject:objToDelete];
                [realm commitWriteTransaction];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't Delete" message:@"You cannot delete the active Vehicle" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel) {
                    }];

                [alert addAction:dismissAction];

                [self presentViewController:alert animated:YES completion:nil];
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

        
        
        
        
        ctvc.currentActiveCar = [Car objectInRealm:[RLMRealm defaultRealm] forPrimaryKey:[self activeCarID]];
        

        
        Car *selectedCar = [self.cars objectAtIndex:path.row];
        ctvc.selectedCar = selectedCar;
        

    }
    
}


@end
