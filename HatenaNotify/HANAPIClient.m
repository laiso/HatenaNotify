//
//  HANAPIClient.m
//  HatenaNotify
//

#import "HANAPIClient.h"

#import <AFNetworking/AFNetworking.h>

@interface HANAPIClient()
@property(nonatomic, strong) AFHTTPRequestOperationManager *request;
@property(nonatomic) BOOL hasSession;
@end

@implementation HANAPIClient

static const NSString *kHANAPIClientPersistent = @"1";

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
  if(!self.hasSession){
    completionHandler(nil, @[]);
    return;
  }
  
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
               completionHandler(nil);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completionHandler(error);
             }];
}

- (void)logout
{
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  [[self loadCookies] enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
    [storage deleteCookie:cookie];
  }];
}

#pragma mark - Private

- (BOOL)hasSession
{
  return ([[self loadCookies] count] > 0);
}

- (void)onError:(NSError *)error
{
  ALog(@"%@", error.localizedDescription);
}

- (NSArray *)loadCookies
{
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  return [storage cookiesForURL:[NSURL URLWithString:@"http://www.hatena.ne.jp"]];
}

@end
