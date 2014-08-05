//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>
@protocol IParseNetRequestDomainBeanToDataDictionary;
@protocol IParseNetRespondDictionaryToDomainBean;

/**
 * 业务Bean相关的助手方法群(这里使用的是抽象工厂模式)
 *
 * 这里罗列的接口是每个业务Bean都需要实现的.
 *
 * @author skyduck
 */
@protocol IDomainBeanHelper <NSObject>
/**
 * 将当前业务Bean, 解析成跟后台数据接口对应的数据字典
 * @return
 */
- (id<IParseNetRequestDomainBeanToDataDictionary>)getParseDomainBeanToDDStrategy;

/**
 * 当前业务Bean, 对应的path.
 * @return
 */
- (NSString *)getSpecialPath;

/**
 * 当前网络响应业务Bean的Class
 * @return
 */
- (Class)getClassOfNetRespondBean;
@end
