//
//  CustomCarTableViewCell.h
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/13/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCarTableViewCell : UITableViewCell
@property IBOutlet UIImageView *thumbnailImageView;

@property IBOutlet UILabel *carTextLabel;
@property IBOutlet UILabel *carDetailTextLabel;
@property IBOutlet UILabel *activeCarLabel;

/*
 @property (strong, nonatomic) IBOutlet UIImageView *thumbnailImageView;
 
 @property (strong, nonatomic) IBOutlet UILabel *carTextLabel;
 @property (strong, nonatomic) IBOutlet UILabel *carDetailTextLabel;
 @property (strong, nonatomic) IBOutlet UILabel *activeCarLabel;
*/


@end
