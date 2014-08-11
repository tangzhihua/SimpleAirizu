//
//  AirizuLogInInfoModel.m
//  SimpleAirizu
//
//  Created by 王珊珊 on 14-8-7.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import "AirizuLogInInfoModel.h"

@implementation AirizuLogInInfoModel

- (id)initWithAccount:(NSString *)account password:(NSString *)password isAutoLogin:(BOOL)isAutoLogin {
    if (self = [super init]) {
        _account = account;
        _password = password;
        _isAutoLogin = isAutoLogin;
    }
    return self;
}

@end
