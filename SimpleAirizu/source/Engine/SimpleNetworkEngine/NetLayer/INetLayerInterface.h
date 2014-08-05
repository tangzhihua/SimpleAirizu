//
//  INetLayerInterface.h
//  ModelLib
//
//  Created by 唐志华 on 14-4-18.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INetRequestIsCancelled;
@protocol INetRequestHandle;

// 异步网络响应监听块
typedef void (^NetLayerAsyncNetResponseListenerInUIThreadSuccessedBlock)(id<INetRequestIsCancelled> netRequestIsCancelled, NSData *responseData);
typedef void (^NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)(id<INetRequestIsCancelled> netRequestIsCancelled, NSError *error);


// "网络层" 提供给 "业务网络层" 的接口
@protocol INetLayerInterface <NSObject>
@required
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

@optional
/// 这才是理想的接口, 对于今日书院项目, 因为后台没有和客户端定制良好的约定, 导致不得不在 "网络层" 看到了 "业务层"才能看见的netRequestDomainBean
- (id<INetRequestHandle>)requestNetworkWithUrlString:(in NSString *)urlString
                         netRequestOperationPriority:(in NSOperationQueuePriority)netRequestOperationPriority
                                      dataDictionary:(in NSDictionary *)dataDictionary
                                      successedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadSuccessedBlock)successedBlock
                                         failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock;
@end
