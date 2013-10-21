//
//  AppDelegate.m
//  HatenaNotify
//
//  Copyright (c) 2013 laiso. All rights reserved.
//

#import "AppDelegate.h"
#import "HANNotifyService.h"
#import "HANAPIClient.h"
#import "HANAccountService.h"
#import "HANNotifyItem.h"

static NSString * const kHatenaNotifyApp = @"";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
  DLog(@"Current userName: %@", [[HANAccountService new] userName]);
//  [[HANAccountService new] deleteAccount]; DLog(@"Delete account");
#endif
  [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  application.applicationIconBadgeNumber = 0;
  HANAccountService *account = [HANAccountService new];
  if(![account isValidAccount]){
    UIViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AuthViewController"];
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
  }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  HANNotifyService* notify = [HANNotifyService new];
  [notify loadNewNotifyItems:^(NSError *errorOrNil, NSArray *items) {
    if(errorOrNil){
      completionHandler(UIBackgroundFetchResultFailed);
      return;
    }
    
    if(!items.count){
      completionHandler(UIBackgroundFetchResultNoData);
      return;
    }
    
    application.applicationIconBadgeNumber += 1;
    [self presentLocalNotificationNow:items[0]];
    completionHandler(UIBackgroundFetchResultNewData);
  }];
}

#pragma mark - Private
- (void)presentLocalNotificationNow:(HANNotifyItem *)item
{
  UILocalNotification* localNotification = [[UILocalNotification alloc] init];
  localNotification.fireDate = [NSDate new];
  localNotification.alertBody = item.message;
  [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}
@end
