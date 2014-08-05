//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>

// 将网络响应数据字典解析成响应业务Bean
@protocol IParseNetRespondDataDictionaryToNetRespondDomainBean <NSObject>
- (id)parseNetRespondDataDictionaryToNetRespondDomainBean:(in NSDictionary *)netRespondDataDictionary;
@end
