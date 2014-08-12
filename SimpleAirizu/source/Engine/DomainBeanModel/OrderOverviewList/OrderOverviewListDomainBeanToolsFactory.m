//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "LoginDomainBeanToolsFactory.h"
#import "LoginParseDomainBeanToDD.h"

#import "LoginNetRespondBean.h"
#import "UrlConstantForThisProject.h"

@implementation LoginDomainBeanToolsFactory

/**
 * 将当前业务Bean, 解析成跟后台数据接口对应的数据字典
 * @return
 */
- (id<IParseNetRequestDomainBeanToDataDictionary>)getParseDomainBeanToDDStrategy {
  return [[LoginParseDomainBeanToDD alloc] init];
}

/**
 * 当前业务Bean, 对应的URL地址.
 * @return
 */
- (NSString *)getSpecialPath{
  return kUrlConstant_SpecialPath_order_list;
}

/**
 * 当前网络响应业务Bean的Class
 * @return
 */
- (Class)getClassOfNetRespondBean {
  return [LoginNetRespondBean class];
}
@end