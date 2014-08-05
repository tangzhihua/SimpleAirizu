//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "LoginParseDomainBeanToDD.h"

#import "LoginDatabaseFieldsConstant.h"
#import "LoginNetRequestBean.h"

@implementation LoginParseDomainBeanToDD

- (NSDictionary *)parseNetRequestDomainBeanToDataDictionary:(in id)netRequestDomainBean {
  RNAssert(netRequestDomainBean != nil, @"入参为空 !");
  
  do {
    if (! [netRequestDomainBean isMemberOfClass:[LoginNetRequestBean class]]) {
      RNAssert(NO, @"传入的业务Bean的类型不符 !");
      break;
    }
    
    const LoginNetRequestBean *requestBean = netRequestDomainBean;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
		//
		value = requestBean.loginName;
		if ([NSString isEmpty:value]) {
      RNAssert(NO, @"丢失关键参数 : loginName");
      break;
		}
		[params setObject:value forKey:k_Login_RequestKey_loginName];
    //
    value = requestBean.password;
		if ([NSString isEmpty:value]) {
      RNAssert(NO, @"丢失关键参数 : password");
      break;
		}
    [params setObject:value forKey:k_Login_RequestKey_password];
    
    return params;
  } while (NO);
  
  return nil;
}
@end