
#import "LoginNetRespondBean.h"
#import "LoginDatabaseFieldsConstant.h"

static NSString *const kNSCodingField_loginName   = @"loginName";
static NSString *const kNSCodingField_password    = @"password";


@interface LoginNetRespondBean ()

@end

@implementation LoginNetRespondBean

- (NSString *)description {
	return descriptionForDebug(self);
}


#pragma mark -
#pragma mark - 实现 NSCoding 接口

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_loginName forKey:kNSCodingField_loginName];
  [aCoder encodeObject:_password forKey:kNSCodingField_password];
  
  [aCoder encodeObject:_message forKey:k_Login_RespondKey_message];
  [aCoder encodeObject:_userId forKey:k_Login_RespondKey_userId];
  [aCoder encodeObject:_userName forKey:k_Login_RespondKey_userName];
  [aCoder encodeObject:_phoneNumber forKey:k_Login_RespondKey_phoneNumber];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super init])) {
    
    //
    if ([aDecoder containsValueForKey:kNSCodingField_loginName]) {
      _loginName = [aDecoder decodeObjectForKey:kNSCodingField_loginName];
    }
    if ([aDecoder containsValueForKey:kNSCodingField_password]) {
      _password = [aDecoder decodeObjectForKey:kNSCodingField_password];
    }
    
    //
    if ([aDecoder containsValueForKey:k_Login_RespondKey_message]) {
      _message = [aDecoder decodeObjectForKey:k_Login_RespondKey_message];
    }
    //
    if ([aDecoder containsValueForKey:k_Login_RespondKey_userId]) {
      _userId = [aDecoder decodeObjectForKey:k_Login_RespondKey_userId];
    }
    //
    if ([aDecoder containsValueForKey:k_Login_RespondKey_userName]) {
      _userName = [aDecoder decodeObjectForKey:k_Login_RespondKey_userName];
    }
    //
    if ([aDecoder containsValueForKey:k_Login_RespondKey_phoneNumber]) {
      _phoneNumber = [aDecoder decodeObjectForKey:k_Login_RespondKey_phoneNumber];
    }
    
  }
  
  return self;
}
@end
