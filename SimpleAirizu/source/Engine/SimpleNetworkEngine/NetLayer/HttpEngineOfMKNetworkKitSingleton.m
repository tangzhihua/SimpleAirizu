//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "HttpEngineOfMKNetworkKitSingleton.h"

#import "MKNetworkKit.h"

//
#import "GTMBase64.h"
//
#import "HttpRequestHandleOfMKNetworkKit.h"

@interface HttpEngineOfMKNetworkKitSingleton()

// 网络引擎
@property (nonatomic, strong) MKNetworkEngine *networkEngine;

@end

@implementation HttpEngineOfMKNetworkKitSingleton

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
    
    _networkEngine = [[MKNetworkEngine alloc] initWithHostName:kUrlConstant_MainUrl apiPath:kUrlConstant_MainPtah customHeaderFields:nil];
    [_networkEngine registerOperationSubclass:[HttpRequestHandleOfMKNetworkKit class]];
  }
  
  return self;
}

+ (HttpEngineOfMKNetworkKitSingleton *) sharedInstance {
  static HttpEngineOfMKNetworkKitSingleton *singletonInstance = nil;
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
  
  // 设置 公用的http header
  NSMutableDictionary *httpHeaders = [NSMutableDictionary dictionary];
  //
  NSString *cookieString = [[SimpleCookieSingleton sharedInstance] cookieString];
  if (![NSString isEmpty:cookieString]) {
    [httpHeaders setObject:cookieString forKey:@"Cookie"];
  }
  //
  [httpHeaders setObject:[ToolsFunctionForThisProgect getUserAgent] forKey:@"User-Agent"];
  
  NSString *method = @"GET";
  if (dataDictionary.count > 0) {
    method = @"POST";
  }
  MKNetworkOperation *netRequestOperation = (MKNetworkOperation *)[self.networkEngine operationWithURLString:urlString params:dataDictionary httpMethod:method];
  netRequestOperation.queuePriority = netRequestOperationPriority;
  // 设置 "当证书无效时, 也要继续网络访问" 标志位
  // TODO : 目前服务器就是这样配置的, 否则会发生 401错误, SSL -1202
  [netRequestOperation setShouldContinueWithInvalidCertificate:YES];
  [netRequestOperation addHeaders:httpHeaders];
 
  
  [netRequestOperation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    
    PRPLog(@"netRequestOperation异步请求 成功 时的状态");
    PRPLog(@"MKNetworkOperation-->isCancelled=%i", completedOperation.isCancelled);
    PRPLog(@"MKNetworkOperation-->isExecuting=%i", completedOperation.isExecuting);
    PRPLog(@"MKNetworkOperation-->isFinished=%i", completedOperation.isFinished);
    PRPLog(@"MKNetworkOperation-->isConcurrent=%i", completedOperation.isConcurrent);
    PRPLog(@"MKNetworkOperation-->isReady=%i", completedOperation.isReady);
    
    NSData *netRawEntityData = [completedOperation responseData];
    successedBlock((id<INetRequestIsCancelled>)completedOperation, netRawEntityData);
  } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    
    PRPLog(@"netRequestOperation异步请求 失败 时的状态");
    PRPLog(@"MKNetworkOperation-->isCancelled=%i", completedOperation.isCancelled);
    PRPLog(@"MKNetworkOperation-->isExecuting=%i", completedOperation.isExecuting);
    PRPLog(@"MKNetworkOperation-->isFinished=%i", completedOperation.isFinished);
    PRPLog(@"MKNetworkOperation-->isConcurrent=%i", completedOperation.isConcurrent);
    PRPLog(@"MKNetworkOperation-->isReady=%i", completedOperation.isReady);
    
    failedBlock((id<INetRequestIsCancelled>)completedOperation, error);
    
  }];
  
  [self.networkEngine enqueueOperation:netRequestOperation];
  
  PRPLog(@"将 netRequestOperation 入队之后([self.networkEngine enqueueOperation:netRequestOperation]) 的状态");
  PRPLog(@"MKNetworkOperation-->isCancelled=%i", netRequestOperation.isCancelled);
  PRPLog(@"MKNetworkOperation-->isExecuting=%i", netRequestOperation.isExecuting);
  PRPLog(@"MKNetworkOperation-->isFinished=%i", netRequestOperation.isFinished);
  PRPLog(@"MKNetworkOperation-->isConcurrent=%i", netRequestOperation.isConcurrent);
  PRPLog(@"MKNetworkOperation-->isReady=%i", netRequestOperation.isReady);
  
  return (id<INetRequestHandle>)netRequestOperation;
}

@end
