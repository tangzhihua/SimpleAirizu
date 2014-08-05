//
//  NetRequestHandleNilObject.m
//  ModelLib
//
//  Created by 唐志华 on 14-4-20.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import "NetRequestHandleNilObject.h"

@implementation NetRequestHandleNilObject
/**
 * 判断当前网络请求, 是否处于空闲状态(只有处于空闲状态时, 才应该发起一个新的网络请求)
 *
 * @return
 */
- (BOOL)isBusy {
  return NO;
}

/**
 * 取消当前请求
 */
- (void)cancel {
  
}
@end
