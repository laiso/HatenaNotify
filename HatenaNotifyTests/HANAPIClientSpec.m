#import <Kiwi/Kiwi.h>

#import <AFNetworking/AFNetworking.h>

#import "HANAPIClient.h"

SPEC_BEGIN(HANAPIClientSpec)

describe(@"HANAPIClientTests", ^{
  __block HANAPIClient *client;
  beforeEach(^{
    client = [HANAPIClient new];
    [client logout];
  });
  it(@"ログインする", ^{
    id req = [AFHTTPRequestOperationManager mock];
    [req expect:@selector(setResponseSerializer:)];
    id block = ^(NSArray* params){
      void (^success)(AFHTTPRequestOperation *operation, id responseObject) = params[2];
      id operation = [AFHTTPRequestOperation mock];
      id response = [NSHTTPURLResponse mock];
      [response stub:@selector(allHeaderFields) andReturn:@{@"X-Welcome": @"-----------hogehoge------------"}];
      [operation stub:@selector(response) andReturn:response];
      success(operation, nil);
    };
    [req stub:@selector(POST:parameters:success:failure:) withBlock:block];
    [client setValue:req forKey:@"request"];
    
    __block BOOL success = NO;
    [client login:@"-----------hogehoge------------" password:@"hoehogehoge" completionHandler:^(NSError *errorOrNil) {
      success = (errorOrNil == nil);
    }];
    
    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
  });
  it(@"Cookieは保存されていない", ^{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://www.hatena.ne.jp"]];
    [[theValue(cookies.count) should] equal:theValue(0)];
  });
});

SPEC_END