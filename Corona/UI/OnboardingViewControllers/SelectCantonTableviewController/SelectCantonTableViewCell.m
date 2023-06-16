//
//  SelectCantonTableViewCell.m
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import "SelectCantonTableViewCell.h"
#import "UIColor+SwissPlates.h"
#import "UIImage+SwissPlates.h"

@implementation SelectCantonTableViewCell

- (void)awakeFromNib {
     [super awakeFromNib];
       // Initialization code
       self.selectionStyle = UITableViewCellSelectionStyleNone;
       self.backgroundColor = [UIColor selectCantonTableviewCellBackgroundColor];
       self.contentView.backgroundColor = [UIColor selectCantonTableviewCellContentViewColor];
       _cantonCode.textColor = [UIColor selectCantonTableviewCantoncodeColor];
       _cantonCode.backgroundColor = [UIColor selectCantonTableviewCantoncodeBackgroundColor];
       _cantonName.textColor = [UIColor selectCantonTableviewCantonnameColor];
       _cantonName.backgroundColor = [UIColor selectCantonTableviewCantonnameBackgroundColor];
       self.selectionStyle = UITableViewCellSelectionStyleDefault;
       UIView *cellSelectedBackgroundView = [[UIView alloc] init];
       cellSelectedBackgroundView.backgroundColor = [UIColor selectCantonTableviewCellSelectedBackgroundColor];
       self.selectedBackgroundView = cellSelectedBackgroundView;
       self.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    /*
     // Configure the view for the selected state
     [UIView beginAnimations:@"AlphaChange" context:NULL];
     [UIView setAnimationDuration:0.15];
     
     if (selected == YES)
     self.contentView.alpha = 1.0;
     else
     self.contentView.alpha = 1.0;
     
     [UIView commitAnimations];
     */
}

@end
