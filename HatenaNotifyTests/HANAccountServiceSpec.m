//
//  HANAccountServiceSpec.m
//  HatenaNotify
//
//  Copyright 2013 laiso. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "HANAccountService.h"
#import "HANAPIClient.h"

SPEC_BEGIN(HANAccountServiceSpec)

describe(@"HANAccountService", ^{
  __block HANAccountService *account;
  beforeEach(^{
    account = [HANAccountService new];
    [[HANAPIClient new] logout];
  });
  describe(@"パスワード未設定時:", ^{
    beforeEach(^{
      [account deleteAccount];
    });
    afterEach(^{
      [account deleteAccount];
    });
    it(@"パスワードを保存", ^{
      [account saveUserName:@"hoge" password:@"hage"];
      [[account.userName should] equal:@"hoge"];
      [[account.password should] equal:@"hage"];
    });
    it(@"アカウントを削除", ^{
      [account saveUserName:@"hoge" password:@"hage"];
      [account deleteAccount];
      [[account.userName should] beNil];
      [[account.password should] beNil];
    });
  });
  describe(@"パスワード設定済み:", ^{
    beforeEach(^{
      [account saveUserName:@"hoge" password:@"hage"];
    });
    it(@"既存パスワード確認", ^{
      [[account.userName should] equal:@"hoge"];
      [[account.password should] equal:@"hage"];
    });
  });
});

SPEC_END


