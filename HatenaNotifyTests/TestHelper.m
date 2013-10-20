//
//  TestHelper.m
//  HatenaNotify
//

#import "TestHelper.h"

@implementation TestHelper

+ (NSArray *)objectsFromPullJSON
{
  NSBundle *bundle = [NSBundle bundleForClass:[TestHelper class]];
  NSData *data = [NSData dataWithContentsOfFile:[bundle pathForResource:@"pull.json" ofType:nil]];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
  return json[@"notices"];
}

+ (NSData *)dataFromPullJSON
{
  NSBundle *bundle = [NSBundle bundleForClass:[TestHelper class]];
  return [NSData dataWithContentsOfFile:[bundle pathForResource:@"pull.json" ofType:nil]];
}


+ (NSDictionary *)anyPullObject
{
  return [[TestHelper objectsFromPullJSON] lastObject];
}

@end
