//
//  AppDelegate.h
//  SimpleAirizu
//
//  Created by 唐志华 on 14-8-5.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

@interface AppDelegate : Activity <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;

+ (AppDelegate *)sharedAppDelegate;
@end
