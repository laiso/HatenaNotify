//
//  HANNotifyService.h
//  HatenaNotify
//

#import <Foundation/Foundation.h>

extern NSString * const kHatenaNotifyBackgroundfetchedNotification;

@interface HANNotifyService : NSObject
@property(nonatomic, readonly) NSArray* items;
- (void)loadNotifyItems:(void (^)(NSError *errorOrNil, NSArray *items))completionHandler;
- (void)loadNewNotifyItems:(void (^)(NSError *errorOrNil, NSArray* items))completionHandler;
@end
