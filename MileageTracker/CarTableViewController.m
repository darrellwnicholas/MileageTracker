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
    
    [self.view setNeedsDisplay];
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



- (NSUInteger)calculateCurrentOilLifeForCar:(Car *)car {
    if (car.currentMileage >= car.nextOilChange) {
        return 0;
    } else {
        float cMiles = car.currentMileage;
        float nOilChange = car.nextOilChange;
        float difference = nOilChange - cMiles;
        float mpchange = car.oilChangeMiles;
        float percent = (difference / mpchange) * 100;
        NSUInteger result = (NSUInteger)percent;
        return result;
          
    }
}

- (float)calculateMPG:(Car*)car {
    RLMResults *fuelResults1 = [car.fuelEntries objectsWhere:@"fillUp = YES"];
    if (fuelResults1.count <= 1) {
        return 0.0;
    } else {
        NSUInteger __block firstEntry = 0;
        NSUInteger __block secondEntry = 0;
        float __block gallonsTotal = 0.0;
        
        RLMResults *fuelResults = [car.fuelEntries sortedResultsUsingProperty:@"date" ascending:NO];
        NSMutableArray *results = [NSMutableArray new];
        for (FuelEntry *entry in fuelResults) {
            [results addObject:entry];
        }
        
        [results enumerateObjectsUsingBlock:^(FuelEntry *obj, NSUInteger idx, BOOL *stop) {
            if (obj.fillUp == YES && firstEntry == 0) {
                firstEntry = obj.mileage;
                gallonsTotal += obj.gallons;
            } else if (obj.fillUp == NO && firstEntry == 0) {
                idx++;
            } else if (obj.fillUp == YES && firstEntry != 0) {
                secondEntry = obj.mileage;
                *stop = YES;
            } else {
                gallonsTotal += obj.gallons;
            }
            
        }];
        
        return (firstEntry - secondEntry) / gallonsTotal;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *activeCarLabel = (UILabel*)[cell.contentView viewWithTag:4];
    UILabel *mpgLabel = (UILabel*)[cell.contentView viewWithTag:50];
    UILabel *oilLifeLabel = (UILabel*)[cell.contentView viewWithTag:40];
    UILabel *carNameLabel = (UILabel*)[cell.contentView viewWithTag:20];
    UILabel *odometerLabel = (UILabel*)[cell.contentView viewWithTag:30];
    UIImageView *carImageView = (UIImageView*)[cell.contentView viewWithTag:10];
    
    [cell.contentView addSubview:carImageView];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    RLMResults *myCars = [Car allObjects];
    self.cars = myCars;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        activeCarLabel.hidden = YES;
        Car *car = [self.cars objectAtIndex:indexPath.row]; // get the car for this row
        PhotoObject *img = [car.carPhoto lastObject];      // get the image for the car
        NSString *photoName = [documentsDirectory stringByAppendingString:img.imageName];
        carImageView.image = [UIImage imageWithContentsOfFile:photoName];
        
        // oil life label
        if ([self calculateCurrentOilLifeForCar:car] <= 10) {
            oilLifeLabel.textColor = [UIColor redColor];
        } else {
            oilLifeLabel.textColor = [UIColor greenColor];
        }
        oilLifeLabel.text = [NSString stringWithFormat:@"%li%%", [self calculateCurrentOilLifeForCar:car]];
        
        // Car Name Label
        carNameLabel.text = car.name;
        
        // Get the current mileage, and set the odometer label
        NSString *miles = [NSString stringWithFormat:@"%@", @(car.currentMileage)];
        odometerLabel.text = miles;
        
        // MPG Label
        mpgLabel.text = [NSString stringWithFormat:@"%.2f", [self calculateMPG:car]];
        
        // if this is the active car, make the label visible
        if ([car.uuid isEqualToString:[self activeCarID]]) {
            activeCarLabel.hidden = NO;
        }

    } else {
        activeCarLabel.hidden = YES;
        Car *car = [self.cars objectAtIndex:indexPath.row]; // get the car for this row
        PhotoObject *img = [car.carPhoto lastObject];      // get the image for the car
        NSString *photoName = [documentsDirectory stringByAppendingString:img.imageName];
        carImageView.image = [UIImage imageWithContentsOfFile:photoName];
        
        // oil life label
        if ([self calculateCurrentOilLifeForCar:car] <= 10) {
            oilLifeLabel.textColor = [UIColor redColor];
        } else {
            oilLifeLabel.textColor = [UIColor greenColor];
        }
        oilLifeLabel.text = [NSString stringWithFormat:@"%li%%", [self calculateCurrentOilLifeForCar:car]];
        
        // Car Name Label
        carNameLabel.text = car.name;
        
        // Get the current mileage, and set the odometer label
        NSString *miles = [NSString stringWithFormat:@"%@", @(car.currentMileage)];
        odometerLabel.text = miles;
        
        // TODO: add a property to the Car class for "mpg"
        // For the time being, we will set this at a constant value, just for testing
        mpgLabel.text = [NSString stringWithFormat:@"%.2f", [self calculateMPG:car]];
        
        
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

- (void)drawGaugeWithPressure: (CGFloat)pressure
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* strokeColor = [UIColor colorWithRed: 0.437 green: 0.437 blue: 0.437 alpha: 1];
    UIColor* highPressureColor = [UIColor colorWithRed: 1 green: 0.3 blue: 0.3 alpha: 1];
    UIColor* lowPressureColor = [UIColor colorWithRed: 0.316 green: 0.915 blue: 0.451 alpha: 1];
    
    //// Variable Declarations
    CGFloat angle = -240 * pressure;
    UIColor* limitingColor = pressure > 0.7 ? highPressureColor : lowPressureColor;
    
    //// Outer Frame Drawing
    UIBezierPath* outerFramePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(124, 42, 100, 100)];
    [UIColor.whiteColor setFill];
    [outerFramePath fill];
    [strokeColor setStroke];
    outerFramePath.lineWidth = 2;
    [outerFramePath stroke];
    
    
    //// Scale Frame Drawing
    UIBezierPath* scaleFramePath = UIBezierPath.bezierPath;
    [scaleFramePath moveToPoint: CGPointMake(138.49, 112.5)];
    [scaleFramePath addCurveToPoint: CGPointMake(153.5, 56.49) controlPoint1: CGPointMake(127.17, 92.89) controlPoint2: CGPointMake(133.89, 67.81)];
    [scaleFramePath addCurveToPoint: CGPointMake(209.51, 71.5) controlPoint1: CGPointMake(173.11, 45.17) controlPoint2: CGPointMake(198.19, 51.89)];
    [scaleFramePath addCurveToPoint: CGPointMake(209.51, 112.5) controlPoint1: CGPointMake(216.83, 84.19) controlPoint2: CGPointMake(216.83, 99.81)];
    [scaleFramePath addLineToPoint: CGPointMake(197.38, 105.5)];
    [scaleFramePath addCurveToPoint: CGPointMake(197.38, 78.5) controlPoint1: CGPointMake(202.21, 97.15) controlPoint2: CGPointMake(202.21, 86.85)];
    [scaleFramePath addCurveToPoint: CGPointMake(160.5, 68.62) controlPoint1: CGPointMake(189.93, 65.59) controlPoint2: CGPointMake(173.41, 61.16)];
    [scaleFramePath addCurveToPoint: CGPointMake(150.62, 105.5) controlPoint1: CGPointMake(147.59, 76.07) controlPoint2: CGPointMake(143.16, 92.59)];
    [scaleFramePath addLineToPoint: CGPointMake(138.49, 112.5)];
    [scaleFramePath closePath];
    [strokeColor setStroke];
    scaleFramePath.lineWidth = 2;
    [scaleFramePath stroke];
    
    
    //// Display Drawing
    UIBezierPath* displayPath = UIBezierPath.bezierPath;
    [displayPath moveToPoint: CGPointMake(190.02, 129.74)];
    [displayPath addCurveToPoint: CGPointMake(157.98, 129.74) controlPoint1: CGPointMake(179.78, 134.09) controlPoint2: CGPointMake(168.22, 134.09)];
    [displayPath addLineToPoint: CGPointMake(160.72, 123.3)];
    [displayPath addCurveToPoint: CGPointMake(187.28, 123.3) controlPoint1: CGPointMake(169.21, 126.9) controlPoint2: CGPointMake(178.79, 126.9)];
    [displayPath addLineToPoint: CGPointMake(190.02, 129.74)];
    [displayPath closePath];
    [limitingColor setFill];
    [displayPath fill];
    [strokeColor setStroke];
    displayPath.lineWidth = 2;
    [displayPath stroke];
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(174, 58)];
    [bezierPath addLineToPoint: CGPointMake(174, 51)];
    [bezierPath moveToPoint: CGPointMake(133, 92)];
    [bezierPath addLineToPoint: CGPointMake(140, 92)];
    [bezierPath moveToPoint: CGPointMake(208, 92)];
    [bezierPath addLineToPoint: CGPointMake(215, 92)];
    [bezierPath moveToPoint: CGPointMake(198.04, 67.96)];
    [bezierPath addLineToPoint: CGPointMake(202.99, 63.01)];
    [bezierPath moveToPoint: CGPointMake(145.01, 63.01)];
    [bezierPath addLineToPoint: CGPointMake(149.96, 67.96)];
    [bezierPath moveToPoint: CGPointMake(205.41, 78.99)];
    [bezierPath addLineToPoint: CGPointMake(211.88, 76.31)];
    [bezierPath moveToPoint: CGPointMake(136.12, 76.31)];
    [bezierPath addLineToPoint: CGPointMake(142.59, 78.99)];
    [bezierPath moveToPoint: CGPointMake(158.31, 54.12)];
    [bezierPath addLineToPoint: CGPointMake(160.99, 60.59)];
    [bezierPath moveToPoint: CGPointMake(187.01, 123.41)];
    [bezierPath addLineToPoint: CGPointMake(189.69, 129.88)];
    [bezierPath moveToPoint: CGPointMake(189.69, 54.12)];
    [bezierPath addLineToPoint: CGPointMake(187.01, 60.59)];
    [bezierPath moveToPoint: CGPointMake(160.99, 123.41)];
    [bezierPath addLineToPoint: CGPointMake(158.31, 129.88)];
    [strokeColor setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];
    
    
    //// Arrow Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 174, 92);
    CGContextRotateCTM(context, -(angle + 120) * M_PI / 180);
    
    UIBezierPath* arrowPath = UIBezierPath.bezierPath;
    [arrowPath moveToPoint: CGPointMake(-4, 14)];
    [arrowPath addLineToPoint: CGPointMake(-4, 5)];
    [arrowPath addLineToPoint: CGPointMake(-3, -5)];
    [arrowPath addLineToPoint: CGPointMake(-3, -33)];
    [arrowPath addLineToPoint: CGPointMake(0, -37)];
    [arrowPath addLineToPoint: CGPointMake(3, -33)];
    [arrowPath addLineToPoint: CGPointMake(3, -5)];
    [arrowPath addLineToPoint: CGPointMake(4, 5)];
    [arrowPath addLineToPoint: CGPointMake(4, 14)];
    [arrowPath addLineToPoint: CGPointMake(-4, 14)];
    [arrowPath closePath];
    arrowPath.lineJoinStyle = kCGLineJoinRound;
    
    [strokeColor setFill];
    [arrowPath fill];
    [strokeColor setStroke];
    arrowPath.lineWidth = 2;
    [arrowPath stroke];
    
    CGContextRestoreGState(context);
    
    
    //// Center Oval Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 174, 92);
    
    UIBezierPath* centerOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-6, -6, 12, 12)];
    [UIColor.whiteColor setFill];
    [centerOvalPath fill];
    [strokeColor setStroke];
    centerOvalPath.lineWidth = 2;
    [centerOvalPath stroke];
    
    CGContextRestoreGState(context);
    
    
    //// LimitOval Drawing
    UIBezierPath* limitOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(204.68, 58.4, 3, 3)];
    [UIColor.whiteColor setFill];
    [limitOvalPath fill];
    [strokeColor setStroke];
    limitOvalPath.lineWidth = 2;
    [limitOvalPath stroke];
}



@end
