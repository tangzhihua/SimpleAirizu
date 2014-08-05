//
//  RecommendDomainBeanToolsFactory.m
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//

#import "RecommendDomainBeanToolsFactory.h"

#import "RecommendNetRequestBean.h"
 

static const NSString *const TAG = @"<RecommendDomainBeanToolsFactory>";

@implementation RecommendDomainBeanToolsFactory
/**
 * 将当前业务Bean, 解析成跟后台数据接口对应的数据字典
 * @return
 */
- (id<IParseNetRequestDomainBeanToDataDictionary>)getParseDomainBeanToDDStrategy {
  return nil;
}

/**
 * 当前业务Bean, 对应的URL地址.
 * @return
 */
- (NSString *)getSpecialPath{
  return kUrlConstant_SpecialPath_room_recommend;
}

/**
 * 当前网络响应业务Bean的Class
 * @return
 */
- (Class)getClassOfNetRespondBean {
  return [RecommendNetRequestBean class];
}

@end