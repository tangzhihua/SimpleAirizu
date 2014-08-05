//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "SimpleCookieSingleton.h"
 

static const NSString *const TAG = @"<SimpleCookieSingleton>";

@interface SimpleCookieSingleton()
@property (nonatomic, retain) NSMutableDictionary *cookieCache;
@end

@implementation SimpleCookieSingleton
 
#pragma mark -
#pragma mark 单例方法群
// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
-(id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

// 真正的(私有)init方法
-(id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
    _cookieCache = [[NSMutableDictionary alloc] initWithCapacity:10];
  }
  
  return self;
}

+ (SimpleCookieSingleton *) sharedInstance {
  static SimpleCookieSingleton *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

#pragma mark -
#pragma mark 实例方法群
- (void) clearCookie {
  [_cookieCache removeAllObjects];
}

- (void) setObject:(NSString *) value
            forKey:(NSString *) key {
  [_cookieCache setObject:value forKey:key];
}

- (void) removeObjectForKey:(NSString *) key {
  [_cookieCache removeObjectForKey:key];
}

- (NSString *) cookieString {

  if ([_cookieCache count] <= 0) {
    return nil;
  }
  
  NSMutableArray *mutableParameterComponents = [NSMutableArray array];
  [_cookieCache enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    NSString *component = [NSString stringWithFormat:@"%@=%@", key, obj];
    [mutableParameterComponents addObject:component];
  }];
  
  return [mutableParameterComponents componentsJoinedByString:@";"];
}

@end
