//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "StrategyClassNameMappingBase.h"

@implementation StrategyClassNameMappingBase

- (id)init {
	
	if ((self = [super init])) {
    
    strategyClassesNameMappingList = [[NSMutableDictionary alloc] initWithCapacity:50];
	}
	
	return self;
}

#pragma mark
#pragma mark 通过 key 查找 对应的抽象工厂类 (专为子类准备的)
- (NSString *)getTargetClassNameForKey:(id)key {
  
  RNAssert(key != nil, @"入参 key 不能为空 ! ");
  
  NSString *className = [strategyClassesNameMappingList objectForKey:key];
  return className;
}

@end
