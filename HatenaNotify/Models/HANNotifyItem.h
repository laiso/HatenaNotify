//
//  HANNotifyItem.h
//  HatenaNotify
//

#import <Foundation/Foundation.h>

@interface HANNotifyItem : NSObject
@property(nonatomic, readonly) NSURL *iconURL;
@property(nonatomic, readonly) NSURL *subjectURL;
@property(nonatomic, readonly) NSString *message;
@property(nonatomic, readonly) NSTimeInterval modified;
- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;
@end
