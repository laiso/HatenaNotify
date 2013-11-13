//
//  HANAPIClient.m
//  HatenaNotify
//

#import "HANAPIClient.h"

#import <AFNetworking/AFNetworking.h>

@interface HANAPIClient()
@property(nonatomic, strong) AFHTTPRequestOperationManager *request;
@end

@implementation HANAPIClient

static NSString * const kHANAPIClientPersistent = @"1";
static NSString * const kHANAPIClientCookieKey =@"HANAPIClientCookieKey";

- (id)init
{
  self = [super init];
  if(self){
    _request = [AFHTTPRequestOperationManager manager];
  }
  return self;
}

- (void)pullNotify:(void (^)(NSError *errorOrNil, NSArray *notices))completionHandler
{
  NSArray *cookies = [self loadCookies];
  if(cookies.count == 0){
    // TODO 適切に処理する
    completionHandler(nil, @[]);
    return;
  }
  AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  [self.request setResponseSerializer:[AFJSONResponseSerializer serializer]];
  [self.request GET:@"https://www.hatena.ne.jp/notify/api/pull"
         parameters:@{@"via": [[NSBundle mainBundle] bundleIdentifier],
                      @"format": @"i",
                      @"langa": @"ja",}
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completionHandler(nil, [responseObject objectForKey:@"notices"]);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([[operation response] statusCode] == 400){
                [self onError:error];
              }
              if(error.code == 3840){ // JSON text did not start with array or object and option to allow fragments not set.
                ;
              }
              completionHandler(error, @[]);
            }];
}

- (void)login:(NSString *)name password:(NSString *)password completionHandler:(void (^)(NSError *errorOrNil))completionHandler
{
  NSAssert(name, nil); NSAssert(password, nil);
  if(!name || !password){
    return;
  }
  
  [self.request setResponseSerializer:[AFHTTPResponseSerializer serializer]];
  [self.request POST:@"https://www.hatena.ne.jp/login"
          parameters:@{@"name": name, @"password": password, @"persistent:": kHANAPIClientPersistent}
             success:^(AFHTTPRequestOperation *operation, NSData* responseData) {       
               NSString* logged = [[[operation response] allHeaderFields] objectForKey:@"X-Welcome"];
               if(![logged isEqualToString:name]){
                 NSError* error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                      code:kHatenaNotifyErrorAuthenticationFailed userInfo:@{}];
                 completionHandler(error);
                 return;
               }
               
               // 成功
               completionHandler(nil);
               [self storeCookie];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completionHandler(error);
             }];
}

- (void)logout
{
  [self deleteCookies];
}

#pragma mark - Private
- (void)onError:(NSError *)error
{
  ALog(@"%@", error.localizedDescription);
}

- (NSArray *)loadCookies
{
  [self deleteCookies];
  
  NSMutableArray *cookies = [NSMutableArray array];
  NSDictionary *properties = [[NSUserDefaults standardUserDefaults] objectForKey:kHANAPIClientCookieKey];
  NSHTTPCookie *c = [NSHTTPCookie cookieWithProperties:properties];
  if(c){
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:c];
    [cookies addObject:c];
  }
  return cookies;
}

- (void)storeCookie
{
  NSHTTPCookie *cookie = [[self loadSiteCookies] lastObject];
  if(cookie){
    [[NSUserDefaults standardUserDefaults] setObject:cookie.properties forKey:kHANAPIClientCookieKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

- (void)deleteCookies
{
  [[self loadSiteCookies] enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
  }];
}

- (NSArray *)loadSiteCookies
{
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  return [storage cookiesForURL:[NSURL URLWithString:@"http://www.hatena.ne.jp"]];
}

@end
