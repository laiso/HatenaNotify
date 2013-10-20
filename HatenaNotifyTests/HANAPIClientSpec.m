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
    __block BOOL success = NO;
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
    [client login:@"-----------hogehoge------------" password:@"hoehogehoge" completionHandler:^(NSError *errorOrNil) {
      success = (errorOrNil == nil);
    }];
    
    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
  });
});

SPEC_END