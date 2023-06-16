//
//  SettingsTableViewCell.m
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import "SettingsTableViewCell.h"
#import "UIColor+SwissPlates.h"
#import "UIImage+SwissPlates.h"

@implementation SettingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.backgroundColor = [UIColor settingsTableviewCellBackgroundColor];
    self.contentView.backgroundColor = [UIColor settingsTableviewCellContentViewBackgroundColor];
    _settingsLabel.textColor = [UIColor settingsTableviewSettingsLabelColor];
    _settingsLabel.backgroundColor = [UIColor settingsTableviewSettingsLabelBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    UIView *cellSelectedBackgroundView = [[UIView alloc] init];
    cellSelectedBackgroundView.backgroundColor = [UIColor settingsTableviewCellSelectedBackgroundColor];
    self.selectedBackgroundView = cellSelectedBackgroundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
