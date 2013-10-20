//
//  HANPurchaseService.m
//  HatenaNotify
//

#import "HANPurchaseService.h"

#import <StoreKit/StoreKit.h>
#import "HANAlertUtil.h"

NSString * const kHatenaNotifyPurchaseDisableAds = @"so.lai.hatenanotify.disableads";
NSString * const kHatenaNotifyDisableAdsNotification = @"kHatenaNotifyDisableAdsNotification";

@interface HANPurchaseService() <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation HANPurchaseService

-(id)init
{
  self = [super init];
  if(self){
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
  }
  return self;
}

- (void)dealloc
{
  [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)startDisableAdsTransaction
{
  SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kHatenaNotifyPurchaseDisableAds]];
  request.delegate = self;
  [request start];
}

- (BOOL)isPurchased:(NSString *)productId
{
  return [[[NSUserDefaults standardUserDefaults] objectForKey:productId] boolValue];
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
  [response.products enumerateObjectsUsingBlock:^(SKProduct *product, NSUInteger idx, BOOL *stop) {
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
  }];
}

- (void)requestDidFinish:(SKRequest *)request
{
  return;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
  [HANAlertUtil showError:error.localizedDescription];
}

#pragma mark - SKPaymentTransactionObserve

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
  for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState)
    {
      case SKPaymentTransactionStatePurchased:
        NSLog(@"SKPaymentTransactionStatePurchased:");
        [self completeTransaction:transaction];
        break;
        
      case SKPaymentTransactionStateFailed:
        NSLog(@"SKPaymentTransactionStateFailed:");
        [self failedTransaction:transaction];
        break;
      default:
        break;
    }
  }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
  if([transaction.payment.productIdentifier isEqualToString:kHatenaNotifyPurchaseDisableAds]){
    [self complete:transaction.payment.productIdentifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHatenaNotifyDisableAdsNotification object:nil];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
  }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)complete:(NSString *)productId
{
  [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:productId];
}

@end
