//
//  CantonsSettingsController.h
//  Swiss Plates
//
//  Created by Alain on 25.07.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LanguageIdentifierCodes) {
	LanguageIdentifierEN,
	LanguageIdentifierDE,
	LanguageIdentifierFR,
	LanguageIdentifierIT,
    LanguageIdentifierPreferred
};

@interface CantonsSettingsController : NSObject

+ (CantonsSettingsController *)sharedCantonsSettingsController;

- (NSUInteger) getNumberOfCantons;
- (NSUInteger) getSelectedCanton;
- (void) setSelectedCanton:(NSUInteger)cantonindex;

- (UIImage *) getCantonImageForCantonAtIndex:(NSUInteger)cantonindex;
- (UIImage *) getCantonTypeImageForCantonAtIndex:(NSUInteger)cantonindex;
- (NSString *) getCantonCodeForCantonAtIndex:(NSUInteger)cantonindex;
- (NSString *) getCantonNameForCantonAtIndex:(NSUInteger)cantonindex languageIdentifier:(LanguageIdentifierCodes)languageIdentifier;

@end
