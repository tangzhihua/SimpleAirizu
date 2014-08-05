//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "MKNetworkEngineSingletonForImageDownload.h"

#import "MKNetworkKit.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "LocalCacheDataPathConstant.h"

@interface MyCustomMKNetworkEngineForImageDownload : MKNetworkEngine

@end

@implementation MyCustomMKNetworkEngineForImageDownload
/*!
 *  @abstract Cache Directory Name , 缓存目录名称
 *
 *  @discussion
 *	This method can be over-ridden by subclasses to provide an alternative cache directory.
 这个方法可以被子类覆盖, 用于提供一个替代的缓存目录.
 *  The default directory (MKNetworkKitCache) within the NSCaches directory will be used otherwise.
 否则默认的目录名称是 MKNetworkKitCache, 在NSCaches目录中, 将被使用.
 *  Overriding this method is optional
 重写此方法是可选的.
 */
- (NSString*)cacheDirectoryName {
  return [LocalCacheDataPathConstant thumbnailCachePath];
}

/*!
 *  @abstract Cache Directory In Memory Cost,
 *
 *  @discussion
 *	This method can be over-ridden by subclasses to provide an alternative in memory cache size.
 这个方法可以被子类覆盖, 用于提供一个内存缓存大小的新尺寸.
 *  By default, MKNetworkKit caches 10 recent requests in memory.
 默认的, MKNetworkKit将在内存中缓存最近的10条请求.
 *  The default size is 10
 *  Overriding this method is optional
 */
- (NSUInteger)cacheMemoryCost {
  return 20;
}

@end

@interface MKNetworkEngineSingletonForImageDownload ()
@property (nonatomic, strong) MKNetworkEngine *networkEngine;
@end

@implementation MKNetworkEngineSingletonForImageDownload


-(id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
    
    _networkEngine = [[MyCustomMKNetworkEngineForImageDownload alloc] init];
    [_networkEngine useCache];
  }
  
  return self;
  
}

#pragma mark -
#pragma mark Singleton Implementation

// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
-(id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

+ (MKNetworkEngine *) sharedInstance {
  static MKNetworkEngineSingletonForImageDownload *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance.networkEngine;
}


@end
