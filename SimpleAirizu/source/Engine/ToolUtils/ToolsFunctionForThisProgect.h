//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>

@class VersionNetRespondBean;
// app 新版本检测回调块
typedef void (^AppNewVersionTestHadNewVersionBlock)(VersionNetRespondBean *latestVersionBean);
typedef void (^AppNewVersionTestNoNewVersionBlock)();

@class LogonNetRespondBean;
@interface ToolsFunctionForThisProgect : NSObject

// 同步网络请求App最新版本信息(一定要在子线程中调用此方法, 因为使用sendSynchronousRequest发起的网络请求), 并且返回 VersionNetRespondBean
+ (VersionNetRespondBean *)synchronousRequestAppNewVersionAndReturnVersionBean;
// 异步的方式请求App最新版本信息
+ (void)asyncRequestAppNewVersionWithHadNewVersionBlock:(AppNewVersionTestHadNewVersionBlock)hadNewVersionBlock
                                      noNewVersionBlock:(AppNewVersionTestNoNewVersionBlock)noNewVersionBlock;

// 使用 Info.plist 中的 "Bundle version" 来保存本地App Version
+ (NSString *)localAppVersion;

// 本地 "图书引擎版本号"
+ (NSString *)localBookEngineVersion;

// 获取当前设备的UA信息
+ (NSString *)getUserAgent;

// 格式化 资源长度的字符串显示, 服务器传过来的是 byte 为单位的, 我们要进行格式化为 B KB MB 为单位的字符串
+ (NSString *)formatByteToMBKBBWithResLengthSizeString:(NSString *)resLengthString;
+ (NSString *)formatByteToMBKBBWithResLengthSize:(long long)resLength;

// 根据 "字体" "最大显示尺寸" 来计算一段文字所占据的显示尺寸
+ (CGSize)labelSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
@end
