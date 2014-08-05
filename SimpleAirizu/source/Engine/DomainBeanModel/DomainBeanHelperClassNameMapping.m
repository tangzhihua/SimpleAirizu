//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "DomainBeanHelperClassNameMapping.h"



// 1. 登录
#import "LoginNetRequestBean.h"
#import "LoginDomainBeanToolsFactory.h"



static const NSString *const TAG = @"<DomainBeanHelperClassNameMapping>";

@implementation DomainBeanHelperClassNameMapping

- (id) init {
	
	if ((self = [super init])) {
		
		/**
		 * 1. 登录
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([LoginDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([LoginNetRequestBean class])];
    
   
	}
  
	return self;
}

@end
