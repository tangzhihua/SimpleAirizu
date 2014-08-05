//
//  HttpRequestHandleOfMKNetworkKit.m
//  ModelLib
//
//  Created by 唐志华 on 14-4-18.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import "HttpRequestHandleOfMKNetworkKit.h"

@implementation HttpRequestHandleOfMKNetworkKit
#pragma mark -
#pragma mark - 实现 INetRequestHandle 协议
/**
 * 判断当前网络请求, 是否处于空闲状态(只有处于空闲状态时, 才应该发起一个新的网络请求)
 *
 * @return
 */
- (BOOL)isBusy {
  return !(self.isFinished || self.isCancelled);
}

/**
 * 取消当前请求
 */
- (void)cancel {
  [super cancel];
}

#pragma mark -
#pragma mark - 实现 INetRequestIsCancelled 协议
/**
 * 判断当前网络请求是否已经被取消
 *
 * @return
 */
- (BOOL)isCancell {
  return self.isCancelled;
}
@end
