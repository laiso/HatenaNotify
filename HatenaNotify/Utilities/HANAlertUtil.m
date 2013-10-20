//
//  HANAlertUtil.m
//  HatenaNotify
//

#import "HANAlertUtil.h"

@implementation HANAlertUtil

+ (void)showError:(NSString *)message
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:message delegate:nil cancelButtonTitle:@"閉じる" otherButtonTitles:nil];
  [alert show];
}

@end
