//
//  HANNotifyService.m
//  HatenaNotify
//

#import "HANNotifyService.h"

#import "HANAPIClient.h"
#import "HANNotifyItem.h"

@interface HANNotifyService()
@property(nonatomic, strong) NSMutableArray* HAN_items;
@property(nonatomic, strong) HANAPIClient *client;
@end

NSString * const kHatenaNotifyBackgroundfetchedNotification = @"HatenaNotifyBackgroundfetchedNotification";

@implementation HANNotifyService

- (id)init
{
  self = [super init];
  if(self){
    _HAN_items = [NSMutableArray array];
    _client = [HANAPIClient new];
  }
  return self;
}

- (NSArray *)items
{
  return self.HAN_items;
}

- (void)loadNotifyItems:(void (^)(NSError *errorOrNil, NSArray *items))completionHandler
{
  [self.HAN_items removeAllObjects];
  
  [self.client pullNotify:^(NSError *errorOrNil, NSArray* notices) {
    [notices enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
      HANNotifyItem *item = [[HANNotifyItem alloc] initWithDictionary:obj];
      [self.HAN_items addObject:item];
    }];
    completionHandler(errorOrNil, [self.HAN_items copy]);
  }];
}

- (void)loadNewNotifyItems:(void (^)(NSError *errorOrNil, NSArray *items))completionHandler
{
  __weak HANNotifyService *wSelf = self;
  [self loadNotifyItems:^(NSError *errorOrNil, NSArray *items) {
    NSNotification *notification = [NSNotification notificationWithName:kHatenaNotifyBackgroundfetchedNotification object:items];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    completionHandler(errorOrNil, [wSelf findNewNotifyItems:items]);
    
    if(!errorOrNil){
      // findNewNotifyItemsより後
      HANNotifyItem* item = items[0];
      [wSelf saveLatestNotificationDate:item.modified];
    }
  }];
}

#pragma mark - Private
- (NSArray *)findNewNotifyItems:(NSArray *)items
{
  if(![self latestNotification]){
    return @[];
  }
  
  NSMutableArray *mItems = [NSMutableArray arrayWithCapacity:items.count];
  [items enumerateObjectsUsingBlock:^(HANNotifyItem *item, NSUInteger idx, BOOL *stop) {
//    DLog(@"%f > %f : %d", item.modified, [self latestNotification], (item.modified > [self latestNotification]));
    if(item.modified > [self latestNotification]){
      [mItems addObject:item];
    }
  }];
  return [mItems copy];
}

- (NSTimeInterval)latestNotification
{
  return [[[NSUserDefaults standardUserDefaults] objectForKey:@"latestNotification"] doubleValue];
}

- (BOOL)saveLatestNotificationDate:(NSTimeInterval)time
{
  [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:time] forKey:@"latestNotification"];
  return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
