//
//  SpliceFullUrlByDomainBeanSpecialPathForDreamBook.m
//  ModelLib
//
//  Created by 唐志华 on 14-4-18.
//  Copyright (c) 2014年 唐志华. All rights reserved.
//

#import "SpliceFullUrlByDomainBeanSpecialPathForDreamBook.h"
#import "UrlConstantForThisProject.h"

@implementation SpliceFullUrlByDomainBeanSpecialPathForDreamBook
- (NSString *)fullUrlByDomainBeanSpecialPath:(NSString *)specialPath {
  NSString *fullUrlString = [NSString stringWithFormat:@"%@/%@/%@", kUrlConstant_MainUrl, kUrlConstant_MainPtah, specialPath];
  return fullUrlString;
}
@end
