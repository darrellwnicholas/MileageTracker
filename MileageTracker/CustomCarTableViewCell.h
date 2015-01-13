//
//  CustomCarTableViewCell.h
//  
//
//  Created by Darrell Nicholas on 1/12/15.
//
//

#import <UIKit/UIKit.h>

@interface CustomCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *carTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *carDetailTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *carActiveCarLabel;
@end
