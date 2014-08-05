//
//  DeviceInformation.m
//  airizu
//
//  Created by 唐志华 on 12-12-26.
//
//

#import "DeviceInformation.h"

static const NSString *const TAG = @"<DeviceInformation>";

@implementation DeviceInformation
- (id) init {
  RNAssert(NO, @"Can not use the default init method!");
  
  return nil;
}


+ (void) printDeviceInfo {
  UIDevice *device =[UIDevice currentDevice];
  NSLog(@"    ");
  NSLog(@"-----------------------------");
  NSLog(@"    ");
  NSLog(@"设备信息:");
  NSLog(@"    ");
  NSLog(@"当前app所在路径        = %@", NSHomeDirectory());
  NSLog(@"device.name          = %@", device.name);// e.g. "My iPhone"
  NSLog(@"device.model         = %@", device.model);// e.g. @"iPhone", @"iPod touch"
  NSLog(@"device.localizedModel= %@", device.localizedModel);// localized version of model
  NSLog(@"device.systemName    = %@", device.systemName);// e.g. @"iOS"
  NSLog(@"device.systemVersion = %@", device.systemVersion);// e.g. @"4.0"
  
  
  NSLog(@"    ");
  NSLog(@"    ");
  NSLog(@"App信息:");
  NSLog(@"    ");
  NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
  NSLog(@"infoDictionary.CFBundleIdentifier            = %@", [infoDic objectForKey:@"CFBundleIdentifier"]);
  NSLog(@"infoDictionary.CFBundleInfoDictionaryVersion = %@", [infoDic objectForKey:@"CFBundleInfoDictionaryVersion"]);
  NSLog(@"infoDictionary.CFBundleName                  = %@", [infoDic objectForKey:@"CFBundleName"]);
  NSLog(@"infoDictionary.CFBundleShortVersionString    = %@", [infoDic objectForKey:@"CFBundleShortVersionString"]);
  NSLog(@"infoDictionary.CFBundleVersion               = %@", [infoDic objectForKey:@"CFBundleVersion"]);
  NSLog(@"    ");
  NSLog(@"-----------------------------");
  NSLog(@"    ");
}

@end
