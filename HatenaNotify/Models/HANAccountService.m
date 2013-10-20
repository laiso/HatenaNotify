//
//  HANAccountService.m
//  HatenaNotify
//

#import "HANAccountService.h"

#import <SSKeychain/SSKeychain.h>

#import "HANNotifyService.h"
#import "HANAPIClient.h"

static NSString * const kHatenaNotifyUserNameKey = @"HatenaNotifyUserNameKey";
static NSString * const kHatenaNotifyKeychainServiceName = @"so.lai.hatenanotify";

@interface HANAccountService()
@property(nonatomic, strong) HANAPIClient *api;
@end

@implementation HANAccountService

- (id)init
{
  self = [super init];
  if(self){
    self.api = [HANAPIClient new];
  }
  return self;
}

- (NSString *)userName
{
  return [[NSUserDefaults standardUserDefaults] stringForKey:kHatenaNotifyUserNameKey];
}

- (NSString *)password
{
  return [SSKeychain passwordForService:kHatenaNotifyKeychainServiceName account:self.userName];
}

- (BOOL)isValidAccount
{
  return (self.userName && self.password);
}

- (BOOL)saveUserName:(NSString *)userName password:(NSString *)password
{
  DLog(@"Save password. id:%@", userName);
  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:userName forKey:kHatenaNotifyUserNameKey];
  BOOL save = [defaults synchronize];
  NSAssert(save, nil);
  BOOL saveKeychain = [SSKeychain setPassword:password forService:kHatenaNotifyKeychainServiceName account:userName error:nil];
  NSAssert(saveKeychain, nil);
  return self.isValidAccount;
}

- (BOOL)deleteAccount
{
  BOOL del = [SSKeychain deletePasswordForService:kHatenaNotifyKeychainServiceName account:self.userName];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHatenaNotifyUserNameKey];
  return del;
}

- (void)renewLoginSession:(void (^)(NSError *errorOrNil))completionHandler
{
  if(self.isValidAccount){
    [self.api logout];
    [self.api login:self.userName password:self.password completionHandler:^(NSError *errorOrNil) {
      if(!errorOrNil){
        completionHandler(nil);
        return;
      }
      
      completionHandler(errorOrNil);
      return;
    }];
  }else{
    ALog(@"Couldn't find valid account.");
    NSError* error = [NSError errorWithDomain:@"" code:-1 userInfo:@{}];
    completionHandler(error);
  }
}

#pragma mark - Private

@end
