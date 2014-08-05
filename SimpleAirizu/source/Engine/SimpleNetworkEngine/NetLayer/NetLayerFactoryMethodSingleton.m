//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "NetLayerFactoryMethodSingleton.h"

#import "HttpEngineOfMKNetworkKitSingleton.h"

@implementation NetLayerFactoryMethodSingleton
#pragma mark -
#pragma mark Singleton Implementation

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
    
    
  }
  
  return self;
}

+ (NetLayerFactoryMethodSingleton *) sharedInstance {
  static NetLayerFactoryMethodSingleton *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

#pragma mark -
#pragma mark 实现 INetLayerInterface 协议
/**
 * 发起一个业务Bean的http请求
 *
 * @param url
 *          完整的URL
 * @param dataDictionary
 *          数据字典
 * @param shortConnectionAsyncHttpResponseListener
 *          http异步响应监听
 * @return
 */
- (id<INetRequestHandle>)requestDomainBeanWithNetRequestBean:(in id)netRequestDomainBean
                                 netRequestOperationPriority:(in NSOperationQueuePriority)netRequestOperationPriority
                                                   urlString:(in NSString *)urlString
                                              dataDictionary:(in NSDictionary *)dataDictionary
                                              successedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                 failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock {
  return [[HttpEngineOfMKNetworkKitSingleton sharedInstance] requestDomainBeanWithNetRequestBean:netRequestDomainBean
                                                                     netRequestOperationPriority:netRequestOperationPriority
                                                                                       urlString:urlString
                                                                                  dataDictionary:dataDictionary
                                                                                  successedBlock:successedBlock
                                                                                     failedBlock:failedBlock];
}
@end
