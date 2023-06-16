//
//  UIColor+SwissPlates.m
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import "UIColor+SwissPlates.h"
#import "AppConfig.h"

@implementation UIColor (SwissPlates)

// -------------------------------------------------------------------------------------
// SettingsTableviewController

#ifdef kSwissPlatesPro
//CantonsTableViewCell
+(UIColor *) cantonsTableviewCellBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) cantonsTableviewCellContentViewBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) cantonsTableviewCellSelectedBackgroundColor { return [UIColor colorWithHexString:@"424747"]; }

+(UIColor *) cantonsTableviewCantoncodeColor { return [UIColor colorWithHexString:@"cfcfcf"]; }
+(UIColor *) cantonsTableviewCantoncodeBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) cantonsTableviewCantonnameColor { return [UIColor colorWithHexString:@"cfcfcf"]; }
+(UIColor *) cantonsTableviewCantonnameBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) cantonsTableviewTypeImageColor { return [UIColor colorWithWhite: 0.7 alpha:1.0]; }

//SettingsTableViewCell
+(UIColor *) settingsTableviewCellBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) settingsTableviewCellContentViewBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) settingsTableviewCellSelectedBackgroundColor { return [UIColor colorWithHexString:@"424747"]; }

+(UIColor *) settingsTableviewSettingsLabelColor { return [UIColor colorWithHexString:@"cfcfcf"]; }
+(UIColor *) settingsTableviewSettingsLabelBackgroundColor { return [UIColor clearColor]; }

//SettingsTableviewController
+(UIColor *) settingsTableviewBackgroundColor { return [UIColor colorWithHexString:@"2f3235"]; }
+(UIColor *) settingsTableviewSeparatorColor { return [UIColor colorWithHexString:@"424747"]; }

+(UIColor *) settingsTableviewHeaderBackgroundColor { return [UIColor colorWithHexString:@"515355"]; }
+(UIColor *) settingsTableviewHeaderTitleBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) settingsTableviewHeaderTitleColor { return [UIColor colorWithHexString:@"cfcfcf"]; }
#endif

#ifdef kSwissPlates
//CantonsTableViewCell
+(UIColor *) cantonsTableviewCellBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) cantonsTableviewCellContentViewBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) cantonsTableviewCellSelectedBackgroundColor { return [UIColor colorWithWhite:0.8 alpha:1.0]; }

+(UIColor *) cantonsTableviewCantoncodeColor { return [UIColor colorWithWhite: 0.3 alpha:1.0]; }
+(UIColor *) cantonsTableviewCantoncodeBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) cantonsTableviewCantonnameColor { return [UIColor colorWithWhite: 0.3 alpha:1.0]; }
+(UIColor *) cantonsTableviewCantonnameBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) cantonsTableviewTypeImageColor { return [UIColor colorWithWhite: 0.3 alpha:1.0]; }

//SettingsTableViewCell
+(UIColor *) settingsTableviewCellBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) settingsTableviewCellContentViewBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) settingsTableviewCellSelectedBackgroundColor { return [UIColor colorWithWhite:0.8 alpha:1.0]; }

+(UIColor *) settingsTableviewSettingsLabelColor { return [UIColor colorWithWhite: 0.3 alpha:1.0]; }
+(UIColor *) settingsTableviewSettingsLabelBackgroundColor { return [UIColor clearColor]; }

//SettingsTableviewController
+(UIColor *) settingsTableviewBackgroundColor { return [UIColor colorWithWhite:0.98 alpha:1.0]; }
+(UIColor *) settingsTableviewSeparatorColor { return [UIColor colorWithHexString:@"424747"]; }

+(UIColor *) settingsTableviewHeaderBackgroundColor { return [UIColor colorWithHexString:@"515355"]; }
+(UIColor *) settingsTableviewHeaderTitleBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) settingsTableviewHeaderTitleColor { return [UIColor colorWithHexString:@"cfcfcf"]; }
#endif

//+(UIColor *) settingsTableviewNavigationbarTitleColor { return [UIColor colorWithWhite: 0.7 alpha:1.0]; }

//SettingsWebViewController
+(UIColor *) settingsWebviewControllerBackgroundColor { return [UIColor colorWithHexString:@"2f3235"]; }
+(UIColor *) settingsWebviewControllerWebviewBackgroundColor { return [UIColor colorWithHexString:@"2f3235"]; }
+(UIColor *) settingsWebviewControllerBackButtonColor { return [UIColor colorWithWhite: 0.3 alpha:1.0]; }


// -------------------------------------------------------------------------------------
//SelectCantonTableViewController
#ifdef kSwissPlatesPro
+(UIColor *) selectCantonTableviewControllerBackgroundColor { return [UIColor colorWithHexString:@"2f3235"]; }
+(UIColor *) selectCantonTableviewBackgroundColor { return [UIColor colorWithHexString:@"2f3235"]; }
+(UIColor *) selectCantonTableviewSeparatorColor { return [UIColor colorWithHexString:@"424747"]; }

+(UIColor *) selectCantonTableviewControllerNavigationbarTitleColor { return [UIColor colorWithWhite: 0.3 alpha:1.0]; }

+(UIColor *) selectCantonTableviewCellBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) selectCantonTableviewCellContentViewColor { return [UIColor colorWithWhite: 1.0 alpha:1.0]; }
+(UIColor *) selectCantonTableviewCellSelectedBackgroundColor { return [UIColor colorWithHexString:@"424747"]; }

+(UIColor *) selectCantonTableviewCantoncodeColor { return [UIColor colorWithWhite: 0.3 alpha:1.0]; }
+(UIColor *) selectCantonTableviewCantoncodeBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) selectCantonTableviewCantonnameColor { return [UIColor colorWithWhite: 0.3 alpha:1.0]; }
+(UIColor *) selectCantonTableviewCantonnameBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) selectCantonTableviewCellVehicleTypeImageColor { return [UIColor colorWithWhite: 0.3 alpha:1.0]; }
#endif

#ifdef kSwissPlates
+(UIColor *) selectCantonTableviewControllerBackgroundColor { return [UIColor colorWithHexString:@"2f3235"]; }
+(UIColor *) selectCantonTableviewBackgroundColor { return [UIColor colorWithHexString:@"2f3235"]; }
+(UIColor *) selectCantonTableviewSeparatorColor { return [UIColor colorWithHexString:@"424747"]; }

+(UIColor *) selectCantonTableviewControllerNavigationbarTitleColor { return [UIColor colorWithWhite: 0.8 alpha:1.0]; }

+(UIColor *) selectCantonTableviewCellBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) selectCantonTableviewCellContentViewColor { return [UIColor colorWithHexString:@"2f3235"]; }
+(UIColor *) selectCantonTableviewCellSelectedBackgroundColor { return [UIColor colorWithHexString:@"424747"]; }

+(UIColor *) selectCantonTableviewCantoncodeColor { return [UIColor colorWithHexString:@"cfcfcf"]; }
+(UIColor *) selectCantonTableviewCantoncodeBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) selectCantonTableviewCantonnameColor { return [UIColor colorWithHexString:@"cfcfcf"]; }
+(UIColor *) selectCantonTableviewCantonnameBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) selectCantonTableviewCellVehicleTypeImageColor { return [UIColor colorWithWhite: 0.7 alpha:1.0]; }
#endif

//+(UIColor *) selectCantonTableviewControllerNavigationbarBackgroundColor { return [UIColor colorWithHexString:@"424747"]; }

// -------------------------------------------------------------------------------------
// PlatesViewController

#ifdef kSwissPlatesPro
//PlatesViewController
+(UIColor *) platesViewControllerBackgroundColor { return [UIColor colorWithWhite: 1.0 alpha:1.0]; }
+(UIColor *) platesViewControllerNavigationbarColor { return [UIColor colorWithWhite: 0.1 alpha:1.0]; }
+(UIColor *) platesViewControllerNavigationbarBackButtonColor { return [UIColor colorWithWhite: 0.8 alpha:1.0]; }

+(UIColor *) platesTableviewBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) platesTableviewSeparatorColor { return [UIColor colorWithHexString:@"424747"]; }

+(UIColor *) platesViewControllerSearchButtonImageColor { return [UIColor whiteColor]; }
+(UIColor *) platesViewControllerSearchButtonBackgroundColor { return [UIColor colorWithHexString:@"cc5654"]; }
+(UIColor *) platesViewControllerSearchButtonShadowColor { return [UIColor blackColor]; }
#endif

#ifdef kSwissPlates
//PlatesViewController
+(UIColor *) platesViewControllerBackgroundColor { return [UIColor colorWithHexString:@"2f3235"]; } // Color change
+(UIColor *) platesViewControllerNavigationbarColor { return [UIColor colorWithWhite: 0.1 alpha:1.0]; }
+(UIColor *) platesViewControllerNavigationbarBackButtonColor { return [UIColor colorWithWhite: 0.8 alpha:1.0]; }

+(UIColor *) platesTableviewBackgroundColor { return [UIColor clearColor]; }
+(UIColor *) platesTableviewSeparatorColor { return [UIColor colorWithHexString:@"424747"]; }

+(UIColor *) platesViewControllerSearchButtonImageColor { return [UIColor whiteColor]; }
+(UIColor *) platesViewControllerSearchButtonBackgroundColor { return [UIColor colorWithHexString:@"cc5654"]; }
+(UIColor *) platesViewControllerSearchButtonShadowColor { return [UIColor blackColor]; }
#endif

// -------------------------------------------------------------------------------------

//static NSMutableDictionary *colorNameCache = nil;

- (CGColorSpaceModel)colorSpaceModel {
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)colorSpaceString {
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelUnknown:
			return @"kCGColorSpaceModelUnknown";
		case kCGColorSpaceModelMonochrome:
			return @"kCGColorSpaceModelMonochrome";
		case kCGColorSpaceModelRGB:
			return @"kCGColorSpaceModelRGB";
		case kCGColorSpaceModelCMYK:
			return @"kCGColorSpaceModelCMYK";
		case kCGColorSpaceModelLab:
			return @"kCGColorSpaceModelLab";
		case kCGColorSpaceModelDeviceN:
			return @"kCGColorSpaceModelDeviceN";
		case kCGColorSpaceModelIndexed:
			return @"kCGColorSpaceModelIndexed";
		case kCGColorSpaceModelPattern:
			return @"kCGColorSpaceModelPattern";
		default:
			return @"Not a valid color space";
	}
}

- (BOOL)canProvideRGBComponents {
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelRGB:
		case kCGColorSpaceModelMonochrome:
			return YES;
		default:
			return NO;
	}
}

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
    
	CGFloat r,g,b,a;
    
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			a = components[1];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			a = components[3];
			break;
		default:	// We don't know how to handle this model
			return NO;
	}
    
	if (red) *red = r;
	if (green) *green = g;
	if (blue) *blue = b;
	if (alpha) *alpha = a;
    
	return YES;
}

- (CGFloat)red {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)green {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[1];
}

- (CGFloat)blue {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
	return c[2];
}

- (CGFloat)white {
	NSAssert(self.colorSpaceModel == kCGColorSpaceModelMonochrome, @"Must be a Monochrome color to use -white");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat)alpha {
	return CGColorGetAlpha(self.CGColor);
}

- (UInt32)rgbHex {
	NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use rgbHex");
    
	CGFloat r,g,b,a;
	if (![self red:&r green:&g blue:&b alpha:&a]) return 0;
    
	r = MIN(MAX(self.red, 0.0f), 1.0f);
	g = MIN(MAX(self.green, 0.0f), 1.0f);
	b = MIN(MAX(self.blue, 0.0f), 1.0f);
    
	return (((int)roundf(r * 255)) << 16)
    | (((int)roundf(g * 255)) << 8)
    | (((int)roundf(b * 255)));
}

- (NSString *)stringFromColor {
	NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -stringFromColor");
	NSString *result;
	switch (self.colorSpaceModel) {
		case kCGColorSpaceModelRGB:
			result = [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha];
			break;
		case kCGColorSpaceModelMonochrome:
			result = [NSString stringWithFormat:@"{%0.3f, %0.3f}", self.white, self.alpha];
			break;
		default:
			result = nil;
	}
	return result;
}

- (NSString *)hexStringFromColor {
	return [NSString stringWithFormat:@"%0.6lX", (unsigned long)self.rgbHex];
    //return [NSString stringWithFormat:@"%0.6X", self.rgbHex];
}

+ (UIColor *)colorWithString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	if (![scanner scanString:@"{" intoString:NULL]) return nil;
	const NSUInteger kMaxComponents = 4;
	CGFloat c[kMaxComponents];
	NSUInteger i = 0;
	if (![scanner scanFloat:(float *)&c[i++]]) return nil;
	while (1) {
		if ([scanner scanString:@"}" intoString:NULL]) break;
		if (i >= kMaxComponents) return nil;
		if ([scanner scanString:@"," intoString:NULL]) {
			if (![scanner scanFloat:(float *)&c[i++]]) return nil;
		} else {
			// either we're at the end of there's an unexpected character here
			// both cases are error conditions
			return nil;
		}
	}
	if (![scanner isAtEnd]) return nil;
	UIColor *color;
	switch (i) {
		case 2: // monochrome
			color = [UIColor colorWithWhite:c[0] alpha:c[1]];
			break;
		case 4: // RGB
			color = [UIColor colorWithRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
			break;
		default:
			color = nil;
	}
	return color;
}

#pragma mark Class methods

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
    
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	return [UIColor colorWithRGBHex:hexNum];
}

// -------------------------------------------------------------------------------------

- (BOOL)isEqualToColor:(UIColor *)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            return [UIColor colorWithCGColor:CGColorCreate(colorSpaceRGB, components)];
        } else
            return color;
    };
    
    UIColor *selfColor = convertColorToRGBSpace(self);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:otherColor];
}

@end
