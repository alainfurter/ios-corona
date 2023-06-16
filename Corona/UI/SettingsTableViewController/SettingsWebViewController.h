//
//  SettingsWebViewController.h
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsWebViewController : UIViewController
- (void)loadWebURL:(NSString *)weburl;
- (void)setWebURL:(NSString *)weburl;
@end

NS_ASSUME_NONNULL_END
