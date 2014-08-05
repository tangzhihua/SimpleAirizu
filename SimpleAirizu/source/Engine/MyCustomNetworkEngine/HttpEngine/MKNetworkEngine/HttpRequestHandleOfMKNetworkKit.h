//
//  HttpRequestHandleOfMKNetworkKit.h
//  ModelLib
//
//  Created by 唐志华 on 14-4-18.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkOperation.h"
#import "INetRequestHandle.h"
#import "INetRequestIsCancelled.h"

@interface HttpRequestHandleOfMKNetworkKit : MKNetworkOperation <INetRequestHandle, INetRequestIsCancelled>

@end
