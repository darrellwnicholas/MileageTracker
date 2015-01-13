//
//  CustomCarTableViewCell.m
//  MileageTracker
//
//  Created by Darrell Nicholas on 1/13/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "CustomCarTableViewCell.h"

@implementation CustomCarTableViewCell
@synthesize thumbnailImageView;
@synthesize carTextLabel;
@synthesize carDetailTextLabel;
@synthesize activeCarLabel;

static const NSString *CellIdentifier = @"customCarCell";

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect carTextLabelRectangle = CGRectMake(64, 5, 102, 22);
        carTextLabel = [[UILabel alloc] initWithFrame:carTextLabelRectangle];
        carTextLabel.textAlignment = NSTextAlignmentLeft;
        carTextLabel.text = @"Car Name:";
        UIFontDescriptor *carTextDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:@{@"Family":@"Avenir Next",
                                                          @"Style":@"Regular",
                                                           }];
        carTextLabel.font = [UIFont fontWithDescriptor:carTextDescriptor size:16];
        carTextLabel.tag = 2;
        [self.contentView addSubview:carTextLabel];
        
        CGRect detailTextLabelRect = CGRectMake(64, 25, 114, 14);
        carDetailTextLabel = [[UILabel alloc] initWithFrame:detailTextLabelRect];
        carDetailTextLabel.textAlignment = NSTextAlignmentLeft;
        carDetailTextLabel.text = @"Odometer: 000000";
        UIFontDescriptor *detailTextDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:@{@"Family":@"Avenir Next",
                                                                                               @"Style":@"Medium",
                                                                                               }];
        carDetailTextLabel.font = [UIFont fontWithDescriptor:detailTextDescriptor size:11];
        carDetailTextLabel.tag = 3;
        [self.contentView addSubview:carDetailTextLabel];
        
        CGRect activeCarLabelRectangle = CGRectMake(222, 13, 41, 17);
        activeCarLabel = [[UILabel alloc] initWithFrame:activeCarLabelRectangle];
        activeCarLabel.textAlignment = NSTextAlignmentCenter;
        activeCarLabel.text = @"Active";
        UIFontDescriptor *activeCarLabelDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:@{@"Family":@"Avenir",
                                                                                                 @"Style":@"Roman",
                                                                                                 }];
        activeCarLabel.font = [UIFont fontWithDescriptor:activeCarLabelDescriptor size:14];
        activeCarLabel.textColor = [UIColor redColor];
        activeCarLabel.tag = 4;
        activeCarLabel.hidden = YES;
        [self.contentView addSubview:activeCarLabel];
        
        CGRect thumbnailRectangle = CGRectMake(20, 7, 29, 29);
        thumbnailImageView = [[UIImageView alloc] initWithFrame:thumbnailRectangle];
        thumbnailImageView.tag = 1;
        [self.contentView addSubview:thumbnailImageView];
    }
    return self;
}


//UILabel *activeCarLabel = (UILabel*)[cell.contentView viewWithTag:4];
//    UILabel *carTextLabel = (UILabel*)[cell.contentView viewWithTag:2];
//    UILabel *carDetailTextLabel = (UILabel*)[cell.contentView viewWithTag:3];
//    UIImageView *thumbnailImageView = (UIImageView*)[cell.contentView viewWithTag:1];
//    [cell addSubview:activeCarLabel];
//    [cell addSubview:carTextLabel];
//    [cell addSubview:carDetailTextLabel];
//cell.imageView.image = thumbnailImageView.image;
@end
