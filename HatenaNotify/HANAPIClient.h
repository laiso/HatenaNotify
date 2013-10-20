//
//  HANAPIClient.h
//  HatenaNotify
//

#import <Foundation/Foundation.h>

@interface HANAPIClient : NSObject

- (void)pullNotify:(void (^)(NSError *errorOrNil, NSArray* notices))completionHandler;
- (void)login:(NSString *)name password:(NSString *)password completionHandler:(void (^)(NSError *errorOrNil))completionHandler;
- (void)logout;

@end
