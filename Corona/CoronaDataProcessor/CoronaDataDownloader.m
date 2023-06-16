//
//  CoronaDataDownloader.m
//  Corona
//
//  Created by Alain on 16.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import "CoronaDataDownloader.h"
#import "AFNetworking.h"
#import "Objective-Zip.h"

#define CASES_TOTAL_FILE            @"covid19_cases_switzerland_openzh.json_dl"
#define CASES_FATALITIES_FILE       @"covid19_fatalities_switzerland_openzh.json_dl"
#define CASES_HOSPITALIZED_FILE     @"covid19_hospitalized_switzerland_openzh.json_dl"
#define CASES_VENT_FILE             @"covid19_vent_switzerland_openzh.json_dl"
#define CASES_ICU_FILE              @"covid19_icu_switzerland_openzh.json_dl"
#define CASES_RELEASED_FILE         @"covid19_released_switzerland_openzh.json_dl"
#define CASES_TESTED_FILE           @"covid19_tested_switzerland_openzh.json_dl"

// corona-data.ch
#define CASES_TOTAL_FILE_CD         @"https://github.com/daenuprobst/covid19-cases-switzerland/raw/master/covid19_cases_switzerland_openzh.json"
#define CASES_FATALITIES_FILE_CD    @"https://github.com/daenuprobst/covid19-cases-switzerland/raw/master/covid19_fatalities_switzerland_openzh.json"
#define CASES_HOSPITALIZED_FILE_CD  @"https://github.com/daenuprobst/covid19-cases-switzerland/raw/master/covid19_hospitalized_switzerland_openzh.json"
#define CASES_VENT_FILE_CD          @"https://github.com/daenuprobst/covid19-cases-switzerland/raw/master/covid19_vent_switzerland_openzh.json"
#define CASES_ICU_FILE_CD           @"https://github.com/daenuprobst/covid19-cases-switzerland/raw/master/covid19_icu_switzerland_openzh.json"
#define CASES_RELEASED_FILE_CD      @"https://github.com/daenuprobst/covid19-cases-switzerland/raw/master/covid19_released_switzerland_openzh.json"
#define CASES_TESTED_FILE_CD        @"https://github.com/daenuprobst/covid19-cases-switzerland/raw/master/covid19_tested_switzerland_openzh.json"


@interface CoronaDataDownloader ()
//@property (nonatomic, strong) NSOperationQueue *downloadOperationQueue;
@property (nonatomic, assign) BOOL downloadRequestInProgress;
@property (nonatomic, assign) BOOL isNetworkReachable;
@property (nonatomic, assign) BOOL forceDownloadOnNetworkAvailabilityChange;

@property (nonatomic, assign) BOOL total_cases_downloaded;
@property (nonatomic, assign) BOOL fatalities_cases_downloaded;
@property (nonatomic, assign) BOOL hospitalized_cases_downloaded;
@property (nonatomic, assign) BOOL vent_cases_downloaded;
@property (nonatomic, assign) BOOL icu_cases_downloaded;
@property (nonatomic, assign) BOOL released_cases_downloaded;
@property (nonatomic, assign) BOOL tested_cases_downloaded;

@end

@implementation CoronaDataDownloader

+ (CoronaDataDownloader *)sharedCoronaDataDownloader
{
    static CoronaDataDownloader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoronaDataDownloader alloc] init];
        sharedInstance.forceDownloadOnNetworkAvailabilityChange = NO;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
              NSLog(@"Network status changed.");
             //check for isReachable here
            sharedInstance.isNetworkReachable = ((status == AFNetworkReachabilityStatusReachableViaWiFi) ||
                                                 (status == AFNetworkReachabilityStatusReachableViaWWAN));
            if (sharedInstance.isNetworkReachable && sharedInstance.forceDownloadOnNetworkAvailabilityChange) {
                sharedInstance.forceDownloadOnNetworkAvailabilityChange = NO;
                [sharedInstance sendCoronaDataDownloadRequest:YES successBlock:^{
                    
                } failureBlock:^(NSUInteger failureCode) {
                    
                }];
            }
        }];
    });
    return sharedInstance;
}

- (void) dealloc {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (BOOL) isDownloadOperationInProgress {
    return _downloadRequestInProgress;
}

- (void) cancelDownloadOperations {
    //NSLog(@"CoronaDataDownloader, cancelDownloadOperations");
    //[_downloadOperationQueue cancelAllOperations];
}

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

- (void) resetAllDownloadFlags {
    _total_cases_downloaded = NO;
    _fatalities_cases_downloaded = NO;
    _hospitalized_cases_downloaded = NO;
    _vent_cases_downloaded = NO;
    _icu_cases_downloaded = NO;
    _released_cases_downloaded = NO;
    _tested_cases_downloaded = NO;
}

- (BOOL) areAllFilesDownloaded {
    return _total_cases_downloaded &&
           _fatalities_cases_downloaded &&
           _hospitalized_cases_downloaded &&
           _vent_cases_downloaded &&
           _icu_cases_downloaded &&
           _released_cases_downloaded &&
           _tested_cases_downloaded;;
}

- (void) sendCoronaDataDownloadRequest:(BOOL)zoneZeroAppsServer
                          successBlock:(void(^)(void))successBlock
                          failureBlock:(void(^)(NSUInteger))failureBlock {
    
    if (_isNetworkReachable) {
        NSLog(@"Downloading corona data...");
        [self cancelDownloadOperations];
        _downloadRequestInProgress = YES;
        [self resetAllDownloadFlags];
        
        [self cleanupDocumentsDirectory];
        
        //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSString *path = [paths objectAtIndex:0];
        //NSLog(@"Documents directory content: %@", path);
        //NSLog(@"Documents directory content: %@", [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil]);

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSURL *URL_CASES_TOTAL = [NSURL URLWithString:CASES_TOTAL_FILE_CD];
        NSURLRequest *request_cases_total = [NSURLRequest requestWithURL:URL_CASES_TOTAL];

        NSURLSessionDownloadTask *downloadTaskTotal = [manager downloadTaskWithRequest:request_cases_total progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:CASES_TOTAL_FILE];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"1. File downloaded to: %@", filePath);
            self.total_cases_downloaded = YES;
            if ([self areAllFilesDownloaded]) {
                self.downloadRequestInProgress = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CoronaDataUpdateAvailable"
                                                                    object:self];
                self.downloadRequestInProgress = NO;
            }
            //NSLog(@"Error: %@", [error localizedDescription]);
        }];
        [downloadTaskTotal resume];
        
        NSURL *URL_FATALITIES_TOTAL = [NSURL URLWithString:CASES_FATALITIES_FILE_CD];
        NSURLRequest *request_cases_fatalities = [NSURLRequest requestWithURL:URL_FATALITIES_TOTAL];

        NSURLSessionDownloadTask *downloadTaskFatalities = [manager downloadTaskWithRequest:request_cases_fatalities progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:CASES_FATALITIES_FILE];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"2. File downloaded to: %@", filePath);
            self.fatalities_cases_downloaded = YES;
            if ([self areAllFilesDownloaded]) {
                self.downloadRequestInProgress = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CoronaDataUpdateAvailable"
                                                                    object:self];
                self.downloadRequestInProgress = NO;
            }
            //NSLog(@"Error: %@", [error localizedDescription]);
        }];
        [downloadTaskFatalities resume];
        
        NSURL *URL_HOSPITALIZED_TOTAL = [NSURL URLWithString:CASES_HOSPITALIZED_FILE_CD];
        NSURLRequest *request_cases_hospitalized = [NSURLRequest requestWithURL:URL_HOSPITALIZED_TOTAL];

        NSURLSessionDownloadTask *downloadTaskHospitalized = [manager downloadTaskWithRequest:request_cases_hospitalized progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:CASES_HOSPITALIZED_FILE];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"3. File downloaded to: %@", filePath);
            self.hospitalized_cases_downloaded = YES;
            if ([self areAllFilesDownloaded]) {
                self.downloadRequestInProgress = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CoronaDataUpdateAvailable"
                                                                    object:self];
                self.downloadRequestInProgress = NO;
            }
            //NSLog(@"Error: %@", [error localizedDescription]);
        }];
        [downloadTaskHospitalized resume];
        
        NSURL *URL_VENT_TOTAL = [NSURL URLWithString:CASES_VENT_FILE_CD];
        NSURLRequest *request_cases_vent = [NSURLRequest requestWithURL:URL_VENT_TOTAL];

        NSURLSessionDownloadTask *downloadTaskVent = [manager downloadTaskWithRequest:request_cases_vent progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:CASES_VENT_FILE];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"4. File downloaded to: %@", filePath);
            self.vent_cases_downloaded = YES;
            if ([self areAllFilesDownloaded]) {
                self.downloadRequestInProgress = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CoronaDataUpdateAvailable"
                                                                    object:self];
                self.downloadRequestInProgress = NO;
            }
            //NSLog(@"Error: %@", [error localizedDescription]);
        }];
        [downloadTaskVent resume];
        
        NSURL *URL_ICU_TOTAL = [NSURL URLWithString:CASES_ICU_FILE_CD];
        NSURLRequest *request_cases_icu = [NSURLRequest requestWithURL:URL_ICU_TOTAL];

        NSURLSessionDownloadTask *downloadTaskICU = [manager downloadTaskWithRequest:request_cases_icu progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:CASES_ICU_FILE];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"5. File downloaded to: %@", filePath);
            self.icu_cases_downloaded = YES;
            if ([self areAllFilesDownloaded]) {
                self.downloadRequestInProgress = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CoronaDataUpdateAvailable"
                                                                    object:self];
                self.downloadRequestInProgress = NO;
            }
            //NSLog(@"Error: %@", [error localizedDescription]);
        }];
        [downloadTaskICU resume];
        
        NSURL *URL_RELEASED_TOTAL = [NSURL URLWithString:CASES_RELEASED_FILE_CD];
        NSURLRequest *request_cases_released = [NSURLRequest requestWithURL:URL_RELEASED_TOTAL];

        NSURLSessionDownloadTask *downloadTaskReleased = [manager downloadTaskWithRequest:request_cases_released progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:CASES_RELEASED_FILE];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"6. File downloaded to: %@", filePath);
            self.released_cases_downloaded = YES;
            if ([self areAllFilesDownloaded]) {
                self.downloadRequestInProgress = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CoronaDataUpdateAvailable"
                                                                    object:self];
                self.downloadRequestInProgress = NO;
            }
            //NSLog(@"Error: %@", [error localizedDescription]);
        }];
        [downloadTaskReleased resume];
        
        NSURL *URL_TESTED_TOTAL = [NSURL URLWithString:CASES_TESTED_FILE_CD];
        NSURLRequest *request_cases_tested = [NSURLRequest requestWithURL:URL_TESTED_TOTAL];

        NSURLSessionDownloadTask *downloadTaskTested = [manager downloadTaskWithRequest:request_cases_tested progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:CASES_TESTED_FILE];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            //NSLog(@"7. File downloaded to: %@", filePath);
            self.tested_cases_downloaded = YES;
            if ([self areAllFilesDownloaded]) {
                self.downloadRequestInProgress = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CoronaDataUpdateAvailable"
                                                                    object:self];
                self.downloadRequestInProgress = NO;
            }
            //NSLog(@"Error: %@", [error localizedDescription]);
        }];
        [downloadTaskTested resume];
    } else {
        NSLog(@"Downloading corona data, no network!");
        _forceDownloadOnNetworkAvailabilityChange = YES;
        
    }
}

- (void) setFirstTimeDownloadFlag {
    _forceDownloadOnNetworkAvailabilityChange = YES;
}

@end
