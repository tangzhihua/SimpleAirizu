//
//  AirizuLogInInfoModel.h
//  SimpleAirizu
//
//  Created by 王珊珊 on 14-8-7.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirizuLogInInfoModel : NSObject

@property (nonatomic, readonly, copy) NSString *account;
@property (nonatomic, readonly,copy) NSString *password;
@property (nonatomic, readonly) BOOL isAutoLogin;

- (id)initWithAccount:(NSString *)account password:(NSString *)password isAutoLogin:(BOOL)isAutoLogin;

@end
