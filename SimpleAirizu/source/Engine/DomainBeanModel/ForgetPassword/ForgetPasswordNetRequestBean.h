//
//  DreamBook
//
//  Created by 唐志华 on 13-9-18.
//
//

#import <Foundation/Foundation.h>

@interface ForgetPasswordNetRequestBean : NSObject 
// 手机号码 必填
@property (nonatomic, readonly, strong) NSString *phoneNumber;


#pragma mark -
#pragma mark - 构造方法
- (id)initWithPhoneNumber:(NSString *)phoneNumber;

- (id)init DEPRECATED_ATTRIBUTE;
@end
