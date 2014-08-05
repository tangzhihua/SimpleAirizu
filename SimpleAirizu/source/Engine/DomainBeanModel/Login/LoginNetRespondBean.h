
#import "BaseModel.h"

// 只针对 企业用户, 公共账户 不会需要创建当前模型
@interface LoginNetRespondBean : BaseModel

// 登录名
@property (nonatomic, copy) NSString *loginName;
// 登录密码
@property (nonatomic, copy) NSString *password;


// 消息
@property (nonatomic, copy) NSString *message;
// 用户Id
@property (nonatomic, copy) NSNumber *userId;
// 用户名称
@property (nonatomic, copy) NSString *userName;
// 用户Id
@property (nonatomic, copy) NSString *phoneNumber;

@end
