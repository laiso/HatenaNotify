//
//  TestHelper.h
//  HatenaNotify
//

#import <Foundation/Foundation.h>

@interface TestHelper : NSObject
+ (NSArray *)objectsFromPullJSON;
+ (NSData *)dataFromPullJSON;
+ (NSDictionary *)anyPullObject;
@end
