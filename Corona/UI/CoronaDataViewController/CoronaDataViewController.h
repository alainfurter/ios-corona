//
//  CoronaDataViewController.h
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HCLineChartView.h"
#import "HCChartSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoronaDataViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *chTotalCases;
@property (nonatomic) IBOutlet UILabel *chFatalitiesCases;
@property (nonatomic) IBOutlet UILabel *chHospitalizedCases;
@property (nonatomic) IBOutlet UILabel *chICUCases;
@property (nonatomic) IBOutlet UILabel *chVentCases;


@property (nonatomic) IBOutlet UILabel *cantonTotalCases;
@property (nonatomic) IBOutlet UILabel *cantonFatalitiesCases;
@property (nonatomic) IBOutlet UILabel *cantonHospitalizedCases;
@property (nonatomic) IBOutlet UILabel *cantonICUCases;
@property (nonatomic) IBOutlet UILabel *cantonVentCases;

@property (nonatomic) IBOutlet UIImageView *cantonImage;

@property (strong, nonatomic) IBOutlet HCLineChartView *cantonHcLineChartView;
@property (strong, nonatomic) IBOutlet HCLineChartView *chHcLineChartView;

- (void) setCantonsConfigArrayIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
