//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "ForgetPasswordParseDomainBeanToDD.h"

#import "ForgetPasswordDatabaseFieldsConstant.h"
#import "ForgetPasswordNetRequestBean.h"

@implementation ForgetPasswordParseDomainBeanToDD

- (NSDictionary *)parseNetRequestDomainBeanToDataDictionary:(in ForgetPasswordNetRequestBean *)forgetPasswordNetRequestBean {
  do {
    
    // 网络请求参数字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
		
		NSString *value = nil;
		
		// 电话号码
		value = forgetPasswordNetRequestBean.phoneNumber;
		if ([NSString isEmpty:value]) {
      RNAssert(NO, @"丢失关键参数 : phoneNumber");
      break;
		}
		[params setObject:value forKey:k_ForgetPassword_RequestKey_phoneNumber];
    
    return params;
  } while (NO);
  
  return nil;
}
@end