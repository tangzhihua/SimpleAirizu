//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "SimpleNetworkEngineSingleton.h"

#import "IDomainBeanHelper.h"
#import "IParseNetRequestDomainBeanToDataDictionary.h"
#import "DomainBeanHelperFlyweightFactorySingleton.h"
#import "EngineHelperSingleton.h"
#import "INetRequestEntityDataPackage.h"

#import "SimpleCookieSingleton.h"

#import "INetRespondRawEntityDataUnpack.h"
#import "IServerRespondDataTest.h"
#import "IParseNetRequestDomainBeanToDataDictionary.h"
#import "INetRespondDataToNSDictionary.h"
#import "ISpliceFullUrlByDomainBeanSpecialPath.h"

#import "BaseModel.h"

#import "UrlConstantForThisProject.h"
#import "MyNetRequestErrorBean.h"

#import "NetLayerFactoryMethodSingleton.h"

#import "INetRequestHandle.h"
#import "INetRequestIsCancelled.h"

#import "NetRequestHandleNilObject.h"
#import "NetRequestErrorConstantDefs.h"

@interface SimpleNetworkEngineSingleton()


@end


@implementation SimpleNetworkEngineSingleton

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

+ (SimpleNetworkEngineSingleton *)sharedInstance {
  static SimpleNetworkEngineSingleton *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

- (NSOperationQueuePriority)netLayerOperationPriorityTransform:(NetRequestOperationPriority)netRequestOperationPriority {
  switch (netRequestOperationPriority) {
    case NetRequestOperationPriorityVeryLow:
      
      return NSOperationQueuePriorityVeryLow;
    case NetRequestOperationPriorityLow:
      
      return NSOperationQueuePriorityLow;
    case NetRequestOperationPriorityNormal:
      
      return NSOperationQueuePriorityNormal;
    case NetRequestOperationPriorityHigh:
      
      return NSOperationQueuePriorityHigh;
    case NetRequestOperationPriorityVeryHigh:
      
      return NSOperationQueuePriorityVeryHigh;
  }
}

#pragma mark -
#pragma mark 对外公开的方法

- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock{
  return [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                          netRequestOperationPriority:NetRequestOperationPriorityNormal
                                           beginBlock:nil
                                       successedBlock:successedBlock
                                          failedBlock:failedBlock
                                             endBlock:nil];
}

/// 新的引擎接口
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock {
  return [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                          netRequestOperationPriority:NetRequestOperationPriorityNormal
                                           beginBlock:beginBlock
                                       successedBlock:successedBlock
                                          failedBlock:failedBlock
                                             endBlock:endBlock];
}

/// 普通形式
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                    netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
  return [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                          netRequestOperationPriority:NetRequestOperationPriorityNormal
                                           beginBlock:nil
                                       successedBlock:successedBlock
                                          failedBlock:failedBlock
                                             endBlock:nil];
}

/// 配合UI显示的形式
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                    netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock {
  PRPLog(@" ");
	PRPLog(@" ");
	PRPLog(@" ");
	PRPLog(@"<<<<<<<<<<     发起一个DomainBean网络请求, 参数检验中....     >>>>>>>>>>");
	PRPLog(@" ");
	
	do {
		if (netRequestDomainBean == nil || successedBlock == NULL || failedBlock == NULL) {
			RNAssert(NO, @"入参为空.");
			break;
		}
		
		// 将 "网络请求业务Bean" 的 完整class name 作为和这个业务Bean对应的"业务接口" 绑定的所有相关的处理算法的唯一识别Key
		NSString *abstractFactoryMappingKey = NSStringFromClass([netRequestDomainBean class]);
		PRPLog(@"%@%@", @"abstractFactoryMappingKey--> ", abstractFactoryMappingKey);
		
		// 这里的设计使用了 "抽象工厂" 设计模式
		id<IDomainBeanHelper> domainBeanAbstractFactoryObject = [[DomainBeanHelperFlyweightFactorySingleton sharedInstance] domainBeanHelperByRequestDomainBeanClassName:abstractFactoryMappingKey];
		if (![domainBeanAbstractFactoryObject conformsToProtocol:@protocol(IDomainBeanHelper)]) {
			RNAssert(NO, @"必须实现 IDomainBeanHelper 接口");
			break;
		}
		
		// 获取当前业务网络接口, 对应的URL
    NSString *specialPath = [domainBeanAbstractFactoryObject getSpecialPath];
		NSString *fullUrlString = [[[EngineHelperSingleton sharedInstance] getSpliceFullUrlByDomainBeanSpecialPathStrategyObject] fullUrlByDomainBeanSpecialPath:specialPath];
    PRPLog(@"specialPath-->%@", specialPath);
		PRPLog(@"fullUrlString-->%@", fullUrlString);
		
    // 完整的 "数据字典"
    NSDictionary *dataDictionary = nil;
    
		/**
		 * 处理HTTP 请求实体数据, 如果有实体数据的话, 就设置 RequestMethod 为 "POST" 目前POST 和 GET的认定标准是, 有附加参数就使用POST, 没有就使用GET(这里要跟后台开发团队事先约定好)
		 */
		id<IParseNetRequestDomainBeanToDataDictionary> parseDomainBeanToDataDictionary = [domainBeanAbstractFactoryObject getParseDomainBeanToDDStrategy];
    if ([parseDomainBeanToDataDictionary conformsToProtocol:@protocol(IParseNetRequestDomainBeanToDataDictionary)]) {
      dataDictionary = [parseDomainBeanToDataDictionary parseNetRequestDomainBeanToDataDictionary:netRequestDomainBean];
      PRPLog(@"%@%@\n", @"dataDictionary--> \n", dataDictionary);
    }
    
    id<INetRequestHandle> requestHandle = [[NetLayerFactoryMethodSingleton sharedInstance] requestDomainBeanWithNetRequestBean:netRequestDomainBean netRequestOperationPriority:[self netLayerOperationPriorityTransform:netRequestOperationPriority] urlString:fullUrlString dataDictionary:dataDictionary successedBlock:^(id<INetRequestIsCancelled> netRequestIsCancelled, NSData *responseData) {
      // 网络层数据正常返回
      PRPLog(@"<<<<<<<<<<     发起的 DomainBean [%@] 网络层请求成功     >>>>>>>>>>", abstractFactoryMappingKey);
      
      id netRespondDomainBean = nil;
      MyNetRequestErrorBean *serverRespondDataError = [[MyNetRequestErrorBean alloc] init];
      
			do {
				
        // ------------------------------------- >>>
        if ([netRequestIsCancelled isCancell]) {
          // 本次网络请求被取消了
          break;
        }
        // ------------------------------------- >>>
        
        NSData *netRawEntityData = responseData;
        if (![netRawEntityData isKindOfClass:[NSData class]] || netRawEntityData.length <= 0) {
          serverRespondDataError.errorCode = kNetErrorCodeEnum_Server_NoResponseData;
          serverRespondDataError.errorMessage = @"-->从服务器端获得的实体数据为空(EntityData), 这种情况有可能是正常的, 比如 退出登录 接口, 服务器就只是通知客户端访问成功, 而不发送任何实体数据. 也可能是网络超时.";
          break;
        }
        // 将具体网络引擎层返回的 "原始未加工数据byte[]" 解包成 "可识别数据字符串(一般是utf-8)".
        // 这里要考虑网络传回的原生数据有加密的情况, 比如MD5加密的数据, 那么在这里先解密成可识别的字符串
        id<INetRespondRawEntityDataUnpack> netRespondRawEntityDataUnpackMethod = [[EngineHelperSingleton sharedInstance] getNetRespondEntityDataUnpackStrategyAlgorithm];
        if (![netRespondRawEntityDataUnpackMethod conformsToProtocol:@protocol(INetRespondRawEntityDataUnpack)]) {
          serverRespondDataError.errorCode = kNetErrorCodeEnum_Client_ProgrammingError;
          serverRespondDataError.errorMessage = @"-->解析服务器端返回的实体数据的 \"解码算法类(INetRespondRawEntityDataUnpack)\"是必须要实现的.";
          RNAssert(NO, @"%@", serverRespondDataError.errorMessage);
          break;
        }
        NSString *netUnpackedDataOfUTF8String = [netRespondRawEntityDataUnpackMethod unpackNetRespondRawEntityDataToUTF8String:netRawEntityData];
        if ([NSString isEmpty:netUnpackedDataOfUTF8String]) {
          serverRespondDataError.errorCode = kNetErrorCodeEnum_Server_UnpackedResponseDataFailed;
          serverRespondDataError.errorMessage = @"-->解析服务器端返回的实体数据失败, 在netUnpackedDataOfUTF8String不为空的时候, unpackNetRespondRawEntityDataToUTF8String是绝对不能为空的.";
          break;
        }
        PRPLog(@"服务器返回的响应数据 -------------->      \n\n%@\n\n\n\n", netUnpackedDataOfUTF8String);
        
        // 检查服务器返回的数据是否有效, 如果无效, 要获取服务器返回的错误码和错误描述信息
        // (比如说某次网络请求成功了, 但是服务器那边没有有效的数据给客户端, 所以服务器会返回错误码和描述信息告知客户端访问结果)
        id<IServerRespondDataTest> serverRespondDataTest = [[EngineHelperSingleton sharedInstance] getServerRespondDataTestStrategyAlgorithm];
        if (![serverRespondDataTest conformsToProtocol:@protocol(IServerRespondDataTest)]) {
          serverRespondDataError.errorCode = kNetErrorCodeEnum_Client_ProgrammingError;// app 内部程序实现错误
          serverRespondDataError.errorMessage = @"-->检查服务器返回是否有效(IServerRespondDataTest)的算法类, 是必须实现的";
          RNAssert(NO, @"%@", serverRespondDataError.errorMessage);
          break;
        }
        [serverRespondDataError reinitialize:[serverRespondDataTest testServerRespondDataIsValid:netUnpackedDataOfUTF8String]];
        if (serverRespondDataError.errorCode != kNetErrorCodeEnum_Success) {
          // 如果服务器没有有效的数据到客户端, 那么就不需要创建 "网络响应业务Bean"
          PRPLog(@"-->服务器端告知客户端, 本次网络访问未获取到有效数据(具体情况--> %@", serverRespondDataError);
          break;
        }
        
        
				// 将 "已经解包的可识别数据字符串" 解析成 "具体的业务响应数据Bean"
				// note : 将服务器返回的数据字符串(已经解密, 解码完成了), 解析成对应的 "网络响应业务Bean"
        // 20130625 : 对于那种单一的项目, 就是不会同时有JSON/XML等多种数据格式的项目, 可以完全使用KVC来生成 NetRespondBean
				id<IDomainBeanHelper> domainBeanHelper = [[DomainBeanHelperFlyweightFactorySingleton sharedInstance] domainBeanHelperByRequestDomainBeanClassName:abstractFactoryMappingKey];
				if ([domainBeanHelper conformsToProtocol:@protocol(IDomainBeanHelper)]) {
          
          id<INetRespondDataToNSDictionary> netRespondDataToNSDictionaryStrategyAlgorithm = [[EngineHelperSingleton sharedInstance] getNetRespondDataToNSDictionaryStrategyAlgorithm];
					if ([netRespondDataToNSDictionaryStrategyAlgorithm conformsToProtocol:@protocol(INetRespondDataToNSDictionary)]) {
            NSDictionary *netRespondDictionary = [netRespondDataToNSDictionaryStrategyAlgorithm netRespondDataToNSDictionary:netUnpackedDataOfUTF8String];
            if (netRespondDictionary == nil) {
              // 异常 (NullPointerException)
              //RNAssert(NO, @"-->服务器返回的数据, 不能被成功解析成数据字典!");
#warning 因为现在没有和服务器约定一些错误码, 所以目前服务器不能通过返回 errorCode 和 errorMessage 来告知客户端到底出了什么问题, 所以目前临时处理服务器 无结果返回 这种错误
              serverRespondDataError.errorCode = kNetErrorCodeEnum_Server_ResponseDataToDictionaryFailed;
              serverRespondDataError.errorMessage = @"服务器返回的数据, 不能被成功解析成数据字典!";
              break;
            }
            
            // 将 "数据字典" 直接通过 "KVC" 的方式转成 "业务Bean"
            netRespondDomainBean = [[[domainBeanHelper getClassOfNetRespondBean] alloc] initWithDictionary:netRespondDictionary];
            
					}
				}
        
				// ----------------------------------------------------------------------------
        
				
			} while (NO);
			
      // ------------------------------------- >>>
      // 通知控制层, 本次网络请求成功
      if (![netRequestIsCancelled isCancell]) {
        
        if (serverRespondDataError.errorCode != kNetErrorCodeEnum_Success) {
          failedBlock(serverRespondDataError);
        } else {
          successedBlock(netRespondDomainBean);
        }
        
      } else {
        PRPLog(@"<<<<<<<<<<     发起的 DomainBean [%@] 网络请求, 已经被取消     >>>>>>>>>>", abstractFactoryMappingKey);
      }
      // ------------------------------------- >>>
      
      // ------------------------------------- >>>
      // 通知控制层, 本次网络请求彻底完成
      if (endBlock != NULL) {
        endBlock();
      }
      // ------------------------------------- >>>
      
    } failedBlock:^(id<INetRequestIsCancelled> netRequestIsCancelled, NSError *error) {
      // 发生网络请求错误
      PRPLog(@"<<<<<<<<<<     发起的 DomainBean [%@] 网络请求, 网络层访问失败 , 原因-->%@     >>>>>>>>>>", abstractFactoryMappingKey, error.localizedDescription);
      
      // ------------------------------------- >>>
      // 通知控制层, 本次网络请求失败
      if (![netRequestIsCancelled isCancell]) {
        
        MyNetRequestErrorBean *serverRespondDataError = [MyNetRequestErrorBean netRequestErrorBeanWithErrorCode:error.code errorMessage:error.localizedDescription];
        
        failedBlock(serverRespondDataError);
        
      } else {
        
        PRPLog(@"<<<<<<<<<<     发起的 DomainBean [%@] 网络请求, 已经被取消      >>>>>>>>>>", abstractFactoryMappingKey);
      }
      // ------------------------------------- >>>
      
      // ------------------------------------- >>>
      // 通知控制层, 本次网络请求彻底完成
      if (endBlock != NULL) {
        endBlock();
      }
      // ------------------------------------- >>>
    }];
    
    
    PRPLog(@" ");
		PRPLog(@" ");
		PRPLog(@" ");
		PRPLog(@"<<<<<<<<<<     参数检验正确, 启动子线程进行异步访问.     >>>>>>>>>>");
		PRPLog(@" ");
		PRPLog(@" ");
		PRPLog(@" ");
		
		
    // 发起网络请求成功
    if (beginBlock != NULL) {
      // 通知控制层, 本次网络请求参数正确, 激活成功
      beginBlock();
    }
    return requestHandle;
	} while (NO);
	
  
  PRPLog(@" ");
  PRPLog(@" ");
  PRPLog(@" ");
  PRPLog(@"<<<<<<<<<<     参数检验错误     >>>>>>>>>>");
  PRPLog(@" ");
  PRPLog(@" ");
  PRPLog(@" ");
  // 发起网络请求失败
  return [[NetRequestHandleNilObject alloc] init];
  
}
@end
