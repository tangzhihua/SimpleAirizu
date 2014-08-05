//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "ServerRespondDataTestForDreamBook.h"
#import "MyNetRequestErrorBean.h"




@implementation ServerRespondDataTestForDreamBook
#pragma mark 实现 IServerRespondDataTest 接口
- (MyNetRequestErrorBean *) testServerRespondDataIsValid:(in NSString *)serverRespondDataOfUTF8String {
  NSInteger errorCode = kNetErrorCodeEnum_Success;
  NSString *errorMessage = @"OK";
  
  NSError *error = nil;
  
  NSDictionary *xmlDataNSDictionary = nil;
  NSDictionary *response = [xmlDataNSDictionary objectForKey:@"response"];
  if ([response isKindOfClass:[NSDictionary class]]) {
    NSNumber *validate = [response objectForKey:@"validate"];
    if (![validate boolValue]) {
      errorCode = kNetErrorCodeEnum_Server_Custom_Error;
      errorMessage = [response objectForKey:@"error"];
    }
  }
  
  
  
  // TODO : 目前后台接口没有统一错误提示, 如出错时, 可以返回 errorCode 和 errorMessage .
  // 暂时这里先不实现, 等后台修改接口时, 在做处理.
  return [MyNetRequestErrorBean netRequestErrorBeanWithErrorCode:errorCode errorMessage:errorMessage];
}
@end
