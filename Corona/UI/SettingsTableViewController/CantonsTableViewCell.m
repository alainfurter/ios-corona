//
//  CantonsTableViewCell.m
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import "CantonsTableViewCell.h"
#import "UIColor+SwissPlates.h"
#import "UIImage+SwissPlates.h"

@implementation CantonsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor cantonsTableviewCellBackgroundColor];
    self.contentView.backgroundColor = [UIColor cantonsTableviewCellContentViewBackgroundColor];
    _cantonCode.textColor = [UIColor cantonsTableviewCantoncodeColor];
    _cantonCode.backgroundColor = [UIColor cantonsTableviewCantoncodeBackgroundColor];
    _cantonName.textColor = [UIColor cantonsTableviewCantonnameColor];
    _cantonName.backgroundColor = [UIColor cantonsTableviewCantonnameBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *cellSelectedBackgroundView = [[UIView alloc] init];
    cellSelectedBackgroundView.backgroundColor = [UIColor cantonsTableviewCellSelectedBackgroundColor];
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
