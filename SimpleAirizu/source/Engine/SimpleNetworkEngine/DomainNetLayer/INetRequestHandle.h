//
//  INetRequestHandle.h
//  ModelLib
//
//  Created by 唐志华 on 14-4-18.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 给外部控制层持有一个网络请求的操作句柄
 *
 * @author skyduck
 *
 */
@protocol INetRequestHandle <NSObject>
/**
 * 判断当前网络请求, 是否处于繁忙状态(只有处于空闲状态时, 才应该发起一个新的网络请求)
 * 这里设计成 busy 而不是 idle 的目的是, 在iOS中, nil是安全的空对象, 如果设计成 busy时, 当 netRequestHandle 句柄对象即使为nil时, 判断逻辑也是正确的
 *
 * @return
 */
- (BOOL)isBusy;

/**
 * 取消当前请求
 */
- (void)cancel;
@end
