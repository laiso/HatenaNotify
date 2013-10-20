//
//  HANNotifyServiceSpec.m
//  HatenaNotify
//
//  Created by laiso on 10/18/13.
//  Copyright 2013 laiso. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "TestHelper.h"

#import "HANNotifyService.h"
#import "HANAPIClient.h"

SPEC_BEGIN(HANNotifyServiceSpec)

describe(@"HANNotifyService", ^{
  __block HANNotifyService* notify;
  beforeEach(^{
    notify = [HANNotifyService new];
  });
  it(@"通知取得", ^{
    // TODO あんま意味のないテスト……
    id mockNotify = [HANNotifyService mock];
    __block BOOL done;
    [mockNotify expect:@selector(loadNotifyItems:)];
    [mockNotify stub:@selector(client) andReturn:nil];
    [mockNotify loadNotifyItems:^(NSError *errorOrNil, NSArray *items) {
      done = YES;
    }];
    
    [[expectFutureValue(theValue(done)) shouldEventually] beTrue];
  });
});

SPEC_END


