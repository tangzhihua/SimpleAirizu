//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>

// 将一个请求业务Bean解析成数据字典
@protocol IParseNetRequestDomainBeanToDataDictionary <NSObject>
- (NSDictionary *)parseNetRequestDomainBeanToDataDictionary:(in id)netRequestDomainBean;
@end
