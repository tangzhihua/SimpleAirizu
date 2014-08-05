//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#ifndef ModelLib_MacroConstantForPublic_h
#define ModelLib_MacroConstantForPublic_h


typedef NS_ENUM(NSInteger, UserNotificationEnum) {
	
	// 从服务器获取重要信息成功
	kUserNotificationEnum_GetImportantInfoFromServerSuccess = 2013,
  // 用户登录 "成功"
  kUserNotificationEnum_UserLogonSuccess,
  // 用户已经退出登录
  kUserNotificationEnum_UserLoged,
  
  // 获取软件新版本信息 "成功"
  kUserNotificationEnum_GetNewAppVersionSuccess,
  
  // 订单支付成功
  kUserNotificationEnum_OrderPaySucceed,
  // 订单支付失败
  kUserNotificationEnum_OrderPayFailed,
  
  
  // 下载完成并且安装成功一本书籍
  kUserNotificationEnum_DownloadAndInstallSucceed
};


typedef NS_ENUM(NSInteger, NewVersionDetectStateEnum) {
  // 还未进行 新版本 检测
  kNewVersionDetectStateEnum_NotYetDetected = 0,
  // 服务器端有新版本存在
  kNewVersionDetectStateEnum_HasNewVersion,
  // 本地已经是最新版本
  kNewVersionDetectStateEnum_LocalAppIsTheLatest
};



#define CustomErrorDomain @"com.retech.dreambook.client"

#define IOS7_OR_LATER       ([UIDevice currentDevice].systemVersion.floatValue > 7.0)
#define CURRENT_IOS_VERSION [[UIDevice currentDevice].systemVersion floatValue]
#define IS_iPad             ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound)
#define IS_IPHONE5          ([[UIScreen mainScreen] bounds].size.height * [UIScreen mainScreen].scale == 1136)

#endif
