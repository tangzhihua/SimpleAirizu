//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "DomainBeanHelperFlyweightFactorySingleton.h"

#import "DomainBeanHelperClassNameMapping.h"
#import "IDomainBeanHelper.h"

@interface DomainBeanHelperFlyweightFactorySingleton()
/**
 * requestDomainBeanClassName 和 其对应的Helper类映射的map
 */
@property (nonatomic, strong) DomainBeanHelperClassNameMapping *domainBeanHelperClassNameMapping;
/**
 * 享元对象缓存集合
 */
@property (nonatomic, strong) NSMutableDictionary *flyweightObjectCacheMap;
@end

@implementation DomainBeanHelperFlyweightFactorySingleton

#pragma mark -
#pragma mark GlobalDataCacheForMemorySingleton Singleton Implementation

// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
- (id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

// 真正的(私有)init方法
- (id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
    
    _domainBeanHelperClassNameMapping = [[DomainBeanHelperClassNameMapping alloc] init];
    _flyweightObjectCacheMap = [[NSMutableDictionary alloc] initWithCapacity:100];
  }
  
  return self;
}

+ (DomainBeanHelperFlyweightFactorySingleton *)sharedInstance {
  static DomainBeanHelperFlyweightFactorySingleton *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

#pragma mark -
#pragma mark - 根据key提供一个与该key绑定的业务接口的抽象工厂对象

- (id<IDomainBeanHelper>)domainBeanHelperByRequestDomainBeanClassName:(in NSString *)requestDomainBeanClassName {
  do{
    if([NSString isEmpty:requestDomainBeanClassName]){
      RNAssert(NO, @"入参 requestDomainBeanClassName 为空.");
      break;
    }
    
    id<IDomainBeanHelper> abstractFactoryObject = [_flyweightObjectCacheMap objectForKey:requestDomainBeanClassName];
    if (abstractFactoryObject == nil) {
      NSString *className = [_domainBeanHelperClassNameMapping getTargetClassNameForKey:requestDomainBeanClassName];
      if([NSString isEmpty:className]){
        RNAssert(NO, @"找不到 requestDomainBeanClassName 对应的抽象工厂类 ! ");
        break;
      }
      
      abstractFactoryObject = [[NSClassFromString(className) alloc] init];
      if(abstractFactoryObject == nil){
        RNAssert(NO, @"反射创建抽象工厂类失败 ! ");
        break;
      }
      
      [_flyweightObjectCacheMap setObject:abstractFactoryObject forKey:requestDomainBeanClassName];
    }
    return abstractFactoryObject;
  }while(NO);
  
  return nil;
}
@end
