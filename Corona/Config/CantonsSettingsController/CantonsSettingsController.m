//
//  CantonsSettingsController.m
//  Swiss Plates
//
//  Created by Alain on 25.07.13.
//  Copyright (c) 2013 Zone Zero Apps. All rights reserved.
//

#import "CantonsSettingsController.h"

#import <sys/utsname.h>

#import "UIImage+SwissPlates.h"
#import "AppConfig.h"

@interface CantonsSettingsController ()
@property(nonatomic, strong) NSString *cantonsConfigFile;
@property(nonatomic, strong) NSArray *cantonsList;
@property(nonatomic, assign) NSUInteger selectedCanton;
@end

@implementation CantonsSettingsController

+ (CantonsSettingsController *)sharedCantonsSettingsController
{
    static CantonsSettingsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CantonsSettingsController alloc] init];
     
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CantonConfig" ofType:@"plist"];
        NSArray *cantonsList = [[NSDictionary dictionaryWithContentsOfFile: filePath] objectForKey: @"Cantons"];
        
        sharedInstance.cantonsList = cantonsList;
        sharedInstance.selectedCanton = 0;
        
    });
    
    return sharedInstance;
}

- (NSUInteger) getSelectedCanton {
    return _selectedCanton;
}

- (void) setSelectedCanton:(NSUInteger)cantonindex {
    if (cantonindex < [self getNumberOfCantons]) {
        _selectedCanton = cantonindex;
    }
}

- (NSString *) machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
	
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (NSString *) getLanguageIdentiferCode:(LanguageIdentifierCodes)identifiercode {
    if (identifiercode == LanguageIdentifierEN) {
        return @"EN";
    }
    if (identifiercode == LanguageIdentifierDE) {
        return @"DE";
    }
    if (identifiercode == LanguageIdentifierFR) {
        return @"FR";
    }
    if (identifiercode == LanguageIdentifierIT) {
        return @"IT";
    }
    if (identifiercode == LanguageIdentifierPreferred) {
        NSString *preflanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([preflanguage isEqualToString:@"en"] || [preflanguage isEqualToString:@"de"] || [preflanguage isEqualToString:@"fr"] || [preflanguage isEqualToString:@"it"]) {
            return [preflanguage uppercaseString];
        } else return @"EN";
    }
    return @"EN";
}

- (NSUInteger) getNumberOfCantons {
    return [_cantonsList count];
}

- (UIImage *) getCantonImageForCantonAtIndex:(NSUInteger)cantonindex {
    if (cantonindex < [_cantonsList count]) {
        return [UIImage imageNamed: [[_cantonsList objectAtIndex: cantonindex] objectForKey: @"Flag"]];
    }
    return nil;
}

- (UIImage *) getCantonTypeImageForCantonAtIndex:(NSUInteger)cantonindex {
    if (cantonindex < [_cantonsList count]) {
        return [UIImage imageNamed: [[_cantonsList objectAtIndex: cantonindex] objectForKey: @"TypeImg"]];
    }
    return nil;
}

- (NSString *) getCantonCodeForCantonAtIndex:(NSUInteger)cantonindex {
    if (cantonindex < [_cantonsList count]) {
        return [[_cantonsList objectAtIndex: cantonindex] objectForKey: @"Code"];
    }
    return nil;
}

- (NSString *) getCantonNameForCantonAtIndex:(NSUInteger)cantonindex languageIdentifier:(LanguageIdentifierCodes)languageIdentifier {
    if (cantonindex < [_cantonsList count]) {
        NSString *languageIdentifierCode = [self getLanguageIdentiferCode:languageIdentifier];
        return [[_cantonsList objectAtIndex: cantonindex] objectForKey: [NSString stringWithFormat:@"Name%@", languageIdentifierCode]];
    }
    return nil;
}

@end
