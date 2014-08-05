//
//  AppDelegate.m
//  SimpleAirizu
//
//  Created by 唐志华 on 14-8-5.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import "AppDelegate.h"

//


#import "SimpleStoreManager.h"
///
#import "CommandInvokerSingleton.h"
//
#import "CommandForInitApp.h"
#import "CommandForPrintDeviceInfo.h"
#import "CommandForGetImportantInfoFromServer.h"
#import "CommandForInitMobClick.h"
#import "CommandForNewAppVersionCheck.h"
#import "CommandForLoadingLocalCacheData.h"


#import "WelcomeActivity.h"

/*
 UIApplicationDelegate 代理函数调用的时间（应用程序生命周期）
 
 UIApplicationDelegate 包含下面几个函数监控应用程序状态的改变:
 – application:didFinishLaunchingWithOptions:
 – applicationDidBecomeActive:
 – applicationWillResignActive:
 – applicationDidEnterBackground:
 – applicationWillEnterForeground:
 – applicationWillTerminate:
 
 1)
 当一个应用程序首先运行时，调用函数 didFinishLaunchingWithOptions ，但此时应用程序还处于inactive状态，
 所以接着会调用 applicationDidBecomeActive 函数，此时就进入了应用程序的界面了。
 
 2)
 接着当按下home键时（此时主界面是应用程序主界面），会调用applicationWillResignActive函数，
 接着调用applicationDidEnterBackground函数，这时手机回到桌面。
 
 3)
 当再按下应用程序图标时，（假设此时应用程序的内存还没有被其他的应用程序挤掉），
 调用 applicationWillEnterForeground 函数，接着调用 applicationDidBecomeActive 函数，
 此时又会到应用程序主界面。
 
 4)
 在应用程序的主界面，我们双击home键，（出现多任务栏），调用 applicationWillResignActive 函数，
 点击上面部分又会回到程序中，调用 applicationDidBecomeActive 函数，如果点击多任务栏的其他应用程序，
 则会调用 applicationDidEnterBackground 函数之后，进入其他应用程序的界面。
 
 5)
 而对于 applicationWillTerminate 函数，这里要说明一下：对于我们一般的应用程序，当按下home按钮之后，
 应用程序会处于一个suspended状态，如果现在去运行其他的程序，当内存不足，
 或者在多任务栏点击“减号”会完全退出应用程序，但是不管是哪一种，
 都不会去调用 applicationWillTerminate 函数（针对IOS4以上），因此我们不能在此函数中保存数据。
 那 applicationWillTerminate 函数在什么时间调用呢？我查了下资料，还在网上找了找，
 原来这与当应用程序按下home按钮之后，应用程序的状态有关，当状态为suspended时，是永远不会调用此函数的，
 而当状态为“后台运行”（running in the background）时，当内存不足或者点击“减号”时，才会调用此函数！
 
 官方的原话为：
 （Even if you develop your application using iPhone SDK 4 and later, you must still be prepared for your application to be terminated. If memory becomes constrained, the system might remove applications from memory in order to make more room. If your application is currently suspended, the system removes your application from memory without any notice. However, if your application is currently running in the background, the system does call the applicationWillTerminate:method of the application delegate. Your application cannot request additional background execution time from this method.）
 */


@implementation AppDelegate

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[SKPaymentQueue defaultQueue] removeTransactionObserver:[SimpleStoreManager sharedInstance]];
}

+ (AppDelegate *) sharedAppDelegate {
	return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  PRPLog(@">>>>>>>>>>>>>>     应用程序 爱日租 启动      <<<<<<<<<<<<<<<<<");
  PRPLog(@">>>>>>>>>>>>>>     application:didFinishLaunchingWithOptions:      <<<<<<<<<<<<<<<<<");
  PRPLog(@"launchOptions=%@", launchOptions);
	
  // 设置支付处理监听
  [[SKPaymentQueue defaultQueue] addTransactionObserver:[SimpleStoreManager sharedInstance]];
  
  id command = nil;
	
  // 打印当前设备的信息
  command = [CommandForPrintDeviceInfo commandForPrintDeviceInfo];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // TODO : 初始化App(一定要保证首先调用)
  command = [CommandForInitApp commandForCommandForInitApp];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // 加载本地缓存的数据, 一定要保证本方法在CommandForInitApp之后调用 (有一部分本地缓存的数据, 是必须同步加载完才能进入App的.)
  command = [CommandForLoadingLocalCacheData commandForLoadingLocalCacheData];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
	// 从服务器获取重要的信息
  command = [CommandForGetImportantInfoFromServer commandForGetImportantInfoFromServer];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // 启动友盟SDK
  command = [CommandForInitMobClick commandForInitMobClick];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
	// 启动 "新版本信息检测" 子线程
  command = [CommandForNewAppVersionCheck commandForNewAppVersionCheck];
  [[CommandInvokerSingleton sharedInstance] runCommandWithCommandObject:command];
  
  // Add the view controller's view to the window and display.
  LocalActivityManager *localActivityManager = [LocalActivityManager sharedInstance];
  [_window addSubview:localActivityManager.rootViewController.view];
  [_window makeKeyAndVisible];
  
  // 启动App第一个界面
  Intent *intent = [Intent intentWithSpecificComponentClass:[WelcomeActivity class]];
  [self startActivity:intent];
  
  return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  
  // Make sure we save the model when the application is quitting
  
}


@end
