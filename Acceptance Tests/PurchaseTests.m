#import <KIF/KIF.h>

#import "AcceptanceTestHelper.h"
#import "HANWebViewController.h"

@interface PurchaseTests : KIFTestCase
@end

@implementation PurchaseTests

- (void)beforeEach
{  
  HANWebViewController* web = (HANWebViewController *)[AcceptanceTestHelper viewControllerByStoryboardId:@"WebViewController"];
  web.url = [NSURL URLWithString:@"https://www.google.com/"];
  UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:web];
  [AcceptanceTestHelper presentViewController:navigationController];
}

// TODO SImulatorは課金がテストできないのでエラーが出るのが正常
- (void)testDisableAds
{
  [tester tapViewWithAccessibilityLabel:@"広告を非表示"];
  [tester waitForViewWithAccessibilityLabel:@"エラー"];
  [tester tapViewWithAccessibilityLabel:@"閉じる"];
}

- (void)testDismissWebViewController
{
  [tester tapViewWithAccessibilityLabel:@"閉じる"];
}


@end