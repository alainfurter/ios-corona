//
//  CoronaDataProcessor.m
//  Corona
//
//  Created by Alain on 15.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import "CoronaDataProcessor.h"

#define CASES_TOTAL_FILE            @"covid19_cases_switzerland_openzh.json"
#define CASES_FATALITIES_FILE       @"covid19_fatalities_switzerland_openzh.json"
#define CASES_HOSPITALIZED_FILE     @"covid19_hospitalized_switzerland_openzh.json"
#define CASES_VENT_FILE             @"covid19_vent_switzerland_openzh.json"
#define CASES_ICU_FILE              @"covid19_icu_switzerland_openzh.json"
#define CASES_RELEASED_FILE         @"covid19_released_switzerland_openzh.json"
#define CASES_TESTED_FILE           @"covid19_tested_switzerland_openzh.json"

#define CASES_TOTAL_FILE_DL         @"covid19_cases_switzerland_openzh.json_dl"
#define CASES_FATALITIES_FILE_DL    @"covid19_fatalities_switzerland_openzh.json_dl"
#define CASES_HOSPITALIZED_FILE_DL  @"covid19_hospitalized_switzerland_openzh.json_dl"
#define CASES_VENT_FILE_DL          @"covid19_vent_switzerland_openzh.json_dl"
#define CASES_ICU_FILE_DL           @"covid19_icu_switzerland_openzh.json_dl"
#define CASES_RELEASED_FILE_DL      @"covid19_released_switzerland_openzh.json_dl"
#define CASES_TESTED_FILE_DL        @"covid19_tested_switzerland_openzh.json_dl"


@implementation CoronaDataProcessor

+ (CoronaDataProcessor *)sharedCoronaDataProcessor
{
    static CoronaDataProcessor *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoronaDataProcessor alloc] init];
    });
    return sharedInstance;
}

/*
[cases_canton_total_dict enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(id key, id obj, BOOL *stop) {
    NSString *dict_date = (NSString*)key;
    NSString *dict_number = (NSString*)obj;
    NSLog(@"%@ / %@", dict_date, dict_number);
}];
*/

//NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//[dateFormatter setDateFormat:@"yyyy-MM-dd"];

- (void)cleanupDocumentsDirectory {
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cases_total_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_TOTAL_FILE];
    NSString *cases_fatalities_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_FATALITIES_FILE];
    NSString *cases_hospitalized_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_HOSPITALIZED_FILE];
    NSString *cases_vent_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_VENT_FILE];
    NSString *cases_icu_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_ICU_FILE];
    NSString *cases_released_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_RELEASED_FILE];
    NSString *cases_tested_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_TESTED_FILE];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cases_total_filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cases_total_filepath error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:cases_fatalities_filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cases_fatalities_filepath error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:cases_hospitalized_filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cases_hospitalized_filepath error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:cases_vent_filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cases_vent_filepath error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:cases_icu_filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cases_icu_filepath error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:cases_released_filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cases_released_filepath error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:cases_tested_filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cases_tested_filepath error:nil];
    }
}

- (NSDictionary*)getLatestTotalCasesForCaseFileNameAndCantonCode:(NSString*)caseFileName cantonCode:(NSString *)cantonCode {
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cases_filepath = [documentsDirectoryPath stringByAppendingPathComponent:caseFileName];
    
    /*
    if ([[NSFileManager defaultManager] fileExistsAtPath:cases_filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cases_filepath error:nil];
    }
    */
    
    NSString *src_cases_file_wo_ext = [caseFileName stringByDeletingPathExtension];
    NSString *src_cases_file = [src_cases_file_wo_ext stringByAppendingString:@".json_dl"];
    NSString *src_filepath = [documentsDirectoryPath stringByAppendingPathComponent:src_cases_file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:src_filepath]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:cases_filepath]) {
            [[NSFileManager defaultManager] removeItemAtPath:cases_filepath error:nil];
        }
        [[NSFileManager defaultManager] copyItemAtPath:src_filepath toPath:cases_filepath error:NULL];
    } else {
        if (![[NSFileManager defaultManager] fileExistsAtPath:cases_filepath]) {
            NSLog(@"getLatestTotalCasesForCaseFileNameAndCantonCode, source file inexistent!");
            return nil;
        }
    }
    
    NSData *cases_total_data = [NSData dataWithContentsOfFile:cases_filepath];
    if (!cases_total_data) {
        return nil;
    }
    NSError *error;
    NSDictionary *cases_total_dict = [NSJSONSerialization JSONObjectWithData:cases_total_data options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    NSDictionary *cases_canton_total_dict = [cases_total_dict objectForKey:cantonCode];
    //NSLog(@"Canton: %@", cantonCode);
    //NSLog(@"%@", cases_canton_total_dict);
    //NSLog(@"%@", cases_total_dict);

    NSArray *sorted_keys = [[cases_canton_total_dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    __block NSString *dict_date = nil;
    __block NSNumber *dict_number = nil;
    [sorted_keys enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *dict_date_test = (NSString*)obj;
        //NSLog(@"%@", dict_date);
        NSNumber *dict_number_test = [cases_canton_total_dict objectForKey:dict_date_test];
        //NSLog(@"%@ / %@", dict_date, dict_number);
        if (![dict_number_test isKindOfClass:[NSNull class]]) {
            dict_date = dict_date_test;
            dict_number = dict_number_test;
            *stop = true;
        }
    }];
    if (dict_date && dict_number) {
        return [NSDictionary dictionaryWithObject:dict_number forKey:dict_date];
    }
    return nil;
}

- (NSDictionary*)getLatestTotalCasesForCantonCode:(NSString *)cantonCode {
    return [self getLatestTotalCasesForCaseFileNameAndCantonCode:CASES_TOTAL_FILE cantonCode:cantonCode];
}

- (NSDictionary*)getLatestFatalitiesCasesForCantonCode:(NSString *)cantonCode {
    return [self getLatestTotalCasesForCaseFileNameAndCantonCode:CASES_FATALITIES_FILE cantonCode:cantonCode];
}

- (NSDictionary*)getLatestHospitalizedCasesForCantonCode:(NSString *)cantonCode {
    return [self getLatestTotalCasesForCaseFileNameAndCantonCode:CASES_HOSPITALIZED_FILE cantonCode:cantonCode];
}

- (NSDictionary*)getLatestVentCasesForCantonCode:(NSString *)cantonCode {
    return [self getLatestTotalCasesForCaseFileNameAndCantonCode:CASES_VENT_FILE cantonCode:cantonCode];
}

- (NSDictionary*)getLatestICUCasesForCantonCode:(NSString *)cantonCode {
    return [self getLatestTotalCasesForCaseFileNameAndCantonCode:CASES_ICU_FILE cantonCode:cantonCode];
}

- (NSDictionary*)getLatestReleasedCasesForCantonCode:(NSString *)cantonCode {
    return [self getLatestTotalCasesForCaseFileNameAndCantonCode:CASES_RELEASED_FILE cantonCode:cantonCode];
}

- (NSDictionary*)getLatestTestedCasesForCantonCode:(NSString *)cantonCode {
    return [self getLatestTotalCasesForCaseFileNameAndCantonCode:CASES_TESTED_FILE cantonCode:cantonCode];
}

- (NSArray*)getCasesDatesForCantonCode:(NSString*)caseFileName cantonCode:(NSString *)cantonCode {
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cases_filepath = [documentsDirectoryPath stringByAppendingPathComponent:caseFileName];
    
    /*
    if ([[NSFileManager defaultManager] fileExistsAtPath:cases_filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cases_filepath error:nil];
    }
    */
    
    NSString *src_cases_file_wo_ext = [caseFileName stringByDeletingPathExtension];
    NSString *src_cases_file = [src_cases_file_wo_ext stringByAppendingString:@".json_dl"];
    NSString *src_filepath = [documentsDirectoryPath stringByAppendingPathComponent:src_cases_file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:src_filepath]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:cases_filepath]) {
            [[NSFileManager defaultManager] removeItemAtPath:cases_filepath error:nil];
        }
        [[NSFileManager defaultManager] copyItemAtPath:src_filepath toPath:cases_filepath error:NULL];
    } else {
        if (![[NSFileManager defaultManager] fileExistsAtPath:cases_filepath]) {
            NSLog(@"getLatestTotalCasesForCaseFileNameAndCantonCode, source file inexistent!");
            return nil;
        }
    }
  
    NSData *cases_data = [NSData dataWithContentsOfFile:cases_filepath];
    if (!cases_data) {
        return nil;
    }
    NSError *error;
    NSDictionary *cases_dict = [NSJSONSerialization JSONObjectWithData:cases_data options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    NSDictionary *cases_canton_dict = [cases_dict objectForKey:cantonCode];
    //NSLog(@"Canton: %@", cantonCode);
    //NSLog(@"%@", cases_canton_total_dict);
    //NSLog(@"%@", cases_total_dict);

    NSArray *sorted_keys = [[cases_canton_dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    __block NSMutableArray *date_array = [NSMutableArray array];
    [sorted_keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *dict_date_str = (NSString*)obj;
        //NSLog(@"%@", dict_date);
        NSDate *dict_date = [dateFormatter dateFromString:dict_date_str];
        [date_array addObject:dict_date];
    }];
    if (date_array && ([date_array count] != 0)) {
        return [NSArray arrayWithArray:date_array];
    }
    return nil;
}

- (NSArray*)getCasesNumbersForCantonCode:(NSString*)caseFileName cantonCode:(NSString *)cantonCode {
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *cases_filepath = [documentsDirectoryPath stringByAppendingPathComponent:caseFileName];
 
    /*
    if ([[NSFileManager defaultManager] fileExistsAtPath:cases_filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:cases_filepath error:nil];
    }
    */
    
    NSString *src_cases_file_wo_ext = [caseFileName stringByDeletingPathExtension];
    NSString *src_cases_file = [src_cases_file_wo_ext stringByAppendingString:@".json_dl"];
    NSString *src_filepath = [documentsDirectoryPath stringByAppendingPathComponent:src_cases_file];
    if ([[NSFileManager defaultManager] fileExistsAtPath:src_filepath]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:cases_filepath]) {
            [[NSFileManager defaultManager] removeItemAtPath:cases_filepath error:nil];
        }
        [[NSFileManager defaultManager] copyItemAtPath:src_filepath toPath:cases_filepath error:NULL];
    } else {
        if (![[NSFileManager defaultManager] fileExistsAtPath:cases_filepath]) {
            NSLog(@"getLatestTotalCasesForCaseFileNameAndCantonCode, source file inexistent!");
            return nil;
        }
    }
  
    NSData *cases_data = [NSData dataWithContentsOfFile:cases_filepath];
    if (!cases_data) {
        return nil;
    }
    NSError *error;
    NSDictionary *cases_dict = [NSJSONSerialization JSONObjectWithData:cases_data options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    NSDictionary *cases_canton_dict = [cases_dict objectForKey:cantonCode];
    //NSLog(@"Canton: %@", cantonCode);
    //NSLog(@"%@", cases_canton_total_dict);
    //NSLog(@"%@", cases_total_dict);

    NSArray *sorted_keys = [[cases_canton_dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    __block NSMutableArray *numbers_array = [NSMutableArray array];
    [sorted_keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *dict_date_str = (NSString*)obj;
        //NSLog(@"%@", dict_date_str);
        NSNumber *dict_number = [cases_canton_dict objectForKey:dict_date_str];
        //NSLog(@"%@ / %@", dict_date_str, dict_number);
        if ([dict_number isKindOfClass:[NSNull class]]) {
            [numbers_array addObject:@0];
        } else {
            [numbers_array addObject:dict_number];
        }
    }];
    //NSLog(@"Array: %@", numbers_array);
    if (numbers_array && ([numbers_array count] != 0)) {
        return [NSArray arrayWithArray:numbers_array];
    }
    return nil;
}

- (NSArray*)getTotalCasesDatesForCantonCode:(NSString *)cantonCode {
    return [self getCasesDatesForCantonCode:CASES_TOTAL_FILE cantonCode:cantonCode];
}

- (NSArray*)getTotalCasesNumbersForCantonCode:(NSString *)cantonCode {
    return [self getCasesNumbersForCantonCode:CASES_TOTAL_FILE cantonCode:cantonCode];
}

@end
