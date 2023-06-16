//
//  SelectCantonTableViewController.m
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import "SelectCantonTableViewController.h"

#import "UIColor+SwissPlates.h"
#import "UIImage+SwissPlates.h"
#import "SelectCantonTableViewCell.h"

#define TYPEIMAGEWIDTH              16
#define TYPEIMAGEHEIGHT             16

@interface SelectCantonTableViewController ()

@end

@implementation SelectCantonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"SelectCantonTableviewController, viewdidload");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.view.backgroundColor = [UIColor selectCantonTableviewControllerBackgroundColor];
    self.tableView.backgroundColor = [UIColor selectCantonTableviewBackgroundColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = [UIColor selectCantonTableviewSeparatorColor];
    
    //self.navigationController.navigationBar.barTintColor = [UIColor selectCantonTableviewControllerNavigationbarBackgroundColor];
    //self.navigationController.navigationBar.tintColor = [UIColor selectCantonTableviewControllerNavigationbarTitleColor];
    
    self.navigationItem.hidesBackButton = YES;

    //self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor selectCantonTableviewControllerNavigationbarTitleColor]}];
    [self.navigationController.navigationBar.topItem setTitle:NSLocalizedString(@"Choose canton", @"SettingsViewController")];
    self.title = NSLocalizedString(@"Choose canton", @"SettingsViewController");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Testing
    //[self performSegueWithIdentifier:@"ShowIntro" sender:self];
}


/*
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
*/
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [[CantonsSettingsController sharedCantonsSettingsController] getNumberOfCantons];
    } else if (section == 1) {
        return 6;
    }
    return 0;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[SelectCantonTableViewCell class]]) {
        SelectCantonTableViewCell *cantonscell = (SelectCantonTableViewCell *)cell;
        cantonscell.cantonImage.image = [[CantonsSettingsController sharedCantonsSettingsController] getCantonImageForCantonAtIndex:[indexPath row]];
        cantonscell.cantonCode.text = [[CantonsSettingsController sharedCantonsSettingsController] getCantonCodeForCantonAtIndex:[indexPath row]];
        cantonscell.cantonName.text = [[CantonsSettingsController sharedCantonsSettingsController] getCantonNameForCantonAtIndex:[indexPath row] languageIdentifier:LanguageIdentifierPreferred];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCantonTableViewCell"];
    [self configureCell: cell atIndexPath:indexPath];
    return cell;
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
    //NSLog(@"SelectCantonTableviewController, didselectrowatindexpath %@", indexPath);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSString stringWithFormat:@"%d", (int)indexPath.row] forKey:@"canton_set"];
    [prefs synchronize];
    if (_delegate && [_delegate respondsToSelector:@selector(cantonIndexSelected:)]) {
        [_delegate cantonIndexSelected:indexPath.row];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
