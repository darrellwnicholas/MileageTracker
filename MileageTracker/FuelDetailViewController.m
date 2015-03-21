//
//  FuelDetailCollectionViewController.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/14/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "FuelDetailViewController.h"

@interface FuelDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) id currentResponder;
@end

@implementation FuelDetailViewController

//static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    _mileageLabel.text = [@(self.selectedEntry.mileage) stringValue];
    _driverIDLabel.text = self.activeCar.driverID;

    self.pricePerGallonTextField.text = [NSString stringWithFormat:@"%.3f", self.selectedEntry.price];
    self.numberGallonsPumpedTextField.text = [NSString stringWithFormat:@"%.3f", self.selectedEntry.gallons];
    if (self.selectedEntry.fillUp == YES) {
        [self.isFillUpSwitch setOn:YES];
        self.yesNoLabel.text = @"-Yes";
    } else {
        [self.isFillUpSwitch setOn:NO];
        self.yesNoLabel.text = @"-No";
    }
    
//    self.selectedEntry.price = self.pricePerGallonTextField.text.doubleValue;
//    self.selectedEntry.gallons = self.numberGallonsPumpedTextField.text.doubleValue;
//   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterMediumStyle;
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.doesRelativeDateFormatting = YES;
    
    _dateLabel.text = [formatter stringFromDate:self.selectedEntry.date];
    
    // creating date picker for "keyboard" of dateLabel
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [_dateLabel setInputView:datePicker];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
//    making sure scrollview adjusts to accomodate navigation bar. Before I had not set scrollview all the way to the top of the view, I had
//    only set it to the bottom of the navigation bar in the storyboard. In that instance I had to set this value to NO. Now that I have
//    corrected my scrollview size, I am back to setting this value to YES (which I believe is the default, so this may be unnecessary).
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _pricePerGallonTextField.delegate = nil;
    _numberGallonsPumpedTextField.delegate = nil;
}

- (void)dateTextField:(id)sender
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    UIDatePicker *picker = (UIDatePicker*)_dateLabel.inputView;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *entryDate = picker.date;
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormat setDoesRelativeDateFormatting:YES];
     
    
    NSString *dateString = [dateFormat stringFromDate:entryDate];
    _dateLabel.text = [NSString stringWithFormat:@"%@", dateString];
    self.selectedEntry.date = entryDate;
    [realm commitWriteTransaction];
}

// Called when the UIKeyboardDidShowNotification is sent...
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.scrollView setContentOffset:CGPointMake(0, kbSize.height / 2) animated:YES];
}

// Called when the text field is being edited
// setting textField delegate to self
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    sender.delegate = self;
    self.currentResponder = sender;
}

// Called when the UIKeyboardWillHideNotification is sent.
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    if (textField.tag <= 12) {
        return [textField resignFirstResponder];
    } else {
        return [textField resignFirstResponder];
    }
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}


- (IBAction)toggleFuelEntryFillUp:(UISwitch *)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    if ([sender isOn]) {
        self.selectedEntry.fillUp = YES;
        self.yesNoLabel.text = @"-Yes";
    } else {
        self.selectedEntry.fillUp = NO;
        self.yesNoLabel.text = @"-No";
    }
    [realm commitWriteTransaction];
}

- (IBAction)save:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save" message:@"Save all changes?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        self.selectedEntry.price = self.pricePerGallonTextField.text.doubleValue;
        self.selectedEntry.gallons = self.numberGallonsPumpedTextField.text.doubleValue;
        
        
        [realm commitWriteTransaction];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];

}
@end
