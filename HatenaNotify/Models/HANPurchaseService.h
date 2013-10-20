//
//  HANPurchaseService.h
//  HatenaNotify
//

#import <Foundation/Foundation.h>


extern NSString * const kHatenaNotifyPurchaseDisableAds;
extern NSString * const kHatenaNotifyDisableAdsNotification;

@interface HANPurchaseService : NSObject
- (void)startDisableAdsTransaction;
- (BOOL)isPurchased:(NSString *)productId;
@end
