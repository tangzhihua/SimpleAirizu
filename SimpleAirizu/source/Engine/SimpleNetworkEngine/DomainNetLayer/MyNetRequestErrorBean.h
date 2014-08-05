//
//  RESTError.h
//  iHotelApp
//
//  Created by Mugunth Kumar on 1-Jan-11.
//  Copyright 2010 Steinlogic. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MyNetRequestErrorBean : NSError

@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, assign) NSInteger errorCode;

- (NSString *)localizedOption;
/**
 * 重新初始化
 *
 * @param srcObject
 */
- (void)reinitialize:(MyNetRequestErrorBean *)srcObject;
+ (id)netRequestErrorBeanWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage;
@end
