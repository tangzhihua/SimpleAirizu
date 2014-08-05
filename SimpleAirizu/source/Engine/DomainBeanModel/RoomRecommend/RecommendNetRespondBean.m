//
//  RecommendNetRespondBean.m
//  airizu
//
//  Created by 唐志华 on 12-12-25.
//
//

#import "RecommendNetRespondBean.h"
#import "RecommendCity.h"

static const NSString *const TAG = @"<RecommendNetRespondBean>";

static NSString *const kNSCodingField_recommendCityList = @"recommendCityList";

@implementation RecommendNetRespondBean


#pragma mark -
#pragma mark - 实现 NSCoding 接口
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:_recommendCityList forKey:kNSCodingField_recommendCityList];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    
    _recommendCityList = [aDecoder decodeObjectForKey:kNSCodingField_recommendCityList];
  }
  
  return self;
}

@end

