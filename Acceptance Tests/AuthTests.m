#import <KIF/KIF.h>

#import "AcceptanceTestHelper.h"
#import "HANAuthViewController.h"

@interface AuthTests : KIFTestCase
@property(nonatomic, weak) UIViewController *viewController;
@end

@implementation AuthTests

- (void)beforeEach
{
  self.viewController = [AcceptanceTestHelper viewControllerByStoryboardId:@"AuthViewController"];
  [AcceptanceTestHelper presentViewController:self.viewController];
}

- (void)afterEach
{
  [self.viewController dismissViewControllerAnimated:NO completion:nil];
  [tester waitForViewWithAccessibilityLabel:@"NotifyItemsTable"];
}

- (void)testFailInput
{
  [tester tapViewWithAccessibilityLabel:@"はてなアカウントを認証する"];
  [tester waitForViewWithAccessibilityLabel:@"ID・パスワードが入力されていません"];
  [tester tapViewWithAccessibilityLabel:@"閉じる"];
}

- (void)testAuthenticationSuccess
{  
  [tester waitForViewWithAccessibilityLabel:@"HatenaID"];
  [tester enterText:@"!!!cnorris!!!" intoViewWithAccessibilityLabel:@"HatenaID"];
  [tester enterText:@"OK" intoViewWithAccessibilityLabel:@"Password"];
  [tester tapViewWithAccessibilityLabel:@"はてなアカウントを認証する"];
  
  [tester waitForViewWithAccessibilityLabel:@"認証が完了しました"];
  [tester tapViewWithAccessibilityLabel:@"閉じる"];
}

@end