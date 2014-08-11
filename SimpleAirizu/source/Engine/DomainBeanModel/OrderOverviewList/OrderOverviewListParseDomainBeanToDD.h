//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "IParseNetRequestDomainBeanToDataDictionary.h"

@interface LoginParseDomainBeanToDD : NSObject <IParseNetRequestDomainBeanToDataDictionary>
- (NSDictionary *)parseNetRequestDomainBeanToDataDictionary:(in id)netRequestDomainBean;
@end