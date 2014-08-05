//
//  INetRequestCancel.h
//  ModelLib
//
//  Created by 唐志华 on 14-4-18.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import <Foundation/Foundation.h>

// 判断当前网络请求是否已经被取消了
@protocol INetRequestIsCancelled <NSObject>
/**
 * 判断当前网络请求是否已经被取消
 *
 * @return
 */
- (BOOL)isCancell;
@end
