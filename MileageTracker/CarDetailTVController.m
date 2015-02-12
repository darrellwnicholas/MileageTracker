//
//  CarDetailTVController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/11/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "CarDetailTVController.h"
#import "CarTableViewController.h"

@interface CarDetailTVController ()
@property (nonatomic, assign) id currentResponder;
@end

@implementation CarDetailTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // UITextFieldDelegate assignments
    _carNameTextField.delegate = self;
    _carMakeTextField.delegate = self;
    _carVINTextField.delegate = self;
    _carYearTextField.delegate = self;
    _carMileageTextField.delegate = self;
    _fuelCardPINTextField.delegate = self;
    _carOilChangeMileageTextField.delegate = self;
    
    // Textfield value assignments
    _carNameTextField.text  = _selectedCar.name;
    _carMakeTextField.text  = _selectedCar.make;
    _carVINTextField.text   = _selectedCar.VIN;
    NSString *yearString = [NSString stringWithFormat:@"%li", (long)_selectedCar.year];
    _carYearTextField.text  = yearString;
    if ([self.selectedCar.uuid isEqualToString:[self activeCarID]]) {
        _activeVehicleLabel.text = @"Yes";
    } else {
        _activeVehicleLabel.text = @"No";
    }
    NSString *milesString = [NSString stringWithFormat:@"%li", (long)_selectedCar.currentMileage];
    _carMileageTextField.text = milesString;
    _fuelCardPINTextField.text = _selectedCar.driverID;
    NSString *oilChangeMiles = [NSString stringWithFormat:@"%li", (long)_selectedCar.oilChangeMiles];
    _carOilChangeMileageTextField.text = oilChangeMiles;
    
    
//     NSData *pngData = [NSData dataWithContentsOfFile:self.selectedCar.carPhoto.lastObject];
//     UIImage *image = [UIImage imageWithData:pngData];
    
    
    PhotoObject *obj = [self.selectedCar.carPhoto lastObject];
    
    _carPhotoImageView.image = [UIImage imageNamed:obj.imageName];
    
    NSLog(@"self.selectedCar.name = %@", self.selectedCar.name);
    NSLog(@"self.activeCar.name = %@", self.currentActiveCar.name);

}

- (void)dealloc {
    // unset the delegates because the textField delegate uses assign, not necessary if it uses weak reference
    // this is how it is defined in the header: @property(nonatomic, assign) id<UITextFieldDelegate> delegate
    _carNameTextField.delegate = nil;
    _carMakeTextField.delegate = nil;
    _carVINTextField.delegate = nil;
    _carYearTextField.delegate = nil;
    _carMileageTextField.delegate = nil;
    _fuelCardPINTextField.delegate = nil;
    _carOilChangeMileageTextField.delegate = nil;
}
- (NSString *)activeCarID {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"activeCar"];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeVehicleActive:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:self.selectedCar.uuid forKey:@"activeCar"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.selectedCar.currentMileage forKey:@"LastKnownMileage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.activeVehicleLabel.text = @"Yes";
}

- (IBAction)takeOrChoosePhoto:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Vehicle Photo" message:@"Take photo or choose existing..." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            UIAlertView *notAvailableAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"Your device has no camera, or it is not available at this time" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            [notAvailableAlert show];
        }

    }];
    UIAlertAction *chooseAction = [UIAlertAction actionWithTitle:@"Choose Existing" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            UIAlertView *notAvailableAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"You have no photos or your library isn't available at this time" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            [notAvailableAlert show];
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cameraAction];
    [alert addAction:chooseAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)saveChanges:(id)sender {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save" message:@"Save all changes?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        self.selectedCar.name = self.carNameTextField.text;
        self.selectedCar.make = self.carMakeTextField.text;
        self.selectedCar.VIN = self.carVINTextField.text;
        self.selectedCar.year = [[NSString stringWithFormat:@"%@", self.carYearTextField.text]integerValue];
        self.selectedCar.currentMileage = [[NSString stringWithFormat:@"%@",self.carMileageTextField.text]integerValue];
        self.selectedCar.driverID = self.fuelCardPINTextField.text;
        self.selectedCar.oilChangeMiles = [[NSString stringWithFormat:@"%@", self.carOilChangeMileageTextField.text] integerValue];
        [realm commitWriteTransaction];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    // turn the image into png data
    NSData *pngData = UIImagePNGRepresentation(chosenImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *uuidImageName = [NSString stringWithFormat:@"%@-image.png",[self.selectedCar uuid]];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:uuidImageName]; //Add the file name
    NSLog(@"%@", filePath);
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    PhotoObject *obj = [[PhotoObject alloc] init];
    obj.imageName = filePath;
    [self.selectedCar.carPhoto addObject:obj];
    [realm commitWriteTransaction];
    
    //self.carPhotoImageView.image = chosenImage;
    //NSLog(@"%@", info.description);
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
/*
 Make an alert view with if else for choosing take a photo or pick a photo. Either way, save the image to the documents
 directory of the app
 
 probably need to check if camera is available too
 
 --From scratchpad app--
 
 - (IBAction)takePhoto:(UIButton *)sender {
 
 UIImagePickerController *picker = [[UIImagePickerController alloc] init];
 picker.delegate = self;
 picker.allowsEditing = YES;
 picker.sourceType = UIImagePickerControllerSourceTypeCamera;
 
 [self presentViewController:picker animated:YES completion:NULL];
 }
 
 - (IBAction)selectPhoto:(UIButton *)sender {
 
 UIImagePickerController *picker = [[UIImagePickerController alloc] init];
 picker.delegate = self;
 picker.allowsEditing = YES;
 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
 
 [self presentViewController:picker animated:YES completion:NULL];
 }

 */

@end
