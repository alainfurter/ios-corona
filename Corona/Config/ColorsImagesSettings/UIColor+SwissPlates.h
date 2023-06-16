//
//  UIColor+SwissPlates.h
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CantonsSettingsController.h"

@interface UIColor (SwissPlates)

// -------------------------------------------------------------------------------------
// Settings

//CantonsTableViewCell
+(UIColor *) cantonsTableviewCellBackgroundColor;
+(UIColor *) cantonsTableviewCellContentViewBackgroundColor;
+(UIColor *) cantonsTableviewCellSelectedBackgroundColor;

+(UIColor *) cantonsTableviewCantoncodeColor;
+(UIColor *) cantonsTableviewCantoncodeBackgroundColor;
+(UIColor *) cantonsTableviewCantonnameColor;
+(UIColor *) cantonsTableviewCantonnameBackgroundColor;
+(UIColor *) cantonsTableviewTypeImageColor;

//SettingsTableViewCell
+(UIColor *) settingsTableviewCellBackgroundColor;
+(UIColor *) settingsTableviewCellContentViewBackgroundColor;
+(UIColor *) settingsTableviewCellSelectedBackgroundColor;

+(UIColor *) settingsTableviewSettingsLabelColor;
+(UIColor *) settingsTableviewSettingsLabelBackgroundColor;

//SettingsTableviewController
+(UIColor *) settingsTableviewBackgroundColor;
+(UIColor *) settingsTableviewSeparatorColor;

+(UIColor *) settingsTableviewHeaderBackgroundColor;
+(UIColor *) settingsTableviewHeaderTitleBackgroundColor;
+(UIColor *) settingsTableviewHeaderTitleColor;

//+(UIColor *) settingsTableviewNavigationbarTitleColor;

//SettingsWebViewController
+(UIColor *) settingsWebviewControllerBackgroundColor;
+(UIColor *) settingsWebviewControllerWebviewBackgroundColor;
+(UIColor *) settingsWebviewControllerBackButtonColor;

// -------------------------------------------------------------------------------------
//SelectCantonTableViewController

+(UIColor *) selectCantonTableviewControllerBackgroundColor;
+(UIColor *) selectCantonTableviewBackgroundColor;
+(UIColor *) selectCantonTableviewSeparatorColor;

//+(UIColor *) selectCantonTableviewControllerNavigationbarBackgroundColor;
+(UIColor *) selectCantonTableviewControllerNavigationbarTitleColor;

+(UIColor *) selectCantonTableviewCellBackgroundColor;
+(UIColor *) selectCantonTableviewCellContentViewColor;
+(UIColor *) selectCantonTableviewCellSelectedBackgroundColor;

+(UIColor *) selectCantonTableviewCantoncodeColor;
+(UIColor *) selectCantonTableviewCantoncodeBackgroundColor;
+(UIColor *) selectCantonTableviewCantonnameColor;
+(UIColor *) selectCantonTableviewCantonnameBackgroundColor;
+(UIColor *) selectCantonTableviewCellVehicleTypeImageColor;

// -------------------------------------------------------------------------------------
//PlatesViewController
+(UIColor *) platesViewControllerBackgroundColor;
+(UIColor *) platesViewControllerNavigationbarColor;
+(UIColor *) platesViewControllerNavigationbarBackButtonColor;

+(UIColor *) platesTableviewBackgroundColor;
+(UIColor *) platesTableviewSeparatorColor;

+(UIColor *) platesViewControllerSearchButtonImageColor;
+(UIColor *) platesViewControllerSearchButtonBackgroundColor;
+(UIColor *) platesViewControllerSearchButtonShadowColor;

// -------------------------------------------------------------------------------------

- (NSString *)stringFromColor;
- (NSString *)hexStringFromColor;

+ (UIColor *)colorWithString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

- (BOOL)isEqualToColor:(UIColor *)otherColor;

@end
