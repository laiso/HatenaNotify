//
//  AcceptanceTestHelper.m
//  HatenaNotify
//

#import <KIF/KIF.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "TestHelper.h"
#import "AcceptanceTestHelper.h"
#import "HANAccountService.h"

NSString * const kChuckNorrisModeUserName = @"!!!cnorris!!!";

@implementation AcceptanceTestHelper

+ (void)load
{
  [KIFTestActor setDefaultTimeout:5.00]; // seconds
  [AcceptanceTestHelper enableChuckNorrisMode];
}

+ (UIViewController *)viewControllerByStoryboardId:(NSString *)storyboardId
{
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  return [storyboard instantiateViewControllerWithIdentifier:storyboardId];
}

+ (void)presentViewController:(UIViewController *)viewController
{
  UIViewController* root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
  [root.presentedViewController dismissViewControllerAnimated:NO completion:nil];
  [root presentViewController:viewController animated:NO completion:nil];
}

+ (void)enableChuckNorrisMode
{
  [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
    return ([request.URL.path hasSuffix:@"/login"]);
  } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
    OHHTTPStubsResponse *response = [OHHTTPStubsResponse new];
    response.httpHeaders = @{@"X-Welcome": kChuckNorrisModeUserName};
    response.statusCode = 200;
    return response;
  }];

  [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
    return ([request.URL.path hasSuffix:@"/api/pull"]);
  } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
    OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithData:[TestHelper dataFromPullJSON]
                                                               statusCode:200
                                                                  headers:@{@"content-type": @"application/json"}];
    return response;
  }];
  
  [[HANAccountService new] saveUserName:kChuckNorrisModeUserName password:@"OK"];
  
  NSURL *url = [NSURL URLWithString:@"http://www.hatena.ne.jp"];
  NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:@{} forURL:url];
  [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:url mainDocumentURL:url];
}

+ (void)thankYouNorris
{
  [OHHTTPStubs removeAllStubs];
  [[HANAccountService new] deleteAccount];
}

@end
