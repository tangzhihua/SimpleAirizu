//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>

@interface LoginNetRequestBean : NSObject 
// 用户名 必填
@property (nonatomic, readonly, strong) NSString *loginName;
// 密码 必填
@property (nonatomic, readonly, strong) NSString *password;

#pragma mark -
#pragma mark - 构造方法
- (id)initWithLoginName:(NSString *)loginName password:(NSString *)password;

- (id)init DEPRECATED_ATTRIBUTE;
@end
