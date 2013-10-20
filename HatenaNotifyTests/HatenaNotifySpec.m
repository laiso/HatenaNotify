#import <Kiwi/Kiwi.h>

SPEC_BEGIN(HatenaNotifySpec)

describe(@"HatenaNotifyTests", ^{
  it(@"Windowのframeが生成済み", ^{
    UIWindow* win = [[UIApplication sharedApplication] keyWindow];
    [[theValue(win.frame.size.width) should] equal:theValue(320)];
  });
});

SPEC_END