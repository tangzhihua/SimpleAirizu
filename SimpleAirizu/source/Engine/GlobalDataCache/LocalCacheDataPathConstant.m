//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "LocalCacheDataPathConstant.h"
#import "SimpleFolderTools.h"

@implementation LocalCacheDataPathConstant

// 静态初始化方法
+ (void) initialize {
  // 这是为了子类化当前类后, 父类的initialize方法会被调用2次
  if (self == [LocalCacheDataPathConstant class]) {
    
  }
}

// 项目中图片缓存目录 (可以被清除)
+ (NSString *)thumbnailCachePath {
  static NSString *_thumbnailCachePath = nil;
  if (nil == _thumbnailCachePath) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"ThumbnailCachePath"];
    _thumbnailCachePath = [fullPath copy];
  }
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager createDirectoryAtPath:_thumbnailCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
  return _thumbnailCachePath;
}

// 那些需要始终被保存, 不能由用户进行清除的文件
+ (NSString *)importantDataCachePath {
  static NSString *_importantDataCachePath = nil;
  if (nil == _importantDataCachePath) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"ImportantDataCache"];
    _importantDataCachePath = [fullPath copy];
  }
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager createDirectoryAtPath:_importantDataCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
  return _importantDataCachePath;
}

// 本地书籍保存目录
+ (NSString *)localBookCachePath {
  static NSString *_localBookCachePath = nil;
  if (nil == _localBookCachePath) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"LocalBookDir"];
    _localBookCachePath = [fullPath copy];
  }
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager createDirectoryAtPath:_localBookCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
  return _localBookCachePath;
}

// 主题皮肤保存目录
+ (NSString *)themeCachePath {
  static NSString *_localBookCachePath = nil;
  if (nil == _localBookCachePath) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"Theme"];
    _localBookCachePath = [fullPath copy];
  }
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager createDirectoryAtPath:_localBookCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
  return _localBookCachePath;
}

// RichBook workspace
+ (NSString *)richBookWorkspacePath {
  static NSString *_richBookWorkspace = nil;
  if (nil == _richBookWorkspace) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"RichBookWorkspace"];
    _richBookWorkspace = [fullPath copy];
  }
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager createDirectoryAtPath:_richBookWorkspace withIntermediateDirectories:YES attributes:nil error:NULL];
  return _richBookWorkspace;
}

// RichBook log 目录
+ (NSString *)richBookLogPath {
  return [NSString stringWithFormat:@"%@/log", [self richBookWorkspacePath]];
}

// RichBook global.param
+ (NSString *)richBookGlobalParamPath {
  return [NSString stringWithFormat:@"%@/global.param", [self richBookWorkspacePath]];
}

// 能否被用户清空的目录数组(可以从这里获取用户可以直接清空的文件夹路径数组)
+ (NSArray *)directoriesCanBeClearByTheUser {
  NSArray *directories = [NSArray arrayWithObjects:[self thumbnailCachePath], nil];
  return directories;
}

// 创建本地数据缓存目录(一次性全部创建, 不会重复创建)
+ (void)createLocalCacheDirectories {
  // 创建本地数据缓存目录(一次性全部创建, 不会重复创建)
  NSArray *directories = [NSArray arrayWithObjects:[self thumbnailCachePath], [self importantDataCachePath], [self localBookCachePath], [self themeCachePath], [self richBookWorkspacePath], nil];
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  for (NSString *path in directories) {
    if (![fileManager fileExistsAtPath:path]) {
      [fileManager createDirectoryAtPath:path
             withIntermediateDirectories:YES
                              attributes:nil
                                   error:nil];
    }
  }
  
}

// 本地缓存的数据的大小(字节)
+ (long long)localCacheDataSize {
  long long size = 0;
  NSArray *directories = [LocalCacheDataPathConstant directoriesCanBeClearByTheUser];
  for(NSString *directory in directories) {
    size += [SimpleFolderTools folderSizeAtPath3:directory];
  }
  
  return size;
}
@end
