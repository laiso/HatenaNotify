//
//  HANNotifyItem.m
//  HatenaNotify
//

#import "HANNotifyItem.h"

@interface HANNotifyItem()
@property(nonatomic, strong) NSMutableDictionary* objects;
@end

@implementation HANNotifyItem

- (NSURL *)iconURL
{
  return [NSURL URLWithString:[self.objects objectForKey:@"icon"]];
}

- (NSURL *)subjectURL
{
  return [NSURL URLWithString:[self.objects objectForKey:@"subject"]];
}

- (NSString *)message
{
  NSMutableString *text = [NSMutableString string];
  [self.objects[@"content"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
    NSString* word;
    
    // String
    if([obj respondsToSelector:@selector(isEqualToString:)]){
      [text appendString:(NSString *)obj];
      return;
    }
    
    // Number
    if([obj respondsToSelector:@selector(stringValue)]){
      [text appendString:[(NSNumber *)obj stringValue]];
      return;
    }
    
    // Dictionary
    if([obj objectForKey:@"name"]){
      word = obj[@"name"];
    }else if([obj objectForKey:@"text"]){
      word = obj[@"text"];
    }else if([[obj objectForKey:@"type"] isEqualToString:@"star"]){
      word = @"\u2B50";
    }else{
      DLog(@"%@", obj);
    }
    
    if(word){
      [text appendString:word];
    }
  }];
  return [text copy];
}

- (NSTimeInterval)modified
{
  return [self.objects[@"modified"] doubleValue];
}

- (instancetype)init
{
  self = [super init];
  if(self){
    _objects = [NSMutableDictionary dictionary];
  }
  return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary
{
  self = [self init];
  if(self){
    _objects = [NSMutableDictionary dictionaryWithDictionary:otherDictionary];
  }
  return self;
}

@end
