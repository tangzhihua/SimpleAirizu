//
//  Message.m
//  airizu
//
//  Created by 唐志华 on 12-12-26.
//
//

#import "Message.h"

@implementation Message

- (id)init {
  if ((self = [super init])) {
    _what = -1;
    _data = [[NSMutableDictionary alloc] init];
  }
  
  return self;
}

+ (Message *)obtain {
  return [[Message alloc] init];
}
@end
