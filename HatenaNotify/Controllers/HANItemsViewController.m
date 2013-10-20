//
//  HANItemsViewController.m
//  HatenaNotify
//

#import "HANItemsViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "HANWebViewController.h"
#import "HANNotifyService.h"
#import "HANAPIClient.h"
#import "HANAccountService.h"
#import "HANNotifyItem.h"
#import "HANAlertUtil.h"

@interface HANItemsViewController()
@property(nonatomic, strong) HANNotifyService* notify;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) HANNotifyItem* currentItem;
@property(nonatomic, weak) IBOutlet UIToolbar* toolbar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *logoutButton;
- (IBAction)onLogoutButton:(id)sender;
- (IBAction)onRefresh:(id)sender;
@end


@implementation HANItemsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self){
    _notify = [HANNotifyService new];
    _currentItem = nil;
    _items = [NSMutableArray array];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tableView.accessibilityLabel = @"NotifyItemsTable";
  self.tableView.tableHeaderView = self.toolbar;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self reloadTableView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:kHatenaNotifyBackgroundfetchedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString* NotifyCell = @"NotifyCell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NotifyCell];
  HANNotifyItem* item = [self.items objectAtIndex:indexPath.row];
  [cell.imageView setImageWithURL:item.iconURL placeholderImage:[UIImage imageNamed:@"default-icon.gif"]];
  cell.textLabel.text = item.message;
  return cell;
}

# pragma mark - UITableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSAssert((self.items.count > indexPath.row), nil);
  if(self.items.count > indexPath.row){
    self.currentItem = [self.items objectAtIndex:indexPath.row];
  }
  return indexPath;
}

# pragma mark - UIStoryboard
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([segue.identifier isEqualToString:@"openURL"]){
    UINavigationController* nav = (UINavigationController*)segue.destinationViewController;
    HANWebViewController* web = (HANWebViewController *)nav.topViewController;
    web.url = self.currentItem.subjectURL;
  }
}

# pragma mark - IBAction
- (IBAction)onLogoutButton:(id)sender
{
  [self.items removeAllObjects];
  [self.tableView reloadData];
  [self presentAuthViewController];
}

- (IBAction)onRefresh:(id)sender
{
  if([sender isKindOfClass:[UIRefreshControl class]]){
    [(UIRefreshControl *)sender beginRefreshing];
    [self reloadTableView];
    [(UIRefreshControl *)sender endRefreshing];
  }
}

#pragma mark - Private
- (void)presentAuthViewController
{
  UIViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AuthViewController"];
  UIWindow* window = [[UIApplication sharedApplication] keyWindow];
  [window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)reloadTableView
{
  if(![[HANAccountService new] isValidAccount]){
    return;
  }
  
  __weak HANItemsViewController *wSelf = self;
  [[HANAccountService new] renewLoginSession:^(NSError *errorOrNil) {
    [self.notify loadNotifyItems:^(NSError *errorOrNil, NSArray *items) {
      if(errorOrNil){
        [HANAlertUtil showError:@"認証エラーが発生しました。一度ログアウトして再度ログインしてください"];
        return;
      }
      
      DLog(@"Load %d items.", items.count);
      wSelf.items = [items mutableCopy];
      [wSelf.tableView reloadData];
    }];
  }];
}

@end