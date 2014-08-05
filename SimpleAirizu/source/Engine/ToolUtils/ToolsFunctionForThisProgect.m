//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "ToolsFunctionForThisProgect.h"

#import "NSDictionary+SafeValue.h"
#import "MacroConstantForPublic.h"
#import "SimpleCookieSingleton.h"
#import "VersionNetRespondBean.h"

@implementation ToolsFunctionForThisProgect

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  RNAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

// 同步网络请求App最新版本信息(一定要在子线程中调用此方法, 因为使用sendSynchronousRequest发起的网络请求), 并且返回 VersionNetRespondBean
// 今日书院(我们的app id) : 722737021
// 蚂蚁短租(用于测试) : 494520120
#define APP_URL @"http://itunes.apple.com/lookup?id=722737021"
+ (VersionNetRespondBean *)synchronousRequestAppNewVersionAndReturnVersionBean {
  VersionNetRespondBean *versionBean = nil;
  
  do {
    
    NSString *URL = APP_URL;
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:URL]];
    [urlRequest setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    // 同步请求网络数据
    NSData *recervedData
    = [NSURLConnection sendSynchronousRequest:urlRequest
                            returningResponse:&urlResponse
                                        error:&error];
    if (![recervedData isKindOfClass:[NSData class]]) {
      break;
    }
    if (recervedData.length <= 0) {
      break;
    }
    urlRequest = nil;
    
    NSDictionary *jsonRootNSDictionary = [NSJSONSerialization JSONObjectWithData:recervedData options:0 error:&error];
    
    if (![jsonRootNSDictionary isKindOfClass:[NSDictionary class]]) {
      break;
    }
    //NSString *jsonString = [[NSString alloc] initWithData:recervedData encoding:NSUTF8StringEncoding];
    
    NSArray *infoArray = [jsonRootNSDictionary objectForKey:@"results"];
    if ([infoArray count] > 0) {
      NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
      NSString *lastVersion = [releaseInfo objectForKey:@"version"];// 服务器最新版本
      NSString *trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];// 下载URL
      NSString *fileSizeBytes = [releaseInfo objectForKey:@"fileSizeBytes"];// app大小
      NSString *releaseNotes = [releaseInfo objectForKey:@"releaseNotes"];// 更新内容
      versionBean = [VersionNetRespondBean versionNetRespondBeanWithNewVersion:lastVersion
                                                                   andFileSize:fileSizeBytes
                                                              andUpdateContent:releaseNotes
                                                            andDownloadAddress:trackViewUrl];
    }
  } while (NO);
  
  return versionBean;
}

// 异步的方式请求App最新版本信息
+ (void)asyncRequestAppNewVersionWithHadNewVersionBlock:(AppNewVersionTestHadNewVersionBlock)hadNewVersionBlock
                                      noNewVersionBlock:(AppNewVersionTestNoNewVersionBlock)noNewVersionBlock {
  static VersionNetRespondBean *latestVersionBean = nil;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    do {
      latestVersionBean = [ToolsFunctionForThisProgect synchronousRequestAppNewVersionAndReturnVersionBean];
      
    } while (NO);
    
    dispatch_async(dispatch_get_main_queue(), ^{
      // 更新界面
      if (latestVersionBean != nil) {
        if (![latestVersionBean.latestVersion isEqualToString:[ToolsFunctionForThisProgect localAppVersion]]) {
          // 有新版本可以下载
          hadNewVersionBlock(latestVersionBean);
        } else {
          // 没有新版本可以下载
          noNewVersionBlock();
        }
      }
      
      
    });
  });
  
}

/*
 Xcode4有两个版本号，一个是Version,另一个是Build,对应于Info.plist的字段名分别为CFBundleShortVersionString,CFBundleVersion。
 友盟SDK为了兼容Xcode3的工程，默认取的是Build号，如果需要取Xcode4的Version，可以使用下面的方法。
 
 NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
 */
// 使用 Info.plist 中的 "Bundle version" 来保存本地App Version
+ (NSString *)localAppVersion {
  NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
  NSString *version = [infoDic objectForKey:@"CFBundleVersion"];
  return version;
}

// 本地 "图书引擎版本号"
+ (NSString *)localBookEngineVersion {
  NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
  NSString *version = [infoDic objectForKey:@"CFBundleShortVersionString"];
  return version;
}

static NSString *userAgentString = nil;
// e.g. @"DreamBook_1.1.2_iPad Simulator7.0.3_iOS7.0"
+ (NSString *)getUserAgent {
  if ([NSString isEmpty:userAgentString]) {
    // app名称 : DreamBook
    NSString *bundleName = @"DreamBook";
    // app当前版本号 : 1.1.2
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    // 当前设备型号 : e.g. @"iPhone", @"iPod touch", @"iPad Simulator"
    NSString *model = [[UIDevice currentDevice] model];
    // 当前设备操作系统系统版本号 : 7.0.3
    NSArray *aOsVersions = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    NSString *modelVersion = [[UIDevice currentDevice] systemVersion];
    NSInteger iOsVersionMajor = [[aOsVersions objectAtIndex:0] intValue];
    NSInteger iOsVersionMinor1 = [[aOsVersions objectAtIndex:1] intValue];
    userAgentString = [NSString stringWithFormat:@"%@_%@_%@%@_iOS%d.%d", bundleName, version, model, modelVersion, iOsVersionMajor, iOsVersionMinor1];
  }
  
  return  userAgentString;
}

// 格式化 资源长度的字符串显示, 服务器传过来的是 byte 为单位的, 我们要进行格式化为 B KB MB 为单位的字符串
+ (NSString *)formatByteToMBKBBWithResLengthSizeString:(NSString *)resLengthString {
  if ([NSString isEmpty:resLengthString]) {
    RNAssert(NO, @"入参异常 resLengthString 为空.");
    return nil;
  }
  
  return [self formatByteToMBKBBWithResLengthSize:[resLengthString longLongValue]];
  
}

+ (NSString *)formatByteToMBKBBWithResLengthSize:(long long)resLength {
  if (resLength <= 0) {
    return @"0 B";
  }
  
  if (resLength >= 1024 * 1024) {
    return [NSString stringWithFormat:@"%.2f M", resLength / (float)(1024 * 1024)];
  } else if (resLength >= 1024) {
    return [NSString stringWithFormat:@"%.2f K", resLength / (float)(1024)];
  } else {
    return [NSString stringWithFormat:@"%.2f B", (float)resLength];
  }
}

// 根据 "字体" "最大显示尺寸" 来计算一段文字所占据的显示尺寸
+ (CGSize)labelSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
  paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
  NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
  CGSize labelSize = CGSizeZero;
  if (IOS7_OR_LATER) {
    labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
  } else {
    labelSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
  }
  
  /*
   This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
   */
  labelSize.height = ceil(labelSize.height);
  labelSize.width = ceil(labelSize.width) + 4.0;
  
  return labelSize;
}

@end
