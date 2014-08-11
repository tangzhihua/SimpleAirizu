//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import "LoginNetRequestBean.h"

@implementation LoginNetRequestBean

- (id)initWithLoginName:(NSString *)loginName password:(NSString *)password {
  
  if ((self = [super init])) {
    _loginName = [loginName copy];
    _password = [password copy];
  }
  
  return self;
}

#pragma mark -
#pragma mark - 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id)init {
  RNAssert(NO, @"Can not use the default init method!");
  
  return nil;
}

- (NSString *)description {
	return descriptionForDebug(self);
}
@end