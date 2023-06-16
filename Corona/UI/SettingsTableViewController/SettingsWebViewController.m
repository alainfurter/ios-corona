//
//  SettingsWebViewController.m
//  Corona
//
//  Created by Alain on 14.04.20.
//  Copyright © 2020 Zone Zero Apps. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "SettingsWebViewController.h"
#import "UIColor+SwissPlates.h"
#import "UIImage+SwissPlates.h"

@interface SettingsWebViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *webURL;
@end

@implementation SettingsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor settingsWebviewControllerBackgroundColor];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_webView];
    [self.webView setFrame:self.view.frame];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    self.webView.backgroundColor = [UIColor settingsWebviewControllerWebviewBackgroundColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage crossbutton]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backAction)];
    backButton.tintColor = [UIColor settingsWebviewControllerBackButtonColor];
    self.navigationController.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void) backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _webView.navigationDelegate = self;
    if (_webURL) {
        //NSLog(@"SettingsWebViewController, viewWillAppear, started loading page");
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webURL]]];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _webView.navigationDelegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWebURL:(NSString *)weburl {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weburl]]];
}

- (void)setWebURL:(NSString *)weburl {
    _webURL = weburl;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //NSLog(@"SettingsWebViewController, loadWebURL, started loading page");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //NSLog(@"SettingsWebViewController, loadWebURL, page loaded");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //NSLog(@"SettingsWebViewController, didFailNavigation, page loading failed");
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
