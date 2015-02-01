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
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterMediumStyle;
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.doesRelativeDateFormatting = YES;
    
    _dateLabel.text = [formatter stringFromDate:self.selectedEntry.date];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // make sure scrollview doesn't automatically resize to accomodate for nav bar (at least I think that's what it's doing). It was leaving blank space at the top of the screen about the size of the nav bar.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _pricePerGallonTextField.delegate = nil;
    _numberGallonsPumpedTextField.delegate = nil;
}

// Called when the UIKeyboardDidShowNotification is sent...
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.scrollView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
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
    return [textField resignFirstResponder];
    
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//#pragma mark <UICollectionViewDataSource>
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
//    return 0;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
//    return 0;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell
//    
//    return cell;
//}
//
//#pragma mark <UICollectionViewDelegate>
//
///*
//// Uncomment this method to specify if the specified item should be highlighted during tracking
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//	return YES;
//}
//*/
//
///*
//// Uncomment this method to specify if the specified item should be selected
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//*/
//
///*
//// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
//	return NO;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	return NO;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	
//}
//*/

- (IBAction)toggleFuelEntryFillUp:(UISwitch *)sender {
}
@end
