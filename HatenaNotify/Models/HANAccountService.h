//
//  HANAccountService.h
//  HatenaNotify
//

#import <Foundation/Foundation.h>

@interface HANAccountService : NSObject
@property(nonatomic, readonly) NSString *userName;
@property(nonatomic, readonly) NSString *password;
@property(nonatomic, readonly) BOOL isValidAccount;
- (BOOL)saveUserName:(NSString *)userName password:(NSString *)password;
- (BOOL)deleteAccount;
@end
