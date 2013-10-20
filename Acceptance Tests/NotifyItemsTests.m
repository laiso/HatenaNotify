#import <KIF/KIF.h>

#import "HANItemsViewController.h"
#import "AcceptanceTestHelper.h"

@interface HANItemsViewController()
- (void)reloadTableView;
@end

@interface NotifyItemsTests : KIFTestCase
@property(nonatomic, weak) HANItemsViewController* viewController;
@end

@implementation NotifyItemsTests

- (void)beforeAll
{
  HANItemsViewController *rootViewController = (HANItemsViewController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
  [rootViewController reloadTableView];
  [tester waitForViewWithAccessibilityLabel:@"NotifyCell"];
}

// TODO ダミーデータの読み込みを先に解決
/*
- (void)testDisplayNotifyItems
{
  [tester waitForViewWithAccessibilityLabel:@"ProfileImage"];
  [tester waitForViewWithAccessibilityLabel:@"Message"];
}
*/

- (void)testLogout
{
  [tester tapViewWithAccessibilityLabel:@"ログアウト"];
  [tester waitForViewWithAccessibilityLabel:@"はてなアカウントを認証する"];
}

@end
