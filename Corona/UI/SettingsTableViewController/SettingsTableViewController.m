//
//  SettingsTableViewController.m
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

#import "SettingsTableViewController.h"
#import "UIColor+SwissPlates.h"
#import "UIImage+SwissPlates.h"
#import "CantonsTableViewCell.h"
#import "SettingsTableViewCell.h"
#import "RevealViewController.h"
#import "CoronaDataViewController.h"
//#import "PlatesMessagesController.h"
//#import "AppConfig.h"
#import "SDiOSVersion.h"
#import "AppConfig.h"
#import "Reachability.h"
#import "SettingsWebViewController.h"

#define TOPBARHEIGHT                16
#define TYPEIMAGEWIDTH              16
#define TYPEIMAGEHEIGHT             16

#define HEADERFONTSIZE              14
#define HEADERVIEWHEIGHT            20
#define HEADERLRINSET               5
#define HEADERTBINSET               0

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"SettingsTableviewController, viewdidload");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = [UIColor settingsTableviewBackgroundColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = [UIColor settingsTableviewSeparatorColor];
    //UIView *dummyFooterView =  [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 0)];
    //((self.tableView.tableHeaderView = dummyFooterView;
    //dummyFooterView.hidden = YES;
    
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor settingsViewControllerNavigationTitleColor]}];
    //[self.navigationController.navigationBar.topItem setTitle:NSLocalizedString(@"Choose canton", @"SettingsViewController")];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *cantonindexstring = [prefs objectForKey:@"canton_set"];
    if (cantonindexstring) {
        NSInteger cantonindex = (NSUInteger)[cantonindexstring integerValue];
        if (cantonindex < [[CantonsSettingsController sharedCantonsSettingsController] getNumberOfCantons]) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:cantonindex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [[CantonsSettingsController sharedCantonsSettingsController] getNumberOfCantons];
    } else if (section == 1) {
        return 5;
    }
    return 0;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([cell isKindOfClass:[CantonsTableViewCell class]]) {
            CantonsTableViewCell *cantonscell = (CantonsTableViewCell *)cell;
            cantonscell.cantonImage.image = [[CantonsSettingsController sharedCantonsSettingsController] getCantonImageForCantonAtIndex:[indexPath row]];
            cantonscell.cantonCode.text = [[CantonsSettingsController sharedCantonsSettingsController] getCantonCodeForCantonAtIndex:[indexPath row]];
            cantonscell.cantonName.text = [[CantonsSettingsController sharedCantonsSettingsController] getCantonNameForCantonAtIndex:[indexPath row] languageIdentifier:LanguageIdentifierPreferred];
        }
    } else if (indexPath.section == 1) {
        if ([cell isKindOfClass:[SettingsTableViewCell class]]) {
            SettingsTableViewCell *settingscell = (SettingsTableViewCell *)cell;
            
            if (indexPath.row == 0) {
                settingscell.settingsLabel.text = NSLocalizedString(@"Contact", nil);
            } else if (indexPath.row == 1) {
                settingscell.settingsLabel.text = NSLocalizedString(@"Recommend to friends", nil);
            } else if (indexPath.row == 2) {
                settingscell.settingsLabel.text = NSLocalizedString(@"Make a review", nil);
            } else if (indexPath.row == 3) {
                settingscell.settingsLabel.text = NSLocalizedString(@"Follow us on Twitter", nil);
            } else if (indexPath.row == 4) {
                settingscell.settingsLabel.text = NSLocalizedString(@"Credits", nil);
            }
            
            /*
            if (indexPath.row == 0) {
                settingscell.settingsLabel.text = NSLocalizedString(@"Contact", @"Contact support title");
            } else if (indexPath.row == 1) {
                settingscell.settingsLabel.text = NSLocalizedString(@"Recommend to friends", @"Recommend support button");
            } else if (indexPath.row == 2) {
                settingscell.settingsLabel.text = NSLocalizedString(@"Make a review", @"Review support button");
            } else if (indexPath.row == 3) {
                settingscell.settingsLabel.text = NSLocalizedString(@"Follow us on Twitter", @"Follow support button");
            } else if (indexPath.row == 4) {
                settingscell.settingsLabel.text = NSLocalizedString(@"Credits", @"Credits support button");
            }
            */
            //settingscell.settingsLabel.text = NSLocalizedString(@"Gift this app", @"Gift support button");
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CantonsTableViewCell"];
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsTableViewCell"];
    }
    [self configureCell: cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return HEADERVIEWHEIGHT;
    }
    return 0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEADERVIEWHEIGHT)];
        headerview.backgroundColor = [UIColor settingsTableviewHeaderBackgroundColor];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerview.frame, HEADERLRINSET, HEADERTBINSET)];
        headerLabel.backgroundColor = [UIColor settingsTableviewHeaderTitleBackgroundColor];
        headerLabel.textColor = [UIColor settingsTableviewHeaderTitleColor];
        headerLabel.font = [UIFont systemFontOfSize:HEADERFONTSIZE];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        [headerview addSubview:headerLabel];
        headerLabel.text = NSLocalizedString(@"Support", @"Support header view text");
        return headerview;
    }
    return nil;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"SettingsTableviewController, didselectrowatindexpath %@", indexPath);
    if (indexPath.section == 0) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:[NSString stringWithFormat:@"%d", (int)indexPath.row] forKey:@"canton_set"];
        [prefs synchronize];
        
        UIViewController *frontViewController = [[self revealViewController] frontViewController];
        if ([frontViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)frontViewController;
            UIViewController *rootViewController = [navigationController.viewControllers objectAtIndex:0];
            if ([rootViewController isKindOfClass:[CoronaDataViewController class]]) {
                CoronaDataViewController *coronaDataViewController = (CoronaDataViewController*)rootViewController;
                [coronaDataViewController setCantonsConfigArrayIndex:indexPath.row];
            }
        } else {
            if ([frontViewController isKindOfClass:[CoronaDataViewController class]]) {
                CoronaDataViewController *coronaDataViewController = (CoronaDataViewController*)frontViewController;
                [coronaDataViewController setCantonsConfigArrayIndex:indexPath.row];
            }
        }
        RevealViewController *revealViewController = (RevealViewController*)[self revealViewController];
        [revealViewController revealToggle:nil];
    } else if (indexPath.section == 1) {
         [tableView deselectRowAtIndexPath: indexPath animated: YES];
        if (indexPath.row == 0) {
            [self sendSupportEmail];
        } else if (indexPath.row == 1) {
            [self recommendApp];
        } else if (indexPath.row == 2) {
            [self makeReview];
        } else if (indexPath.row == 3) {
            [self followOnTwitter];
        } else if (indexPath.row == 4) {
            //[self performSegueWithIdentifier:@"SettingsWebSegue" sender:self];
            [self showCredits];
        }
    }
}


#pragma mark - Navigation
 
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        if ([sender isKindOfClass:[CantonsTableViewCell  class]]) {
            return YES;
        }
        if ([sender isKindOfClass:[SettingsTableViewCell class]]) {
            if (indexPath.row == 0) {
                [self sendSupportEmail];
            } else if (indexPath.row == 1) {
                [self recommendApp];
            } else if (indexPath.row == 2) {
                [self makeReview];
            } else if (indexPath.row == 3) {
                [self followOnTwitter];
            } else if (indexPath.row == 4) {
                [self showCredits];
                return YES;
            }
        }
    }
    return NO;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        [self.tableView deselectRowAtIndexPath: indexPath animated: NO];
        if ([sender isKindOfClass:[CantonsTableViewCell class]]) {
            //NSLog(@"SettingsTableviewController, prepareforsegue, cantonstableviewcell");
            /*
            UINavigationController *navController = segue.destinationViewController;
            PlatesViewController* cvc = [navController childViewControllers].firstObject;
            if ([cvc isKindOfClass:[PlatesViewController class]]) {
                if ([cvc respondsToSelector:@selector(setCantonsConfigArrayIndex:)]) {
                    [cvc setCantonsConfigArrayIndex:[indexPath row]];
                }
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:[NSString stringWithFormat:@"%d", (int)indexPath.row] forKey:@"canton_set"];
                [prefs synchronize];
            }
            */
        }
        if ([sender isKindOfClass:[SettingsTableViewCell class]]) {
            //NSLog(@"SettingsTableviewController, prepareforsegue, settingstableviewcell");
            /*
            UINavigationController *navController = segue.destinationViewController;
            PlatesViewController* cvc = [navController childViewControllers].firstObject;
            if ([cvc isKindOfClass:[PlatesViewController class]]) {
                if (indexPath.row == 0) {
                    [self sendSupportEmail];
                } else if (indexPath.row == 1) {
                    [self recommendApp];
                } else if (indexPath.row == 2) {
                    [self makeReview];
                } else if (indexPath.row == 3) {
                    [self followOnTwitter];
                } else if (indexPath.row == 4) {
                    [self showCredits];
                }
            }
            */
         }
    }
    if ([sender isKindOfClass:[SettingsTableViewController class]]) {
        //NSLog(@"SettingsTableviewController, prepareforsegue, programmatically executed");
        if ([segue.identifier isEqualToString:@"SettingsWebSegue"]) {
            //NSLog(@"SettingsTableviewController, prepareforsegue, programmatically executed, load page");
            if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
                UIViewController *rootViewController = [navigationController.viewControllers objectAtIndex:0];
                if ([rootViewController isKindOfClass:[SettingsWebViewController class]]) {
                    SettingsWebViewController *settingsWebViewController = (SettingsWebViewController*)rootViewController;
                    //[settingsWebViewController loadWebURL:kSupportCreditURL];
                    [settingsWebViewController setWebURL:kSupportCreditURL];
                }
            }
        }
    }
}

// Support actions

- (void) sendSupportEmail {
    /*
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController=  [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject: NSLocalizedString(@"Swiss Plates support", @"Swiss Plates settings support email subject")];
        [mailController setMessageBody: [NSString stringWithFormat: @"%@\n\n\n\n\n\n\n\n\n\n\niPhone: %@\niOS Version: %@\nApp version: %@\nLanguage: %@",NSLocalizedString(@"Dear Support, ", @"Swiss Plates settings support email draft text"), [SDiOSVersion deviceNameString], [[UIDevice currentDevice] systemVersion], kUTControllerAppName, [[NSLocale currentLocale] localeIdentifier]] isHTML:NO];
        [mailController setToRecipients:  [NSArray arrayWithObject: kSupportEmail]];
        [self presentViewController:mailController animated:YES completion:nil];
    } else {
        [[PlatesMessagesController sharedPlatesMessagesController] showNoEmailSupportErrorMessage:self.view cancelblock:nil okblock:nil];
    }
     */
}

- (void) recommendApp {
    /*
    NSString *description =  NSLocalizedString(@"Check out this app!", @"Recommend Swiss Plates Share Item Description");
    
    NSString *appStoreIDString = [NSString stringWithFormat: @"%d", AppStoreID];
    NSString *appStoreURL =  [NSString stringWithFormat: @"http://itunes.apple.com/ch/app/%@/id%@?mt=8&uo=4", AppStoreURLIPHONE,appStoreIDString];;
    
    NSString *imageURLString = kITellAFriendImageURLSmall;
    //NSString *imageNameFromBundle = kBundleIconImage;
    
    NSString *emailBody = [NSMutableString stringWithFormat:@"<div> \n"
                           "<p style=\"font:17px Helvetica,Arial,sans-serif\">%@</p> \n"
                           "<table border=\"0\"> \n"
                           "<tbody> \n"
                           "<tr> \n"
                           "<td style=\"padding-right:10px;vertical-align:top\"> \n"
                           "<a target=\"_blank\" href=\"%@\"><img height=\"120\" border=\"0\" src=\"%@\" alt=\"Cover Art\"></a> \n"
                           "</td> \n"
                           "<td style=\"vertical-align:top\"> \n"
                           "<a target=\"_blank\" href=\"%@\" style=\"color: Black;text-decoration:none\"> \n"
                           "<h1 style=\"font:bold 16px Helvetica,Arial,sans-serif\">%@</h1> \n"
                           "<p style=\"font:14px Helvetica,Arial,sans-serif;margin:0 0 2px\">By: %@</p> \n"
                           "<p style=\"font:14px Helvetica,Arial,sans-serif;margin:0 0 2px\">Category: %@</p> \n"
                           "</a> \n"
                           "<p style=\"font:14px Helvetica,Arial,sans-serif;margin:0\"> \n"
                           "<a target=\"_blank\" href=\"%@\"><img src=\"http://ax.phobos.apple.com.edgesuite.net/email/images_shared/view_item_button.png\"></a> \n"
                           "</p> \n"
                           "</td> \n"
                           "</tr> \n"
                           "</tbody> \n"
                           "</table> \n"
                           "<br> \n"
                           "<br> \n"
                           "<table align=\"center\"> \n"
                           "<tbody> \n"
                           "<tr> \n"
                           "<td valign=\"top\" align=\"center\"> \n"
                           "<span style=\"font-family:Helvetica,Arial;font-size:11px;color:#696969;font-weight:bold\"> \n"
                           "</td> \n"
                           "</tr> \n"
                           "<tr> \n"
                           "<td align=\"center\"> \n"
                           "<span style=\"font-family:Helvetica,Arial;font-size:11px;color:#696969\"> \n"
                           "Please note that you have not been added to any email lists. \n"
                           "</span> \n"
                           "</td> \n"
                           "</tr> \n"
                           "</tbody> \n"
                           "</table> \n"
                           "</div>",
                           description,
                           appStoreURL,
                           imageURLString,
                           appStoreURL,
                           AppName,
                           kAppSeller,
                           kAppCategory,
                           appStoreURL];
    
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController=  [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject: description];
        [mailController setMessageBody: emailBody isHTML:YES];
        [self presentViewController:mailController animated:YES completion:nil];
    } else {
        [[PlatesMessagesController sharedPlatesMessagesController] showNoEmailSupportErrorMessage:self.view cancelblock:nil okblock:nil];
    }
     */
}

- (void) makeReview {
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    
    storeViewController.delegate = self;
    
    NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier: [NSNumber numberWithInteger:AppStoreID]};
    
    [storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                       if (result)
                                           [self presentViewController:storeViewController
                                                              animated:YES
                                                            completion:nil];
                                   }];
}

static NSString *const iTellAFriendGiftiOSiTunesURLFormat = @"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=%d&productType=C&pricingParameter=STDQ";
static NSString *const iTellAFriendRateiOSAppStoreURLFormat = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";

- (void) giftApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:iTellAFriendGiftiOSiTunesURLFormat, AppStoreID]] options:@{} completionHandler:^(BOOL success) {
        NSLog(@"SettingsTableviewController, giftApp, execute openurl completed");
    }];
}

- (void) followOnTwitter {
    /*
    NSString *userName = kTwitterUsername;
    NSArray *urls = [NSArray arrayWithObjects:
                     @"twitter:@{username}", // Twitter
                     @"tweetbot:///user_profile/{username}", // TweetBot
                     @"tweetie://user?screen_name={username}", //Tweetie
                     @"echofon:///user_timeline?{username}", // Echofon
                     @"twit:///user?screen_name={username}", // Twittelator Pro
                     @"x-seesmic://twitter_profile?twitter_screen_name={username}", // Seesmic
                     @"x-birdfeed://user?screen_name={username}", // Birdfeed
                     @"tweetings:///user?screen_name={username}", // Tweetings
                     @"simplytweet:?link=http://twitter.com/{username}", // SimplyTweet
                     @"icebird://user?screen_name={username}", // IceBird
                     @"fluttr://user/{username}", // Fluttr
                     @"http://twitter.com/{username}", // Web fallback,
                     nil];
    
    for (NSString *candidate in urls) {
        NSString *currentcandidate = [candidate stringByReplacingOccurrencesOfString:@"{username}" withString:userName];
        NSURL *url = [NSURL URLWithString:currentcandidate];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                NSLog(@"SettingsTableviewController, followOnTwitter, execute openurl completed");
            }];
        }
    }
     */
}

- (void) showCredits {
    /*
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable) {
        [[PlatesMessagesController sharedPlatesMessagesController] showNoNetworkMessage:self.view cancelblock:nil okblock:nil];
        return;
    }
    
    [self performSegueWithIdentifier:@"SettingsWebSegue" sender:self];
     */
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController*) mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [mailController dismissViewControllerAnimated: YES completion: ^{}];
}

@end
