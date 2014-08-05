//
//  IntentFilter.m
//  airizu
//
//  Created by 唐志华 on 13-1-24.
//
//

#import "IntentFilter.h"
static const NSString *const TAG = @"<IntentFilter>";

@interface IntentFilter ()

@end

@implementation IntentFilter

- (NSString *)description {
  NSString *description = [NSString stringWithFormat:@"IntentFilter [actions=%@", _actions];
  return description;
}

- (id) init {
  if ((self = [super init])) {
		_actions = [[NSMutableArray alloc] initWithCapacity:10];
  }
  
  return self;
}

+(id)intentFilter {
  return [[IntentFilter alloc] init];
}
@end
