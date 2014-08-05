//
//  CommandForLoadingLocalCacheData.m
//  airizu
//
//  Created by 唐志华 on 13-3-22.
//
//

#import "CommandForInitApp.h"

#import "GlobalDataCacheForMemorySingleton.h"
#import "GlobalDataCacheForNeedSaveToFileSystem.h"

#import "LocalCacheDataPathConstant.h"

#import "MKNetworkEngineSingletonForImageDownload.h"
#import "MKNetworkEngineSingletonForUpAndDownLoadBigFile.h"






@interface CommandForInitApp ()
// 这个命令只能执行一次
@property (nonatomic, assign) BOOL isExecuted;

@end










@implementation CommandForInitApp
/**
 
 * 执行命令对应的操作
 
 */
-(void)execute {
  
  if (!self.isExecuted) {
    self.isExecuted = YES;
		
    // 创建本地缓存目录
    ///
    // 初始化单例类
    [MKNetworkEngineSingletonForImageDownload sharedInstance];
    [MKNetworkEngineSingletonForUpAndDownLoadBigFile sharedInstance];
    // 目前使用的是 MKNetworkKit 的 UIImageView+MKNetworkKitAdditions.h 这个类别, 来进行 图片的缓存加载
    [UIImageView setDefaultEngine:[MKNetworkEngineSingletonForImageDownload sharedInstance]];
    //
    [SimpleNetworkEngineSingleton sharedInstance];
    //
    [GlobalDataCacheForMemorySingleton sharedInstance];
    // 发送个无害的消息, 只是为了让 GlobalDataCacheForNeedSaveToFileSystem 调用其自身的+(void)initialize方法.
    [GlobalDataCacheForNeedSaveToFileSystem self];
    // 创建本地缓存目录
    [LocalCacheDataPathConstant createLocalCacheDirectories];
    
    
    
  }
  
}

#pragma mark -
#pragma mark 单例方法群

// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
-(id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

// 真正的(私有)init方法
-(id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
    _isExecuted = NO;
    
  }
  
  return self;
}

+(id)commandForCommandForInitApp {
	
  static CommandForInitApp *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}


@end
