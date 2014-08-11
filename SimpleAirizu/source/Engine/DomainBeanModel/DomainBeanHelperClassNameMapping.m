//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "DomainBeanHelperClassNameMapping.h"



// 2.2	用户登录
#import "LoginNetRequestBean.h"
#import "LoginDomainBeanToolsFactory.h"

// 2.3	忘记密码
#import "ForgetPasswordNetRequestBean.h"
#import "ForgetPasswordDomainBeanToolsFactory.h"

static const NSString *const TAG = @"<DomainBeanHelperClassNameMapping>";

@implementation DomainBeanHelperClassNameMapping

- (id) init {
	
	if ((self = [super init])) {
		
		/**
		 * 2.2	用户登录
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([LoginDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([LoginNetRequestBean class])];
    
    /**
		 * 2.3	忘记密码
		 */
    [strategyClassesNameMappingList setObject:NSStringFromClass([ForgetPasswordDomainBeanToolsFactory class])
                                       forKey:NSStringFromClass([ForgetPasswordNetRequestBean class])];
	}
  
	return self;
}

@end
