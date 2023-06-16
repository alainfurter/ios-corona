//
//  CantonsTableViewCell.h
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CantonsTableViewCell : UITableViewCell
@property (nonatomic) IBOutlet UIImageView *cantonImage;
@property (nonatomic) IBOutlet UILabel *cantonCode;
@property (nonatomic) IBOutlet UILabel *cantonName;
@end

NS_ASSUME_NONNULL_END
