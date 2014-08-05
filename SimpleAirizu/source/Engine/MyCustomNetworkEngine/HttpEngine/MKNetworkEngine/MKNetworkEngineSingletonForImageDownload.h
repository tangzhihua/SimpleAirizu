//
//  MKNetworkEngineSingletonForImageDownload.h
//  SimpleBook
//
//  Created by 唐志华 on 13-12-12.
//  Copyright (c) 2013年 唐志华. All rights reserved.
//

#import "MKNetworkEngine.h"

 
@class MKNetworkEngine;
@interface MKNetworkEngineSingletonForImageDownload : NSObject
+ (MKNetworkEngine *) sharedInstance;
@end