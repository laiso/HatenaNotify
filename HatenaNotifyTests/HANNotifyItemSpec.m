//
//  HANNotifyItemSpec.m
//  HatenaNotify
//
//  Copyright 2013 laiso. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "TestHelper.h"
#import "HANNotifyItem.h"

SPEC_BEGIN(HANNotifyItemSpec)

describe(@"HANNotifyItem", ^{
  __block HANNotifyItem* item;
  beforeEach(^{
    item = [[HANNotifyItem alloc] initWithDictionary:[TestHelper anyPullObject]];
  });
  it(@"#message", ^{
    [[item.message should] equal:@"shiiiiirさんがあなたのエントリー(全霊長類待望の「i…)をブックマークしました"];
  });
  it(@"#iconURL", ^{
    [[item.iconURL should] equal:[NSURL URLWithString:@"http://www.st-hatena.com/users/sh/shiiiiir/profile.gif"]];
  });
});

SPEC_END