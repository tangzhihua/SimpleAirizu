//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "GlobalDataCacheForNeedSaveToFileSystem.h"

#import "GlobalDataCacheForMemorySingleton.h"
#import "NSObject+Serialization.h"
#import "LocalCacheDataPathConstant.h"

#import "LoginDatabaseFieldsConstant.h"
#import "LoginNetRespondBean.h"

#import "NSMutableDictionary+SafeSetObject.h"
#import "ToolsFunctionForThisProgect.h"

#import "NSDate+RFC1123.h"
#import "NSString+MKNetworkKitAdditions.h"

static NSString *const TAG = @"<GlobalDataCacheForNeedSaveToFileSystem>";



// 自动登录的标志
static NSString *const kLocalCacheDataName_AutoLoginMark                     = @"AutoLoginMark";
// 用户是否已经登录了
static NSString *const kLocalCacheDataName_LatestLoginNetRespondBean         = @"LatestLoginNetRespondBean";

// 用户是否是首次启动App
static NSString *const kLocalCacheDataName_FirstStartApp                     = @"FirstStartApp";
// 是否需要显示 初学者指南
static NSString *const kLocalCacheDataName_BeginnerGuide                     = @"BeginnerGuide";

// 当前app版本号, 用了防止升级app时, 本地缓存的序列化数据恢复出错.
static NSString *const kLocalCacheDataName_LocalAppVersion                   = @"LocalAppVersion";


@implementation GlobalDataCacheForNeedSaveToFileSystem

#pragma mark -
#pragma mark 单例方法群

// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
- (id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

// 真正的(私有)init方法
- (id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
  }
  
  return self;
}

+ (GlobalDataCacheForNeedSaveToFileSystem *) privateInstance {
  static GlobalDataCacheForNeedSaveToFileSystem *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

+ (void)initialize {
  // 这是为了子类化当前类后, 父类的initialize方法会被调用2次
  if (self == [GlobalDataCacheForNeedSaveToFileSystem class]) {
    // 注册 "广播消息"
    [self registerBroadcastReceiver];
    
    // 新版本升级处理
    [self newVersionUpgradeHandle];
  }
}

+ (void)dealloc {
  
  if (self == [GlobalDataCacheForNeedSaveToFileSystem class]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
 
    [self unregisterLoginInfoKVO];
    [self unregisterAppConfigKVO];
  }
}

#pragma mark -
#pragma mark 私有方法

// 新版本升级的处理工作(要删除之前的序列化对象文件, 防止类模型发生了变化)
+ (void)newVersionUpgradeHandle {
  // 检查app版本是否发生了变化, 如果发生了变化, 可能是发生了 "软件升级"
  NSString *filePath = [NSString stringWithFormat:@"%@/%@", [LocalCacheDataPathConstant importantDataCachePath], [ToolsFunctionForThisProgect localAppVersion]];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:filePath]) {
    //
    [fileManager removeItemAtPath:[LocalCacheDataPathConstant importantDataCachePath] error:nil];
    
    [fileManager createDirectoryAtPath:[LocalCacheDataPathConstant importantDataCachePath]
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
  }
}

+ (void)serializeObjectToFileSystemWithObject:(id)object fileName:(NSString *)fileName directoryPath:(NSString *)directoryPath {
  if (object == nil) {
    // 如果入参为空, 就证明要删除本地缓存的该对象的序列化文件
    NSString *serializeObjectPath = [NSString stringWithFormat:@"%@/%@", directoryPath, fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:serializeObjectPath]) {
      NSError *error = nil;
      [fileManager removeItemAtPath:serializeObjectPath error:&error];
      if (error != nil) {
        PRPLog(@"删除序列化到本地的对象文件失败! 错误描述:%@", error.localizedDescription);
      }
    }
  } else {
    [object serializeObjectToFileSystemWithFileName:fileName directoryPath:directoryPath];
  }
}

#pragma mark -
#pragma mark 将内存中缓存的数据保存到文件系统中

+ (void)readUserLoginInfoToGlobalDataCacheForMemorySingleton {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  // 自动登录的标志
  id autoLoginMark = [userDefaults objectForKey:(NSString *)kLocalCacheDataName_AutoLoginMark];
  if (autoLoginMark == nil) {
    [userDefaults setBool:YES forKey:(NSString *)kLocalCacheDataName_AutoLoginMark];
  }
  BOOL autoLoginMarkBOOL = [userDefaults boolForKey:(NSString *)kLocalCacheDataName_AutoLoginMark];
  [GlobalDataCacheForMemorySingleton sharedInstance].isNeedAutologin = autoLoginMarkBOOL;
  
  // 用户登录信息
  LoginNetRespondBean *latestLoginNetRespondBean = [LoginNetRespondBean deserializeObjectFromFileSystemWithFileName:kLocalCacheDataName_LatestLoginNetRespondBean
                                                                                                      directoryPath:[LocalCacheDataPathConstant importantDataCachePath]];
  if (latestLoginNetRespondBean != nil) {
    [[GlobalDataCacheForMemorySingleton sharedInstance] noteSignInSuccessfulInfoWithLatestLoginNetRespondBean:latestLoginNetRespondBean
                                                                               usernameForLastSuccessfulLogon:latestLoginNetRespondBean.loginName
                                                                               passwordForLastSuccessfulLogon:latestLoginNetRespondBean.password];
  }
 
  
  // 注册用户登录信息的KVO, 希望在用户登录信息发生变化时, 及时序列化相关数据
  [self registerLoginInfoKVO];
}

+ (void)readAppConfigInfoToGlobalDataCacheForMemorySingleton {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
	// 用户是否是第一次启动App
	id isFirstStartAppTest = [userDefaults objectForKey:kLocalCacheDataName_FirstStartApp];
  if (nil == isFirstStartAppTest) {
    [userDefaults setBool:YES forKey:kLocalCacheDataName_FirstStartApp];
  }
  BOOL isFirstStartApp = [userDefaults boolForKey:kLocalCacheDataName_FirstStartApp];
  [GlobalDataCacheForMemorySingleton sharedInstance].isFirstStartApp = isFirstStartApp;
	
  // 是否需要在启动后显示初学者指南界面
  id isNeedShowBeginnerGuideTest = [userDefaults objectForKey:kLocalCacheDataName_BeginnerGuide];
  if (nil == isNeedShowBeginnerGuideTest) {
    [userDefaults setBool:YES forKey:kLocalCacheDataName_BeginnerGuide];
  }
  BOOL isNeedShowBeginnerGuide = [userDefaults boolForKey:kLocalCacheDataName_BeginnerGuide];
  [GlobalDataCacheForMemorySingleton sharedInstance].isNeedShowBeginnerGuide = isNeedShowBeginnerGuide;
  
  [self registerAppConfigKVO];
}


#pragma mark -
#pragma mark 从文件系统中读取缓存的数据到内存中

+ (void)writeUserLoginInfoToFileSystem {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  // 自动登录的标志
  BOOL autoLoginMark = [GlobalDataCacheForMemorySingleton sharedInstance].isNeedAutologin;
  [userDefaults setBool:autoLoginMark forKey:(NSString *)kLocalCacheDataName_AutoLoginMark];
  
  //
  LoginNetRespondBean *latestLoginNetRespondBean = [GlobalDataCacheForMemorySingleton sharedInstance].latestLoginNetRespondBean;
  [self serializeObjectToFileSystemWithObject:latestLoginNetRespondBean fileName:kLocalCacheDataName_LatestLoginNetRespondBean directoryPath:[LocalCacheDataPathConstant importantDataCachePath]];
}

+ (void)writeAppConfigInfoToFileSystem {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
	// 是否需要显示用户第一次登录时的帮助界面的标志
  BOOL isFirstStartApp = [GlobalDataCacheForMemorySingleton sharedInstance].isFirstStartApp;
  [userDefaults setBool:isFirstStartApp forKey:kLocalCacheDataName_FirstStartApp];
	
  // 是否需要显示用户第一次登录时的帮助界面的标志
  BOOL isNeedShowBeginnerGuide = [GlobalDataCacheForMemorySingleton sharedInstance].isNeedShowBeginnerGuide;
  [userDefaults setBool:isNeedShowBeginnerGuide forKey:kLocalCacheDataName_BeginnerGuide];
}


#pragma mark -
#pragma mark 将内存级别缓存的数据固化到硬盘中

+ (void)saveMemoryCacheToDisk:(NSNotification *)notification {
  PRPLog(@"saveMemoryCacheToDisk:%@", notification);
  
  [self writeUserLoginInfoToFileSystem];
  [self writeAppConfigInfoToFileSystem];
 
}

#pragma mark -
#pragma mark - KVO 监听那些需要实时保存的对象.
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
  
  if ((__bridge id)context == self) {// Our notification, not our superclass’s
    if ([keyPath isEqualToString:kGlobalDataCacheForMemorySingletonProperty_latestLoginNetRespondBean]) {
      // 保存用户登录之后的重要信息
      [GlobalDataCacheForNeedSaveToFileSystem writeUserLoginInfoToFileSystem];
    } else if ([keyPath isEqualToString:kGlobalDataCacheForMemorySingletonProperty_isFirstStartApp]) {
      // 保存 用户第一次启动app的标志位
      [GlobalDataCacheForNeedSaveToFileSystem writeAppConfigInfoToFileSystem];
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

#pragma mark -
#pragma mark - 注册需要序列化的对象的KVO


/// 注册用户登录信息的KVO, 希望在用户登录信息发生变化时, 及时序列化相关数据
+ (void)registerLoginInfoKVO {
  [[GlobalDataCacheForMemorySingleton sharedInstance] addObserver:[GlobalDataCacheForNeedSaveToFileSystem privateInstance]
                                                       forKeyPath:kGlobalDataCacheForMemorySingletonProperty_latestLoginNetRespondBean
                                                          options:NSKeyValueObservingOptionNew
                                                          context:(__bridge void *)[GlobalDataCacheForNeedSaveToFileSystem privateInstance]];
}
+ (void)unregisterLoginInfoKVO {
  [[GlobalDataCacheForMemorySingleton sharedInstance] addObserver:[GlobalDataCacheForNeedSaveToFileSystem privateInstance]
                                                       forKeyPath:kGlobalDataCacheForMemorySingletonProperty_latestLoginNetRespondBean
                                                          options:NSKeyValueObservingOptionNew
                                                          context:(__bridge void *)[GlobalDataCacheForNeedSaveToFileSystem privateInstance]];
}

/// app config
+ (void)registerAppConfigKVO {
  [[GlobalDataCacheForMemorySingleton sharedInstance] addObserver:[GlobalDataCacheForNeedSaveToFileSystem privateInstance]
                                                       forKeyPath:kGlobalDataCacheForMemorySingletonProperty_isFirstStartApp
                                                          options:NSKeyValueObservingOptionNew
                                                          context:(__bridge void *)[GlobalDataCacheForNeedSaveToFileSystem privateInstance]];
}
+ (void)unregisterAppConfigKVO {
  
  [[GlobalDataCacheForMemorySingleton sharedInstance] removeObserver:[GlobalDataCacheForNeedSaveToFileSystem privateInstance]
                                                          forKeyPath:kGlobalDataCacheForMemorySingletonProperty_isFirstStartApp
                                                             context:(__bridge void *)[GlobalDataCacheForNeedSaveToFileSystem privateInstance]];
}

#pragma mark - NSNotification 监听一些对象状态变化时, 发送的通知
//
+ (void)registerBroadcastReceiver {
  
  // 内存告警
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(saveMemoryCacheToDisk:)
                                               name:UIApplicationDidReceiveMemoryWarningNotification
                                             object:nil];
  // 应用进入后台
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(saveMemoryCacheToDisk:)
                                               name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];
  // 应用退出
  // 该事件触发时机说明 :
  // 如果你明确地设置您的应用程序不会在后台运行（通过设置键“应用程序不会在后台运行”），只要用户按下Home键你的应用程序将被终止，它会收到applicationWillTerminate：消息。
  // 但是，如果你的应用程序没有设置这个键它可能永远不会得到applicationWillTerminate：消息，因为它得到由系统终止的时候，它应该已经被暂停。
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(saveMemoryCacheToDisk:)
                                               name:UIApplicationWillTerminateNotification
                                             object:nil];
  
 
}


@end
