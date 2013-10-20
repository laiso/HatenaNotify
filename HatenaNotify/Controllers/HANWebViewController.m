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

@interface HANWebViewController () <ADBannerViewDelegate>
@property(nonatomic, weak) IBOutlet UIWebView* webView;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *closeButton;
@property(nonatomic, weak) IBOutlet ADBannerView *banner;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *disableAdsButton;
@property(nonatomic, strong) HANPurchaseService* purchase;
- (IBAction)dismiss:(id)sender;
- (IBAction)onNavRightButton:(id)sender;
@end

@implementation HANWebViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self){
    _purchase = [HANPurchaseService new];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.disableAdsButton.enabled = NO;
  
  [self configureAccessibility];
  [self configureBanner];
  
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

- (IBAction)onNavRightButton:(id)sender
{
  if(![SKPaymentQueue canMakePayments]){
    [HANAlertUtil showError:@"iOS「設定→一般→機能制限」で「App内での購入」を有効にしてください"];
    return;
  }
  
  [self.purchase startDisableAdsTransaction];
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  self.disableAdsButton.enabled = YES;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  DLog(@"bannerView:didFailToReceiveAdWithError");
  self.banner = nil;
}

#pragma mark - Private

- (void)configureAccessibility
{
  self.closeButton.accessibilityLabel = @"CloseButton";
  self.webView.accessibilityLabel = @"webview";
}

- (void)configureBanner
{
  if([self.purchase isPurchased:kHatenaNotifyPurchaseDisableAds]){
    [self makeHiddenBanner];
  }else{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeHiddenBanner) name:kHatenaNotifyDisableAdsNotification object:nil];
  }
}

- (void)makeHiddenBanner
{
  self.navigationItem.rightBarButtonItem = nil;
  [self.banner removeFromSuperview];
  self.banner.delegate = nil;
  [self.view addSubview:self.webView];
}


@end
