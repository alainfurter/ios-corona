//
//  SelectCantonTableViewController.h
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelectCantonTableViewControllerDelegate <NSObject>
@optional
- (void)cantonIndexSelected:(NSInteger)index;
@end

@interface SelectCantonTableViewController : UITableViewController
@property (weak, readwrite, nonatomic) id<SelectCantonTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
