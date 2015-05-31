//
//  HqPushSdk.h
//  HqSdkIosLib
//
//  Created by lixiurui on 14-8-26.
//  Copyright (c) 2014年 lixiurui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HqPushSdk : NSObject

+(void)startPush:(NSString*)pid;

+(void)processLaunchOption:(NSDictionary*)launchOptions;

+(void)processNotification:(UILocalNotification*)noti;

@end
