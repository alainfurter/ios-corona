//
//  UIImage+SwissPlates.h
//  Swiss Trains
//
//  Created by Alain on 28.11.12.
//  Copyright (c) 2012 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SwissPlates)

// PlatesViewController
+(UIImage *) crossbutton;
+(UIImage *) searchbutton;
+(UIImage *) optionsbutton;

// PlatesSearchView
+(UIImage *) cancelbutton;

// PlateView
+(UIImage *) swissImage;
+(UIImage *) cantonImageWithCantoncode:(NSString *)cantoncode;


// Share Activities
+(UIImage *) mailServiceImage;
+(UIImage *) twitterServiceImage;
+(UIImage *) facebookServiceImage;
+(UIImage *) copyServiceImage;

+ (UIImage *)renderCircleButtonImage:(UIImage *)inputimage backgroundColor:(UIColor *)backgroundColor imageColor:(UIColor *)imageColor imageSize:(CGSize)imageSize;
+ (UIImage *)newCircleImageWithMaskImage:(UIImage *)mask backgroundColor:(UIColor *)backgroundColor imageColor:(UIColor *)imageColor size:(CGSize)imageSize;
+ (UIImage *)newImageFromMaskImage:(UIImage *)mask inColor:(UIColor *) color;

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)imageWithTransparentBorder:(NSUInteger)thickness;
- (UIImage *)imageWithTransparentLeftRight:(NSUInteger)thickness;
- (UIImage *)transparentBorderLeftRightImage:(NSUInteger)thickness;

@end
