//
//  CoronaDataDownloader.h
//  Corona
//
//  Created by Alain on 16.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define DOWNLOADREQUESTFAILED            1

@interface CoronaDataDownloader : NSObject

+ (CoronaDataDownloader *)sharedCoronaDataDownloader;

- (BOOL) isDownloadOperationInProgress;
- (void) cancelDownloadOperations;

- (void) sendCoronaDataDownloadRequest:(BOOL)zoneZeroAppsServer
                          successBlock:(void(^)(void))successBlock
                          failureBlock:(void(^)(NSUInteger))failureBlock;

- (void) setFirstTimeDownloadFlag;


@end

NS_ASSUME_NONNULL_END
