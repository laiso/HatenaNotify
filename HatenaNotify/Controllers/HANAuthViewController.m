//
//  HANAuthViewController.m
//  HatenaNotify
//

#import "HANAuthViewController.h"

#import "HANAPIClient.h"
#import "HANAlertUtil.h"
#import "HANAccountService.h"

@interface HANAuthViewController()
@property(nonatomic, weak) IBOutlet UIButton *authenticateButton;
@property(nonatomic, weak) IBOutlet UITextField *hatenaIdField;
@property(nonatomic, weak) IBOutlet UITextField *passwordField;
@property(nonatomic, strong) HANAPIClient *api;
- (IBAction)authenticate:(id)sender;
@end

@implementation HANAuthViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self){
    _api = [HANAPIClient new];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.authenticateButton.accessibilityLabel = self.authenticateButton.titleLabel.text;
  [self.api logout];
}

#pragma mark - Actions
- (IBAction)authenticate:(id)sender
{
  NSString *user = self.hatenaIdField.text;
  NSString *password = self.passwordField.text;
  if(!user.length || !password.length){
    [HANAlertUtil showError:@"ID・パスワードが入力されていません"];
    return;
  }
  
  __weak HANAuthViewController *wSelf = self;
  [self.api login:user password:password completionHandler:^(NSError *errorOrNil) {
    if(errorOrNil){
      [HANAlertUtil showError:@"認証が失敗しました"];
      return;
    }
    
    HANAccountService* account = [HANAccountService new];
    BOOL save = [account saveUserName:user password:password];
    if(!save){
      [HANAlertUtil showError:@"認証が失敗しました"];
      return;
    }
    
    [wSelf showResultAlert:@"認証が完了しました"];
  }];
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(buttonIndex == alertView.cancelButtonIndex){
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

#pragma mark - Private 
- (void)showResultAlert:(NSString *)text
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:text delegate:nil cancelButtonTitle:@"閉じる" otherButtonTitles:nil];
  alert.accessibilityLabel = [alert buttonTitleAtIndex:alert.cancelButtonIndex];
  alert.delegate = self;
  [alert show];
}

@end
