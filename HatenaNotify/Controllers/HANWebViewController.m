//
//  HANWebViewController.m
//  HatenaNotify
//
//  Created by laiso on 10/15/13.
//  Copyright (c) 2013 laiso. All rights reserved.
//

#import "HANWebViewController.h"

#import <iAd/iAd.h>
#import <StoreKit/StoreKit.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

#import "HANPurchaseService.h"
#import "HANAlertUtil.h"

@interface HANWebViewController () <ADBannerViewDelegate, UIWebViewDelegate>
@property(nonatomic, weak) IBOutlet UIWebView* webView;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *closeButton;
- (IBAction)dismiss:(id)sender;
@end

@implementation HANWebViewController

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configureAccessibility];
  
  if(self.url){
    NSURLRequest* request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark Actions
- (IBAction)dismiss:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  DLog(@"didFailLoadWithError: %@", error);
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Private

- (void)configureAccessibility
{
  self.closeButton.accessibilityLabel = @"CloseButton";
  self.webView.accessibilityLabel = @"webview";
}

@end
