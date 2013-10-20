//
//  HANPurchaseServiceSpec.m
//  HatenaNotify
//
//  Copyright 2013 laiso. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "HANPurchaseService.h"

SPEC_BEGIN(HANPurchaseServiceSpec)

describe(@"HANPurchaseService", ^{
  it(@"#startDisableAdsTransaction", ^{
    HANPurchaseService* purchase = [HANPurchaseService new];
    [purchase startDisableAdsTransaction];
  });
});

SPEC_END


