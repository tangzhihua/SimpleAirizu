//
//  NetRequestHandleNilObject.h
//  ModelLib
//
//  Created by 唐志华 on 14-4-20.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INetRequestHandle.h"

// 网络请求控制句柄, 安全空对象, 用于初始化
@interface NetRequestHandleNilObject : NSObject <INetRequestHandle>

@end
