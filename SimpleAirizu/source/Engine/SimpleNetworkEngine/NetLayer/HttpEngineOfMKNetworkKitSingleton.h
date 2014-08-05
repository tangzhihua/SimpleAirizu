//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>
#import "INetLayerInterface.h"


@interface HttpEngineOfMKNetworkKitSingleton : NSObject <INetLayerInterface>
+ (HttpEngineOfMKNetworkKitSingleton *) sharedInstance;

#pragma mark -
#pragma mark - 实现 INetLayerInterface 协议
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
                                                 failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock;
@end
