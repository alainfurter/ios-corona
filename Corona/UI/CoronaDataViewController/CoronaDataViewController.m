//
//  CoronaDataViewController.m
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CoronaDataViewController.h"
#import "SWRevealViewController.h"
#import "UIColor+SwissPlates.h"
#import "UIImage+SwissPlates.h"
#import "AppConfig.h"
#import "AppDelegate.h"
#import "SelectCantonTableViewController.h"
#import "CoronaDataProcessor.h"
#import "CoronaDataDownloader.h"

#ifdef kSwissPlates
@import GoogleMobileAds;
#import "AFStoreController.h"
#import "StoreViewController.h"
#import "PlatesMessagesController.h"
#endif

#define MAXTEXTLENGTHSECTION0       22
#define MAXTEXTLENGTHSECTION1       28

#define CANTONIMAGEWIDTH            22
#define CANTONIMAGEHEIGHT           22

#define SEARCHBUTTONIMAGEWIDTH      120
#define SEARCHBUTTONIMAGEHEIGHT     120

#define TABLEVIEWBOTTOMINSET        90

@interface CoronaDataViewController () <SelectCantonTableViewControllerDelegate
    #ifdef kSwissPlates
        , GADInterstitialDelegate, GADBannerViewDelegate
    #endif
    >

@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

#ifdef kSwissPlates
@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) NSArray *bannerViewContraints;
@property (assign) BOOL shopIsReinitializing;
#endif

@end

@implementation CoronaDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = [UIColor platesViewControllerNavigationbarColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    CGSize settingsImageSize =  CGSizeMake(40.0f, 40.0f);
    UIImage *settingsImage = [UIImage newImageFromMaskImage: [[UIImage optionsbutton] resizedImage: settingsImageSize interpolationQuality: kCGInterpolationDefault] inColor: [UIColor platesViewControllerNavigationbarBackButtonColor]];
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setBackgroundImage:settingsImage forState:UIControlStateNormal];
    [settingsButton sizeToFit];
    [settingsButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.leftBarButtonItem = settingsItem;
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    _chTotalCases.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    _cantonTotalCases.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(coronaDataUpdateAvailableNotification:)
                                                 name:@"CoronaDataUpdateAvailable"
                                               object:nil];
    
#ifdef kSwissPlates
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    if (![[AFStoreController sharedAFStoreController] isSwissPlatesFullVersionPurchased] && ![[AFStoreController sharedAFStoreController] isSwissPlatesAdsFreeVersionPurchased]) {
        self.interstitial = [self createAndLoadInterstitial];
        self.shopIsReinitializing = NO;
        
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        self.bannerView.adUnitID = @"ca-app-pub-2847204440687988/6872408309";
        self.bannerView.rootViewController = self;
        self.bannerView.delegate = self;
        _bannerViewContraints = @[[NSLayoutConstraint constraintWithItem:_bannerView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.topLayoutGuide
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:0],
                                  [NSLayoutConstraint constraintWithItem:_bannerView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0]];
        GADRequest *request = [GADRequest request];
#ifdef kSwissPlatesTestAds
        request.testDevices = @[@"578faf477824a140de6a4a30d6622662", @"37111372ee69b5d0f65c24259ac77cf9", @"f8e129ca753417bcf25b60a2ef901af6", kGADSimulatorID];
#endif
        [self.bannerView loadRequest:request];
    }
#endif
    
    AppDelegate *appdelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];

    self.view.backgroundColor = [UIColor platesViewControllerBackgroundColor];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *cantonindexstring = [prefs objectForKey:@"canton_set"];
    //NSLog(@"PlatesViewController, viewdidload, cantonindexstring: %@", cantonindexstring);
    if (cantonindexstring) {
        NSInteger cantonindex = (NSUInteger)[cantonindexstring integerValue];
        if (cantonindex < [[CantonsSettingsController sharedCantonsSettingsController] getNumberOfCantons]) {
            NSString *cantonCode = [[CantonsSettingsController sharedCantonsSettingsController] getCantonCodeForCantonAtIndex:cantonindex];
            self.navigationController.title = cantonCode;
            [self setCantonsConfigArrayIndex:cantonindex];
        } else {
            self.navigationController.title = @"AG";
            [self setCantonsConfigArrayIndex:0];
        }
    } else {
        self.navigationController.title = @"AG";
        [self setCantonsConfigArrayIndex:0];
    }
    
#ifdef kSwissPlates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productPurchasedNotification:)
                                                 name:SwissPlatesProductPurchasedNotificationKey
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creditsByVideoAdsNotification:)
                                                 name:SwissPlates2CreditsByVideoAdsNotificationKey
                                               object:nil];
    
    if (![[AFStoreController sharedAFStoreController] isSwissPlatesFullVersionPurchased]) {
        CGSize storeImageSize =  CGSizeMake(20.0f, 20.0f);
        UIImage *storeImage = [UIImage newImageFromMaskImage: [[UIImage storeCart] resizedImage: storeImageSize interpolationQuality: kCGInterpolationDefault] inColor: [UIColor storeCartButtonColor]];
        NSString *creditString = [NSString stringWithFormat:@"%d", (int)[[AFStoreController sharedAFStoreController] countSwissPlatesCredits]];
        UIButton *storeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [storeButton setBackgroundImage:storeImage forState:UIControlStateNormal];
        //[storeButton setImage:storeImage forState:UIControlStateNormal];
        [storeButton setTitle:creditString forState:UIControlStateNormal];
        [storeButton setTitleColor:[UIColor storeCartButtonTitleColor] forState:UIControlStateNormal];
        [storeButton.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [storeButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [storeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, -50.0f, 0.0f, 0.0f)];
        [storeButton setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [storeButton sizeToFit];
        [storeButton addTarget:self action:@selector(showStore) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *storeItem = [[UIBarButtonItem alloc] initWithCustomView:storeButton];
        self.navigationItem.rightBarButtonItem = storeItem;
    }
#endif
}

#ifdef kSwissPlates
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#endif

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //NSLog(@"PlatesViewController, viewwillappear");
    
    NSLog(@"CoronaDataViewController. DownloadCoronaData...");
    [[CoronaDataDownloader sharedCoronaDataDownloader] sendCoronaDataDownloadRequest:YES successBlock:^{
        
    } failureBlock:^(NSUInteger failureCode) {
        
    }];
    
    [_cantonHcLineChartView drawChart];
    [_chHcLineChartView drawChart];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUInteger cantonindex = [[CantonsSettingsController sharedCantonsSettingsController] getSelectedCanton];
    NSString *cantonCode = [[CantonsSettingsController sharedCantonsSettingsController] getCantonCodeForCantonAtIndex:cantonindex];
    //NSLog(@"PlatesViewController, viewDidAppear, cantoncode: %@", cantonCode);
    self.navigationController.title = cantonCode;
    UIImage *image = [[[CantonsSettingsController sharedCantonsSettingsController] getCantonImageForCantonAtIndex:cantonindex] resizedImage: CGSizeMake(CANTONIMAGEWIDTH, CANTONIMAGEHEIGHT) interpolationQuality: kCGInterpolationDefault];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.navigationController.navigationBar.topItem setTitleView:imageView];
    _cantonImage.image = image;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *cantonindexstring = [prefs objectForKey:@"canton_set"];
    if (!cantonindexstring) {
        [self performSegueWithIdentifier:@"SelectCanton" sender:self];
    }
#ifdef kSwissPlates
    // Testing
    //[self performSegueWithIdentifier:@"GoToStore" sender:self];
    //[self performSegueWithIdentifier:@"SelectCanton" sender:self];
#endif
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCantonsConfigArrayIndex:(NSInteger)index {
    //NSLog(@"PlatesViewController, setcantonsconfigarray %d", (int)index);
    if (index < [[CantonsSettingsController sharedCantonsSettingsController] getNumberOfCantons]) {
        //_cantonIndex = index;
        [[CantonsSettingsController sharedCantonsSettingsController] setSelectedCanton:index];
        NSString *cantonCode = [[CantonsSettingsController sharedCantonsSettingsController] getCantonCodeForCantonAtIndex:index];
        //NSLog(@"PlatesViewController, setcantonsconfigarray, cantoncode: %@", cantonCode);
        self.navigationController.title = cantonCode;
        
        UIImage *image = [[[CantonsSettingsController sharedCantonsSettingsController] getCantonImageForCantonAtIndex:index] resizedImage: CGSizeMake(CANTONIMAGEWIDTH, CANTONIMAGEHEIGHT) interpolationQuality: kCGInterpolationDefault];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self.navigationController.navigationBar.topItem setTitleView:imageView];
        _cantonImage.image = image;
        
        [self updateCoronaDataValues];
    }
}

- (void) coronaDataUpdateAvailableNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"CoronaDataUpdateAvailable"]) {
        NSLog(@"coronaDataUpdateAvailableNotification");
        [self updateCoronaDataValues];
    }
}

- (void) updateCoronaDataValues {
    NSLog(@"updateCoronaDataValues");
    NSInteger cantonIndex = [[CantonsSettingsController sharedCantonsSettingsController] getSelectedCanton];
    NSString *cantonCode = [[CantonsSettingsController sharedCantonsSettingsController] getCantonCodeForCantonAtIndex:cantonIndex];
    
    NSDictionary *canton_total_cases = [[CoronaDataProcessor sharedCoronaDataProcessor] getLatestTotalCasesForCantonCode:cantonCode];
    NSDictionary *canton_fatalities_cases = [[CoronaDataProcessor sharedCoronaDataProcessor] getLatestFatalitiesCasesForCantonCode:cantonCode];
    NSDictionary *canton_hospitalized_cases = [[CoronaDataProcessor sharedCoronaDataProcessor] getLatestHospitalizedCasesForCantonCode:cantonCode];
    NSDictionary *canton_vent_cases = [[CoronaDataProcessor sharedCoronaDataProcessor] getLatestVentCasesForCantonCode:cantonCode];
    
    NSDictionary *ch_total_cases = [[CoronaDataProcessor sharedCoronaDataProcessor] getLatestTotalCasesForCantonCode:@"CH"];
    NSDictionary *ch_fatalities_cases = [[CoronaDataProcessor sharedCoronaDataProcessor] getLatestFatalitiesCasesForCantonCode:@"CH"];
    NSDictionary *ch_hospitalized_cases = [[CoronaDataProcessor sharedCoronaDataProcessor] getLatestHospitalizedCasesForCantonCode:@"CH"];
    NSDictionary *ch_vent_cases = [[CoronaDataProcessor sharedCoronaDataProcessor] getLatestVentCasesForCantonCode:@"CH"];
    
    //NSLog(@"%@: %@", cantonCode, canton_total_cases);
    //NSLog(@"%@: %@", @"CH", ch_total_cases);
    
    NSNumber *cantonTotalCases = [[canton_total_cases allValues] lastObject];
    _cantonTotalCases.text = cantonTotalCases ? [cantonTotalCases stringValue] : @"-";
    NSNumber *cantonFatalitiesCases = [[canton_fatalities_cases allValues] lastObject];
    _cantonFatalitiesCases.text = cantonFatalitiesCases ? [cantonFatalitiesCases stringValue] : @"-";
    NSNumber *cantonHospitalizedCases = [[canton_hospitalized_cases allValues] lastObject];
    _cantonHospitalizedCases.text = cantonHospitalizedCases ? [cantonHospitalizedCases stringValue] : @"-";
    NSNumber *cantonVentCases = [[canton_vent_cases allValues] lastObject];
    _cantonVentCases.text = cantonVentCases ? [cantonVentCases stringValue] : @"-";

    NSNumber *chTotalCases = [[ch_total_cases allValues] lastObject];
    _chTotalCases.text = chTotalCases ? [chTotalCases stringValue] : @"-";
    NSNumber *chFatalitiesCases = [[ch_fatalities_cases allValues] lastObject];
    _chFatalitiesCases.text = chFatalitiesCases ? [chFatalitiesCases stringValue] : @"-";
    NSNumber *chHospitalizedCases = [[ch_hospitalized_cases allValues] lastObject];
    _chHospitalizedCases.text = chHospitalizedCases ? [chHospitalizedCases stringValue] : @"-";
    NSNumber *chVentCases = [[ch_vent_cases allValues] lastObject];
    _chVentCases.text = chVentCases ? [chVentCases stringValue] : @"-";
    
    NSArray *cantonTotalDates = [[CoronaDataProcessor sharedCoronaDataProcessor] getTotalCasesDatesForCantonCode:cantonCode];
    NSArray *cantonTotalNumbers = [[CoronaDataProcessor sharedCoronaDataProcessor] getTotalCasesNumbersForCantonCode:cantonCode];
    
    if ([cantonTotalDates count] >= 31 && [cantonTotalNumbers count] >= 31) {
        NSArray *cantonTotalDates_1M = [[cantonTotalDates subarrayWithRange:NSMakeRange([cantonTotalDates count] - 31, 31)] mutableCopy];
        NSArray *cantonTotalNumbers_1M = [[cantonTotalNumbers subarrayWithRange:NSMakeRange([cantonTotalDates count] - 31, 31)] mutableCopy];
        
        [_cantonHcLineChartView updateChartWithXElements:cantonTotalDates_1M yElements:cantonTotalNumbers_1M];
        [_cantonHcLineChartView drawChart];
    }
    
    NSArray *chTotalDates = [[CoronaDataProcessor sharedCoronaDataProcessor] getTotalCasesDatesForCantonCode:@"CH"];
    NSArray *chTotalNumbers = [[CoronaDataProcessor sharedCoronaDataProcessor] getTotalCasesNumbersForCantonCode:@"CH"];
    
    if ([chTotalDates count] >= 31 && [chTotalNumbers count] >= 31) {
        NSArray *chTotalDates_1M = [[chTotalDates subarrayWithRange:NSMakeRange([chTotalDates count] - 31, 31)] mutableCopy];
        NSArray *chTotalNumbers_1M = [[chTotalNumbers subarrayWithRange:NSMakeRange([chTotalDates count] - 31, 31)] mutableCopy];
    
        [_chHcLineChartView updateChartWithXElements:chTotalDates_1M yElements:chTotalNumbers_1M];
        [_chHcLineChartView drawChart];
     }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UIButton class]]) {
        UIViewController *viewController = segue.destinationViewController;
        /*
        if ([viewController isKindOfClass:[PlatesSearchViewController class]]) {
            PlatesSearchViewController *platesSearchViewController = (PlatesSearchViewController *)viewController;
            platesSearchViewController.delegate = self;
        }
        */
    }
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        UIViewController *viewController = segue.destinationViewController;
        /*
        if ([viewController isKindOfClass:[OwnerDetailViewController class]]) {
            OwnerDetailViewController *ownerDetailViewController = (OwnerDetailViewController *)viewController;
            PlateTableviewCell *cell = (PlateTableviewCell *)sender;
            NSIndexPath *indexPath = [_platesTable indexPathForCell:cell];
            PlateDBEntry *plateDBEntry = (PlateDBEntry *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
            [ownerDetailViewController setPlatesOwnerLocation:plateDBEntry];
        }
        */
    }
    if ([sender isKindOfClass:[self class]]) {
        UIViewController *viewController = segue.destinationViewController;
        
        if ([viewController isKindOfClass:[SelectCantonTableViewController class]]) {
            SelectCantonTableViewController *selectCantonTableViewController = (SelectCantonTableViewController *)viewController;
            selectCantonTableViewController.delegate = self;
        }
        /*
        if ([viewController isKindOfClass:[PlatesSearchViewController class]]) {
            PlatesSearchViewController *platesSearchViewController = (PlatesSearchViewController *)viewController;
            platesSearchViewController.delegate = self;
        }
        */
#ifdef kSwissPlates
        if ([viewController isKindOfClass:[StoreViewController class]]) {
            NSLog(@"PlatesViewController, prepareForSegue, go to store");
            //StoreViewController *storeViewController = (StoreViewController *)viewController;
        }
#endif
    }
}


#pragma mark -
#pragma mark SelectCantonTableviewControllerDelegate

- (void)cantonIndexSelected:(NSInteger)index {
    //NSLog(@"PlatesViewController, cantonIndexSelected, index %d", (int)index);
    [self setCantonsConfigArrayIndex:index];
}


#ifdef kSwissPlates

#pragma mark -
#pragma mark Google Mobile Ads Actions

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-2847204440687988/2741591608"];
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
#ifdef kSwissPlatesTestAds
    request.testDevices = @[@"578faf477824a140de6a4a30d6622662", @"37111372ee69b5d0f65c24259ac77cf9", @"f8e129ca753417bcf25b60a2ef901af6", kGADSimulatorID];
#endif
    [interstitial loadRequest:request];
    return interstitial;
}

- (void)addBannerViewToView:(GADBannerView *)bannerView {
    if (![bannerView.superview isEqual:self.view]) {
        bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:bannerView];
        [NSLayoutConstraint activateConstraints:_bannerViewContraints];
        [_platesTable setContentInset:UIEdgeInsetsMake(bannerView.frame.size.height,0, TABLEVIEWBOTTOMINSET,0)];
        [_platesTable scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:YES];
    }
}

- (void)removeBannerView:(GADBannerView *)bannerView {
    if ([bannerView.superview isEqual:self.view]) {
        [bannerView removeFromSuperview];
        [NSLayoutConstraint deactivateConstraints:_bannerViewContraints];
        [_platesTable setContentInset:UIEdgeInsetsMake(0, 0, TABLEVIEWBOTTOMINSET, 0)];
        [_platesTable scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:YES];
    }
}

#pragma mark -
#pragma mark Google Mobile Ads Delegate

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"PlatesViewController, interstitialDidReceiveAd");
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"PlatesViewController, interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"PlatesViewController, interstitialWillPresentScreen");
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"PlatesViewController, interstitialWillDismissScreen");
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"PlatesViewController, interstitialWillLeaveApplication");
}

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
    [self addBannerViewToView:_bannerView];
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    [self removeBannerView:adView];
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}

#pragma mark -
#pragma mark Store Actions

-(void)showStore {
    if ([[AFStoreController sharedAFStoreController] isShopOpenForPurchase]) {
        [self performSegueWithIdentifier:@"GoToStore" sender:self];
    } else {
        if (!_shopIsReinitializing) {
            _shopIsReinitializing = YES;
            [[PlatesMessagesController sharedPlatesMessagesController] showShopNotReadyMessage:self.view cancelblock:nil okblock:nil];
            [[AFStoreController sharedAFStoreController] reinitShop:^(void){
                _shopIsReinitializing = NO;
                if ([[AFStoreController sharedAFStoreController] isShopOpenForPurchase]) {
                    [self performSegueWithIdentifier:@"GoToStore" sender:self];
                } else {
                    [[PlatesMessagesController sharedPlatesMessagesController] showShopCannotBeOpenedMessage:self.view cancelblock:nil okblock:nil];
                }
            } failureBlock:^(void){
                _shopIsReinitializing = NO;
                [[PlatesMessagesController sharedPlatesMessagesController] showShopCannotBeOpenedMessage:self.view cancelblock:nil okblock:nil];
            }];
        } else {
            [[PlatesMessagesController sharedPlatesMessagesController] showShopNotReadyMessage:self.view cancelblock:nil okblock:nil];
        }
    }
}

- (void) productPurchasedNotification:(NSNotification *) notification {
    NSLog(@"PlatesViewController, productPurchasedNotification: %@", notification.name);
    if ([[AFStoreController sharedAFStoreController] isSwissPlatesFullVersionPurchased]) {
        self.navigationItem.rightBarButtonItem = nil;
        if (_bannerView ) {
            [self removeBannerView:_bannerView];
        }
    } else if ([[AFStoreController sharedAFStoreController] isSwissPlatesAdsFreeVersionPurchased]) {
        if (_bannerView ) {
            [self removeBannerView:_bannerView];
        }
    } else {
        NSString *creditString = [NSString stringWithFormat:@"%d", (int)[[AFStoreController sharedAFStoreController] countSwissPlatesCredits]];
        UIBarButtonItem *rightButtomItem = self.navigationItem.rightBarButtonItem;
        UIButton *storeButton = [rightButtomItem customView];
        [storeButton setTitle:creditString forState:UIControlStateNormal];
    }
}

- (void) creditsByVideoAdsNotification:(NSNotification *) notification {
    NSLog(@"PlatesViewController, creditsByVideoAdsNotification: %@", notification.name);
    NSString *creditString = [NSString stringWithFormat:@"%d", (int)[[AFStoreController sharedAFStoreController] countSwissPlatesCredits]];
    UIBarButtonItem *rightButtomItem = self.navigationItem.rightBarButtonItem;
    UIButton *storeButton = [rightButtomItem customView];
    [storeButton setTitle:creditString forState:UIControlStateNormal];
}

#endif

@end
