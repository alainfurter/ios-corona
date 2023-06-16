//
//  AppDelegate.m
//  Corona
//
//  Created by Alain on 13.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "CantonsSettingsController.h"
#import "CoronaDataDownloader.h"

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

@interface AppDelegate ()
@property (nonatomic, strong) NSTimer *downloadTimer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    #ifdef kSwissPlates
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-2847204440687988~8832429157"];

    [[AFStoreController sharedAFStoreController] openSwissPlatesShop:^(void) {
        NSLog(@"AppDelegate, didFinishLaunchingWithOptions, AFStoreController, openSwissPlatesShop, success");
    } failureBlock:^(void) {
        NSLog(@"AppDelegate, didFinishLaunchingWithOptions, AFStoreController, openSwissPlatesShop, failed");
    } oldPurchaseRecords:oldSwissPlatesProductsDictionary];
    
    #endif

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //Testing first use
    //[prefs removeObjectForKey:@"canton_set"];
    
    NSString *cantonindexstring = [prefs objectForKey:@"canton_set"];
    if (cantonindexstring) {
        #ifdef kLoggingIsOn
            NSLog(@"AppDelegate, didfinishlaunchingwithoptions, cantonindexstring set: %@", cantonindexstring);
        #endif
        NSUInteger cantonindex = [cantonindexstring integerValue];
        [[CantonsSettingsController sharedCantonsSettingsController] setSelectedCanton:cantonindex];
    } else {
        NSLog(@"AppDelegate, first time use. Copy initial data files...");
        NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *cases_total_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_TOTAL_FILE_DL];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cases_total_filepath]) {
              NSString *src_cases_total_file_wo_ext = [CASES_TOTAL_FILE stringByDeletingPathExtension];
              NSString *src_cases_total_filepath = [[NSBundle mainBundle] pathForResource:src_cases_total_file_wo_ext ofType:@"json"];
              if (src_cases_total_filepath) {
                  [[NSFileManager defaultManager]  copyItemAtPath:src_cases_total_filepath toPath:cases_total_filepath error:NULL];
              }
        }
        NSString *cases_fatalities_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_FATALITIES_FILE_DL];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cases_fatalities_filepath]) {
              NSString *src_cases_fatalities_file_wo_ext = [CASES_FATALITIES_FILE stringByDeletingPathExtension];
              NSString *src_cases_fatalities_filepath = [[NSBundle mainBundle] pathForResource:src_cases_fatalities_file_wo_ext ofType:@"json"];
              if (src_cases_fatalities_filepath) {
                  [[NSFileManager defaultManager]  copyItemAtPath:src_cases_fatalities_filepath toPath:cases_fatalities_filepath error:NULL];
              }
        }
        NSString *cases_hospitalized_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_HOSPITALIZED_FILE_DL];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cases_hospitalized_filepath]) {
              NSString *src_cases_hospitalized_file_wo_ext = [CASES_HOSPITALIZED_FILE stringByDeletingPathExtension];
              NSString *src_cases_hospitalized_filepath = [[NSBundle mainBundle] pathForResource:src_cases_hospitalized_file_wo_ext ofType:@"json"];
              if (src_cases_hospitalized_filepath) {
                  [[NSFileManager defaultManager]  copyItemAtPath:src_cases_hospitalized_filepath toPath:cases_hospitalized_filepath error:NULL];
              }
        }
        NSString *cases_vent_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_VENT_FILE_DL];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cases_vent_filepath]) {
              NSString *src_cases_vent_file_wo_ext = [CASES_VENT_FILE stringByDeletingPathExtension];
              NSString *src_cases_vent_filepath = [[NSBundle mainBundle] pathForResource:src_cases_vent_file_wo_ext ofType:@"json"];
              if (src_cases_vent_filepath) {
                  [[NSFileManager defaultManager]  copyItemAtPath:src_cases_vent_filepath toPath:cases_vent_filepath error:NULL];
              }
        }
        NSString *cases_icu_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_ICU_FILE_DL];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cases_icu_filepath]) {
              NSString *src_cases_icu_file_wo_ext = [CASES_ICU_FILE stringByDeletingPathExtension];
              NSString *src_cases_icu_filepath = [[NSBundle mainBundle] pathForResource:src_cases_icu_file_wo_ext ofType:@"json"];
              if (src_cases_icu_filepath) {
                  [[NSFileManager defaultManager]  copyItemAtPath:src_cases_icu_filepath toPath:cases_icu_filepath error:NULL];
              }
        }
        NSString *cases_released_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_RELEASED_FILE_DL];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cases_released_filepath]) {
              NSString *src_cases_released_file_wo_ext = [CASES_RELEASED_FILE stringByDeletingPathExtension];
              NSString *src_cases_released_filepath = [[NSBundle mainBundle] pathForResource:src_cases_released_file_wo_ext ofType:@"json"];
              if (src_cases_released_filepath) {
                  [[NSFileManager defaultManager]  copyItemAtPath:src_cases_released_filepath toPath:cases_released_filepath error:NULL];
              }
        }
        NSString *cases_tested_filepath = [documentsDirectoryPath stringByAppendingPathComponent:CASES_TESTED_FILE_DL];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cases_released_filepath]) {
              NSString *src_cases_tested_file_wo_ext = [CASES_TESTED_FILE stringByDeletingPathExtension];
              NSString *src_cases_tested_filepath = [[NSBundle mainBundle] pathForResource:src_cases_tested_file_wo_ext ofType:@"json"];
              if (src_cases_tested_filepath) {
                  [[NSFileManager defaultManager]  copyItemAtPath:src_cases_tested_filepath toPath:cases_tested_filepath error:NULL];
              }
        }
    }
    
    // Delay execution of my block for 10 seconds.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self downloadCoronaData];
    });
        
    _downloadTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                      target:self
                                                    selector:@selector(downloadCoronaData)
                                                    userInfo:nil
                                                     repeats:YES];
    
    //[[UINavigationBar appearance] setTranslucent:NO];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
    [_downloadTimer invalidate];
    _downloadTimer = nil;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    _downloadTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                      target:self
                                                    selector:@selector(downloadCoronaData)
                                                    userInfo:nil
                                                     repeats:YES];
}

-(void)downloadCoronaData {
    NSLog(@"AppDelegate. DownloadCoronaData...");
    [[CoronaDataDownloader sharedCoronaDataDownloader] sendCoronaDataDownloadRequest:YES successBlock:^{
        
    } failureBlock:^(NSUInteger failureCode) {
        
    }];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
