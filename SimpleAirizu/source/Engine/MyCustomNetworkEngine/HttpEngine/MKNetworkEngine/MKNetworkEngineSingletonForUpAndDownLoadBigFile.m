//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "MKNetworkEngineSingletonForUpAndDownLoadBigFile.h"

#import "MKNetworkKit.h"
#import "UIImageView+MKNetworkKitAdditions.h"

@interface MyCustomMKNetworkEngineForUpAndDownLoadFile : MKNetworkEngine

@end

@implementation MyCustomMKNetworkEngineForUpAndDownLoadFile

@end

@interface MKNetworkEngineSingletonForUpAndDownLoadBigFile ()
@property (nonatomic, strong) MKNetworkEngine *networkEngine;
@end

@implementation MKNetworkEngineSingletonForUpAndDownLoadBigFile


-(id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
    
    _networkEngine = [[MyCustomMKNetworkEngineForUpAndDownLoadFile alloc] initWithHostName:kUrlConstant_MainUrl];
    
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
  static MKNetworkEngineSingletonForUpAndDownLoadBigFile *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance.networkEngine;
}


@end
