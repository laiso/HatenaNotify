//
//  AcceptanceTestHelper.h
//  HatenaNotify
//

#import <Foundation/Foundation.h>

extern NSString * const kChuckNorrisModeUserName;

@interface AcceptanceTestHelper : NSObject
+ (UIViewController *)viewControllerByStoryboardId:(NSString *)storyboardId;
+ (void)presentViewController:(UIViewController *)viewController;
+ (void)enableChuckNorrisMode;
+ (void)thankYouNorris;
@end
