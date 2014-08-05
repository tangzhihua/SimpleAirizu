//
//  GlobalDataCache.h
//
//
//  Created by 唐志华 on 12-9-13.
//
//  内存级别缓存
//
//  这是是 "按需缓存" , 内部使用 "数据模型缓存" 实现.
//
//

#import <Foundation/Foundation.h>

// 用于外部 KVO 的, 属性名称(字符串格式).
#define kGlobalDataCacheForMemorySingletonProperty_isFirstStartApp           @"isFirstStartApp"
#define kGlobalDataCacheForMemorySingletonProperty_latestLoginNetRespondBean @"latestLoginNetRespondBean"

@class LoginNetRespondBean;

@interface GlobalDataCacheForMemorySingleton : NSObject

#pragma mark -
#pragma mark - 其他配置
// 用户第一次启动App
@property (nonatomic, assign, setter=setFirstStartApp:) BOOL isFirstStartApp;
// 是否需要在app启动时, 显示 "初学者指南界面"
@property (nonatomic, assign, setter=setNeedShowBeginnerGuide:) BOOL isNeedShowBeginnerGuide;
// 是否需要自动登录的标志
@property (nonatomic, assign, setter=setNeedAutologin:) BOOL isNeedAutologin;


#pragma mark -
#pragma mark - 登录相关的全局变量

// 用户登录成功后, 服务器返回的用户相关信息
@property (nonatomic, readonly, strong) LoginNetRespondBean *latestLoginNetRespondBean;


/// 通过下面两个方法来设置上面的只读属性
- (void)noteSignInSuccessfulInfoWithLatestLoginNetRespondBean:(LoginNetRespondBean *)latestLoginNetRespondBean
                               usernameForLastSuccessfulLogon:(NSString *)usernameForLastSuccessfulLogon
                               passwordForLastSuccessfulLogon:(NSString *)passwordForLastSuccessfulLogon;
- (void)noteSignOutSuccessfulInfo;

#pragma mark -
#pragma mark - 单例
+ (GlobalDataCacheForMemorySingleton *) sharedInstance;
@end
