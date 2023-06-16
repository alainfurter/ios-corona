//
//  CoronaDataProcessor.h
//  Corona
//
//  Created by Alain on 15.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoronaDataProcessor : NSObject

+ (CoronaDataProcessor *)sharedCoronaDataProcessor;

- (NSDictionary*)getLatestTotalCasesForCantonCode:(NSString *)cantonCode;
- (NSDictionary*)getLatestFatalitiesCasesForCantonCode:(NSString *)cantonCode;
- (NSDictionary*)getLatestHospitalizedCasesForCantonCode:(NSString *)cantonCode;
- (NSDictionary*)getLatestVentCasesForCantonCode:(NSString *)cantonCode;
- (NSDictionary*)getLatestICUCasesForCantonCode:(NSString *)cantonCode;
- (NSDictionary*)getLatestReleasedCasesForCantonCode:(NSString *)cantonCode;
- (NSDictionary*)getLatestTestedCasesForCantonCode:(NSString *)cantonCode;

- (NSArray*)getTotalCasesDatesForCantonCode:(NSString *)cantonCode;
- (NSArray*)getTotalCasesNumbersForCantonCode:(NSString *)cantonCode;

@end

NS_ASSUME_NONNULL_END
